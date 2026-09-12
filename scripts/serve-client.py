#!/usr/bin/env python3
"""Serve the runnable client, Truffle payload, and NGH corpus read-only on one origin."""
from __future__ import annotations

import argparse
from collections import OrderedDict
import gzip
import http.server
import io
import os
import mimetypes
import posixpath
import urllib.parse
import urllib.error
import urllib.request
import threading
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DEFAULT_WEB_ROOT = (REPO / "build/client/html5/bin").resolve()
WEB_ROOT = DEFAULT_WEB_ROOT
TRUFFLE_ROOT = (REPO / "public/assets/truffle").resolve()
NGH_ROOT: Path | None = None
REMOTE_IMAGE_PREFIX = "/__skyhaxe_remote__/c_images/"
REMOTE_IMAGE_ORIGIN = "https://swf.nextgenhabbo.com/c_images/"

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
                if root is None:
                    return str(WEB_ROOT / "__missing_runtime_corpus__")
                relative = posixpath.normpath(urllib.parse.unquote(clean[len(prefix):]))
                candidate = (root / relative).resolve()
                if candidate != root and root not in candidate.parents:
                    return str(WEB_ROOT / "__forbidden__")
                return str(candidate)
        return super().translate_path(path)

    def end_headers(self):
        # Store bytes, but require validation on every reuse: no heuristic freshness for old
        # corpus files, and no repeated download of unchanged SWFs or the client bundle.
        if getattr(self, "_response_etag", None):
            self.send_header("ETag", self._response_etag)
        self.send_header("Cache-Control", "no-cache, must-revalidate")
        self.send_header("Vary", "Accept-Encoding")
        super().end_headers()

    # Text served here compresses by roughly six to one, and the client bundle alone is 24 MB.
    # Sending it raw is the whole of the slow first load: the build itself cannot be minified,
    # because `-final` runs Closure, whose property renaming breaks the dynamic property access
    # this port relies on for every SWF symbol and embed.
    COMPRESSIBLE = (".js", ".json", ".txt", ".xml", ".html", ".css", ".svg", ".map", ".ini")
    _gzip_cache: OrderedDict = OrderedDict()
    _gzip_lock = threading.Lock()
    _gzip_limit = 64 * 1024 * 1024
    _remote_image_cache: OrderedDict = OrderedDict()
    _remote_image_lock = threading.Lock()
    _remote_image_cache_limit = 32 * 1024 * 1024

    def _remote_image(self):
        """Fetch one allow-listed image tree for Flash-equivalent browser loading."""
        parsed = urllib.parse.urlparse(self.path)
        if not parsed.path.startswith(REMOTE_IMAGE_PREFIX):
            return None
        relative = posixpath.normpath(urllib.parse.unquote(parsed.path[len(REMOTE_IMAGE_PREFIX):]))
        if relative in ("", ".") or relative == ".." or relative.startswith("../"):
            self.send_error(403, "invalid remote image path")
            return False
        extension = Path(relative).suffix.lower()
        if extension not in (".png", ".jpg", ".jpeg", ".gif"):
            self.send_error(403, "remote asset type is not allowed")
            return False
        encoded = urllib.parse.quote(relative, safe="/@._-")
        upstream = REMOTE_IMAGE_ORIGIN + encoded
        if parsed.query:
            upstream += "?" + parsed.query

        with Handler._remote_image_lock:
            cached = Handler._remote_image_cache.get(upstream)
            if cached is not None:
                Handler._remote_image_cache.move_to_end(upstream)
        if cached is None:
            request = urllib.request.Request(
                upstream,
                headers={
                    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) SkyHaxe/1.0",
                    "Accept": "image/avif,image/webp,image/apng,image/*,*/*;q=0.8",
                    "Referer": "https://swf.nextgenhabbo.com/index.php",
                },
            )
            try:
                with urllib.request.urlopen(request, timeout=20) as response:
                    payload = response.read(8 * 1024 * 1024 + 1)
                    content_type = response.headers.get_content_type()
            except (urllib.error.URLError, TimeoutError) as error:
                self.send_error(502, f"remote image unavailable: {error}")
                return False
            if len(payload) > 8 * 1024 * 1024 or not content_type.startswith("image/"):
                self.send_error(502, "remote response is not an acceptable image")
                return False
            cached = (payload, content_type)
            with Handler._remote_image_lock:
                Handler._remote_image_cache[upstream] = cached
                Handler._remote_image_cache.move_to_end(upstream)
                while sum(len(item[0]) for item in Handler._remote_image_cache.values()) \
                        > Handler._remote_image_cache_limit:
                    Handler._remote_image_cache.popitem(last=False)

        payload, content_type = cached
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        return io.BytesIO(payload)

    def _gzipped(self, path: str):
        """Gzipped bytes for `path`, remembered per (size, mtime) so a 24 MB file is packed once."""
        stat = os.stat(path)
        key = (path, stat.st_size, stat.st_mtime_ns)
        with Handler._gzip_lock:
            cached = Handler._gzip_cache.get(key)
            if cached is None:
                with open(path, "rb") as raw:
                    cached = gzip.compress(raw.read(), 6)
                for stale in list(Handler._gzip_cache):
                    if stale[0] == path:
                        del Handler._gzip_cache[stale]
                Handler._gzip_cache[key] = cached
                while sum(map(len, Handler._gzip_cache.values())) > Handler._gzip_limit:
                    Handler._gzip_cache.popitem(last=False)
            elif key in Handler._gzip_cache:
                Handler._gzip_cache.move_to_end(key)
            return cached

    def send_head(self):
        self._response_etag = None
        remote = self._remote_image()
        if remote is not None:
            return remote or None
        # Only use our precise validator, not second-resolution Last-Modified.
        for header in ("If-Modified-Since",):
            while header in self.headers:
                del self.headers[header]

        path = self.translate_path(self.path)
        accepts = "gzip" in self.headers.get("Accept-Encoding", "")
        compressed = accepts and path.lower().endswith(self.COMPRESSIBLE)
        if os.path.isfile(path):
            stat = os.stat(path)
            etag = f'"{stat.st_mtime_ns:x}-{stat.st_size:x}-{"gz" if compressed else "raw"}"'
            # Nanosecond validators catch even same-size edits made within one second.
            if etag in [value.strip() for value in self.headers.get("If-None-Match", "").split(",")]:
                self.send_response(304)
                self.send_header("ETag", etag)
                self.end_headers()
                return None
            self._response_etag = etag
        if accepts and os.path.isfile(path) and path.lower().endswith(self.COMPRESSIBLE):
            try:
                payload = self._gzipped(path)
            except OSError:
                return super().send_head()
            self.send_response(200)
            self.send_header("Content-Type", self.guess_type(path))
            self.send_header("Content-Encoding", "gzip")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            return io.BytesIO(payload)

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
    global WEB_ROOT, NGH_ROOT
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--bind", default="127.0.0.1")
    parser.add_argument("--web-root", type=Path, default=DEFAULT_WEB_ROOT)
    parser.add_argument("--runtime-root", type=Path,
                        default=os.environ.get("SKYHAXE_RUNTIME_ROOT"),
                        help="SWF/gamedata corpus root (or set SKYHAXE_RUNTIME_ROOT)")
    args = parser.parse_args()
    web_root = args.web_root.resolve()
    if not (web_root / "index.html").is_file():
        raise SystemExit(f"no HTML5 build found at {web_root}")
    if args.runtime_root is None:
        raise SystemExit("pass --runtime-root or set SKYHAXE_RUNTIME_ROOT")
    runtime_root = args.runtime_root.resolve()
    if not runtime_root.is_dir():
        raise SystemExit(f"runtime corpus not found at {runtime_root}")
    server = http.server.ThreadingHTTPServer((args.bind, args.port), Handler)
    WEB_ROOT = web_root
    NGH_ROOT = runtime_root
    print(f"SkyHaxe http://localhost:{args.port}/", flush=True)
    server.serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
