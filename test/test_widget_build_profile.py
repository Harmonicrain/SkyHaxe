import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import widget_build_profile as profile


class WidgetProfileTests(unittest.TestCase):
    def test_original_enabled_bodies_and_event_bus_retained(self):
        source = '''package p {
import p.Keep;
import p.Unused;
class Owner {
function createWidget(k:String):void {
var unused:Unused;
var kept:Keep;
switch (k) {
case RoomWidgetEnum.OTHER: unused = new Unused(); break;
case RoomWidgetEnum.INFOSTAND: kept = new Keep("{case ignored:}"); break;
case RoomWidgetEnum.AVATAR_INFO: return;
}
registerOriginalEvents(kept);
}
function dispose():void { originalDispose(); }
}}'''
        result, record = profile.project(profile.OWNERS[0], source)
        self.assertIn('case RoomWidgetEnum.INFOSTAND: kept = new Keep("{case ignored:}"); break;', result)
        self.assertIn('registerOriginalEvents(kept);', result)
        self.assertIn('function dispose():void { originalDispose(); }', result)
        self.assertNotIn('Unused', result)
        self.assertEqual(record['excluded_widgets'], ['OTHER'])
        self.assertEqual(record['removed_unused_locals'], ['unused'])
        self.assertEqual(profile.project('p/Untouched.as', source), (source, None))

    def test_manifest_fails_closed_on_drift(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = 'class Owner { function createWidget(k:String):void { switch(k) { case RoomWidgetEnum.INFOSTAND: return; case RoomWidgetEnum.AVATAR_INFO: return; } } }'
            _, record = profile.project(profile.OWNERS[0], source)
            path = root / profile.OWNERS[0]
            path.parent.mkdir(parents=True)
            path.write_text(source + ' // changed', encoding='utf-8')
            manifest = root / 'profile.json'
            manifest.write_text(json.dumps({'owners': {profile.OWNERS[0]: record}}))
            with patch.object(profile, 'MANIFEST', manifest):
                with self.assertRaisesRegex(ValueError, 'drift'):
                    profile.apply_to_staged(root)


if __name__ == '__main__':
    unittest.main()
