"""Failed converter probes must never reuse earlier generated fixtures or PASS evidence."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


SPEC = importlib.util.spec_from_file_location(
    "converter_probe", Path(__file__).resolve().parents[1] / "evidence/v21_converter_regression.py")
probe = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(probe)


class ConverterProbeIsolationTest(unittest.TestCase):
    def test_zero_exit_missing_source_cannot_reuse_previous_pass(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fixtures = root / "test/as3/window_conversion"
            fixtures.mkdir(parents=True)
            for name in ("Probe", "OtherProbe"):
                (fixtures / (name + ".as")).write_text("fixture", encoding="utf-8")
            evidence = root / "evidence/v21_converter_regression.json"
            evidence.parent.mkdir()
            evidence.write_text('{"ok": true}', encoding="utf-8")
            old = root / ".toolchain/tests/window-conversion/generated/window_conversion"
            old.mkdir(parents=True)
            for name in ("Probe", "OtherProbe"):
                (old / (name + ".hx")).write_text("stale", encoding="utf-8")
            workspaces = []

            def incomplete(workspace, output):
                workspaces.append(workspace)
                target = output / "window_conversion/Probe.hx"
                target.parent.mkdir(parents=True)
                target.write_text("fresh but incomplete", encoding="utf-8")
                return {"exit_code": 0, "stdout_tail": [], "stderr_tail": []}

            with patch.object(probe, "REPO", root), \
                 patch.object(probe.sync, "run_converter", side_effect=incomplete), \
                 patch.object(probe.subprocess, "run") as compile_or_browser:
                self.assertEqual(probe.main(), 1)
                self.assertEqual(probe.main(), 1)
                compile_or_browser.assert_not_called()
            result = json.loads(evidence.read_text(encoding="utf-8"))
            self.assertFalse(result["ok"])
            self.assertEqual(result["missing_sources"], ["OtherProbe.as"])
            self.assertNotEqual(workspaces[0], workspaces[1])
            self.assertEqual((old / "OtherProbe.hx").read_text(), "stale")


if __name__ == "__main__":
    unittest.main()
