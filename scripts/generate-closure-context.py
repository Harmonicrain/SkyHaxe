#!/usr/bin/env python3
"""Record the typing context a closure needs, so ax3 never falls back to the SWC.

Anything a closure references but does not stage is resolved out of habbo-client.swc, and a SWC
carries less than the source does. Two silent failures came from that: a SWC hides private members,
so `RewriteRedefinedPrivate` could not see that a subclass was legally redeclaring a parent's
private var and emitted an illegal Haxe redefinition; and a SWC cannot say that a rest argument
belongs to AS3 this pipeline converts, so variadic calls crossing a closure boundary were left
unwrapped. Neither produced an error -- just different Haxe.

The context is the full transitive reference closure, including files other batches already own.
sync.py stages it for typing and then keeps only the files the closure itself declares.

Usage:
    python scripts/generate-closure-context.py evidence/v13_..._closure.json [...]
    python scripts/generate-closure-context.py --all
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")

IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\s*;")
PACKAGE = re.compile(r"(?m)^\s*package\s+([\w.]+)")
QUALIFIED = re.compile(r"\b((?:[a-z_]\w*\.){2,}[A-Z_]\w*)\b")
IDENT = re.compile(r"\b([A-Z_][A-Za-z0-9_]*)\b")
_B = chr(92)
# Strings and comments are blanked before the identifier scan, so a class name that appears only
# in a comment or a data string does not drag a file into the context.
STRINGS = re.compile(
    '"(?:[^"' + _B + _B + ']|' + _B + _B + '.)*"'
    + "|'(?:[^'" + _B + _B + "]|" + _B + _B + ".)*'"
    + "|//[^" + chr(92) + "n]*"
    + "|/[*].*?[*]/", re.S)

SKIP_ROOTS = ("flash/", "__AS3__/", "mx/", "fl/")
EXCEPTIONS = REPO / "evidence/m2_exceptions.json"


def seam_sources() -> set[str]:
    """The AS3 files the port deliberately replaces with hand-written Haxe.

    A seam is normally never converted -- sometimes because it cannot be -- so staging one for
    typing puts it back through ax3 and fails the whole batch; ax3 resolves it from the SWC
    instead, which is what it did before contexts existed.

    The exception is a seam a closure has already converted, which is the state every entry marked
    "must become converter output" is heading for. Those convert by construction, and staging them
    matters: a SWC hides private members, so without the source ax3 cannot tell that a subclass is
    legally redeclaring a parent's private field.
    """
    payload = json.loads(EXCEPTIONS.read_text(encoding="utf-8"))
    sources = set()
    for entry in payload["exceptions"]:
        source = entry.get("as3_source")
        if not source:
            continue
        source = source.replace(chr(92), "/")
        relative = source[4:] if source.startswith("src/") else source
        if (REPO / "generated" / (relative[: -len(".as")] + ".hx")).is_file():
            continue
        sources.add(relative)
    return sources


def references(relative: str) -> set[str]:
    """Every client source a file could refer to: imports, same-package siblings, qualified names."""
    text = (CLIENT / relative).read_text(encoding="utf-8-sig", errors="replace")
    code = STRINGS.sub(" ", text)
    package_match = PACKAGE.search(text)
    package = package_match.group(1).replace(".", "/") if package_match else ""
    imports = {q.rsplit(".", 1)[-1]: q.replace(".", "/") for q in IMPORT.findall(text)}
    found = {q.replace(".", "/") for q in QUALIFIED.findall(code)}
    for name in set(IDENT.findall(code)):
        if name in imports:
            found.add(imports[name])
        elif package and (CLIENT / package / (name + ".as")).is_file():
            found.add(f"{package}/{name}")
    return found


def context_for(closure: list[str], seams: set[str]) -> list[str]:
    seen: set[str] = set()
    queue = list(closure)
    while queue:
        relative = queue.pop()
        if relative in seen or relative in seams or not (CLIENT / relative).is_file():
            continue
        seen.add(relative)
        for reference in references(relative):
            if reference.startswith(SKIP_ROOTS):
                continue
            if (CLIENT / (reference + ".as")).is_file():
                queue.append(reference + ".as")
    return sorted(seen - set(closure))


def main(argv: list[str]) -> int:
    if argv == ["--all"]:
        paths = sorted((REPO / "evidence").glob("*closure*.json"))
    else:
        paths = [Path(a) for a in argv]
    if not paths:
        print(__doc__)
        return 1
    global_seams = seam_sources()
    for path in paths:
        payload = json.loads(path.read_text(encoding="utf-8"))
        # A feature closure may define target-specific seams outside com/sulake/core.  Treat their
        # AS3 identities exactly like the global exception manifest: they are useful type
        # boundaries, not context that ax3 should traverse and convert.  Without this, M3c's
        # RoomContentLoader seam silently pulled LibraryLoader/FZip back into the typing batch and
        # IHabboCommunicationManager pulled the obsolete crypto handshake with it.
        local_seams = set(payload.get("seams", {}))
        context = context_for(payload["closure"], global_seams | local_seams)
        payload["context"] = context
        path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
        print(f"{path.name:<44} closure {len(payload['closure']):>4}  context {len(context):>4}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
