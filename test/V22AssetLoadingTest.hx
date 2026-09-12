import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.loaders.AssetLoaderEvent;
import openfl.net.URLRequest;

class V22AssetLoadingTest {
    static var checks = 0;
    static function complete():Void {
        checks++;
        if (checks == 4) js.Browser.document.body.textContent = "V22_ASSET_LOADING_PASS";
    }
    static function main() {
        var library = new AssetLibrary("file-test");
        var textURL = "/test/window-host.html";
        var text = library.loadAssetFromFile("text", new URLRequest(textURL), "text/plain");
        if (library.loadAssetFromFile("text", new URLRequest(textURL), "text/plain") != text)
            throw "Pending same-name URL did not share its ticket";
        text.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, function(event) {
            if (event.target != text || library.getAssetByName("text") == null
                    || Std.string(library.getAssetByName("text").content).indexOf("host-test.js") < 0)
                throw "Completion preceded content registration or lost event target";
            var rejected = false;
            try { library.loadAssetFromFile("text", new URLRequest(textURL), "text/plain"); }
            catch (_:Dynamic) { rejected = true; }
            if (!rejected) throw "Existing asset was silently overwritten";
            haxe.Timer.delay(function() {
                if (!text.disposed) throw "Completed text ticket not automatically disposed";
                complete();
            }, 0);
        });
        var image = library.loadAssetFromFile("image", new URLRequest("/build/tests/v22-embedded/html5/bin/skyhaxe/embed/com/sulake/habbo/window/utils/floorplaneditor/images/FloorEditorTileBase.png"));
        image.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, function(event) {
            var bitmap:openfl.display.BitmapData = library.getAssetByName("image").content;
            if (bitmap == null || bitmap.width < 1 || bitmap.height < 1) throw "Image was published before decode";
            haxe.Timer.delay(function() {
                if (!image.disposed || bitmap.width < 1) throw "Ticket/pixel ownership changed after completion";
                complete();
            }, 0);
        });
        image.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, function(_) { throw "Image fixture failed"; });
        var missing = library.loadAssetFromFile("missing", new URLRequest("/test/missing-window-fixture.txt"), "text/plain");
        missing.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, function(event) {
            if (event.target != missing || library.hasAsset("missing")) throw "Failed request was registered";
            haxe.Timer.delay(function() {
                if (!missing.disposed) throw "Failed ticket not automatically disposed";
                complete();
            }, 0);
        });
        var cancelledLibrary = new AssetLibrary("cancel-test");
        var cancelled = cancelledLibrary.loadAssetFromFile("cancel", new URLRequest(textURL), "text/plain");
        var cancelledLoader = cancelled.assetLoader;
        cancelled.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, function(_) { throw "Disposed library published a late completion"; });
        cancelledLibrary.dispose();
        haxe.Timer.delay(function() {
            if (!cancelled.disposed || !cancelledLoader.disposed) throw "Pending loader not disposed with library";
            complete();
        }, 100);
    }
}
