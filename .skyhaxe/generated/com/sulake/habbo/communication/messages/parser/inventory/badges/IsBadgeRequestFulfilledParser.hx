package com.sulake.habbo.communication.messages.parser.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IsBadgeRequestFulfilledParser implements IMessageParser
    {
        var _requestCode:String;
        var _fulfilled:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._requestCode = k.readString();
            this._fulfilled = k.readBoolean();
            return true;
        }

        public var requestCode(get,never):String;
public function  get_requestCode():String
        {
            return this._requestCode;
        }

        public var fulfilled(get,never):Bool;
public function  get_fulfilled():Bool
        {
            return this._fulfilled;
        }

	public function new() {}
    }

