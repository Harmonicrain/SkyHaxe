package com.sulake.core.runtime;

import com.sulake.core.utils.ClassUtils;

class InterfaceStruct implements IDisposable {
    public var iid(get, never):Null<IID>;
    public var iis(get, never):Null<String>;
    public var unknown(get, never):Null<IUnknown>;
    public var references(get, never):Int;
    public var disposed(get, never):Bool;

    private var _iid:Null<IID>;
    private var _iis:Null<String>;
    private var _unknown:Null<IUnknown>;
    private var _references:Int;

    public function new(iid:IID, unknown:IUnknown) {
        _iid = iid;
        _iis = ClassUtils.getQualifiedClassName(iid);
        _unknown = unknown;
        _references = 0;
    }

    private inline function get_iid():Null<IID> {
        return _iid;
    }

    private inline function get_iis():Null<String> {
        return _iis;
    }

    private inline function get_unknown():Null<IUnknown> {
        return _unknown;
    }

    private inline function get_references():Int {
        return _references;
    }

    private inline function get_disposed():Bool {
        return _unknown == null;
    }

    public function dispose():Void {
        _iid = null;
        _iis = null;
        _unknown = null;
        _references = 0;
    }

    public inline function reserve():Int {
        return ++_references;
    }

    public inline function release():Int {
        if (_references > 0) {
            _references--;
        }
        return _references;
    }
}
