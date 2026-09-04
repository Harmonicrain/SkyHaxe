package com.sulake.habbo.room;

#if html5
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.runtime.Component;
import com.sulake.core.runtime.IContext;
import com.sulake.core.runtime.IHabboConfigurationManager;
import com.sulake.core.runtime.IID;
import com.sulake.core.runtime.IUnknown;
import com.sulake.core.runtime.IUpdateReceiver;
import openfl.events.EventDispatcher;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

/**
 * The component context the converted room engine runs inside.
 *
 * `RoomManager` is a `Component`, and a Component asks its context for the interfaces it declares
 * as dependencies: it does not take its object factory and visualization factory as constructor
 * arguments, it queues `IIDRoomObjectFactory` and `IIDRoomObjectVisualizationFactory` and waits to
 * be handed them. So the engine cannot be built at all without a context, and this is the smallest
 * one that satisfies it.
 *
 * The client's own context is `ComponentContext`, which carries component attachment, the
 * interface broker's queueing, link-event tracking and the update loop. None of that is reachable
 * here: this context serves exactly three components, all constructed together in a known order,
 * so an interface is either registered before it is asked for or it does not exist.
 *
 * It is also its own `IHabboConfigurationManager`. Component delegates every configuration read to
 * `context.configuration` and answers ""/false when it is null, but RoomManager reads the external
 * base URLs straight off the context, so a null there is a crash rather than a default. The three
 * keys it reads name Habbo's stories and extra-data services, which SkyHaxe does not talk to.
 */
class RoomEngineContext implements IContext implements IHabboConfigurationManager {
    public var assets(get, never):AssetLibrary;
    public var events(get, never):EventDispatcher;
    public var root(get, never):IContext;
    public var displayObjectContainer(get, never):DisplayObjectContainer;
    public var configuration(get, set):Null<IHabboConfigurationManager>;
    public var disposed(get, never):Bool;

    final _assets:AssetLibrary;
    final _events:EventDispatcher;
    final _displayObjectContainer:DisplayObjectContainer;
    final _providers:Array<{identifier:IID, unknown:IUnknown}> = [];
    var _disposed = false;

    public function new(?displayObjectContainer:DisplayObjectContainer) {
        _assets = new AssetLibrary("room_engine_context");
        _events = new EventDispatcher();
        _displayObjectContainer = displayObjectContainer != null
            ? displayObjectContainer : new Sprite();
    }

    /**
     * Publish an interface under an identifier.
     *
     * Every provider is registered before the component that depends on it is constructed, so
     * there is no queue: a dependency either resolves at once or was never registered, and the
     * component stays locked -- which is the visible symptom rather than a silent null.
     */
    public function provide(identifier:IID, unknown:IUnknown):Void {
        _providers.push({identifier: identifier, unknown: unknown});
    }

    public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown> {
        var match = find(identifier);
        if (match != null && receiver != null) receiver(identifier, match);
        return match;
    }

    /** IIDs are identified by their class, the way the client's InterfaceStructList matches them. */
    function find(identifier:IID):Null<IUnknown> {
        var wanted = Type.getClass(identifier);
        for (provider in _providers) {
            if (Type.getClass(provider.identifier) == wanted) return provider.unknown;
        }
        return null;
    }

    public function release(identifier:IID):Int {
        return 0;
    }

    public function attachComponent(component:Component, identifiers:Array<IID>):Void {
        for (identifier in identifiers) provide(identifier, component);
    }

    public function detachComponent(component:Component):Void {
        var index = _providers.length - 1;
        while (index >= 0) {
            if (_providers[index].unknown == component) _providers.splice(index, 1);
            index--;
        }
    }

    /**
     * The update receivers this context drives.
     *
     * The client's context runs these off the Flash frame loop. Nothing here has a frame loop of
     * its own, so the room's owner calls `update` and this passes it on -- same receivers, same
     * order, driven from the caller instead.
     */
    final _receivers:Array<IUpdateReceiver> = [];

    public function registerUpdateReceiver(receiver:IUpdateReceiver, priority:UInt):Void {
        if (_receivers.indexOf(receiver) < 0) _receivers.push(receiver);
    }

    public function removeUpdateReceiver(receiver:IUpdateReceiver):Void {
        _receivers.remove(receiver);
    }

    /** Tick every registered receiver; `time` is the client's millisecond clock. */
    public function update(time:UInt):Void {
        for (receiver in _receivers) {
            if (!receiver.disposed) receiver.update(time);
        }
    }

    public function dispose():Void {
        if (_disposed) return;
        _disposed = true;
        _providers.splice(0, _providers.length);
        _receivers.splice(0, _receivers.length);
    }

    inline function get_disposed():Bool return _disposed;
    inline function get_assets():AssetLibrary return _assets;
    inline function get_events():EventDispatcher return _events;
    inline function get_root():IContext return this;
    inline function get_displayObjectContainer():DisplayObjectContainer
        return _displayObjectContainer;
    inline function get_configuration():Null<IHabboConfigurationManager> return this;

    function set_configuration(value:Null<IHabboConfigurationManager>)
        :Null<IHabboConfigurationManager> {
        // The context is its own configuration; nothing in the port supplies another.
        return this;
    }

    // IHabboConfigurationManager. SkyHaxe has no hotel configuration service, and the only keys
    // the room engine reads -- stories.image_url_base, extra_data_service_url and
    // extra_data_batches_enabled -- name services it does not talk to. An absent property is the
    // honest answer, and it is the answer Component itself gives when a context has none.
    public function propertyExists(key:String):Bool return false;

    public function getProperty(key:String, ?substitutions:ASDictionary<ASAny, ASAny>):String
        return "";

    public function setProperty(key:String, value:String, persist:Bool = false,
        overwrite:Bool = false):Void {}

    public function getBoolean(key:String):Bool return false;

    public function getInteger(key:String, fallback:Int):Int return fallback;

    public function interpolate(text:String):String return text;

    public function updateUrlProtocol(url:String):String return url;

    public function createLinkEvent(link:String):Void {}
}
#end
