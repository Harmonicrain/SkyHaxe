import js.Browser;
import openfl.display.Sprite;

class G1dAssetsBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            G1dAssetsTest.main();
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-assets", "pass");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-assets-assertions",
                Std.string(G1dAssetsTest.assertions)
            );
            Browser.console.info('SKYHAXE_G1D_ASSETS_PASS assertions=${G1dAssetsTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-assets", "fail");
            Browser.console.error("SKYHAXE_G1D_ASSETS_FAIL", error);
            throw error;
        }
    }
}
