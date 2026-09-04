package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatlineData
    {
        var _timeStamp:String;
        var _Str_20918:Int = 0;
        var _Str_22073:String;
        var _Str_5798:String;
        var _Str_21220:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._timeStamp = k.readString();
            this._Str_20918 = k.readInteger();
            this._Str_22073 = k.readString();
            this._Str_5798 = k.readString();
            this._Str_21220 = k.readBoolean();
        }

        public var timeStamp(get,never):String;
function  get_timeStamp():String
        {
            return this._timeStamp;
        }

        public var _Str_13143(get,never):Int;
function  get__Str_13143():Int
        {
            return this._Str_20918;
        }

        public var _Str_18796(get,never):String;
function  get__Str_18796():String
        {
            return this._Str_22073;
        }

        public var _Str_23429(get,never):String;
function  get__Str_23429():String
        {
            return this._Str_5798;
        }

        public var _Str_19967(get,never):Bool;
function  get__Str_19967():Bool
        {
            return this._Str_21220;
        }
    }

