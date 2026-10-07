import com.sulake.core.window.text.HabboText;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.AntiAliasType;
import openfl.display.BitmapData;

@:access(com.sulake.core.window.text.HabboText)
class V21ThicknessTest {
    static function snapshot(field:TextField):BitmapData {
        var pixels = new BitmapData(200, 50, true, 0);
        pixels.draw(field);
        return pixels;
    }
    static function main() {
        HabboText.load("/assets/habbo-text", [], run, function(e) { throw e; });
    }
    static function run() {
        var field = new TextField();
        field.width = 200;
        field.height = 50;
        field.defaultTextFormat = new TextFormat("Ubuntu", 18, 0x336699);
        field.text = "Habbo text";
        if (field.getImageReference("absent") != null) throw "Image-free field returned a reference";
        field.embedFonts = true;
        field.antiAliasType = AntiAliasType.ADVANCED;
        field.thickness = -100;
        var expected = HabboText.instance.api.width(field.text, HabboText.openFLStyle(field, field.defaultTextFormat));
        if (Math.abs(field.textWidth - expected) > 0.01)
            throw 'Text width did not use Habbo advances: ${field.textWidth} expected ${expected}';
        var thin = snapshot(field);
        field.thickness = 100;
        var thick = snapshot(field);
        var thinAlpha = 0;
        var thickAlpha = 0;
        for (y in 0...50) for (x in 0...200) {
            thinAlpha += thin.getPixel32(x, y) >>> 24;
            thickAlpha += thick.getPixel32(x, y) >>> 24;
        }
        if (thinAlpha == 0 || thickAlpha <= thinAlpha) throw "Thickness did not reach actual font rasterization";
        field.thickness = 201;
        if (field.thickness != 200) throw "Positive thickness clamp changed";
        field.thickness = -201;
        if (field.thickness != -200) throw "Negative thickness clamp changed";
        field.antiAliasType = AntiAliasType.NORMAL;
        field.embedFonts = false;
        var nativeFill = js.Syntax.code("CanvasRenderingContext2D.prototype.fillText");
        var fallbackCalls = 0;
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = function() { {0}(); return {1}.apply(this, arguments); }", function() { fallbackCalls++; }, nativeFill);
        var normal:BitmapData = null;
        try { normal = snapshot(field); }
        catch (error:Dynamic) { js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = {0}", nativeFill); throw error; }
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = {0}", nativeFill);
        if (fallbackCalls == 0) throw "Normal Ubuntu did not use the reference canvas fallback";
        normal.dispose();
        thin.dispose(); thick.dispose();
        trace("V21_THICKNESS_PASS actual-habbo-canvas pixel-coverage clamp metrics normal-AA-reference-fallback");
    }
}
