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
from functools import lru_cache
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")

IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\s*;")
WILDCARD_IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\.\*\s*;")
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


@lru_cache(maxsize=None)
def exact_source_file(client_root: str, relative: str) -> bool:
    """Resolve an AS3 source using its exact spelling, even on case-insensitive Windows.

    AS3 identifiers are case-sensitive. Without the directory-entry comparison below, a qualified
    constant such as ``ActionTypeCodes.CHASE`` is accepted as the source file ``Chase.as`` on
    Windows. That puts two differently-cased aliases for one file into a closure and lets the first
    copy dictate the generated Haxe module name.
    """
    path = Path(client_root) / relative
    if not path.is_file():
        return False
    return any(entry.name == path.name and entry.is_file() for entry in path.parent.iterdir())


def has_source(relative: str) -> bool:
    return exact_source_file(str(CLIENT.resolve()), relative)


def seam_sources() -> set[str]:
    """The AS3 files the port deliberately replaces with hand-written Haxe.

    A seam is normally never converted -- sometimes because it cannot be -- so staging one for
    typing puts it back through ax3 and fails the whole batch; ax3 resolves it from the SWC
    instead, which is what it did before contexts existed.

    Transitional hand-written ports are deliberately *not* seams.  Their exception state says
    "must become converter output", so excluding them based on whether an older generated tree
    happens to contain a file makes the full-client scope depend on stale build artefacts.  Only
    entries explicitly classified as seams may stop traversal here.
    """
    payload = json.loads(EXCEPTIONS.read_text(encoding="utf-8"))
    sources = set()
    for entry in payload["exceptions"]:
        source = entry.get("as3_source")
        if not source or not entry.get("state", "").startswith("seam --"):
            continue
        source = source.replace(chr(92), "/")
        relative = source[4:] if source.startswith("src/") else source
        sources.add(relative)
    return sources


def references(relative: str, source_text: str | None = None) -> set[str]:
    """Every client source a file could refer to: imports, same-package siblings, qualified names."""
    text = source_text if source_text is not None else (CLIENT / relative).read_text(encoding="utf-8-sig", errors="replace")
    code = STRINGS.sub(" ", text)
    package_match = PACKAGE.search(text)
    package = package_match.group(1).replace(".", "/") if package_match else ""
    imports = {q.rsplit(".", 1)[-1]: q.replace(".", "/") for q in IMPORT.findall(text)}
    wildcards = [q.replace(".", "/") for q in WILDCARD_IMPORT.findall(text)]
    found = {q.replace(".", "/") for q in QUALIFIED.findall(code)}
    for name in set(IDENT.findall(code)):
        if name in imports:
            found.add(imports[name])
        else:
            sibling = f"{package}/{name}" if package else name
            if has_source(f"{sibling}.as"):
                found.add(sibling)
                continue
            # Only used identifiers, not every file in a wildcard-imported package.
            for imported in wildcards:
                if has_source(f"{imported}/{name}.as"):
                    found.add(f"{imported}/{name}")
    return found


def context_for(closure: list[str], seams: set[str]) -> list[str]:
    seam_keys = {path.lower() for path in seams}
    seen: set[str] = set()
    queue = list(closure)
    while queue:
        relative = queue.pop()
        if relative in seen or relative.lower() in seam_keys or not has_source(relative):
            continue
        seen.add(relative)
        for reference in references(relative):
            if reference.startswith(SKIP_ROOTS):
                continue
            if has_source(reference + ".as"):
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
        retired = {entry.lower() for entry in payload.get("retired_exceptions", [])}
        active_seams = {entry for entry in global_seams | local_seams if entry.lower() not in retired}
        context = context_for(payload["closure"], active_seams)
        payload["context"] = context
        path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
        print(f"{path.name:<44} closure {len(payload['closure']):>4}  context {len(context):>4}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
