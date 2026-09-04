package com.sulake.core.runtime;

import com.sulake.core.runtime.IUnknown.InterfaceReceiver;

typedef InterfaceRequest = (identifier:IID, receiver:InterfaceReceiver) -> Null<IUnknown>;
typedef DependencyListenerAction = (unknown:IUnknown, listener:Dynamic) -> Void;

private typedef InjectedDependency = {
    final dependency:ComponentDependency;
    final unknown:IUnknown;
}

/**
 * Platform-neutral dependency state machine extracted from Component.
 * Assets, events and display concerns remain in the eventual OpenFL Component shell.
 */
class ComponentDependencyLifecycle implements IDisposable {
    public var locked(get, never):Bool;
    public var initialized(get, never):Bool;
    public var allRequiredDependenciesInjected(get, never):Bool;
    public var disposed(get, never):Bool;

    private var _locked:Bool;
    private var _initialized:Bool;
    private var _disposed:Bool;
    private var _requiredDependencyCount:Int;
    private var _injected:Array<InjectedDependency>;
    private final _onReady:Void -> Void;
    private final _attachListener:Null<DependencyListenerAction>;
    private final _detachListener:Null<DependencyListenerAction>;

    public function new(
        dependencies:Array<ComponentDependency>,
        request:InterfaceRequest,
        onReady:Void -> Void,
        ?attachListener:DependencyListenerAction,
        ?detachListener:DependencyListenerAction
    ) {
        _locked = dependencies.length > 0;
        _initialized = false;
        _disposed = false;
        _requiredDependencyCount = 1;
        _injected = [];
        _onReady = onReady;
        _attachListener = attachListener;
        _detachListener = detachListener;

        for (dependency in dependencies) {
            if (dependency.isRequired) {
                _requiredDependencyCount++;
            }
            requestDependency(dependency, request);
        }
        dependencyArrived(); // Constructor sentinel: all requests have now been issued.
    }

    private function requestDependency(dependency:ComponentDependency, request:InterfaceRequest):Void {
        var received = false;
        request(dependency.identifier, function(identifier, unknown) {
            if (_disposed || received) {
                unknown.release(identifier);
                return;
            }
            received = true;
            if (dependency.dependencySetter != null) {
                dependency.dependencySetter(unknown);
            }
            var listeners = dependency.eventListeners;
            if (listeners != null && listeners.length > 0) {
                if (_attachListener == null || _detachListener == null) {
                    throw new haxe.Exception("Dependency listeners require attach and detach adapters");
                }
                for (listener in listeners) {
                    _attachListener(unknown, listener);
                }
            }
            _injected.push({dependency: dependency, unknown: unknown});
            if (dependency.isRequired) {
                dependencyArrived();
            }
        });
    }

    private function dependencyArrived():Void {
        if (_requiredDependencyCount > 0) {
            _requiredDependencyCount--;
        }
        if (_requiredDependencyCount == 0 && !_initialized && !_disposed) {
            _initialized = true;
            _locked = false;
            _onReady();
        }
    }

    private inline function get_locked():Bool {
        return _locked;
    }

    private inline function get_initialized():Bool {
        return _initialized;
    }

    private inline function get_allRequiredDependenciesInjected():Bool {
        return _requiredDependencyCount == 0;
    }

    private inline function get_disposed():Bool {
        return _disposed;
    }

    public function dispose():Void {
        if (_disposed) {
            return;
        }
        _disposed = true;
        for (injected in _injected) {
            var dependency = injected.dependency;
            var listeners = dependency.eventListeners;
            if (listeners != null && _detachListener != null) {
                for (listener in listeners) {
                    _detachListener(injected.unknown, listener);
                }
            }
            if (dependency.dependencySetter != null) {
                dependency.dependencySetter(null);
            }
            injected.unknown.release(dependency.identifier);
        }
        _injected = [];
        _locked = false;
    }
}
