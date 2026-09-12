"""Failure-safety contracts; fake converter, real staging/publication, no client writes."""
import contextlib
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import sync


class PublicationTests(unittest.TestCase):
    def test_generated_path_matches_haxe_package_normalization(self):
        self.assertEqual(
            sync.generated_relative("snowwar/_Str_400/Probe.as"),
            "snowwar/_str_400/Probe.hx",
        )

    def test_rules_are_ordered_when_sources_are_cached(self):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-rules-test-") as directory:
            root = Path(directory)
            first = root / "example/A.as"
            second = root / "example/B.as"
            first.parent.mkdir(parents=True)
            first.write_text("foo", encoding="utf-8")
            second.write_text("foo", encoding="utf-8")
            rules = [
                {"id": "first", "reason": "test", "kind": "regex",
                 "pattern": "foo", "replacement": "bar", "expect": {"cached": 2}},
                {"id": "second", "reason": "test", "kind": "regex",
                 "pattern": "bar", "replacement": "baz", "paths": ["example/A.as"],
                 "expect": {"cached": 1}},
            ]
            with patch.object(sync, "RULES", rules):
                applied, unpinned = sync.apply_rules(root, "cached")
            self.assertEqual([item["sites"] for item in applied], [2, 1])
            self.assertEqual(unpinned, [])
            self.assertEqual(first.read_text(encoding="utf-8"), "baz")
            self.assertEqual(second.read_text(encoding="utf-8"), "bar")

    def run_sync(self, mode, deterministic=True):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-sync-test-") as directory:
            root = Path(directory)
            source = root / "client/src/example/A.as"
            source.parent.mkdir(parents=True)
            source.write_text("package example { public class A {} }", encoding="utf-8")
            target = root / "generated/example/A.hx"
            target.parent.mkdir(parents=True)
            target.write_text("old", encoding="utf-8")
            stamp = target.stat().st_mtime_ns
            other = target.with_name("Unrelated.hx")
            other.write_text("keep", encoding="utf-8")
            closure = root / "closure.json"
            closure.write_text(json.dumps({"closure": ["example/A.as"]}), encoding="utf-8")
            manifest = root / "result.json"
            calls = 0

            def convert(workspace, output):
                nonlocal calls
                calls += 1
                if mode != "missing":
                    produced = output / "example/A.hx"
                    produced.parent.mkdir(parents=True)
                    produced.write_text("old" if mode == "unchanged" else
                                        str(calls) if mode == "nondeterministic" else "new",
                                        encoding="utf-8")
                if mode == "support-drift":
                    (output / "Globals.hx").write_text(str(calls), encoding="utf-8")
                return {"exit_code": 1 if mode == "failure" else 0,
                        "seconds": 0, "stdout_tail": [], "stderr_tail": []}

            argv = ["sync.py", "--client-root", str(root / "client"),
                    "--package", "example", "--generated-root", str(root / "generated"),
                    "--closure", str(closure), "--manifest", str(manifest)]
            if deterministic:
                argv.append("--check-determinism")
            with patch.object(sync, "WORKSPACE", root / "workspace"), \
                 patch.object(sync, "check_exceptions", return_value={}), \
                 patch.object(sync, "check_asset_inputs", return_value={
                     "missing_manifest": False, "missing": [], "drifted": []}), \
                 patch.object(sync, "apply_rules", return_value=([], [])), \
                 patch.object(sync, "run_converter", side_effect=convert), \
                 patch.object(sys, "argv", argv), contextlib.redirect_stdout(io.StringIO()):
                status = sync.main()
            result = json.loads(manifest.read_text(encoding="utf-8"))
            self.assertEqual(other.read_text(), "keep")
            self.assertEqual(source.read_text(), "package example { public class A {} }")
            return status, result, target.read_text(), target.stat().st_mtime_ns == stamp

    def test_converter_failure_preserves_published_files(self):
        status, manifest, contents, unchanged = self.run_sync("failure")
        self.assertEqual(status, 1)
        self.assertFalse(manifest["published"])
        self.assertEqual(len(manifest["runs"]), 1)
        self.assertEqual(contents, "old")
        self.assertTrue(unchanged)

    def test_missing_output_preserves_published_files(self):
        self.assertFalse(self.run_sync("missing")[1]["published"])
        self.assertEqual(self.run_sync("missing")[2], "old")

    def test_nondeterminism_preserves_published_files(self):
        status, manifest, contents, _ = self.run_sync("nondeterministic")
        self.assertFalse(manifest["published"])
        self.assertEqual(contents, "old")

    def test_success_publishes(self):
        status, manifest, contents, _ = self.run_sync("success")
        self.assertEqual(status, 0)
        self.assertTrue(manifest["ok"])
        self.assertTrue(manifest["published"])
        self.assertEqual(contents, "new")

    def test_support_module_nondeterminism_blocks_publication(self):
        status, manifest, contents, _ = self.run_sync("support-drift")
        self.assertFalse(manifest["published"])
        self.assertEqual(contents, "old")

    def test_identical_output_preserves_timestamp(self):
        self.assertTrue(self.run_sync("unchanged")[3])

    def test_one_pass_is_not_a_determinism_gate(self):
        status, manifest, contents, _ = self.run_sync("success", deterministic=False)
        self.assertFalse(manifest["ok"])
        self.assertTrue(manifest["published"])
        self.assertEqual(contents, "new")


if __name__ == "__main__":
    unittest.main()
