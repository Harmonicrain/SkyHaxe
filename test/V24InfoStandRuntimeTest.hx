import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.text.HabboText;
import com.sulake.core.window.utils.TextStyleManager;
import com.sulake.habbo.room.RoomEngineContext;
import com.sulake.habbo.localization.HabboLocalizationManager;
import com.sulake.habbo.localization._enum.HabboLocalizationFlags;
import com.sulake.habbo.window.HabboWindowManagerComponent;
import com.sulake.habbo.ui.RoomUI;
import com.sulake.habbo.ui.RoomDesktop;
import com.sulake.habbo.ui.widget.RoomWidgetFactory;
import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniActionMessage;
import com.sulake.habbo.ui.widget.events.RoomWidgetFurniInfostandUpdateEvent;
import com.sulake.habbo.room.object.RoomObjectOperationEnum;
import com.sulake.habbo.room.object.data.LegacyStuffData;
import openfl.Assets;
import openfl.display.Sprite;
import com.sulake.core.window.IWindowContainer;
import com.sulake.core.window.components.IDisplayObjectWrapper;

/** Test-only service fixtures; never included by the production bootstrap. */
@:access(com.sulake.habbo.ui.RoomUI)
@:access(com.sulake.habbo.ui.RoomDesktop)
class V24InfoStandRuntimeTest extends openfl.display.Sprite {
    public function new() {
        super();
        stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
        stage.align = openfl.display.StageAlign.TOP_LEFT;
        js.Syntax.code("CanvasRenderingContext2D.prototype.fillText = function() { throw new Error('Browser font fallback in Infostand'); }");
        HabboText.load("/assets/habbo-text", ["u_regular", "u_bold", "u_small", "u_frame_title"],
            function() { try { run(); } catch (error:Dynamic) { fail(error); } }, fail);
    }
    function fail(error:Dynamic):Void {
        js.Browser.document.body.insertBefore(js.Browser.document.createTextNode("FAIL " + (Reflect.field(error, "stack") ?? Std.string(error))), js.Browser.document.body.firstChild);
    }
    function library(prefix:String):AssetLibrary {
        var records:Dynamic = haxe.Json.parse(Assets.getText(prefix + "/assets.json"));
        var assets = new AssetLibrary(prefix);
        assets.loadFromManifest(new XML(Assets.getText(prefix + "/manifest.bin")), function(name) {
            var record:Dynamic = Reflect.field(records, name);
            return record == null ? null : (record.image ? cast Assets.getBitmapData(record.id) : cast Assets.getText(record.id));
        });
        return assets;
    }
    function run():Void {
        var skins = library("window-service");
        var assets = library("room-ui");
        TextStyleManager.setStyles(TextStyleManager.parseCSS(cast skins.getAssetByName("text_styles_css").content));
        var context = new RoomEngineContext(this);
        var localization = new HabboLocalizationManager(context, HabboLocalizationFlags._Str_16746);
        context.provide(new com.sulake.iid.IIDHabboLocalizationManager(), localization);
        var manager = new HabboWindowManagerComponent(context, 0, skins);
        var ui = new RoomUI(context, 0, assets);
        ui._windowManager = manager;
        ui._localization = localization;
        var connection = new InfoStandConnectionFixture();
        var desktop = new RoomDesktop(cast new InfoStandSessionFixture(), assets, cast connection);
        desktop.windowManager = manager;
        desktop.localization = localization;
        desktop.config = context;
        desktop.layout = cast assets.getAssetByName("room_desktop_layout_xml").content;
        var engine = new InfoStandEngineFixture();
        desktop.roomEngine = cast engine;
        desktop.soundManager = cast new InfoStandSoundFixture();
        desktop.sessionDataManager = cast new InfoStandDataFixture();
        desktop.roomWidgetFactory = new RoomWidgetFactory(ui);
        var roomView:IWindowContainer = cast manager.buildFromXML(cast assets.getAssetByName("room_view_container_xml").content);
        roomView.width = 650;
        roomView.height = 500;
        var roomWrapper:IDisplayObjectWrapper = cast roomView.findChildByName("room_canvas_wrapper");
        var fakeRoom = new Sprite();
        fakeRoom.graphics.beginFill(0x27465B);
        fakeRoom.graphics.drawRect(0, 0, 650, 500);
        fakeRoom.graphics.endFill();
        roomWrapper.setDisplayObject(fakeRoom);
        desktop._layoutManager.addRoomView(roomView);
        desktop.createWidget(RoomWidgetEnum.INFOSTAND);
        var widget:com.sulake.habbo.ui.widget.infostand.InfoStandWidget = cast desktop._widgets.getValue(RoomWidgetEnum.INFOSTAND);
        if (widget == null || widget.mainWindow == null) throw "Original factory did not create Infostand";
        if (widget.handler.container != desktop) throw "Original desktop not installed as handler container";
        widget.registerUpdateEvents(ui.events);
        var furni = new RoomWidgetFurniInfostandUpdateEvent(RoomWidgetFurniInfostandUpdateEvent.FURNI);
        furni.id = 42;
        furni.category = 10;
        furni.name = "Visual Infostand Canary";
        furni.description = "Generated widget and generated window runtime";
        furni.ownerId = 1;
        furni.ownerName = "SkyHaxe";
        furni.stuffData = new LegacyStuffData();
        ui.events.dispatchEvent(furni);
        for (action in [RoomWidgetFurniActionMessage.RWFAM_MOVE, RoomWidgetFurniActionMessage.RWFUAM_ROTATE, RoomWidgetFurniActionMessage.RWFAM_PICKUP])
            desktop.processWidgetMessage(new RoomWidgetFurniActionMessage(action, 42, 10));
        var expected = [RoomObjectOperationEnum.OBJECT_MOVE, RoomObjectOperationEnum.OBJECT_ROTATE_POSITIVE, RoomObjectOperationEnum.OBJECT_PICKUP];
        if (engine.operations.join("|") != expected.map(value -> "42:10:" + value).join("|"))
            throw "Original desktop/handler action routing changed: " + engine.operations;
        for (_ in 0...4) manager.update(16);
        if (!widget.mainWindow.visible) throw "Original Infostand did not become visible";
        js.Browser.document.body.insertBefore(js.Browser.document.createTextNode("V24_INFOSTAND_RUNTIME_PASS original-factory desktop-routing move rotate pickup widget-construction disposal Habbo HTML5"), js.Browser.document.body.firstChild);
    }
}

private class InfoStandConnectionFixture {
    public var messages:Array<Dynamic> = [];
    public function new() {}
    public function addMessageEvent(event:Dynamic):Dynamic { messages.push(event); return event; }
    public function removeMessageEvent(event:Dynamic):Void { messages.remove(event); }
}
private class InfoStandSessionFixture {
    public function new() {}
    public function get_isGameSession():Bool return false;
    public function get_playTestMode():Bool return false;
}
private class InfoStandSoundFixture {
    public function new() {}
    public function get_musicController():Dynamic return null;
}
private class InfoStandDataFixture {
    final events = new openfl.events.EventDispatcher();
    public function new() {}
    public function get_events():openfl.events.EventDispatcher return events;
    public function hasSecurity(level:Int):Bool return false;
}
private class InfoStandEngineFixture {
    final events = new openfl.events.EventDispatcher();
    public final operations:Array<String> = [];
    public function new() {}
    public function get_events():openfl.events.EventDispatcher return events;
    public function get_activeRoomHasFreeFurniMovementsMode():Bool return false;
    public function modifyRoomObject(id:Int, category:Int, operation:String):Bool {
        operations.push(id + ":" + category + ":" + operation);
        return true;
    }
}
