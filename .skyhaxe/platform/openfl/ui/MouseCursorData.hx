package openfl.ui;

import openfl.display.BitmapData;
import openfl.geom.Point;

/** Flash native-cursor data contract implemented by the HTML5 Mouse candidate adapter. */
class MouseCursorData {
    public var data:Vector<BitmapData>;
    public var frameRate:Float = 0;
    public var hotSpot:Point = new Point();
    public function new() {}
}
