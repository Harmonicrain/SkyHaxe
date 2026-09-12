package com.sulake.habbo.room;

#if html5
import com.sulake.core.assets.IAssetLibrary;
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.swf.SwfAssetLibrary;
import com.sulake.core.assets.swf.SwfFile;
import com.sulake.core.utils.xml.XML;
import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationLoader;
import com.sulake.room.IRoomContentLoader;
import com.sulake.room.events.RoomContentLoadedEvent;
import com.sulake.room.object.IRoomObject;
import com.sulake.room.object.IRoomObjectController;
import com.sulake.habbo.room.object.RoomObjectVariableEnum;
import com.sulake.room.object.visualization.utils.GraphicAssetCollection;
import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Uint8Array;
import openfl.events.IEventDispatcher;

/** What one content type resolves to once its SWF has landed. */
private typedef LoadedContent = {
    var collection:GraphicAssetCollection;
    var visualization:XML;
    var assets:XML;
    var logic:Null<XML>;
    var visualizationType:String;
    var logicType:String;
}

/**
 * The room engine's content loader, over SkyHaxe's SWF reader.
 *
 * `RoomManager` never loads anything itself. It asks this for a type's placeholder, builds the
 * object against the placeholder's art, calls `loadObjectContent`, and waits for a
 * `RoomContentLoadedEvent` on its own dispatcher -- at which point it swaps the real visualization
 * onto the objects already on screen. That whole progressive-load behaviour lives in the converted
 * engine; this only has to fetch bytes and answer questions about them.
 *
 * The client's `RoomContentLoader` is 2,020 lines because it also owns furnidata parsing, the
 * public-room catalogue, the Gordon download queue and the AIR asset variants. It is a seam for
 * the same reason `IAssetLibrary` is: the AS3 loading stack is written in terms of `LibraryLoader`
 * and a vendored zip decoder, and SkyHaxe reads SWFs with `SwfFile`.
 */
class SkyRoomContentLoader implements IRoomContentLoader {
    /** RoomContentLoader.as:48 -- the placeholders every not-yet-loaded object is drawn as. */
    public static inline var PLACE_HOLDER = "place_holder";
    public static inline var WALL_PLACE_HOLDER = "wall_place_holder";
    public static inline var PET_PLACE_HOLDER = "pet_place_holder";

    /**
     * RoomObjectUserTypes -- the types the engine draws without downloading anything.
     *
     * An avatar's art comes from the compositor, not from a SWF, so an object of this type is
     * built straight from its visualization name with no asset collection at all. That is what
     * lets a user appear the moment the server mentions them.
     */
    public static inline var USER = "user";
    public static inline var PET = "pet";
    public static inline var BOT = "bot";
    public static inline var RENTABLE_BOT = "rentable_bot";
    public static inline var ROOM = "room";
    public static inline var TILE_CURSOR = "tile_cursor";
    public static inline var SELECTION_ARROW = "selection_arrow";

    /**
     * The Gordon SWF each placeholder ships in.
     *
     * Their symbols follow the same `<library>_<type>_<document>` shape as any furni; only the
     * library and the type differ, because one SWF is not named after the type it draws.
     */
    static final PLACE_HOLDER_LIBRARIES = [
        PLACE_HOLDER => "PlaceHolderFurniture",
        WALL_PLACE_HOLDER => "PlaceHolderWallItem",
        PET_PLACE_HOLDER => "PlaceHolderPet",
        ROOM => "HabboRoomContent",
        TILE_CURSOR => "TileCursor",
        SELECTION_ARROW => "SelectionArrow",
    ];

    /** Where a furni class SWF lives. */
    public var furniBase:String = "";
    /** Where the Gordon content -- the placeholders -- lives. */
    public var contentBase:String = "";

    final _content = new StringMap<Null<LoadedContent>>();
    final _loading = new StringMap<Bool>();
    /** Root content types returned for public worlds; child objects share their name prefix. */
    final _publicRoomRoots = new StringMap<Bool>();
    /** Which placeholder a content type wants; absent means the default furniture one. */
    final _placeHolders = new StringMap<String>();
    var _disposed = false;

    public function new() {}

    /**
     * Say that a type is a wall item or a pet, so it gets the right placeholder.
     *
     * The client reads this off furnidata, which it also owns. The HTML5 `RoomContentLoader`
     * parses that data and declares each category through this adapter.
     */
    public function setPlaceHolderType(contentType:String, placeHolder:String):Void {
        _placeHolders.set(contentType, placeHolder);
    }

    public function getPlaceHolderType(contentType:String):String {
        var declared = _placeHolders.get(contentType);
        return declared == null ? PLACE_HOLDER : declared;
    }

    /**
     * The types RoomManager loads before it reports itself initialized.
     *
     * The client also preloads the room shell, the tile cursor, the selection arrow and every
     * public-room world named in the configuration. Those are loaded by the port's own room shell
     * rather than through the engine, so listing them here would block initialization on a
     * download nothing is waiting for.
     */
    public function getPlaceHolderTypes():Array<Dynamic> {
        return [PLACE_HOLDER, WALL_PLACE_HOLDER, PET_PLACE_HOLDER, ROOM, TILE_CURSOR,
            SELECTION_ARROW];
    }

    /** RoomContentLoader.as:773 -- a content type names itself. */
    public function getContentType(type:String):String {
        return type;
    }

    /** RoomContentLoader.as:778 -- avatars and pets are drawn from the compositor, not a SWF. */
    public function hasInternalContent(type:String):Bool {
        return type == USER || type == PET || type == BOT || type == RENTABLE_BOT;
    }

    /**
     * Start a download, and report whether one is now in flight.
     *
     * RoomManager passes its own event dispatcher, because that is what drives the
     * placeholder-to-real swap.
     */
    /**
     * Timing probe for the ~1.1s stall a furni interaction provokes.
     *
     * The stall sits inside `_context.update()` and involves no network, so the suspicion is the
     * engine's own deferred content swap: `RoomManager.update` drains `processLoadedContentTypes`,
     * and `updateObjectContents` then rebuilds every object of that type across every room. That
     * is converted code and cannot be instrumented directly, but it is driven entirely by the
     * RCLE_SUCCESS this class dispatches -- so timestamping the dispatch places the trigger
     * against the blocking task, and the gap between the two says whether the engine picked it up
     * on the very next tick.
     *
     * Remove with the investigation.
     */
    static inline var TRACE = true;

    static inline function trace(message:String):Void {
        if (TRACE) Browser.console.info("SKYHAXE_CONTENT_TRACE "
            + Std.string(Math.round(Browser.window.performance.now())) + " " + message);
    }

    public function loadObjectContent(type:String, dispatcher:IEventDispatcher):Bool {
        if (type == null || _content.exists(type) || _loading.exists(type)) return false;
        trace('loadObjectContent $type');
        _loading.set(type, true);
        var placeHolder = PLACE_HOLDER_LIBRARIES.exists(type);
        var publicRoom = StringTools.startsWith(type, "hh_room_");
        var library = placeHolder ? PLACE_HOLDER_LIBRARIES.get(type) : type;
        var url = placeHolder || publicRoom
            ? PublicRoomVisualizationLoader.contentAssetUrl(contentBase, library + ".swf")
            : PublicRoomVisualizationLoader.assetBase(furniBase) + library + ".swf";
        fetchBytes(url, function(raw) {
            read(type, library, url, raw, dispatcher);
        }, function(error) {
            // A missing SWF costs that type, not the room: its objects keep the placeholder.
            Browser.console.warn('SKYHAXE_CONTENT_ABSENT $type: ' + Std.string(error));
            fail(type, dispatcher);
        });
        return true;
    }

    function read(type:String, library:String, url:String, raw:Bytes,
            dispatcher:IEventDispatcher):Void {
        try {
            var file = SwfFile.read(raw);
            var index = binaryXml(file, library + "_index");
            var visualizationType = attr(index, "visualization");
            var logicType = attr(index, "logic");
            var assets = binaryXml(file, library + "_" + type + "_assets");
            var visualization = binaryXml(file, library + "_" + type + "_visualization");
            var logic = optionalXml(file, library + "_" + type + "_logic");
            SwfAssetLibrary.build(library, url, file, function(assetLibrary) {
                try {
                    var collection = new GraphicAssetCollection();
                    collection.assetLibrary = assetLibrary;
                    if (!collection._Str_13182(assets))
                        throw "the assets document was rejected";
                    _content.set(type, {collection: collection, visualization: visualization,
                        assets: assets, logic: logic, visualizationType: visualizationType,
                        logicType: logicType});
                    if (StringTools.startsWith(type, "hh_room_") && type == library)
                        registerPublicRoomChildren(library, file, assetLibrary);
                    _loading.remove(type);
                    trace('dispatch RCLE_SUCCESS $type');
                    dispatcher.dispatchEvent(
                        new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_SUCCESS, type));
                    trace('returned from RCLE_SUCCESS $type');
                } catch (error:Dynamic) {
                    Browser.console.warn('SKYHAXE_CONTENT_FAILED $type: ' + Std.string(error));
                    fail(type, dispatcher);
                }
            }, function(error) {
                Browser.console.warn('SKYHAXE_CONTENT_FAILED $type: ' + Std.string(error));
                fail(type, dispatcher);
            });
        } catch (error:Dynamic) {
            Browser.console.warn('SKYHAXE_CONTENT_FAILED $type: ' + Std.string(error));
            fail(type, dispatcher);
        }
    }

    /**
     * A public room is one Gordon library with a shell plus many passive object definitions.
     * Packet 5202 names those children (`k`, `table1`, ...); RoomMessageHandler asks for them as
     * `<world>_<child>`. Flash's AssetLibrary exposes every child index from the already-loaded
     * SWF, so mirror that here instead of attempting a nonexistent SWF per object.
     */
    function registerPublicRoomChildren(library:String, file:SwfFile,
            assetLibrary:AssetLibrary):Void {
        var prefix = library + "_" + library + "_";
        var suffix = "_index";
        for (symbol in file.exportedNames()) {
            if (!StringTools.startsWith(symbol, prefix) || !StringTools.endsWith(symbol, suffix))
                continue;
            var childName = symbol.substr(prefix.length,
                symbol.length - prefix.length - suffix.length);
            if (childName == "") continue;
            var childType = library + "_" + childName;
            try {
                var index = binaryXml(file, symbol);
                var assets = binaryXml(file, library + "_" + childType + "_assets");
                var visualization = binaryXml(file,
                    library + "_" + childType + "_visualization");
                var logic = optionalXml(file, library + "_" + childType + "_logic");
                var collection = new GraphicAssetCollection();
                collection.assetLibrary = assetLibrary;
                if (!collection._Str_13182(assets)) continue;
                _content.set(childType, {collection: collection,
                    visualization: visualization, assets: assets, logic: logic,
                    visualizationType: attr(index, "visualization"),
                    logicType: attr(index, "logic")});
            } catch (error:Dynamic) {
                Browser.console.warn('SKYHAXE_PUBLIC_CONTENT_FAILED $childType: '
                    + Std.string(error));
            }
        }
    }

    function fail(type:String, dispatcher:IEventDispatcher):Void {
        _loading.remove(type);
        // Recorded as a null so the type is never retried; its objects keep the placeholder.
        _content.set(type, null);
        dispatcher.dispatchEvent(
            new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_FAILURE, type));
    }

    public function getVisualizationType(type:String):String {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.visualizationType;
    }

    public function getLogicType(type:String):String {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.logicType;
    }

    public function hasVisualizationXML(type:String):Bool return getVisualizationXML(type) != null;

    public function getVisualizationXML(type:String):XML {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.visualization;
    }

    public function hasAssetXML(type:String):Bool return getAssetXML(type) != null;

    public function getAssetXML(type:String):XML {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.assets;
    }

    public function hasLogicXML(type:String):Bool return getLogicXML(type) != null;

    public function getLogicXML(type:String):XML {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.logic;
    }

    /** Null until the type's SWF has landed -- which is how RoomManager knows to wait. */
    public function getGraphicAssetCollection(type:String):IGraphicAssetCollection {
        var loaded = _content.get(type);
        return loaded == null ? null : loaded.collection;
    }

    /** RoomContentLoader.as:1742 -- every object records the room it belongs to. */
    public function roomObjectCreated(object:IRoomObject, roomId:String):Void {
        var controller:IRoomObjectController = cast object;
        if (controller != null && controller.getModelController() != null) {
            controller.getModelController().setString(
                RoomObjectVariableEnum.OBJECT_ROOM_ID, roomId, true);
        }
    }

    // The public-room catalogue and the AIR asset-injection path are the client's, not the port's:
    // SkyHaxe loads public rooms through PublicRoomVisualizationLoader and has no bundled library
    // to insert. Answering honestly keeps RoomManager on the download path this can serve.
    public function insertObjectContent(_arg_1:Int, _arg_2:Int, _arg_3:IAssetLibrary):Bool
        return false;

    public function getPublicRoomContentType(type:String):String {
        if (type == null || type == "") return null;
        var contentType = StringTools.startsWith(type, "hh_room_") ? type : "hh_room_" + type;
        _publicRoomRoots.set(contentType, true);
        return contentType;
    }

    /** Public child objects are `root_child`, so prefix matching is not sufficient here. */
    public function isPublicRoomRootContentType(type:String):Bool {
        return type != null && _publicRoomRoots.exists(type);
    }

    public function getPublicRoomWorldHeightScale(type:String):Float return 1;

    public function getPublicRoomWorldSize(type:String):Int return 32;

    public function isPublicRoomWorldType(type:String):Bool {
        return type != null && type != "";
    }

    public function dispose():Void {
        if (_disposed) return;
        _disposed = true;
        _content.clear();
        _loading.clear();
        _placeHolders.clear();
        _publicRoomRoots.clear();
    }

    static function attr(node:XML, name:String):String {
        var value = node.attribute(name);
        return value == null ? "" : value.toString();
    }

    static function binaryXml(file:SwfFile, symbol:String):XML {
        var document = optionalXml(file, symbol);
        if (document == null) throw 'the SWF has no $symbol document';
        return document;
    }

    static function optionalXml(file:SwfFile, symbol:String):Null<XML> {
        var character = file.symbols.get(symbol);
        if (character == null) return null;
        return new XML(character.payload.getString(0, character.payload.length));
    }

    static function fetchBytes(url:String, onLoaded:Bytes->Void, onError:Dynamic->Void):Void {
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.arrayBuffer();
        }).then(function(buffer) {
            var array = new Uint8Array(buffer);
            var bytes = Bytes.alloc(array.length);
            for (index in 0...array.length) bytes.set(index, array[index]);
            onLoaded(bytes);
            return null;
        }).catchError(onError);
    }
}
#end
