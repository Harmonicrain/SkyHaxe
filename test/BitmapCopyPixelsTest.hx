import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import skyhaxe.compat.BitmapCopyPixels;

class BitmapCopyPixelsTest {
    public static function main():Void {
        BitmapCopyPixels.install();

        // Paired -47 offsets must cancel: all 115 destination rows receive source rows 0..114.
        var source = new BitmapData(1, 162, false, 0);
        for (y in 0...162) source.setPixel32(0, y, 0xFF000000 | y);
        var target = new BitmapData(1, 115, false, 0xFFFF00FF);
        target.copyPixels(source, new Rectangle(0, -47, 1, 162), new Point(0, -47));
        equal(0xFF000000, target.getPixel32(0, 0), "top row");
        equal(0xFF000072, target.getPixel32(0, 114), "bottom row");

        // Ordinary and one-sided clipping retain the normal Flash mapping.
        var ordinary = new BitmapData(1, 3, false, 0);
        ordinary.copyPixels(source, new Rectangle(0, 10, 1, 3), new Point(0, 0));
        equal(0xFF00000A, ordinary.getPixel32(0, 0), "ordinary top");
        equal(0xFF00000C, ordinary.getPixel32(0, 2), "ordinary bottom");
        var clipped = new BitmapData(1, 3, false, 0xFFFF00FF);
        clipped.copyPixels(source, new Rectangle(0, 10, 1, 3), new Point(0, -1));
        equal(0xFF00000B, clipped.getPixel32(0, 0), "negative destination advances source");
        equal(0xFF00000C, clipped.getPixel32(0, 1), "negative destination second row");
        equal(0xFFFF00FF, clipped.getPixel32(0, 2), "uncovered row retained");
        #if (js && html5)
        js.Browser.document.body.setAttribute("data-result", "pass");
        js.Browser.document.body.innerText = "BITMAP_COPY_PIXELS_PASS";
        #end
        trace("BITMAP_COPY_PIXELS_PASS paired-negative ordinary destination-clipped");
    }

    static function equal(expected:UInt, actual:UInt, label:String):Void {
        if (expected != actual) throw '$label expected=${StringTools.hex(expected, 8)} actual=${StringTools.hex(actual, 8)}';
    }
}
