import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load(name, relative):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DISCOVERY = load("skyhaxe_discovery", "build-support/generation/discover-update.py")
UPDATE = load("skyhaxe_update", "build-support/generation/update-client.py")


class UpdateWorkflowTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp_root = ROOT / "build/tests/update-workflow"
        cls.temp_root.mkdir(parents=True, exist_ok=True)

    def test_discovers_new_transitive_class_asset_and_reflected_class(self):
        with tempfile.TemporaryDirectory(dir=self.temp_root) as temporary:
            src = Path(temporary) / "src"; package = src / "com/example"; package.mkdir(parents=True)
            (package / "Root.as").write_text(
                'package com.example { import com.example.Feature; public class Root { '
                'private var f:Feature; private var reflected:String="com.example.Reflected"; } }')
            (package / "Feature.as").write_text(
                'package com.example { public class Feature { [Embed(source="icon.png")] var Icon:Class; } }')
            (package / "Reflected.as").write_text('package com.example { public class Reflected {} }')
            (package / "icon.png").write_bytes(b"png")
            closure, assets, unresolved = DISCOVERY.discover(src, ["com/example/Root.as"], set())
            self.assertEqual(closure, ["com/example/Feature.as", "com/example/Reflected.as",
                                       "com/example/Root.as"])
            self.assertEqual(len(assets), 1)
            self.assertTrue(assets[0]["exists"])
            self.assertEqual(unresolved, [])

    def test_dirty_checkout_requires_explicit_inclusion(self):
        with tempfile.TemporaryDirectory(dir=self.temp_root) as temporary:
            repo = Path(temporary)
            UPDATE.run(["git", "init", str(repo)])
            UPDATE.run(["git", "-C", str(repo), "config", "user.email", "test@example.invalid"])
            UPDATE.run(["git", "-C", str(repo), "config", "user.name", "Test"])
            (repo / "tracked.as").write_text("one")
            UPDATE.run(["git", "-C", str(repo), "add", "tracked.as"])
            UPDATE.run(["git", "-C", str(repo), "commit", "-m", "base"])
            (repo / "tracked.as").write_text("two")
            with self.assertRaisesRegex(RuntimeError, "IncludeDirty"):
                UPDATE.git_info(repo, False)
            self.assertTrue(UPDATE.git_info(repo, True)["dirty"])

    def test_tree_diff_reports_added_changed_and_removed(self):
        with tempfile.TemporaryDirectory(dir=self.temp_root) as temporary:
            root = Path(temporary); left = root / "left"; right = root / "right"
            left.mkdir(); right.mkdir()
            (left / "changed").write_text("old"); (right / "changed").write_text("new")
            (left / "removed").write_text("x"); (right / "added").write_text("x")
            self.assertEqual(UPDATE.compare(UPDATE.tree_manifest(left), UPDATE.tree_manifest(right)), {
                "added": ["added"], "removed": ["removed"], "changed": ["changed"]})


if __name__ == "__main__":
    unittest.main()
