import js.Browser;
import openfl.display.Sprite;

class G1dByteArrayBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            G1dByteArrayTest.main();
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-bytearray", "pass");
            Browser.document.documentElement.setAttribute(
                "data-skyhaxe-g1d-bytearray-assertions",
                Std.string(G1dByteArrayTest.assertions)
            );
            Browser.console.info('SKYHAXE_G1D_BYTEARRAY_PASS assertions=${G1dByteArrayTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-bytearray", "fail");
            Browser.console.error("SKYHAXE_G1D_BYTEARRAY_FAIL", error);
            throw error;
        }
    }
}
