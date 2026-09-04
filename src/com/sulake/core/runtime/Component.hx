package com.sulake.core.runtime;

import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.runtime.IUnknown.InterfaceReceiver;
import com.sulake.core.utils.ClassUtils;
import openfl.events.Event;
import openfl.events.EventDispatcher;

class Component implements IUnknown {
    public static inline final COMPONENT_EVENT_RUNNING = "COMPONENT_EVENT_RUNNING";
    public static inline final COMPONENT_EVENT_DISPOSING = "COMPONENT_EVENT_DISPOSING";
    public static inline final COMPONENT_EVENT_UNLOCKED = "COMPONENT_EVENT_UNLOCKED";
    public static inline final INTERNAL_EVENT_UNLOCKED = "_INTERNAL_EVENT_UNLOCKED";
    public static inline final COMPONENT_FLAG_NULL = 0;
    public static inline final COMPONENT_FLAG_DISPOSABLE = 1;
    public static inline final COMPONENT_FLAG_CONTEXT = 2;
    public static inline final COMPONENT_FLAG_INTERFACE = 4;

    public var locked(get, never):Bool;
    public var disposed(get, never):Bool;
    public var context(get, never):Null<IContext>;
    public var events(get, never):EventDispatcher;
    public var assets(get, never):AssetLibrary;
    public var flags(get, never):Int;
    public var allRequiredDependenciesInjected(get, never):Bool;

    private var _context:Null<IContext>;
    private var _events:Null<EventDispatcher>;
    private var _assets:Null<AssetLibrary>;
    private var _interfaces:Null<InterfaceStructList>;
    private var _lifecycle:Null<ComponentDependencyLifecycle>;
    private var _flags:Int;
    private var _disposed = false;

    public function new(context:Null<IContext>, flags:Int = 0, ?assets:AssetLibrary) {
        if (context == null && (flags & COMPONENT_FLAG_CONTEXT) == 0) {
            throw new haxe.Exception("IContext not provided to Component constructor");
        }
        _context = context;
        _flags = flags;
        _interfaces = new InterfaceStructList();
        _events = new EventDispatcher();
        _assets = assets == null ? new AssetLibrary("_internal_asset_library") : assets;
        var dependencies = getDependencies();
        _lifecycle = new ComponentDependencyLifecycle(
            dependencies,
            requestInterface,
            componentReady,
            attachDependencyListener,
            detachDependencyListener
        );
    }

    private function requestInterface(identifier:IID, receiver:InterfaceReceiver):Null<IUnknown> {
        return _context == null ? null : _context.queueInterface(identifier, receiver);
    }

    private function componentReady():Void {
        initComponent();
        if (_events != null) {
            _events.dispatchEvent(new Event(INTERNAL_EVENT_UNLOCKED));
            _events.dispatchEvent(new Event(COMPONENT_EVENT_RUNNING));
        }
    }

    private static function attachDependencyListener(unknown:IUnknown, listener:Dynamic):Void {
        var component = Std.downcast(unknown, Component);
        if (component == null) throw new haxe.Exception("Dependency event listeners require a Component provider");
        component.events.addEventListener(Reflect.field(listener, "type"), Reflect.field(listener, "callback"));
    }

    private static function detachDependencyListener(unknown:IUnknown, listener:Dynamic):Void {
        var component = Std.downcast(unknown, Component);
        if (component != null && !component.disposed) {
            component.events.removeEventListener(Reflect.field(listener, "type"), Reflect.field(listener, "callback"));
        }
    }

    public function getDependencies():Array<ComponentDependency> {
        return [];
    }

    public function initComponent():Void {}

    @:allow(com.sulake.core.runtime.ComponentContext)
    private function setContext(context:IContext):Void {
        _context = context;
    }

    @:allow(com.sulake.core.runtime.ComponentContext)
    private function registerInterfaces(identifiers:Array<IID>):Void {
        for (identifier in identifiers) {
            if (_interfaces.getStructByInterface(identifier) == null) {
                _interfaces.insert(new InterfaceStruct(identifier, this));
            }
        }
    }

    private inline function get_locked():Bool return _lifecycle != null && _lifecycle.locked;
    private inline function get_disposed():Bool return _disposed;
    private inline function get_context():Null<IContext> return _context;
    private function get_events():EventDispatcher {
        if (_events == null) throw new haxe.Exception("Component events are disposed");
        return _events;
    }
    private function get_assets():AssetLibrary {
        if (_assets == null) throw new haxe.Exception("Component assets are disposed");
        return _assets;
    }
    private inline function get_flags():Int return _flags;
    private inline function get_allRequiredDependenciesInjected():Bool {
        return _lifecycle != null && _lifecycle.allRequiredDependenciesInjected;
    }

    public function queueInterface(identifier:IID, ?receiver:InterfaceReceiver):Null<IUnknown> {
        var struct = _interfaces == null ? null : _interfaces.getStructByInterface(identifier);
        if (struct == null) {
            if (_context == null) return null;
            var self:Dynamic = this;
            if (_context == self) return null;
            return _context.queueInterface(identifier, receiver);
        }
        if (_disposed) throw new haxe.Exception('Interface requested through disposed ${ClassUtils.getQualifiedClassName(this)}');
        if (locked) return null;
        struct.reserve();
        if (receiver != null) receiver(identifier, this);
        return this;
    }

    public function release(identifier:IID):Int {
        if (_disposed) return 0;
        var struct = _interfaces.getStructByInterface(identifier);
        if (struct == null) throw new haxe.Exception('Attempting to release unknown interface: ${ClassUtils.getQualifiedClassName(identifier)}');
        var references = struct.release();
        if ((_flags & COMPONENT_FLAG_INTERFACE) != 0
            && references == 0
            && _interfaces.getTotalReferenceCount() == 0) {
            if (_context != null) _context.detachComponent(this);
            dispose();
        }
        return references;
    }

    public function dispose():Void {
        if (_disposed) return;
        var oldContext = _context;
        _disposed = true;
        var self:Dynamic = this;
        if (oldContext != null && oldContext != self) oldContext.detachComponent(this);
        if (_lifecycle != null) _lifecycle.dispose();
        _lifecycle = null;
        if (_events != null) _events.dispatchEvent(new Event(COMPONENT_EVENT_DISPOSING));
        _events = null;
        if (_interfaces != null) _interfaces.dispose();
        _interfaces = null;
        if (_assets != null) _assets.dispose();
        _assets = null;
        _context = null;
    }

    public function toString():String {
        return '[component ${ClassUtils.getQualifiedClassName(this)} refs: ${_interfaces == null ? 0 : _interfaces.getTotalReferenceCount()}]';
    }
}
