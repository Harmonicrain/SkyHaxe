package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InClientLinkMessageParser implements IMessageParser
    {
        var _link:String;


        public var link(get,never):String;
public function  get_link():String
        {
            return this._link;
        }

        public function flush():Bool
        {
            this._link = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._link = k.readString();
            return true;
        }

	public function new() {}
    }

