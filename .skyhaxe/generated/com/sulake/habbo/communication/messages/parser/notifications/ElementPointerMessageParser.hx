package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ElementPointerMessageParser implements IMessageParser
    {
        var _key:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._key = k.readString();
            return true;
        }

        public var key(get,never):String;
public function  get_key():String
        {
            return this._key;
        }

	public function new() {}
    }

