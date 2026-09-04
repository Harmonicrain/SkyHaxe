#!/usr/bin/env python3
"""Serve the runnable client, Truffle payload, and NGH corpus read-only on one origin."""
from __future__ import annotations

import argparse
import http.server
import mimetypes
import posixpath
import urllib.parse
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
WEB_ROOT = (REPO / "build/html5/bin").resolve()
TRUFFLE_ROOT = (REPO / "public/assets/truffle").resolve()
NGH_ROOT = Path(r"C:\habbo\ngh").resolve()

mimetypes.add_type("application/wasm", ".wasm")
mimetypes.add_type("application/javascript", ".js")
mimetypes.add_type("application/octet-stream", ".tfc")


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_ROOT), **kwargs)

    def translate_path(self, path: str) -> str:
        clean = urllib.parse.urlparse(path).path
        mounts = (("/assets/truffle/", TRUFFLE_ROOT), ("/ngh/", NGH_ROOT))
        for prefix, root in mounts:
            if clean.startswith(prefix):
                relative = posixpath.normpath(urllib.parse.unquote(clean[len(prefix):]))
                candidate = (root / relative).resolve()
                if candidate != root and root not in candidate.parents:
                    return str(WEB_ROOT / "__forbidden__")
                return str(candidate)
        return super().translate_path(path)

    def end_headers(self):
        # SimpleHTTPRequestHandler sends Last-Modified but no Cache-Control and no ETag. With no
        # explicit freshness a browser applies heuristic caching -- roughly 10% of the file's age
        # -- and the gordon corpus was last written in 2016, so its SWFs get cached for years and
        # are never revalidated. The client bundle is minutes old and revalidates normally, so a
        # reload mixes a fresh bundle with indefinitely stale assets. That is nondeterministic by
        # construction: it works on a clean profile, breaks on F5, and comes back after a cache
        # wipe or in incognito, which is precisely the reload failure this was diagnosed from.
        #
        # A development server has no reason to want any of that. Every response is explicitly
        # uncacheable so a reload is always the same as a first load.
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def send_head(self):
        # Ignore conditional requests from anything already holding a heuristically cached copy,
        # so an existing stale cache cannot survive the switch to no-store above.
        for header in ("If-Modified-Since", "If-None-Match"):
            while header in self.headers:
                del self.headers[header]
        return super().send_head()

    def do_POST(self):
        self.send_error(405, "read-only server")

    def do_PUT(self):
        self.send_error(405, "read-only server")

    def do_DELETE(self):
        self.send_error(405, "read-only server")

    def log_message(self, fmt, *args):
        pass


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--bind", default="127.0.0.1")
    args = parser.parse_args()
    if not (WEB_ROOT / "index.html").is_file():
        raise SystemExit("build the HTML5 client first")
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    print(f"SkyHaxe http://localhost:{args.port}/", flush=True)
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
