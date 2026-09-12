import js.Browser;
import openfl.display.Sprite;

class G1dAssetLibraryBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            G1dAssetLibraryTest.main();
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-asset-library", "pass");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-asset-library-assertions",
                Std.string(G1dAssetLibraryTest.assertions)
            );
            Browser.console.info('SKYHAXE_G1D_ASSET_LIBRARY_PASS assertions=${G1dAssetLibraryTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-asset-library-error", Std.string(error));
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-asset-library", "fail");
            Browser.console.error("SKYHAXE_G1D_ASSET_LIBRARY_FAIL", error);
            throw error;
        }
    }
}
