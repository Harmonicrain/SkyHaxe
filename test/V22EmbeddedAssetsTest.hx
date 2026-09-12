import com.sulake.core.window.tools.binaryData.ProfilerOutput__Str_15863;
import com.sulake.habbo.window.utils.floorplaneditor.images.FloorEditorTileBase;

class V22EmbeddedAssetsTest extends openfl.display.Sprite {
    static final earlyBinary = new ProfilerOutput__Str_15863();
    public function new() {
        super();
        var binary = new ProfilerOutput__Str_15863();
        if (earlyBinary.length != binary.length || earlyBinary.position != 0) throw "Static binary Embed initialization changed";
        var original = openfl.Assets.getBytes("skyhaxe/embed/com/sulake/core/window/tools/binaryData/ProfilerOutput__Str_15863.bin");
        if (binary.length != original.length || binary.position != 0
                || binary.endian != openfl.utils.Endian.BIG_ENDIAN) throw "Embedded byte-array contract changed";
        for (index in 0...original.length)
            if (binary.get(index) != original[index]) throw "Embedded bytes differ";
        binary.position = 0;
        var xml = new com.sulake.core.utils.xml.XML(binary.readUTFBytes(binary.length));
        if (xml.toXMLString().length == 0) throw "Embedded profiler XML is empty";
        var first = new FloorEditorTileBase();
        var second = new FloorEditorTileBase();
        var image = openfl.Assets.getBitmapData("skyhaxe/embed/com/sulake/habbo/window/utils/floorplaneditor/images/FloorEditorTileBase.png");
        if (first.bitmapData == null || first.bitmapData.width != image.width
                || first.bitmapData.height != image.height || first.bitmapData == second.bitmapData)
            throw "Embedded bitmap dimensions or instance ownership changed";
        for (y in 0...image.height) for (x in 0...image.width)
            if (first.bitmapData.getPixel32(x, y) != image.getPixel32(x, y)) throw "Embedded pixels differ";
        first.bitmapData.dispose();
        if (second.bitmapData.width != image.width) throw "Disposing one embedded image changed another";
        second.bitmapData.dispose();
        js.Browser.document.body.insertBefore(js.Browser.document.createTextNode("V22_EMBEDDED_PASS"), js.Browser.document.body.firstChild);
        trace("V22_EMBEDDED_PASS exact-bytes exact-pixels independent-instances");
    }
}
