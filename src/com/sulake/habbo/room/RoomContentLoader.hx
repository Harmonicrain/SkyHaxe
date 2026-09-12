package com.sulake.habbo.room;

#if html5
import com.sulake.core.assets.IAssetLibrary;
import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
import com.sulake.room.IRoomManager;
import com.sulake.room.object.IRoomObjectVisualizationFactory;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import js.Browser;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

/**
 * HTML5 host facade for the converted RoomEngine.
 *
 * The AS3 class combines content lookup with Flash's LibraryLoader/FZip downloader.  The latter is
 * not portable and is already replaced by SkyRoomContentLoader + SwfFile; this class preserves the
 * API RoomEngine calls while delegating the actual SWF work to that proven loader.
 */
class RoomContentLoader extends SkyRoomContentLoader {
    public static inline var RCL_LOADER_READY = "RCL_LOADER_READY";

    public var visualizationFactory:Null<IRoomObjectVisualizationFactory>;
    public var roomManager:Null<IRoomManager>;
    public var sessionDataManager:Dynamic;
    public var iconAssets:Null<IAssetLibrary>;
    public var iconListener:Dynamic;

    static var configuredFurniBase = "";
    static var configuredContentBase = "";
    static var configuredFurnidataUrl = "";

    final aliases = new StringMap<String>();
    final activeTypes = new IntMap<String>();
    final activeTypeIds = new StringMap<Int>();
    final activeColours = new IntMap<Int>();
    final wallTypes = new IntMap<String>();
    final wallColours = new IntMap<Int>();

    public static function configure(furniBase:String, contentBase:String,
            furnidataUrl:String = ""):Void {
        configuredFurniBase = furniBase == null ? "" : furniBase;
        configuredContentBase = contentBase == null ? "" : contentBase;
        configuredFurnidataUrl = furnidataUrl == null ? "" : furnidataUrl;
    }

    public function new(loaderUrl:String = "") {
        super();
        furniBase = configuredFurniBase;
        contentBase = configuredContentBase;
    }

    public function initialize(dispatcher:IEventDispatcher, configuration:Dynamic):Void {
        // Match the AS3 lifecycle: RoomEngine installs its ready listener immediately after this
        // call, so readiness must be reported on a later turn rather than synchronously.
        if (configuredFurnidataUrl == "") {
            haxe.Timer.delay(function() dispatcher.dispatchEvent(new Event(RCL_LOADER_READY)), 0);
            return;
        }
        var url = com.sulake.habbo.room.object.visualization.room.publicroom
            .PublicRoomVisualizationLoader.assetUrl(configuredFurnidataUrl);
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.text();
        }).then(function(text) {
            skyhaxe.BootMetrics.mark("room-furnidata-downloaded");
            readFurnidata(new com.sulake.core.utils.xml.XML(text));
            skyhaxe.BootMetrics.mark("room-furnidata-parsed");
            dispatcher.dispatchEvent(new Event(RCL_LOADER_READY));
            return null;
        }).catchError(function(error) {
            Browser.console.error("SKYHAXE_ROOM_ENGINE_FURNIDATA_FAILED " + Std.string(error));
        });
    }

    function readFurnidata(document:com.sulake.core.utils.xml.XML):Void {
        for (section in ["roomitemtypes", "wallitemtypes"])
            for (node in document.child(section))
                for (entry in node.child("furnitype")) {
                    var id = Std.parseInt(xmlAttr(entry, "id"));
                    var declared = xmlAttr(entry, "classname");
                    if (id == null || declared == "") continue;
                    var className = declared;
                    var colour = 0;
                    var star = className.indexOf("*");
                    if (star >= 0) {
                        var parsed = Std.parseInt(className.substr(star + 1));
                        if (parsed != null) colour = parsed;
                        className = className.substr(0, star);
                    }
                    if (section == "wallitemtypes") {
                        wallTypes.set(id, className);
                        wallColours.set(id, colour);
                        setPlaceHolderType(className, SkyRoomContentLoader.WALL_PLACE_HOLDER);
                    } else {
                        activeTypes.set(id, className);
                        activeTypeIds.set(declared, id);
                        activeColours.set(id, colour);
                        setPlaceHolderType(className, SkyRoomContentLoader.PLACE_HOLDER);
                    }
                }
        Browser.console.info('SKYHAXE_ROOM_ENGINE_FURNIDATA floor=${countInt(activeTypes)} '
            + 'wall=${countInt(wallTypes)}');
    }

    static function countInt<T>(map:IntMap<T>):Int {
        var count = 0;
        for (_ in map) count++;
        return count;
    }

    static function xmlAttr(node:com.sulake.core.utils.xml.XML, name:String):String {
        var value = node.attribute(name);
        return value == null ? "" : value.toString();
    }

    public function setRoomObjectAlias(original:String, alias:String):Void {
        if (original != null && alias != null) aliases.set(original, alias);
    }

    override public function getContentType(type:String):String {
        var alias = aliases.get(type);
        return alias == null ? type : alias;
    }

    public function setActiveObjectType(id:Int, type:String):Void {
        if (type == null) return;
        activeTypes.set(id, type);
        activeTypeIds.set(type, id);
    }

    public function getActiveObjectType(id:Int):String return activeTypes.get(id);
    public function getActiveObjectTypeId(type:String):Int {
        var id = activeTypeIds.get(type);
        return id == null ? -1 : id;
    }
    public function getActiveObjectColorIndex(id:Int):Int {
        var value = activeColours.get(id);
        return value == null ? 0 : value;
    }

    public function getWallItemType(id:Int, extra:String = null):String return wallTypes.get(id);
    public function getWallItemColorIndex(id:Int):Int {
        var value = wallColours.get(id);
        return value == null ? 0 : value;
    }

    public function getObjectCategory(type:String):Int {
        if (type == SkyRoomContentLoader.USER || type == SkyRoomContentLoader.PET
            || type == SkyRoomContentLoader.BOT || type == SkyRoomContentLoader.RENTABLE_BOT)
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
        if (type == SkyRoomContentLoader.ROOM || isPublicRoomRootContentType(type))
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM;
        if (type == SkyRoomContentLoader.TILE_CURSOR
            || type == SkyRoomContentLoader.SELECTION_ARROW)
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR;
        if (getPlaceHolderType(type) == SkyRoomContentLoader.WALL_PLACE_HOLDER)
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
        return RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
    }

    public function getPetType(id:Int):String return SkyRoomContentLoader.PET;
    public function getPetColor(type:Int, palette:Int):Dynamic return null;
    public function getPetColorsByTag(type:Int, tag:String):Array<Dynamic> return [];
    public function getPetLayerIdForTag(type:Int, tag:String, scale:Int = 64):Int return -1;
    public function getPetDefaultPalette(type:Int, breed:String):Dynamic return null;
    public function getRoomObjectAdURL(type:String):String return null;

    public function loadThumbnailContent(id:Int, type:String, url:String,
            dispatcher:IEventDispatcher):Bool return false;
    public function _Str_21771(type:String, name:String):String return null;
    public function _Str_16696(type:String, name:String, bitmap:BitmapData, dispose:Bool,
            overwrite:Bool = true):Bool {
        var collection = getGraphicAssetCollection(type);
        return collection != null
            && collection.addAsset(name, bitmap, dispose, 0, 0, false, false);
    }

    public function purge():Void {}
}
#end
