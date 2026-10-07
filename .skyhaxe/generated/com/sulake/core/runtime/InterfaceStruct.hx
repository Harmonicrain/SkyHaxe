package com.sulake.core.runtime
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

    /*internal*/ final class InterfaceStruct implements IDisposable 
    {
        var _iid:IID;
        var _iis:String;
        var _unknown:IUnknown;
        var _references:UInt = 0;

        public function new(iid:IID, unknown:IUnknown)
        {
            this._iid = iid;
            this._iis = getQualifiedClassName(this._iid);
            this._unknown = unknown;
            this._references = 0;
        }

        public var iid(get,never):IID;
public function  get_iid():IID
        {
            return this._iid;
        }

        public var iis(get,never):String;
public function  get_iis():String
        {
            return this._iis;
        }

        public var unknown(get,never):IUnknown;
public function  get_unknown():IUnknown
        {
            return this._unknown;
        }

        public var references(get,never):UInt;
public function  get_references():UInt
        {
            return this._references;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._unknown == null;
        }

        public function dispose()
        {
            this._iid = null;
            this._iis = null;
            this._unknown = null;
            this._references = 0;
        }

        public function reserve():UInt
        {
            return ++this._references;
        }

        public function release():UInt
        {
            return ASCompat.toUInt((this.references > 0) ? --this._references : 0);
        }
    }

