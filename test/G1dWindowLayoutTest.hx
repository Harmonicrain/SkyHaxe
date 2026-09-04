import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.WindowController;
import com.sulake.core.window.utils.WindowParser;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.utils.Assets;

class G1dWindowLayoutTest {
    public static var assertions(default, null):Int = 0;

    public static function main():WindowController {
        assertions = 0;
        var root = testRealLayout();
        trace('G1D_WINDOW_LAYOUT_PASS assertions=$assertions');
        return root;
    }

    private static function testRealLayout():WindowController {
        var source = Assets.getText("fixtures/HabboCatalogCom_redeemItemCodeWidget.bin");
        truth(source != null && source.length == 1121, "exact real layout fixture packaged read-only");
        var root = new WindowParser().parseLayout(new XML(source));
        equal("layout", root.typeName, "layout root type");
        equal("redeemItemCodeWidget", root.name, "layout name");
        equal(282.0, root.layoutWidth, "layout width");
        equal(50.0, root.layoutHeight, "layout height");
        equal(1, root.numChildren, "single top-level window entity");

        var container = require(root.findChildByName("redeemItemCodeWidget"), "named container");
        equal("container", container.typeName, "container type");
        equal(38.0, container.x, "container x preserved");
        equal(350.0, container.y, "container y preserved");
        equal(282.0, container.layoutWidth, "container width preserved");
        equal(50.0, container.layoutHeight, "container height preserved");
        equal(3, countWindowChildren(container), "children hierarchy preserved");

        var redeem = require(root.findChildByName("redeem"), "redeem button");
        equal("button", redeem.typeName, "button type");
        equal(393361, redeem.param, "button params");
        equal(3, redeem.style, "button style");
        equal("$" + "{redeem}", redeem.caption, "URL-decoded localization caption");
        equal(100.0, redeem.maxWidth, "button maximum width");
        truth(Std.isOfType(redeem.getChildByName("__caption"), TextField), "button uses real OpenFL TextField");

        var text = require(root.findChildByName("voucher_code"), "voucher text");
        equal("text", text.typeName, "text type");
        equal("lorem ipsum", text.caption, "plain caption URL decoding");
        equal(true, text.properties.get("always_show_selection"), "Boolean variable typed");
        equal("left", text.properties.get("auto_size"), "String variable typed");
        equal(16, text.properties.get("max_chars"), "int variable typed");
        equal(0.0, text.properties.get("spacing"), "Number variable typed");
        truth(Std.isOfType(text.getChildByName("__caption"), TextField), "text uses real OpenFL TextField");

        var pixels = new BitmapData(360, 430, true, 0x00000000);
        pixels.draw(root);
        truth((pixels.getPixel32(255, 378) >>> 24) > 0, "button produces real OpenFL pixels");
        truth((pixels.getPixel32(40, 352) >>> 24) > 0, "container produces real OpenFL pixels");
        pixels.dispose();
        return root;
    }

    private static function countWindowChildren(window:WindowController):Int {
        var result = 0;
        for (index in 0...window.numChildren) if (Std.isOfType(window.getChildAt(index), WindowController)) result++;
        return result;
    }

    private static function require(value:Null<WindowController>, message:String):WindowController {
        assertions++;
        if (value == null) throw new haxe.Exception('$message: missing');
        return value;
    }

    private static function truth(value:Bool, message:String):Void equal(true, value, message);

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!js.Syntax.strictEq(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }
}
