import com.sulake.core.window.text.HabboText;
import openfl.text.Font;
import openfl.text.FontStyle;

@:access(com.sulake.core.window.text.HabboText)
class V21FontCoverageTest {
    static function main() {
        HabboText.load("/assets/habbo-text", [], run, function(e) { throw e; });
    }
    static function run() {
        var font = new Font("ubuntu");
        font.fontStyle = FontStyle.REGULAR;
        if (!HabboText.fontHasGlyphs(font, "Habbo 123") || !HabboText.fontHasGlyphs(font, ""))
            throw "Present glyphs were rejected";
        if (HabboText.fontHasGlyphs(font, "\u{10FFFF}")) throw "Absent Unicode glyph was accepted";
        font.fontStyle = FontStyle.BOLD;
        if (!HabboText.fontHasGlyphs(font, "Habbo")) throw "Bold face coverage failed";
        font.fontName = "Ubuntu Bold Italic";
        if (!HabboText.fontHasGlyphs(font, "Habbo café")) throw "Embedded alias coverage failed";
        trace("V21_FONT_COVERAGE_PASS actual-ttf present absent-unicode bold aliases");
    }
}
