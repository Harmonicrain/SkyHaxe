package com.sulake.habbo.room;

#if html5
import com.sulake.core.runtime.IID;
import com.sulake.core.runtime.IContext;
import com.sulake.core.runtime.IUnknown;
import com.sulake.core.runtime.Component;
import com.sulake.core.communication.connection.IConnection;
import com.sulake.habbo.avatar.AvatarRoomRenderer;
import com.sulake.habbo.advertisement.IAdManager;
import com.sulake.habbo.advertisement.events.AdEvent;
import com.sulake.habbo.communication.IHabboCommunicationManager;
import com.sulake.habbo.room.RoomObjectLogicComponent;
import com.sulake.habbo.session.UserDataManager;
import com.sulake.habbo.session.IRoomSession;
import com.sulake.habbo.session.IRoomSessionManager;
import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomModerationSettings;
import com.sulake.habbo.room.object.RoomObjectVisualizationFactory;
import com.sulake.iid.IIDAvatarRenderManager;
import com.sulake.iid.IIDHabboAdManager;
import com.sulake.iid.IIDHabboCommunicationManager;
import com.sulake.iid.IIDHabboConfigurationManager;
import com.sulake.iid.IIDHabboRoomSessionManager;
import com.sulake.iid.IIDHabboWindowManager;
import com.sulake.iid.IIDRoomManager;
import com.sulake.iid.IIDRoomObjectFactory;
import com.sulake.iid.IIDRoomObjectVisualizationFactory;
import com.sulake.iid.IIDRoomRendererFactory;
import com.sulake.iid.IIDSessionDataManager;
import com.sulake.room.RoomManager;
import com.sulake.room.renderer.IRoomRenderer;
import com.sulake.room.renderer.IRoomRendererFactory;
import com.sulake.room.renderer.RoomRenderer;
import js.Browser;
import openfl.display.DisplayObjectContainer;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;

/**
 * Owns the converted RoomEngine and the small HTML5 host boundary it needs.
 *
 * This is deliberately orchestration, not a second room implementation: object creation, room
 * XML, rendering, depth sorting and interaction all stay in generated client classes. The two
 * host-only values below stand in for services whose UI is not part of this milestone yet.
 */
class RoomEngineRuntime {
    static var _context:Null<RoomEngineContext>;
    static var _engine:Null<RoomEngine>;
    static var _timer:Null<haxe.Timer>;
    static var _starting = false;
    static var _waiting:Array<{ready:RoomEngine->Void, failed:Dynamic->Void}> = [];

    public static var engine(get, never):Null<RoomEngine>;
    static inline function get_engine():Null<RoomEngine> return _engine;

    public static function ensure(container:DisplayObjectContainer, furniBase:String,
            contentBase:String, furnidataUrl:String, onReady:RoomEngine->Void,
            onError:Dynamic->Void, ?roomConnection:IConnection):Void {
        if (_engine != null && _engine.isInitialized) {
            onReady(_engine);
            return;
        }
        _waiting.push({ready: onReady, failed: onError});
        if (_starting) return;
        _starting = true;

        AvatarRoomRenderer.prepare(contentBase, function() {
            try {
                RoomContentLoader.configure(furniBase, contentBase, furnidataUrl);
                var context = new RoomEngineContext(container);
                context.provide(new IIDHabboConfigurationManager(), context);
                context.provide(new IIDAvatarRenderManager(), AvatarRoomRenderer.renderManager());
                if (roomConnection != null)
                    context.provide(new IIDHabboCommunicationManager(),
                        new RoomEngineCommunicationService(roomConnection));
                context.provide(new IIDHabboAdManager(), new RoomAdManagerHost(context, furniBase));

                var objectFactory = new RoomObjectLogicComponent(context);
                context.provide(new IIDRoomObjectFactory(), objectFactory);
                var visualizationFactory = new RoomObjectVisualizationFactory(context);
                context.provide(new IIDRoomObjectVisualizationFactory(), visualizationFactory);

                var roomManager = new RoomManager(context);
                context.provide(new IIDRoomManager(), roomManager);
                context.provide(new IIDRoomRendererFactory(), new Html5RoomRendererFactory());

                // RoomEngine requires these two services even though room construction does not
                // use their UI/data surfaces. Keep the boundary explicit and fail if a new room
                // path starts relying on a member that is not supplied here.
                var session = new RoomEngineHostService();
                context.provide(new IIDSessionDataManager(), cast session);
                context.provide(new IIDHabboWindowManager(), cast new RoomEngineHostService());
                context.provide(new IIDHabboRoomSessionManager(),
                    cast new RoomSessionManagerHost(context, roomConnection));

                _context = context;
                _engine = new RoomEngine(context, RoomEngine.SETUP_WITHOUT_COMMUNICATION);
                startClock();
            } catch (error:Dynamic) {
                fail(error);
            }
        }, fail);
    }

    static function startClock():Void {
        if (_timer != null) return;
        var started = haxe.Timer.stamp();
        _timer = new haxe.Timer(16);
        _timer.run = function() {
            if (_context == null || _engine == null) return;
            _context.update(Std.int(haxe.Timer.stamp() * 1000));
            if (_starting && _engine.isInitialized) {
                _starting = false;
                var waiting = _waiting;
                _waiting = [];
                Browser.console.info("SKYHAXE_ROOM_ENGINE_READY");
                for (entry in waiting) entry.ready(_engine);
            } else if (_starting && haxe.Timer.stamp() - started > 20) {
                fail("converted RoomEngine did not initialize within 20 seconds");
            }
        };
    }

    static function fail(error:Dynamic):Void {
        _starting = false;
        var waiting = _waiting;
        _waiting = [];
        for (entry in waiting) entry.failed(error);
    }

    public static function reset():Void {
        if (_timer != null) _timer.stop();
        _timer = null;
        if (_engine != null && !_engine.disposed) _engine.dispose();
        if (_context != null && !_context.disposed) _context.dispose();
        _engine = null;
        _context = null;
        _starting = false;
        _waiting = [];
    }
}

/** HTML5 implementation of the image-only part of HabboAdManager used by room billboards. */
private class RoomAdManagerHost extends Component implements IAdManager {
    final _furniBase:String;

    public function new(context:IContext, furniBase:String) {
        _furniBase = furniBase;
        super(context);
    }

    public function showInterstitial():Void {}

    public function loadRoomAdImage(roomId:Int, objectId:Int, objectCategory:Int,
            imageUrl:String, clickUrl:String):Void {
        if (_disposed || imageUrl == null || imageUrl == "") {
            dispatchResult(AdEvent.ROOM_AD_IMAGE_LOADING_FAILED, roomId, objectId,
                objectCategory, imageUrl, clickUrl, null);
            return;
        }
        var image = Browser.document.createImageElement();
        image.crossOrigin = "anonymous";
        image.onload = function(_) {
            if (_disposed) return;
            try {
                var canvas = Browser.document.createCanvasElement();
                canvas.width = image.width;
                canvas.height = image.height;
                canvas.getContext2d().drawImage(image, 0, 0);
                var bitmap = BitmapData.fromCanvas(canvas, true);
                dispatchResult(AdEvent.ROOM_AD_IMAGE_LOADED, roomId, objectId,
                    objectCategory, imageUrl, clickUrl, bitmap);
            } catch (error:Dynamic) {
                Browser.console.warn('SKYHAXE_ROOM_AD_FAILED $imageUrl: ' + Std.string(error));
                dispatchResult(AdEvent.ROOM_AD_IMAGE_LOADING_FAILED, roomId, objectId,
                    objectCategory, imageUrl, clickUrl, null);
            }
        };
        image.onerror = function(_) {
            if (_disposed) return;
            Browser.console.warn('SKYHAXE_ROOM_AD_ABSENT $imageUrl');
            dispatchResult(AdEvent.ROOM_AD_IMAGE_LOADING_FAILED, roomId, objectId,
                objectCategory, imageUrl, clickUrl, null);
        };
        image.src = roomAdUrl(imageUrl);
    }

    function roomAdUrl(imageUrl:String):String {
        var path = com.sulake.habbo.room.object.visualization.room.publicroom
            .PublicRoomVisualizationLoader.assetUrl(imageUrl);
        var base = com.sulake.habbo.room.object.visualization.room.publicroom
            .PublicRoomVisualizationLoader.assetBase(_furniBase);
        var parts = [for (part in base.split("/")) if (part != "") part];
        if (parts.length == 0 || StringTools.startsWith(path, '/' + parts[0] + '/'))
            return path;
        return '/' + parts[0] + path;
    }

    inline function dispatchResult(type:String, roomId:Int, objectId:Int, objectCategory:Int,
            imageUrl:String, clickUrl:String, bitmap:BitmapData):Void {
        events.dispatchEvent(new AdEvent(type, roomId, bitmap, imageUrl, clickUrl,
            null, null, objectId, objectCategory));
    }
}

/** The converted engine only consumes the already-authenticated connection. */
private class RoomEngineCommunicationService implements IHabboCommunicationManager {
    final _connection:IConnection;
    var _disposed = false;

    public function new(connection:IConnection) _connection = connection;
    public var connection(get, never):IConnection;
    inline function get_connection():IConnection return _connection;
    public var disposed(get, never):Bool;
    inline function get_disposed():Bool return _disposed;
    public function dispose():Void _disposed = true;
    public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown> return null;
    public function release(identifier:IID):Int return 0;
}

/**
 * Minimal room-session ownership required by RoomEngine and RoomMessageHandler.
 *
 * Session UI and moderation are outside the renderer milestone, but a room still needs a stable
 * own-user id and a UserDataManager. Returning null here is not a harmless stub: user creation,
 * chat and mouse-over paths dereference the session directly.
 */
private class RoomSessionManagerHost extends Component implements IRoomSessionManager {
    final _sessions = new Map<Int, RoomSessionHost>();
    final _connection:Null<IConnection>;

    public function new(context:IContext, connection:Null<IConnection>) {
        _connection = connection;
        super(context);
    }

    public function getSession(roomId:Int):IRoomSession {
        var session = _sessions.get(roomId);
        if (session == null) {
            session = new RoomSessionHost(roomId, _connection);
            _sessions.set(roomId, session);
        }
        return session;
    }

    public var sessionStarting(get, never):Bool;
    inline function get_sessionStarting():Bool return false;
    public function gotoRoom(roomId:Int, password:String = "", roomName:String = ""):Bool return false;
    public function gotoRoomNetwork(roomId:Int, networkId:Int):Bool return false;
    public function startSession(session:IRoomSession):Bool return false;
    public function startGameSession():Void {}
    public function disposeGameSession():Void {}
    public function disposeSession(roomId:Int, openLandingView:Bool = true):Void _sessions.remove(roomId);
}

/** Rendering-path IRoomSession. UI/moderation senders remain inert until their milestone. */
private class RoomSessionHost implements IRoomSession {
    final _roomId:Int;
    final _userDataManager:UserDataManager;
    var _ownUserRoomId:Int = -1;
    var _roomControllerLevel:Int = 0;
    var _isUserDecorating:Bool = false;
    var _isRoomOwner:Bool = false;
    var _playTestMode:Bool = false;
    var _isGuildRoom:Bool = false;
    var _isSpectatorMode:Bool = false;
    var _arePetsAllowed:Bool = true;
    var _tradeMode:Int = 0;
    var _roomModerationSettings:RoomModerationSettings;
    var _isNuxNotComplete:Bool = false;

    public function new(roomId:Int, connection:Null<IConnection>) {
        _roomId = roomId;
        _userDataManager = new UserDataManager();
        if (connection != null) _userDataManager.connection = connection;
    }

    public var roomId(get, never):Int;
    inline function get_roomId():Int return _roomId;
    public var roomResources(get, never):String;
    inline function get_roomResources():String return "";
    public var state(get, never):String;
    inline function get_state():String return "";
    public var ownUserRoomId(get, set):Int;
    inline function get_ownUserRoomId():Int return _ownUserRoomId;
    inline function set_ownUserRoomId(value:Int):Int return _ownUserRoomId = value;
    public var roomControllerLevel(get, set):Int;
    inline function get_roomControllerLevel():Int return _roomControllerLevel;
    inline function set_roomControllerLevel(value:Int):Int return _roomControllerLevel = value;
    public var isUserDecorating(get, set):Bool;
    inline function get_isUserDecorating():Bool return _isUserDecorating;
    inline function set_isUserDecorating(value:Bool):Bool return _isUserDecorating = value;
    public var isRoomOwner(get, set):Bool;
    inline function get_isRoomOwner():Bool return _isRoomOwner;
    inline function set_isRoomOwner(value:Bool):Bool return _isRoomOwner = value;
    public var playTestMode(get, set):Bool;
    inline function get_playTestMode():Bool return _playTestMode;
    inline function set_playTestMode(value:Bool):Bool return _playTestMode = value;
    public var isGuildRoom(get, set):Bool;
    inline function get_isGuildRoom():Bool return _isGuildRoom;
    inline function set_isGuildRoom(value:Bool):Bool return _isGuildRoom = value;
    public var isSpectatorMode(get, set):Bool;
    inline function get_isSpectatorMode():Bool return _isSpectatorMode;
    inline function set_isSpectatorMode(value:Bool):Bool return _isSpectatorMode = value;
    public var arePetsAllowed(get, set):Bool;
    inline function get_arePetsAllowed():Bool return _arePetsAllowed;
    inline function set_arePetsAllowed(value:Bool):Bool return _arePetsAllowed = value;
    public var tradeMode(get, set):Int;
    inline function get_tradeMode():Int return _tradeMode;
    inline function set_tradeMode(value:Int):Int return _tradeMode = value;
    public var userDataManager(get, never):UserDataManager;
    inline function get_userDataManager():UserDataManager return _userDataManager;
    public var areBotsAllowed(get, never):Bool;
    inline function get_areBotsAllowed():Bool return true;
    public var isPrivateRoom(get, never):Bool;
    inline function get_isPrivateRoom():Bool return true;
    public var isNoobRoom(get, never):Bool;
    inline function get_isNoobRoom():Bool return false;
    public var isGameSession(get, never):Bool;
    inline function get_isGameSession():Bool return false;
    public var doorMode(never, set):Int;
    inline function set_doorMode(value:Int):Int return value;
    public var roomModerationSettings(get, set):RoomModerationSettings;
    inline function get_roomModerationSettings():RoomModerationSettings return _roomModerationSettings;
    inline function set_roomModerationSettings(value:RoomModerationSettings):RoomModerationSettings return _roomModerationSettings = value;
    public var isNuxNotComplete(get, set):Bool;
    inline function get_isNuxNotComplete():Bool return _isNuxNotComplete;
    inline function set_isNuxNotComplete(value:Bool):Bool return _isNuxNotComplete = value;

    public function start():Bool return true;
    public function sendChatMessage(message:String, styleId:Int = 0):Void {}
    public function sendChangeMottoMessage(motto:String):Void {}
    public function sendShoutMessage(message:String, styleId:Int = 0):Void {}
    public function sendWhisperMessage(recipient:String, message:String, styleId:Int = 0):Void {}
    public function sendChatTypingMessage(typing:Bool):Void {}
    public function sendAvatarExpressionMessage(expression:Int):Void {}
    public function sendSignMessage(sign:Int):Void {}
    public function sendDanceMessage(dance:Int):Void {}
    public function sendChangePostureMessage(posture:Int):Void {}
    public function sendCreditFurniRedeemMessage(objectId:Int):Void {}
    public function sendPresentOpenMessage(objectId:Int):Void {}
    public function sendOpenPetPackageMessage(objectId:Int, name:String):Void {}
    public function sendRoomDimmerGetPresetsMessage():Void {}
    public function sendRoomDimmerSavePresetMessage(id:Int, type:Int, color:UInt, brightness:Int, backgroundOnly:Bool):Void {}
    public function sendRoomDimmerChangeStateMessage():Void {}
    public function sendConversionPoint(category:String, type:String, action:String, extra:String = null, value:Int = 0):Void {}
    public function sendPollStartMessage(pollId:Int):Void {}
    public function sendPollRejectMessage(pollId:Int):Void {}
    public function votePoll(counter:Int):Void {}
    public function sendPollAnswerMessage(pollId:Int, questionId:Int, answers:Array<ASAny>):Void {}
    public function sendPeerUsersClassificationMessage(data:String):Void {}
    public function sendRoomUsersClassificationMessage(data:String):Void {}
    public function sendVisitFlatMessage(roomId:Int):Void {}
    public function sendVisitUserMessage(userName:String):Void {}
    public function ambassadorAlert(userId:Int):Void {}
    public function kickUser(userId:Int):Void {}
    public function banUserWithDuration(userId:Int, duration:String):Void {}
    public function muteUser(userId:Int, minutes:Int):Void {}
    public function assignRights(userId:Int):Void {}
    public function removeRights(userId:Int):Void {}
    public function letUserIn(userName:String, allow:Bool):Void {}
    public function pickUpPet(petId:Int):Void {}
    public function mountPet(petId:Int):Void {}
    public function togglePetRidingPermission(petId:Int):Void {}
    public function dismountPet(petId:Int):Void {}
    public function removeSaddleFromPet(petId:Int):Void {}
    public function requestPetCommands(petId:Int):Void {}
    public function useProductForPet(petId:Int, productId:Int):Void {}
    public function plantSeed(objectId:Int):Void {}
    public function quit():Void {}
    public function changeQueue(queueId:Int):Void {}
    public function sendUpdateClothingChangeFurniture(objectId:Int, figure:String, gender:String):Void {}
    public function receivedChatWithTrackingId(trackingId:Int):Void {}
    public function harvestPet(petId:Int):Void {}
    public function togglePetBreedingPermission(petId:Int):Void {}
    public function compostPlant(objectId:Int):Void {}
    public function sendScriptProceed():Void {}
}

private class Html5RoomRendererFactory implements IRoomRendererFactory {
    var _disposed = false;

    public function new() {}
    public function createRenderer():IRoomRenderer return new RoomRenderer(null);
    public var disposed(get, never):Bool;
    inline function get_disposed():Bool return _disposed;
    public function dispose():Void _disposed = true;
    public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown> return null;
    public function release(identifier:IID):Int return 0;
}

/** Minimal service object used only for mandatory-but-not-yet-consumed component dependencies. */
private class RoomEngineHostService implements IUnknown {
    final _events = new EventDispatcher();
    var _disposed = false;

    public function new() {}
    public var disposed(get, never):Bool;
    inline function get_disposed():Bool return _disposed;
    public var events(get, never):EventDispatcher;
    inline function get_events():EventDispatcher return _events;
    public var userId(get, never):Int;
    inline function get_userId():Int return 0;
    public var topSecurityLevel(get, never):Int;
    inline function get_topSecurityLevel():Int return 0;
    public var isRoomCameraFollowDisabled(get, never):Bool;
    inline function get_isRoomCameraFollowDisabled():Bool return false;
    public function isPerkAllowed(name:String):Bool return false;
    public function isIgnored(name:String):Bool return false;

    /**
     * Hover hit-testing asks session furnidata whether a surface supports sitting or lying.
     * Rendering furnidata currently lives in RoomContentLoader, so no interaction metadata is
     * available here yet. Null is the engine's supported "ordinary surface" result.
     */
    public function getFloorItemDataByName(name:String, index:Int = 0):Dynamic return null;
    public function getWallItemDataByName(name:String, index:Int = 0):Dynamic return null;

    /**
     * RoomEngine.requestBadgeImageAsset (:4692) picks one of these by reference and calls it, so
     * a missing member is a `not a function` crash rather than a blank badge -- which is what the
     * room's one guild furni was doing on every state update.
     *
     * Empty is the honest answer: this port has no badge image store, so the engine takes its own
     * not-loaded-yet path, draws `loading_icon` and registers a listener for an image that will
     * arrive when the badge milestone does.
     */
    public function getGroupBadgeAssetName(badgeCode:String):String return "";
    public function getBadgeImageAssetName(badgeCode:String):String return "";

    public function dispose():Void _disposed = true;
    public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown> return null;
    public function release(identifier:IID):Int return 0;
}
#end
