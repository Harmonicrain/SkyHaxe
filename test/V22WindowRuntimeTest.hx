import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.utils.TextStyleManager;
import com.sulake.core.window.text.TruffleText;
import com.sulake.habbo.room.RoomEngineContext;
import com.sulake.habbo.window.HabboWindowManagerComponent;
import com.sulake.habbo.localization.HabboLocalizationManager;
import com.sulake.habbo.localization._enum.HabboLocalizationFlags;
import com.sulake.iid.IIDHabboLocalizationManager;
import openfl.Assets;
import com.sulake.core.window.IWindow;
import com.sulake.core.window.IWindowContainer;
import com.sulake.core.window._enum.WindowState;
import com.sulake.core.window.events.WindowMouseEvent;
import openfl.events.MouseEvent;

/** Real manager/lifecycle/skins canary, not an infostand or Flash pixel-parity claim. */
@:access(com.sulake.habbo.window.HabboWindowManagerComponent)
@:access(com.sulake.core.window.motion.Motions)
class V22WindowRuntimeTest extends openfl.display.Sprite {
    var manager:HabboWindowManagerComponent;
    var context:RoomEngineContext;
    function mouse(type:String, x:Float, y:Float, held:Bool=false):Void {
        stage.dispatchEvent(new MouseEvent(type, true, false, x, y, null, false, false, false, held));
        manager.update(16);
    }
    function renderedHash():String {
        var pixels = new openfl.display.BitmapData(350, 230, true, 0);
        pixels.draw(this);
        var hash = haxe.crypto.Sha256.make(pixels.getPixels(pixels.rect)).toHex();
        pixels.dispose();
        return hash;
    }
    public function new() {
        super();
        js.Browser.window.addEventListener("error", function(event:Dynamic) { fail(event.message); });
        stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
        stage.align = openfl.display.StageAlign.TOP_LEFT;
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = function() { throw new Error('Browser font fallback in generated window runtime'); }");
        TruffleText.load("/public/assets/truffle", ["u_regular", "u_bold", "u_small", "u_frame_title"],
            function() { try { initialize(); } catch (error:Dynamic) { fail(error); } }, fail);
    }
    function fail(error:Dynamic):Void {
        var details = error != null && Reflect.field(error, "stack") != null ? Reflect.field(error, "stack") : Std.string(error);
        js.Browser.document.body.insertBefore(js.Browser.document.createTextNode("FAIL " + details), js.Browser.document.body.firstChild);
        js.Browser.console.error(error);
    }
    function initialize():Void {
        var timer = com.sulake.core.window.motion.Motions._Str_5307;
        if (timer != com.sulake.core.window.motion.Motions._Str_5307 || Math.abs(timer.delay - 1000 / stage.frameRate) > 0.001)
            throw "Original motion timer lost singleton/stage-rate behavior";
        var records:Dynamic = haxe.Json.parse(Assets.getText("window-service/assets.json"));
        var library = new AssetLibrary("original-window-service");
        library.loadFromManifest(new XML(Assets.getText("window-service/manifest.bin")), function(name) {
            var record:Dynamic = Reflect.field(records, name);
            if (record == null) return null;
            return record.image ? cast Assets.getBitmapData(record.id) : cast Assets.getText(record.id);
        });
        TextStyleManager.setStyles(TextStyleManager.parseCSS(cast library.getAssetByName("text_styles_css").content));
        context = new RoomEngineContext(this);
        var localization = new HabboLocalizationManager(context, HabboLocalizationFlags._Str_16746);
        localization.updateLocalization("fixture.title", "Generated window manager");
        context.provide(new IIDHabboLocalizationManager(), localization);
        manager = new HabboWindowManagerComponent(context, 0, library);
        if (!manager._isInitialized) throw "Original window manager did not initialize";
        var window = manager.buildFromXML(new XML('<layout><window><frame name="canary" x="20" y="20" width="300" height="180" style="0" caption="%24%7Bfixture.title%7D"><children><button name="test_button" x="30" y="65" width="180" height="28" style="0" caption="Generated button"/><text name="test_text" x="30" y="30" width="200" height="20" caption="Truffle text"/></children></frame></window></layout>'));
        if (window == null || cast(window, com.sulake.core.window.IWindowContainer).findChildByName("test_button") == null) throw "Generated XML window construction failed";
        manager.update(16);
        haxe.Timer.delay(function() {
            try {
                manager.update(16);
                var pixels = new openfl.display.BitmapData(350, 230, true, 0);
                pixels.draw(this);
                var visible = 0;
                for (y in 0...230) for (x in 0...350) if ((pixels.getPixel32(x, y) >>> 24) > 0) visible++;
                if (visible < 1000) throw "Generated skin canvas is empty";
                pixels.dispose();
                var button:IWindow = cast(window, IWindowContainer).findChildByName("test_button");
                var rect = new openfl.geom.Rectangle();
                button.getGlobalRectangle(rect);
                var clicks = 0;
                button.addEventListener(WindowMouseEvent.CLICK, function(_) { clicks++; });
                var idle = renderedHash();
                mouse(MouseEvent.MOUSE_MOVE, rect.x + rect.width / 2, rect.y + rect.height / 2);
                if (!button.testStateFlag(WindowState.HOVERING)) throw "Generated button did not hover: " + button.state;
                var hover = renderedHash();
                if (hover == idle) throw "Hover state did not alter skin pixels";
                mouse(MouseEvent.MOUSE_DOWN, rect.x + rect.width / 2, rect.y + rect.height / 2, true);
                if (!button.testStateFlag(WindowState.PRESSED)) throw "Generated button did not press";
                mouse(MouseEvent.MOUSE_UP, rect.x + rect.width / 2, rect.y + rect.height / 2);
                mouse(MouseEvent.CLICK, rect.x + rect.width / 2, rect.y + rect.height / 2);
                if (clicks != 1 || button.testStateFlag(WindowState.PRESSED)) throw "Generated click/release lifecycle failed: " + clicks;
                mouse(MouseEvent.MOUSE_MOVE, 390, 240);
                if (button.testStateFlag(WindowState.HOVERING)) throw "Hover state survived pointer exit";
                window.dispose();
                manager.update(16);
                if (!window.disposed || !button.disposed) throw "Window disposal retained children";
                var description:XML = cast library.getAssetByName("habbo_element_description_xml").content;
                var styles = [];
                var hashes = new Map<String, Bool>();
                for (entry in description.child("window")) {
                    var kind = entry.attribute("type").toString();
                    if (kind != "frame" && kind != "button") continue;
                    var style = Std.parseInt(entry.attribute("style").toString());
                    var sample = manager.buildFromXML(new XML('<layout><window><' + kind + ' name="style_sample" x="20" y="20" width="300" height="180" style="' + style + '" caption="Authored style ' + style + '"/></window></layout>'));
                    if (sample == null || sample.style != style) throw "Authored style not selected: " + kind + ":" + style;
                    manager.update(16);
                    hashes.set(renderedHash(), true);
                    styles.push(kind + ":" + style);
                    sample.dispose();
                    manager.update(16);
                }
                if (styles.length < 10 || [for (hash in hashes.keys()) hash].length < 5) throw "Authored style variants collapsed";
                var list:com.sulake.core.window.components.IItemListWindow = cast manager.buildFromXML(new XML('<layout><window><itemlist_vertical name="list_canary" x="20" y="20" width="200" height="80"><children><button name="first" width="180" height="24" caption="First"/><button name="second" width="180" height="24" caption="Second"/></children></itemlist_vertical></window></layout>'));
                manager.update(16);
                if (list.numListItems != 2 || list.getListItemByName("second") == null) throw "Generated list failed to attach authored items";
                var removed = list.removeListItemAt(0);
                if (removed.name != "first" || list.numListItems != 1 || removed.disposed) throw "List removal changed ownership/disposal";
                list.addListItem(removed);
                if (list.getListItemAt(1) != removed) throw "List reattachment changed ordering";
                list.dispose();
                if (!removed.disposed) throw "List disposal retained its child";
                var furni:com.sulake.core.window.components.IItemListWindow = cast manager.buildFromXML(new XML(Assets.getText("window-service/infostand-furni.xml")));
                manager.update(16);
                if (furni == null || furni.getListItemByName("info_border") == null || furni.getListItemByName("button_list") == null)
                    throw "Original Infostand furniture layout did not construct";
                furni.dispose();
                manager.dispose();
                if (!manager.disposed || numChildren != 0) throw "Manager disposal retained its desktop";
                js.Browser.document.body.insertBefore(js.Browser.document.createTextNode("V22_WINDOW_RUNTIME_PASS visible=" + visible + " hover click list infostand-layout dispose styles=" + styles.join(",")), js.Browser.document.body.firstChild);
            } catch (error:Dynamic) { fail(error); }
        }, 100);
    }
}
