#!/usr/bin/env python3
"""Serve the V4 public-room canary and mount the NGH corpus read-only."""
from __future__ import annotations

import argparse
import http.server
import mimetypes
import posixpath
import urllib.parse
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
WEB_ROOT = (REPO / "build/tests/v4-public-room/html5/bin").resolve()
NGH_ROOT = Path(r"C:\habbo\ngh").resolve()
mimetypes.add_type("application/x-shockwave-flash", ".swf")


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_ROOT), **kwargs)

    def translate_path(self, path: str) -> str:
        clean = urllib.parse.urlparse(path).path
        if clean.startswith("/ngh/"):
            relative = posixpath.normpath(urllib.parse.unquote(clean[len("/ngh/"):]))
            candidate = (NGH_ROOT / relative).resolve()
            if candidate != NGH_ROOT and NGH_ROOT not in candidate.parents:
                return str(WEB_ROOT / "__forbidden__")
            return str(candidate)
        return super().translate_path(path)

    def do_POST(self):
        self.send_error(405, "read-only server")

    do_PUT = do_POST
    do_DELETE = do_POST

    def log_message(self, fmt, *args):
        pass


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8777)
    parser.add_argument("--bind", default="127.0.0.1")
    args = parser.parse_args()
    if not (WEB_ROOT / "index.html").is_file():
        raise SystemExit("V4 browser build missing")
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    print(f"V4 http://{args.bind}:{args.port}/", flush=True)
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
