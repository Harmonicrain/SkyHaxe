#!/usr/bin/env python3
"""Serve the G4b page and the Truffle text payload from one origin, read-only.

Truffle's packed loader fetches its manifest, fonts and per-style raster chunks at runtime from a
`base` URL. That payload is ~99 MB, almost all of it raster caches for styles this page never
uses, so it is mounted here rather than copied into the OpenFL asset bundle: the loader pulls only
the chunks the styles in use actually need.

    /                 -> build/tests/g4b-window/html5/bin
    /assets/truffle/  -> public/assets/truffle   (read-only; GET and HEAD only)

Usage:
    python scripts/serve-g4b.py [--port 8780]
"""
from __future__ import annotations

import argparse
import http.server
import mimetypes
import posixpath
import urllib.parse
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
WEB_ROOT = REPO / "build/tests/g4b-window/html5/bin"
TRUFFLE_ROOT = (REPO / "public/assets/truffle").resolve()
TRUFFLE_PREFIX = "/assets/truffle/"

mimetypes.add_type("application/wasm", ".wasm")
mimetypes.add_type("application/javascript", ".js")
mimetypes.add_type("font/ttf", ".ttf")
mimetypes.add_type("application/octet-stream", ".tfc")


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_ROOT), **kwargs)

    def translate_path(self, path: str) -> str:
        clean = urllib.parse.urlparse(path).path
        if not clean.startswith(TRUFFLE_PREFIX):
            return super().translate_path(path)
        relative = posixpath.normpath(urllib.parse.unquote(clean[len(TRUFFLE_PREFIX):]))
        candidate = (TRUFFLE_ROOT / relative).resolve()
        if TRUFFLE_ROOT not in candidate.parents and candidate != TRUFFLE_ROOT:
            return str(WEB_ROOT / "__forbidden__")
        return str(candidate)

    def log_message(self, fmt, *args):
        pass


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=8780)
    ap.add_argument("--bind", default="127.0.0.1")
    args = ap.parse_args()
    if not (WEB_ROOT / "index.html").is_file():
        raise SystemExit("no G4b build at {}. Run scripts/test-g4b-window.ps1 first.".format(WEB_ROOT))
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    print("page    http://{}:{}/".format(args.bind, args.port))
    print("truffle http://{}:{}{} -> {} (read-only)".format(
        args.bind, args.port, TRUFFLE_PREFIX, TRUFFLE_ROOT))
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
