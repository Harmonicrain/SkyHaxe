#!/usr/bin/env python3
"""Serve the G4 browser build and mount the NGH corpus read-only on the same origin."""
from __future__ import annotations

import argparse
import http.server
import json
import mimetypes
import posixpath
import urllib.parse
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
WEB_ROOT = REPO / "build/tests/g4-renderer/html5/bin"
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
            return str(WEB_ROOT / "__forbidden__")
        return str(candidate)

    def log_message(self, fmt, *args):
        pass

    def do_POST(self):
        if self.capture_output is None or urllib.parse.urlparse(self.path).path != "/flash-result":
            self.send_error(405, "POST disabled")
            return
        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0 or length > 1024 * 1024:
            self.send_error(413, "invalid capture size")
            return
        try:
            value = json.loads(self.rfile.read(length).decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.send_error(400, "invalid JSON")
            return
        self.capture_output.parent.mkdir(parents=True, exist_ok=True)
        self.capture_output.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")
        self.send_response(204)
        self.end_headers()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8771)
    parser.add_argument("--bind", default="127.0.0.1")
    parser.add_argument("--capture-output", type=Path)
    args = parser.parse_args()
    if not (WEB_ROOT / "index.html").is_file():
        raise SystemExit("G4 browser build missing; run scripts/test-g4-renderer.ps1 first")
    Handler.capture_output = args.capture_output.resolve() if args.capture_output else None
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    print(f"G4 http://{args.bind}:{args.port}/ (NGH mounted read-only at /ngh/)", flush=True)
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
