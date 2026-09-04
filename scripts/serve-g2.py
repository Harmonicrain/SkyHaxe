#!/usr/bin/env python3
"""Serve the G2 test page and the asset corpus from one origin, read-only.

G2's definition of done requires the reader to fetch SWFs **over HTTP, not from `C:\\`** --
loading through a local path hides CORS, MIME and caching problems that only appear in a real
deployment. Serving the corpus from a second port would introduce cross-origin failures that are
an artefact of the test rig rather than of the client, so both live under one origin here:

    /              -> build/tests/g2-swf-reader/html5/bin
    /ngh/...       -> c:/habbo/ngh/...           (read-only; GET and HEAD only)

The corpus root is resolved and every request is checked against it, so `..` cannot escape.

Usage:
    python scripts/serve-g2.py [--port 8769]

G2e may additionally pass `--capture-output <file>`. That enables exactly one localhost-only
`POST /flash-result` endpoint which writes the AIR reference result under SkyHaxe's build tree.
It does not enable writes to `/ngh/`; the corpus remains GET/HEAD-only.
"""
from __future__ import annotations

import argparse
import http.server
import mimetypes
import posixpath
import json
import urllib.parse
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
WEB_ROOT = REPO / "build/tests/g2-swf-reader/html5/bin"
CORPUS_ROOT = Path(r"C:\habbo\ngh").resolve()
CORPUS_PREFIX = "/ngh/"

mimetypes.add_type("application/x-shockwave-flash", ".swf")


class Handler(http.server.SimpleHTTPRequestHandler):
    capture_output: Path | None = None

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_ROOT), **kwargs)

    def translate_path(self, path: str) -> str:
        clean = urllib.parse.urlparse(path).path
        if not clean.startswith(CORPUS_PREFIX):
            return super().translate_path(path)

        relative = posixpath.normpath(urllib.parse.unquote(clean[len(CORPUS_PREFIX):]))
        candidate = (CORPUS_ROOT / relative).resolve()
        if CORPUS_ROOT not in candidate.parents and candidate != CORPUS_ROOT:
            # Refuse to serve anything outside the corpus, whatever the path claimed.
            return str(WEB_ROOT / "__forbidden__")
        return str(candidate)

    def log_message(self, fmt, *args):
        if self.capture_output is not None:
            log = self.capture_output.with_suffix(".requests.log")
            with log.open("a", encoding="utf-8") as handle:
                handle.write((fmt % args) + "\n")

    def do_POST(self):
        if self.capture_output is None or urllib.parse.urlparse(self.path).path != "/flash-result":
            self.send_error(405, "POST disabled")
            return
        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0 or length > 2 * 1024 * 1024:
            self.send_error(413, "invalid capture size")
            return
        raw = self.rfile.read(length)
        try:
            value = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.send_error(400, "invalid JSON")
            return
        self.capture_output.parent.mkdir(parents=True, exist_ok=True)
        self.capture_output.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")
        self.send_response(204)
        self.end_headers()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=8769)
    ap.add_argument("--bind", default="127.0.0.1")
    ap.add_argument("--capture-output", type=Path)
    args = ap.parse_args()

    if not (WEB_ROOT / "index.html").is_file():
        raise SystemExit("no G2 build at {}. Run scripts/test-g2-swf-reader.ps1 first.".format(WEB_ROOT))

    Handler.capture_output = args.capture_output.resolve() if args.capture_output else None
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    print("page   http://{}:{}/".format(args.bind, args.port))
    print("corpus http://{}:{}{} -> {} (read-only)".format(
        args.bind, args.port, CORPUS_PREFIX, CORPUS_ROOT))
    if Handler.capture_output:
        print("capture POST /flash-result -> {}".format(Handler.capture_output))
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
