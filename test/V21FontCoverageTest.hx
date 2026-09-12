import com.sulake.core.window.text.TruffleText;
import openfl.text.Font;
import openfl.text.FontStyle;

@:access(com.sulake.core.window.text.TruffleText)
class V21FontCoverageTest {
    static function main() {
        // The HTML fixture loads real TTF files through Truffle's real registry/parser.
        TruffleText.instance = new TruffleText({registry: js.Syntax.code("window.__glyphRegistry")});
        var font = new Font("ubuntu");
        font.fontStyle = FontStyle.REGULAR;
        if (!window_conversion.Probe.glyphs(font, "Habbo 123") || !window_conversion.Probe.glyphs(font, ""))
            throw "Present glyphs were rejected";
        if (window_conversion.Probe.glyphs(font, "\u{10FFFF}")) throw "Absent Unicode glyph was accepted";
        font.fontStyle = FontStyle.BOLD;
        if (!TruffleText.fontHasGlyphs(font, "Habbo")) throw "Bold face coverage failed";
        font.fontName = "not a registered font";
        var rejected = false;
        try { TruffleText.fontHasGlyphs(font, "a"); } catch (e:Dynamic) { rejected = true; }
        if (!rejected) throw "Unknown font silently fell back";
        trace("V21_FONT_COVERAGE_PASS actual-ttf present absent-unicode bold unknown-face");
    }
}
