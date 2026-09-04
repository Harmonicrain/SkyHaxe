package com.sulake.core.runtime;

interface IDisposable {
    public var disposed(get, never):Bool;

    public function dispose():Void;
}
