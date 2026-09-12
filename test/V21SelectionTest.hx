import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.BitmapData;

@:access(openfl.text.TextField)
@:access(com.sulake.core.window.text.TruffleText)
class V21SelectionTest {
    static function draw(field:TextField):BitmapData {
        var pixels = new BitmapData(160, 40, true, 0xFFFFFFFF);
        pixels.draw(field);
        return pixels;
    }
    static function main() {
        com.sulake.core.window.text.TruffleText.instance = new com.sulake.core.window.text.TruffleText(js.Syntax.code("window.__truffleAPI"));
        var field = new TextField();
        field.width = 160;
        field.height = 40;
        field.defaultTextFormat = new TextFormat("Ubuntu", 18, 0x0000FF);
        field.text = "Habbo selection";
        field.selectable = true;
        field.setSelection(0, 5);
        var hidden = draw(field);
        field.alwaysShowSelection = true;
        var visible = draw(field);
        var changed = 0;
        var gray = 0;
        for (y in 0...40) for (x in 0...160) {
            if (hidden.getPixel32(x, y) != visible.getPixel32(x, y)) changed++;
            if (visible.getPixel(x, y) == 0x808080) gray++;
        }
        if (changed == 0 || gray == 0) throw "Unfocused selection was not rendered gray";
        field.this_onFocusOut(null);
        if (field.selectionBeginIndex != 0 || field.selectionEndIndex != 5)
            throw "Focus loss destroyed selection range";
        field.alwaysShowSelection = false;
        var hiddenAgain = draw(field);
        for (y in 0...40) for (x in 0...160)
            if (hidden.getPixel32(x, y) != hiddenAgain.getPixel32(x, y))
                throw "Disabling persistent selection did not restore ordinary rendering";
        hidden.dispose(); visible.dispose(); hiddenAgain.dispose();
        trace("V21_SELECTION_PASS real-canvas gray-highlight blur-retains-range toggle-restores-pixels");
    }
}
