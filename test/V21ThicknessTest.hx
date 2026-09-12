import com.sulake.core.window.text.TruffleText;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.AntiAliasType;
import openfl.display.BitmapData;

@:access(com.sulake.core.window.text.TruffleText)
class V21ThicknessTest {
    static function snapshot(field:TextField):BitmapData {
        var pixels = new BitmapData(200, 50, true, 0);
        pixels.draw(field);
        return pixels;
    }
    static function main() {
        TruffleText.instance = new TruffleText(js.Syntax.code("window.__truffleAPI"));
        var field = new TextField();
        field.width = 200;
        field.height = 50;
        field.defaultTextFormat = new TextFormat("Ubuntu", 18, 0x336699);
        field.text = "Habbo text";
        if (field.getImageReference("absent") != null) throw "Image-free field returned a reference";
        field.embedFonts = true;
        field.antiAliasType = AntiAliasType.ADVANCED;
        field.thickness = -100;
        var expected = TruffleText.instance.api.measure(field.text, TruffleText.openFLStyle(field, field.defaultTextFormat), {});
        if (Math.abs(field.textWidth - expected.textWidth) > 0.01)
            throw 'Text width did not use Truffle advances: ${field.textWidth} expected ${expected.textWidth}';
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
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = function() { throw new Error('Browser font fallback used'); }");
        var normal = snapshot(field);
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = {0}", nativeFill);
        normal.dispose();
        thin.dispose(); thick.dispose();
        trace("V21_THICKNESS_PASS actual-truffle-canvas pixel-coverage clamp metrics normal-AA-no-browser-fallback");
    }
}
