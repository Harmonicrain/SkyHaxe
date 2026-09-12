import com.sulake.habbo.utils.HabboWebTools;
class V22HostBridgeTest {
    static function main() {
        var context = new com.sulake.habbo.room.RoomEngineContext();
        var component = new com.sulake.core.runtime.Component(context);
        var identifier = new com.sulake.iid.IIDHabboLocalizationManager();
        context.provide(identifier, component);
        var reserved = context.queueInterface(identifier);
        if (reserved != component || com.sulake.core.runtime.Component.requiredDependencyIids(component).getStructByInterface(identifier).references != 1)
            throw "Component interface was not registered/reserved";
        if (reserved.release(identifier) != 0) throw "Component interface reference was not released";
        context.detachComponent(component);
        if (context.queueInterface(identifier) != null) throw "Detached component remained available";
        component.dispose();
        var all = new HostLinkTracker("");
        var profile = new HostLinkTracker("profile/");
        context.addLinkEventTracker(all);
        context.addLinkEventTracker(profile);
        context.addLinkEventTracker(profile);
        context.createLinkEvent("profile/7");
        context.createLinkEvent("room/9");
        if (all.links.length != 2 || profile.links.join("") != "profile/7" || context.linkEventTrackers.length != 2)
            throw "Link prefix routing or duplicate handling changed";
        context.removeLinkEventTracker(profile);
        context.createLinkEvent("profile/8");
        if (profile.links.length != 1) throw "Removed tracker still received a link";
        context.dispose();
        if (context.linkEventTrackers.length != 0) throw "Disposed context retained trackers";
        if (HabboWebTools.isAirApplication || HabboWebTools.OPENLINK != "openlink") throw "Wrong browser platform identity";
        var bitmap = new openfl.display.BitmapData(1, 1, true, 0);
        if (HabboWebTools.renderAirLoginBackground(bitmap)) throw "Missing renderer must report false";
        HabboWebTools.renderAirLoginBackgroundCallback = function(target) { target.setPixel32(0, 0, 0xFFFFFFFF); return true; };
        if (!HabboWebTools.renderAirLoginBackground(bitmap) || bitmap.getPixel32(0, 0) != 0xFFFFFFFF) throw "Background renderer not delegated";
        HabboWebTools.renderAirLoginBackgroundCallback = null;
        var calls:Array<String> = [];
        var host:Dynamic = {};
        host.openHabblet = function(name:String, value:String) { calls.push(name + ":" + value); };
        host.openWebPageAndMinimizeClient = function(url:String) { calls.push(url); };
        Reflect.setField(js.Browser.window, "FlashExternalInterface", host);
        HabboWebTools.openHabblet("fixture", "value");
        HabboWebTools.openWebPageAndMinimizeClient("https://example.invalid/");
        Reflect.deleteField(js.Browser.window, "FlashExternalInterface");
        HabboWebTools.openHabblet("missing-host");
        if (calls.join("|") != "fixture:value|https://example.invalid/") throw "Host method arguments changed";
        bitmap.dispose();
        js.Browser.document.body.textContent = "V22_HOST_PASS";
    }
}

private class HostLinkTracker implements com.sulake.core.runtime.events.ILinkEventTracker {
    public var linkPattern(get, never):String;
    public final links:Array<String> = [];
    final prefix:String;
    public function new(prefix:String) { this.prefix = prefix; }
    public function get_linkPattern():String return prefix;
    public function linkReceived(link:String):Void { links.push(link); }
}
