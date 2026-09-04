import js.Browser;
import openfl.display.Sprite;

class G1dBitmapDataAssetBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            G1dBitmapDataAssetTest.main();
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-bitmap-asset", "pass");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-bitmap-asset-assertions",
                Std.string(G1dBitmapDataAssetTest.assertions)
            );
            Browser.console.info('SKYHAXE_G1D_BITMAP_ASSET_PASS assertions=${G1dBitmapDataAssetTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-bitmap-asset", "fail");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-bitmap-asset-error",
                Std.string(Reflect.field(error, "message"))
            );
            Browser.console.error("SKYHAXE_G1D_BITMAP_ASSET_FAIL", error);
            throw error;
        }
    }
}
