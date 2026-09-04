import js.Browser;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class G1dWindowLayoutBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            var heading = new TextField();
            heading.defaultTextFormat = new TextFormat("_sans", 18, 0xE7EEF9, true);
            heading.text = "SkyHaxe · real 2016 XML layout canary";
            heading.width = 430;
            heading.height = 28;
            heading.x = 18;
            heading.y = 12;
            addChild(heading);

            var root = G1dWindowLayoutTest.main();
            root.x = 18;
            root.y = 18;
            addChild(root);
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-window-layout", "pass");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-window-layout-assertions",
                Std.string(G1dWindowLayoutTest.assertions)
            );
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-window-layout-fixture", "redeemItemCodeWidget");
            Browser.console.info('SKYHAXE_G1D_WINDOW_LAYOUT_PASS assertions=${G1dWindowLayoutTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-window-layout", "fail");
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-window-layout-error", Std.string(error));
            Browser.console.error("SKYHAXE_G1D_WINDOW_LAYOUT_FAIL", error);
            throw error;
        }
    }
}
