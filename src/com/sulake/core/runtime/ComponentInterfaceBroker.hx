package com.sulake.core.runtime;

import com.sulake.core.runtime.IUnknown.InterfaceReceiver;
import com.sulake.core.utils.ClassUtils;

/** Platform-neutral interface routing extracted from ComponentContext. */
class ComponentInterfaceBroker implements IDisposable {
    public var disposed(get, never):Bool;
    public var providerCount(get, never):Int;
    public var queuedInterfaceCount(get, never):Int;

    private var _providers:Null<InterfaceStructList>;
    private var _queues:Null<Array<ComponentInterfaceQueue>>;

    public function new() {
        _providers = new InterfaceStructList();
        _queues = [];
    }

    private inline function providers():InterfaceStructList {
        if (_providers == null) {
            throw new haxe.Exception("ComponentInterfaceBroker is disposed");
        }
        return _providers;
    }

    private inline function queues():Array<ComponentInterfaceQueue> {
        if (_queues == null) {
            throw new haxe.Exception("ComponentInterfaceBroker is disposed");
        }
        return _queues;
    }

    private inline function get_disposed():Bool {
        return _providers == null;
    }

    private inline function get_providerCount():Int {
        return providers().length;
    }

    private inline function get_queuedInterfaceCount():Int {
        return queues().length;
    }

    public function queueInterface(identifier:IID, ?receiver:InterfaceReceiver):Null<IUnknown> {
        var provider = providers().getStructByInterface(identifier);
        if (provider != null && provider.unknown != null) {
            return provider.unknown.queueInterface(identifier, receiver);
        }
        if (receiver != null) {
            getOrCreateQueue(identifier).receivers.unshift(receiver);
        }
        return null;
    }

    public function attach(unknown:IUnknown, identifiers:Array<IID>, available:Bool = true):Void {
        for (identifier in identifiers) {
            providers().insert(new InterfaceStruct(identifier, unknown));
            if (available) {
                announce(identifier, unknown);
            }
        }
    }

    public function announceImplementor(unknown:IUnknown):Void {
        var structs:Array<InterfaceStruct> = [];
        providers().mapStructsByImplementor(unknown, structs);
        for (interfaceStruct in structs) {
            if (interfaceStruct.iid != null) {
                announce(interfaceStruct.iid, unknown);
            }
        }
    }

    public function detach(unknown:IUnknown):Int {
        var removed = 0;
        var index = providers().getIndexByImplementor(unknown);
        while (index > -1) {
            providers().remove(index).dispose();
            removed++;
            index = providers().getIndexByImplementor(unknown);
        }
        return removed;
    }

    private function announce(identifier:IID, unknown:IUnknown):Void {
        var queue = getQueue(identifier);
        if (queue == null) {
            return;
        }
        while (queue.receivers.length > 0) {
            var acquired = unknown.queueInterface(identifier);
            if (acquired == null) {
                throw new haxe.Exception('Interface still unavailable: ${ClassUtils.getQualifiedClassName(identifier)}');
            }
            queue.receivers.pop()(identifier, acquired);
        }
        queues().remove(queue);
        queue.dispose();
    }

    private function getOrCreateQueue(identifier:IID):ComponentInterfaceQueue {
        var existing = getQueue(identifier);
        if (existing != null) {
            return existing;
        }
        var created = new ComponentInterfaceQueue(identifier);
        queues().push(created);
        return created;
    }

    private function getQueue(identifier:IID):Null<ComponentInterfaceQueue> {
        var name = ClassUtils.getQualifiedClassName(identifier);
        for (queue in queues()) {
            if (queue.identifier != null && ClassUtils.getQualifiedClassName(queue.identifier) == name) {
                return queue;
            }
        }
        return null;
    }

    public function dispose():Void {
        if (_providers == null) {
            return;
        }
        _providers.dispose();
        _providers = null;
        for (queue in queues()) {
            queue.dispose();
        }
        _queues = null;
    }
}
