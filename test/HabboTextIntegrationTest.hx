import com.sulake.core.window.text.HabboText;
import js.Browser;
import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.geom.Matrix;
import openfl.geom.ColorTransform;

@:access(com.sulake.core.window.text.HabboText)
class HabboTextIntegrationTest extends Sprite {
    // The full client loads the style manager before the dynamically constructed label-cache singleton.
    static final stylesReady = com.sulake.core.window.utils.TextStyleManager.enumerateStyles();
    public function new() {
        super();
        HabboText.load("/assets/habbo-text", [], function() {
            try { run(); } catch (e:Dynamic) { js.Syntax.code("window.__fontHaxe = {ok:false,error:String({0}),stack:{0}.stack}", e); }
        }, function(error) { js.Syntax.code("window.__fontHaxe = {ok:false,error:String({0})}", error); });
    }
    static function check(value:Bool, message:String):Void { if (!value) throw new haxe.Exception(message); }
    static function snapshot(field:TextField, ?background:UInt = 0):BitmapData {
        var bitmap = new BitmapData(220, 60, true, background); bitmap.draw(field); return bitmap;
    }
    function run():Void {
        var api = HabboText.instance.api;
        var cases = 0;
        // Exercise the original stylesheet-to-label cache path used by window headers and tabs.
        var cssBytes = openfl.Assets.getBytes("skyhaxe/component/HabboWindowManagerCom/text_styles_css.bin");
        var parsed = com.sulake.core.window.utils.TextStyleManager.parseCSS(cssBytes.toString());
        com.sulake.core.window.utils.TextStyleManager.setStyles(parsed);
        var labelCases = 0;
        for (spec in [{name:"u_frame_title", text:"Navigator", bold:true, color:0xFFFFFF},
                      {name:"u_button_tab", text:"Public Rooms", bold:false, color:0x000000}]) {
            var label = com.sulake.core.window.utils.TextFieldCache.getTextFieldByStyleName(spec.name);
            check(label.antiAliasType == AntiAliasType.ADVANCED, 'Stylesheet lost advanced antialiasing: ${spec.name}');
            check(label.sharpness == 80 && label.thickness == -15, 'Stylesheet lost raster settings: ${spec.name}');
            label.textColor = spec.color; label.text = spec.text;
            var effective = HabboText.openFLStyle(label, label.defaultTextFormat);
            check(api.strategy(label.text, effective) == "native", 'UI label bypassed native renderer: ${spec.name}');
            var expectedLabel = new TextField();
            var expectedFormat = new TextFormat("Ubuntu", 12, spec.color, spec.bold);
            expectedFormat.kerning = true;
            expectedLabel.defaultTextFormat = expectedFormat;
            expectedLabel.antiAliasType = AntiAliasType.ADVANCED; expectedLabel.gridFitType = GridFitType.PIXEL;
            expectedLabel.sharpness = 80; expectedLabel.thickness = -15;
            expectedLabel.autoSize = openfl.text.TextFieldAutoSize.LEFT; expectedLabel.text = spec.text;
            var actualPixels = snapshot(label, 0xFF337F98), expectedPixels = snapshot(expectedLabel, 0xFF337F98);
            check(actualPixels.compare(expectedPixels) == 0, 'UI label raster differs from its intended style: ${spec.name}');
            actualPixels.dispose(); expectedPixels.dispose(); labelCases++;
        }
        for (face in ["Ubuntu", "Ubuntu condensed", "Volter", "Volter Bold", "Ubuntu Medium", "Ubuntu Bold Italic"])
            for (size in [10, 12, 18]) {
                var field = new TextField(); field.width = 220; field.height = 60;
                field.defaultTextFormat = new TextFormat(face, size, 0x336699);
                field.antiAliasType = AntiAliasType.ADVANCED; field.gridFitType = GridFitType.PIXEL;
                field.thickness = -15; field.sharpness = 80; field.text = "Habbo AV café";
                var expected:Float = api.width(field.text, HabboText.openFLStyle(field, field.defaultTextFormat));
                check(Math.abs(field.textWidth - expected) < 0.001, 'Width mismatch $face $size: ${field.textWidth} / $expected');
                var positions:Array<Float> = api.positions(field.text, HabboText.openFLStyle(field, field.defaultTextFormat));
                var bounds = field.getCharBoundaries(3);
                check(bounds != null && Math.abs(bounds.x - (positions[3] + 2)) < 0.001, 'Character bounds mismatch $face $size');
                var pixels = snapshot(field, 0xFFEEEEEE), ink = 0;
                for (y in 0...60) for (x in 0...220) if (pixels.getPixel(x, y) != 0xEEEEEE) ink++;
                check(ink > 0, 'No glyph pixels $face $size'); pixels.dispose(); cases++;
            }
        var field = new TextField(); field.width = 180; field.height = 55;
        field.defaultTextFormat = new TextFormat("Ubuntu", 18, 0x0000FF);
        field.antiAliasType = AntiAliasType.ADVANCED; field.gridFitType = GridFitType.PIXEL;
        field.text = "Habbo selection"; field.selectable = true; field.setSelection(0, 5);
        var hidden = snapshot(field, 0xFFFFFFFF); field.alwaysShowSelection = true;
        var selected = snapshot(field, 0xFFFFFFFF), gray = 0;
        for (y in 0...55) for (x in 0...180) if (selected.getPixel(x, y) == 0x808080) gray++;
        check(gray > 0, "Unfocused selection highlight disappeared"); field.alwaysShowSelection = false;
        var restored = snapshot(field, 0xFFFFFFFF);
        check(hidden.compare(restored) == 0, "Selection toggle changed ordinary text pixels");
        field.type = TextFieldType.INPUT; field.text = "";
        var m:Dynamic = api.metrics(HabboText.openFLStyle(field, field.defaultTextFormat));
        check(Math.abs(field.textHeight - Math.ceil(m.ascent + m.descent)) < 0.001, "Empty input metrics differ");
        field.type = TextFieldType.DYNAMIC; field.text = "Habbo";
        var clipped = new BitmapData(220, 60, true, 0xFF102030);
        clipped.draw(field, new Matrix(1, 0, 0, 1, -4, 3), new ColorTransform(0, 0, 0, 0.5, 255, 255, 255));
        check(clipped.getPixel(219, 59) == 0x102030, "Retained draw escaped field bounds");
        var font = new openfl.text.Font("Ubuntu");
        check(HabboText.fontHasGlyphs(font, "Habbo café") && !HabboText.fontHasGlyphs(font, "\u{10FFFF}"), "Font coverage differs");
        var wrap = new TextField(); wrap.defaultTextFormat = new TextFormat("Ubuntu", 12);
        wrap.width = 75; wrap.height = 100; wrap.wordWrap = true; wrap.multiline = true; wrap.text = "Habbo words wrap correctly";
        check(wrap.numLines > 1 && wrap.textWidth <= 75, "Wrapping ignored the new advances");
        hidden.dispose(); selected.dispose(); restored.dispose(); clipped.dispose();
        var sample = new TextField(); sample.defaultTextFormat = new TextFormat("Ubuntu", 18, 0xFFFFFF);
        sample.antiAliasType = AntiAliasType.ADVANCED; sample.gridFitType = GridFitType.PIXEL;
        sample.text = "Habbo HTML5 fonts: café AV"; sample.width = 400; sample.height = 70; addChild(sample);
        js.Syntax.code("window.__fontHaxe = {ok:true,cases:{0},labelCases:{1},stats:{2}}", cases, labelCases, api.stats());
    }
}
