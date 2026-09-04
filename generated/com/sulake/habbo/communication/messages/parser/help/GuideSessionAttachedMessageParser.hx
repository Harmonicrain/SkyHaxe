package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionAttachedMessageParser implements IMessageParser
    {
        var _Str_19490:Bool = false;
        var _Str_21721:Int = 0;
        var _Str_21548:String;
        var _Str_21391:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19490 = k.readBoolean();
            this._Str_21721 = k.readInteger();
            this._Str_21548 = k.readString();
            this._Str_21391 = k.readInteger();
            return true;
        }

        public var _Str_23343(get,never):Bool;
function  get__Str_23343():Bool
        {
            return this._Str_19490;
        }

        public var _Str_20566(get,never):Int;
function  get__Str_20566():Int
        {
            return this._Str_21721;
        }

        public var _Str_19914(get,never):String;
function  get__Str_19914():String
        {
            return this._Str_21548;
        }

        public var _Str_19737(get,never):Int;
function  get__Str_19737():Int
        {
            return this._Str_21391;
        }

	public function new() {}
    }

