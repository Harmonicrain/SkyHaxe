import js.Browser;
import openfl.display.Sprite;

class G1dComponentShellBrowserMain extends Sprite {
    public function new() {
        super();
        try {
            G1dComponentShellTest.main();
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-component-shell", "pass");
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-component-shell-assertions", Std.string(G1dComponentShellTest.assertions));
            Browser.console.info('SKYHAXE_G1D_COMPONENT_SHELL_PASS assertions=${G1dComponentShellTest.assertions}');
        } catch (error:Dynamic) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-component-shell", "fail");
            Browser.document.documentElement.setAttribute("data-skyhaxe-g1d-component-shell-error", Std.string(Reflect.field(error, "message")));
            Browser.console.error("SKYHAXE_G1D_COMPONENT_SHELL_FAIL", error);
            throw error;
        }
    }
}
