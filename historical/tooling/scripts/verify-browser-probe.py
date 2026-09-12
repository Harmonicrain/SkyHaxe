"""Run a local development fixture in isolated headless Chrome with a real HTTP origin."""
import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import re
import subprocess
import tempfile
from threading import Thread

REPO = Path(__file__).resolve().parents[1]


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, *_):
        pass

    def log_error(self, message, *args):
        # Keep actionable HTTP failures in evidence without flooding successful
        # probes with hundreds of embedded-skin requests.
        self.server.probe_http_errors.append(message % args)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--page", required=True)
    parser.add_argument("--marker", required=True)
    parser.add_argument("--result", required=True)
    parser.add_argument("--attribute", help="Optional HTML result attribute used by existing OpenFL fixtures")
    parser.add_argument("--screenshot", help="Optional repo-relative Chrome screenshot evidence")
    args = parser.parse_args()
    server = ThreadingHTTPServer(("127.0.0.1", 0), partial(QuietHandler, directory=str(REPO)))
    server.probe_http_errors = []
    worker = Thread(target=server.serve_forever, daemon=True)
    worker.start()
    profile = tempfile.mkdtemp(prefix="skyhaxe-probe-")
    try:
        url = f"http://127.0.0.1:{server.server_port}/{args.page}"
        command = [
            "C:/Program Files/Google/Chrome/Application/chrome.exe", "--headless", "--disable-gpu",
            "--no-first-run", "--no-default-browser-check", "--user-data-dir=" + profile,
            "--virtual-time-budget=10000", "--dump-dom", "--window-size=650,500",
        ]
        if args.screenshot:
            command.append("--screenshot=" + str(REPO / args.screenshot))
        browser = subprocess.run(command + [url], capture_output=True, text=True, timeout=45)
        match = re.search(r"<body>([^<]*)", browser.stdout)
        body = match.group(1) if match else ""
        if args.attribute:
            attribute = re.search(r'\b' + re.escape(args.attribute) + r'="([^"]*)"', browser.stdout)
            body = attribute.group(1) if attribute else ""
            passed = browser.returncode == 0 and body == args.marker
        else:
            passed = browser.returncode == 0 and args.marker in body and "FAIL" not in body
        error = re.search(r'\b' + re.escape(args.attribute) + r'-error="([^"]*)"', browser.stdout) if args.attribute else None
        result = {"ok": passed, "fixture": args.page, "browser_exit": browser.returncode, "body": body,
                  "error": error.group(1) if error else None,
                  "http_errors": list(server.probe_http_errors),
                  "browser_stderr_tail": browser.stderr.splitlines()[-25:] if not passed else []}
        (REPO / args.result).write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
        print(body or browser.stderr[-1500:])
        if result["error"]: print(result["error"])
        return 0 if passed else 1
    finally:
        server.shutdown()
        server.server_close()


if __name__ == "__main__":
    raise SystemExit(main())
