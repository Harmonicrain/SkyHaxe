"""Wildcard imports must find used embedded classes, not pull in an entire package."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("walker", Path(__file__).resolve().parents[1] / "scripts/generate-closure-context.py")
walker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(walker)


class WildcardTests(unittest.TestCase):
    def tearDown(self):
        walker.exact_source_file.cache_clear()

    def test_retired_exception_stays_in_typing_context(self):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-retired-") as directory:
            root = Path(directory)
            (root / "p").mkdir()
            (root / "p/A.as").write_text("package p { import p.Retired; class A { var dependency:Retired; } }", encoding="utf-8")
            (root / "p/Retired.as").write_text("package p { class Retired {} }", encoding="utf-8")
            manifest = root / "closure.json"
            manifest.write_text(json.dumps({"closure": ["p/A.as"], "retired_exceptions": ["p/Retired.as"]}), encoding="utf-8")
            with patch.object(walker, "CLIENT", root), patch.object(walker, "seam_sources", return_value={"p/Retired.as"}):
                self.assertEqual(walker.main([str(manifest)]), 0)
            self.assertIn("p/Retired.as", json.loads(manifest.read_text())["context"])

    def test_used_class_and_same_package_precedence(self):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-wildcard-") as directory:
            root = Path(directory)
            for relative in ("p/A.as", "p/Local.as", "p/assets/Used.as", "p/assets/Unused.as", "p/assets/Local.as"):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("", encoding="utf-8")
            (root / "p/A.as").write_text('''package p {
                import p.assets.*;
                public class A { var used:Used; var local:Local;
                    // Unused
                    var text:String = "Unused";
                }
            }''', encoding="utf-8")
            with patch.object(walker, "CLIENT", root):
                references = walker.references("p/A.as")
            self.assertIn("p/assets/Used", references)
            self.assertIn("p/Local", references)
            self.assertNotIn("p/assets/Local", references)
            self.assertNotIn("p/assets/Unused", references)

    def test_qualified_constant_does_not_alias_differently_cased_source(self):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-case-") as directory:
            root = Path(directory)
            (root / "p/models").mkdir(parents=True)
            (root / "p/A.as").write_text('''package p {
                import p.models.Badge;
                public class A { var badge:Badge; var value:int = p.models.BADGE; }
            }''', encoding="utf-8")
            (root / "p/models/Badge.as").write_text(
                "package p.models { public class Badge {} }", encoding="utf-8")
            with patch.object(walker, "CLIENT", root):
                context = walker.context_for(["p/A.as"], set())
            self.assertIn("p/models/Badge.as", context)
            self.assertNotIn("p/models/BADGE.as", context)

    def test_root_package_sibling_is_a_dependency(self):
        with tempfile.TemporaryDirectory(prefix="skyhaxe-root-package-") as directory:
            root = Path(directory)
            (root / "Owner.as").write_text(
                "package { public class Owner { var required:RequiredLibrary; } }", encoding="utf-8")
            (root / "RequiredLibrary.as").write_text(
                "package { public class RequiredLibrary {} }", encoding="utf-8")
            with patch.object(walker, "CLIENT", root):
                context = walker.context_for(["Owner.as"], set())
            self.assertIn("RequiredLibrary.as", context)


if __name__ == "__main__":
    unittest.main()
