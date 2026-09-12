package com.sulake.core.runtime;

import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.runtime.IUnknown.InterfaceReceiver;
import haxe.ds.ObjectMap;
import openfl.events.Event;
import com.sulake.core.runtime.events.ILinkEventTracker;

class ComponentContext extends Component implements IContext {
    public var root(get, never):IContext;
    private final _linkEventTrackers = new openfl.Vector<ILinkEventTracker>();
    public var linkEventTrackers(get, never):openfl.Vector<ILinkEventTracker>;
    private function get_linkEventTrackers():openfl.Vector<ILinkEventTracker> return _linkEventTrackers;
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

    private var _broker:Null<ComponentInterfaceBroker>;
    private var _components:Null<Array<Component>>;
    private var _unlockListeners:Null<ObjectMap<Component, Event -> Void>>;
    private var _lastError = "";
    private var _lastDebug = "";
    private var _lastWarning = "";

    public function new(?parent:IContext, flags:Int = 0, ?assets:AssetLibrary) {
        super(parent, flags | Component.COMPONENT_FLAG_CONTEXT, assets);
        _broker = new ComponentInterfaceBroker();
        _components = [];
        _unlockListeners = new ObjectMap();
        if (parent == null) setContext(this);
    }

    private function get_root():IContext {
        return context == null || context == this ? this : context.root;
    }

    override public function queueInterface(identifier:IID, ?receiver:InterfaceReceiver):Null<IUnknown> {
        var local = super.queueInterface(identifier, receiver);
        if (local != null) return local;
        var provided = _broker == null ? null : _broker.queueInterface(identifier, receiver);
        if (provided != null) return provided;
        return context == null || context == this ? null : context.queueInterface(identifier, receiver);
    }

    public function attachComponent(component:Component, identifiers:Array<IID>):Void {
        if (_components == null || _broker == null) throw new haxe.Exception("ComponentContext is disposed");
        if (_components.indexOf(component) > -1) throw new haxe.Exception('Component already attached: $component');
        if (component.context == null) component.setContext(this);
        component.registerInterfaces(identifiers);
        _components.push(component);
        _broker.attach(component, identifiers, !component.locked);
        if (component.locked) {
            var listener:Event -> Void = null;
            listener = function(_) {
                if (component.disposed || _broker == null) return;
                component.events.removeEventListener(Component.INTERNAL_EVENT_UNLOCKED, listener);
                _unlockListeners.remove(component);
                _broker.announceImplementor(component);
            };
            _unlockListeners.set(component, listener);
            component.events.addEventListener(Component.INTERNAL_EVENT_UNLOCKED, listener);
        }
    }

    public function detachComponent(component:Component):Void {
        if (_components == null || _broker == null) return;
        var listener = _unlockListeners.get(component);
        if (listener != null && !component.disposed) component.events.removeEventListener(Component.INTERNAL_EVENT_UNLOCKED, listener);
        _unlockListeners.remove(component);
        _broker.detach(component);
        _components.remove(component);
    }

    public function error(message:String, fatal:Bool, category:Int = -1, cause:Dynamic = null):Void {
        _lastError = message;
        com.sulake.core.Core.error(message, fatal, category, cause);
    }

    public function debug(message:String):Void {
        _lastDebug = message;
        com.sulake.core.Core.debug(message);
    }

    public function warning(message:String):Void {
        _lastWarning = message;
        com.sulake.core.Core.warning(message);
    }

    public function getLastErrorMessage():String return _lastError;
    public function getLastDebugMessage():String return _lastDebug;
    public function getLastWarningMessage():String return _lastWarning;

    override public function dispose():Void {
        if (disposed) return;
        var children = _components == null ? [] : _components.copy();
        for (component in children) {
            if (component != this) component.dispose();
        }
        if (_broker != null) _broker.dispose();
        _broker = null;
        _components = null;
        _unlockListeners = null;
        _linkEventTrackers.length = 0;
        super.dispose();
    }
}
