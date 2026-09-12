"""Run small AS3 -> Haxe -> JavaScript behavior probes before full window conversion."""
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import sync


def main():
    # ax3 can skip a source after a parse error while still exiting zero. Never
    # let a previous run's Probe.hx (or another fixture) satisfy this run's gate.
    parent = REPO / ".toolchain/tests/window-conversion"
    parent.mkdir(parents=True, exist_ok=True)
    workspace = Path(tempfile.mkdtemp(prefix="run-", dir=parent))
    evidence = REPO / "evidence/v21_converter_regression.json"
    evidence.write_text(json.dumps({"ok": False, "phase": "started",
                                   "workspace": str(workspace)}, indent=2) + "\n",
                        encoding="utf-8")
    source = REPO / "test/as3"
    staged = workspace / "as3"
    staged.mkdir(parents=True, exist_ok=True)
    fixture_sources = list(source.rglob("*.as"))
    for path in fixture_sources:
        destination = staged / path.relative_to(source)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, destination)
    out = workspace / "generated"
    out.mkdir(parents=True, exist_ok=True)
    conversion = sync.run_converter(workspace, out)
    missing = [path.relative_to(source).as_posix() for path in fixture_sources
               if not (out / sync.generated_relative(
                   path.relative_to(source).as_posix())).is_file()]
    if conversion["exit_code"] or missing:
        evidence.write_text(json.dumps({"ok": False, "phase": "conversion",
            "workspace": str(workspace), "missing_sources": missing,
            "conversion": conversion}, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(conversion, indent=2))
        print("Missing fixture outputs:", missing)
        return 1
    js = workspace / "probe.js"
    command = ["haxe", "-cp", str(REPO / "src"), "-cp", str(REPO / ".toolchain/ax3/compat"),
               "-cp", str(REPO / "generated"), "-cp", str(out), "-cp", str(REPO / "test"), "-lib", "lime", "-lib", "openfl",
               "-D", "html5", "--remap", "flash:openfl",
               "-main", "V21ConverterRegressionTest", "-js", str(js)]
    compiled = subprocess.run(command, cwd=REPO)
    if compiled.returncode:
        return compiled.returncode
    # TextFormat pulls in OpenFL's browser runtime; execute all probes in a real DOM rather
    # than gradually accumulating fake browser globals in the Node test harness.
    html = workspace / "probe.html"
    html.write_text('''<!doctype html><meta charset="utf-8"><body><script>
var results = [];
window.onerror = function(message) { document.body.textContent = 'FAIL ' + message; };
console.log = function() { results.push(Array.from(arguments).join(' '));
document.body.textContent = results.join('\\n'); };
</script><script src="probe.js"></script></body>''', encoding="utf-8")
    profile = tempfile.mkdtemp(prefix="skyhaxe-converter-")
    browser = subprocess.run([
        "C:/Program Files/Google/Chrome/Application/chrome.exe", "--headless", "--disable-gpu",
        "--no-first-run", "--no-default-browser-check", "--allow-file-access-from-files",
        "--user-data-dir=" + profile, "--dump-dom", html.as_uri()
    ], capture_output=True, text=True, timeout=45)
    import re
    match = re.search(r"<body>([^<]*)", browser.stdout)
    body = match.group(1) if match else ""
    passed = browser.returncode == 0 and "V21_CONVERTER_PASS" in body \
        and "SHADOW_INT_COERCION_PASS" in body and "FAIL" not in body
    record = {"ok": passed, "browser_exit": browser.returncode, "body": body,
              "workspace": str(workspace), "fixture_count": len(fixture_sources),
              "target": "AS3 -> generated Haxe -> browser JavaScript"}
    (REPO / "evidence/v21_converter_regression.json").write_text(
        json.dumps(record, indent=2) + "\n", encoding="utf-8")
    print(body or browser.stderr[-2000:])
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
