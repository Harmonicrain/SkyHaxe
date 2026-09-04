package com.sulake.core.runtime;

import com.sulake.core.runtime.IUnknown.InterfaceReceiver;

class ComponentInterfaceQueue implements IDisposable {
    public var identifier(get, never):Null<IID>;
    public var receivers(get, never):Array<InterfaceReceiver>;
    public var disposed(get, never):Bool;

    private var _identifier:Null<IID>;
    private var _receivers:Null<Array<InterfaceReceiver>>;
    private var _isDisposed:Bool;

    public function new(identifier:IID) {
        _identifier = identifier;
        _receivers = [];
        _isDisposed = false;
    }

    private inline function get_identifier():Null<IID> {
        return _identifier;
    }

    private inline function get_receivers():Array<InterfaceReceiver> {
        if (_receivers == null) {
            throw new haxe.Exception("ComponentInterfaceQueue is disposed");
        }
        return _receivers;
    }

    private inline function get_disposed():Bool {
        return _isDisposed;
    }

    public function dispose():Void {
        if (_isDisposed) {
            return;
        }
        _isDisposed = true;
        _identifier = null;
        _receivers = null;
    }
}
