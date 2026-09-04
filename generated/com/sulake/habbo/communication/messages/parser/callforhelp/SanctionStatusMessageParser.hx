package com.sulake.habbo.communication.messages.parser.callforhelp
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SanctionStatusMessageParser implements IMessageParser
    {
        var _Str_21269:Bool = false;
        var _Str_20966:Bool = false;
        var _Str_19378:String;
        var _Str_19998:Int = 0;
        var _Str_21197:String;
        var _Str_20631:String;
        var _Str_19322:Int = 0;
        var _Str_22000:String;
        var _Str_19157:Int = 0;
        var _Str_21458:Bool = false;
        var _Str_22154:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_21269 = k.readBoolean();
            this._Str_20966 = k.readBoolean();
            this._Str_19378 = k.readString();
            this._Str_19998 = k.readInteger();
            k.readInteger();
            this._Str_21197 = k.readString();
            this._Str_20631 = k.readString();
            this._Str_19322 = k.readInteger();
            this._Str_22000 = k.readString();
            this._Str_19157 = k.readInteger();
            k.readInteger();
            this._Str_21458 = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._Str_22154 = k.readString();
            }
            return true;
        }

        public var _Str_22957(get,never):Bool;
function  get__Str_22957():Bool
        {
            return this._Str_21269;
        }

        public var _Str_16442(get,never):Bool;
function  get__Str_16442():Bool
        {
            return this._Str_20966;
        }

        public var _Str_22691(get,never):String;
function  get__Str_22691():String
        {
            return this._Str_19378;
        }

        public var _Str_22497(get,never):Int;
function  get__Str_22497():Int
        {
            return this._Str_19998;
        }

        public var _Str_22005(get,never):String;
function  get__Str_22005():String
        {
            return this._Str_21197;
        }

        public var _Str_25720(get,never):String;
function  get__Str_25720():String
        {
            return this._Str_20631;
        }

        public var _Str_20904(get,never):Int;
function  get__Str_20904():Int
        {
            return this._Str_19322;
        }

        public var _Str_23024(get,never):String;
function  get__Str_23024():String
        {
            return this._Str_22000;
        }

        public var _Str_23610(get,never):Int;
function  get__Str_23610():Int
        {
            return this._Str_19157;
        }

        public var _Str_23177(get,never):Bool;
function  get__Str_23177():Bool
        {
            return this._Str_21458;
        }

        public var _Str_21248(get,never):String;
function  get__Str_21248():String
        {
            return this._Str_22154;
        }

	public function new() {}
    }

