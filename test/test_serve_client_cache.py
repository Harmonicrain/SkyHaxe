"""Exercise real HTTP validation and compression against the development handler."""
import gzip
import http.client
import importlib.util
import os
from pathlib import Path
import tempfile
import threading
import unittest
from unittest import mock

spec = importlib.util.spec_from_file_location("serve_client", Path(__file__).resolve().parents[1] / "scripts/serve-client.py")
server_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(server_module)


class CacheTest(unittest.TestCase):
    def test_revalidation_edit_and_compression_reuse(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            server_module.WEB_ROOT = root
            payload = b"var test = 123;\n" * 1000
            (root / "client.js").write_bytes(payload)
            (root / "other.json").write_bytes(b"{}")
            (root / "asset.swf").write_bytes(b"FWS-test")
            server = server_module.http.server.ThreadingHTTPServer(("127.0.0.1", 0), server_module.Handler)
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()

            def request(path, headers=None):
                connection = http.client.HTTPConnection(*server.server_address)
                connection.request("GET", path, headers=headers or {})
                response = connection.getresponse()
                result = response.status, dict(response.getheaders()), response.read()
                connection.close()
                return result

            try:
                status, headers, body = request("/client.js", {"Accept-Encoding": "gzip"})
                self.assertEqual(status, 200)
                self.assertEqual(gzip.decompress(body), payload)
                self.assertEqual(headers["Vary"], "Accept-Encoding")
                status, _, body = request("/client.js", {"Accept-Encoding": "gzip", "If-None-Match": headers["ETag"]})
                self.assertEqual((status, body), (304, b""))
                request("/other.json", {"Accept-Encoding": "gzip"})
                self.assertEqual(len(server_module.Handler._gzip_cache), 2)
                status, raw_headers, body = request("/asset.swf")
                self.assertEqual(status, 200)
                self.assertEqual(request("/asset.swf", {"If-None-Match": raw_headers["ETag"]})[0], 304)
                old = (root / "client.js").stat()
                (root / "client.js").write_bytes(payload.replace(b"123", b"456"))
                os.utime(root / "client.js", ns=(old.st_atime_ns, old.st_mtime_ns + 100))
                status, changed, body = request("/client.js", {"Accept-Encoding": "gzip", "If-None-Match": headers["ETag"]})
                self.assertEqual(status, 200)
                self.assertNotEqual(changed["ETag"], headers["ETag"])
                self.assertIn(b"456", gzip.decompress(body))
            finally:
                server.shutdown()
                server.server_close()
                thread.join()

    def test_remote_image_bridge_is_allow_listed_and_cached(self):
        payload = b"\x89PNG\r\n\x1a\nroom-ad"

        class Response:
            headers = type("Headers", (), {"get_content_type": lambda self: "image/png"})()

            def __enter__(self):
                return self

            def __exit__(self, *_):
                return False

            def read(self, _limit):
                return payload

        with tempfile.TemporaryDirectory() as directory, mock.patch.object(
                server_module.urllib.request, "urlopen", return_value=Response()) as fetch:
            server_module.WEB_ROOT = Path(directory)
            server_module.Handler._remote_image_cache.clear()
            server = server_module.http.server.ThreadingHTTPServer(("127.0.0.1", 0), server_module.Handler)
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()

            def request(path):
                connection = http.client.HTTPConnection(*server.server_address)
                connection.request("GET", path)
                response = connection.getresponse()
                result = response.status, dict(response.getheaders()), response.read()
                connection.close()
                return result

            try:
                path = "/__skyhaxe_remote__/c_images/ridge/Rooms/Myn_10/wip_08_1.png"
                self.assertEqual(request(path), (200, mock.ANY, payload))
                self.assertEqual(request(path)[0], 200)
                self.assertEqual(fetch.call_count, 1)
                self.assertEqual(request("/__skyhaxe_remote__/c_images/../../secret.png")[0], 403)
                self.assertEqual(request("/__skyhaxe_remote__/c_images/file.swf")[0], 403)
            finally:
                server.shutdown()
                server.server_close()
                thread.join()


if __name__ == "__main__":
    unittest.main()
