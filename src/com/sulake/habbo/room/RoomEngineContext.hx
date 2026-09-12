package com.sulake.habbo.room;

#if html5
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.runtime.Component;
import com.sulake.core.runtime.IContext;
import com.sulake.core.runtime.IHabboConfigurationManager;
import com.sulake.core.runtime.IID;
import com.sulake.core.runtime.IUnknown;
import com.sulake.core.runtime.IUpdateReceiver;
import com.sulake.core.runtime.events.ILinkEventTracker;
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
class RoomEngineContext extends Component implements IContext {
    public var root(get, never):IContext;
    public var displayObjectContainer(get, never):DisplayObjectContainer;
    public var configuration(get, set):Null<IHabboConfigurationManager>;
    var _configuration:Null<IHabboConfigurationManager>;
    final _displayObjectContainer:DisplayObjectContainer;
    final _providers:Array<{identifier:IID, unknown:IUnknown}> = [];
    final _pending:Array<{identifier:IID, receiver:ASFunction}> = [];
    final _linkEventTrackers = new openfl.Vector<ILinkEventTracker>();
    public var linkEventTrackers(get, never):openfl.Vector<ILinkEventTracker>;
    inline function get_linkEventTrackers():openfl.Vector<ILinkEventTracker> return _linkEventTrackers;

    public function new(?displayObjectContainer:DisplayObjectContainer) {
        super(this, Component.COMPONENT_FLAG_CONTEXT, new AssetLibrary("room_engine_context"));
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
        // Same registration contract as ComponentContext.attachComponent: the original
        // component must own the IID that dependency disposal later releases.
        if (Std.isOfType(unknown, Component)) {
            var component:Component = cast unknown;
            var interfaces = Component.requiredDependencyIids(component);
            if (interfaces.getStructByInterface(identifier) == null)
                interfaces.insert(new com.sulake.core.runtime.InterfaceStruct(identifier, component));
        }
        _providers.push({identifier: identifier, unknown: unknown});
        if (Std.isOfType(unknown, Component) && cast(unknown, Component).locked) {
            var component:Component = cast unknown;
            var unlocked:openfl.events.Event->Void = null;
            unlocked = function(_) {
                component.events.removeEventListener("_INTERNAL_EVENT_UNLOCKED", unlocked);
                deliverPending(identifier, unknown);
            };
            component.events.addEventListener("_INTERNAL_EVENT_UNLOCKED", unlocked);
            return;
        }
        deliverPending(identifier, unknown);
    }

    function deliverPending(identifier:IID, unknown:IUnknown):Void {
        var wanted = Type.getClass(identifier);
        // Remove before callbacks: injection can publish another component reentrantly.
        var ready = _pending.filter(request -> Type.getClass(request.identifier) == wanted);
        for (request in ready) _pending.remove(request);
        for (request in ready) {
            if (Type.getClass(request.identifier) == wanted) {
                if (Std.isOfType(unknown, Component))
                    cast(unknown, Component).queueInterface(request.identifier, request.receiver);
                else
                    request.receiver(request.identifier, unknown);
            }
        }
    }

    override public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown> {
        var match = find(identifier);
        if (Std.isOfType(match, Component) && cast(match, Component).locked) {
            if (receiver != null) _pending.push({identifier: identifier, receiver: receiver});
            return null;
        }
        if (Std.isOfType(match, Component)) return match.queueInterface(identifier, receiver);
        if (match != null && receiver != null) receiver(identifier, match);
        if (match == null && receiver != null)
            _pending.push({identifier: identifier, receiver: receiver});
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

    override public function release(identifier:IID):UInt {
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

    override public function registerUpdateReceiver(receiver:IUpdateReceiver, priority:UInt):Void {
        if (_receivers.indexOf(receiver) < 0) _receivers.push(receiver);
    }

    override public function removeUpdateReceiver(receiver:IUpdateReceiver):Void {
        _receivers.remove(receiver);
    }

    public function getLastErrorMessage():String return "";

    /** Tick every registered receiver; `time` is the client's millisecond clock. */
    public function update(time:UInt):Void {
        for (receiver in _receivers) {
            if (!receiver.disposed) receiver.update(time);
        }
    }

    override public function dispose():Void {
        if (disposed) return;
        _providers.splice(0, _providers.length);
        _pending.splice(0, _pending.length);
        _receivers.splice(0, _receivers.length);
        _linkEventTrackers.length = 0;
        super.dispose();
    }

    inline function get_root():IContext return this;
    inline function get_displayObjectContainer():DisplayObjectContainer
        return _displayObjectContainer;
    inline function get_configuration():Null<IHabboConfigurationManager> return _configuration;

    function set_configuration(value:Null<IHabboConfigurationManager>)
        :Null<IHabboConfigurationManager> {
        return _configuration = value;
    }

    // IHabboConfigurationManager. SkyHaxe has no hotel configuration service, and the only keys
    // the room engine reads -- stories.image_url_base, extra_data_service_url and
    // extra_data_batches_enabled -- name services it does not talk to. An absent property is the
    // honest answer, and it is the answer Component itself gives when a context has none.
    override public function propertyExists(key:String):Bool return _configuration != null && _configuration.propertyExists(key);

    override public function getProperty(key:String, ?substitutions:ASDictionary<ASAny, ASAny>):String
        return _configuration == null ? "" : _configuration.getProperty(key, substitutions);

    override public function setProperty(key:String, value:String, persist:Bool = false,
        overwrite:Bool = false):Void {
        if (_configuration != null) _configuration.setProperty(key, value, persist, overwrite);
    }

    override public function getBoolean(key:String):Bool return _configuration != null && _configuration.getBoolean(key);

    override public function getInteger(key:String, fallback:Int):Int return _configuration == null ? fallback : _configuration.getInteger(key, fallback);

    override public function interpolate(text:String):String return _configuration == null ? text : _configuration.interpolate(text);

    override public function updateUrlProtocol(url:String):String return _configuration == null ? url : _configuration.updateUrlProtocol(url);

    /** The host supplies the original context's prefix-based registration contract. */
    public function addLinkEventTracker(tracker:ILinkEventTracker):Void {
        if (_linkEventTrackers.indexOf(tracker) < 0) _linkEventTrackers.push(tracker);
    }
    public function removeLinkEventTracker(tracker:ILinkEventTracker):Void {
        var index = _linkEventTrackers.indexOf(tracker);
        if (index >= 0) _linkEventTrackers.splice(index, 1);
    }
    public function createLinkEvent(link:String):Void {
        for (tracker in _linkEventTrackers)
            if (tracker.linkPattern.length == 0 || link.substr(0, tracker.linkPattern.length) == tracker.linkPattern)
                tracker.linkReceived(link);
    }
}
#end
