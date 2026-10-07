package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class DoorbellMessageParser implements IMessageParser
    {
        var _userName:String;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userName = k.readString();
            return true;
        }

        public function flush():Bool
        {
            this._userName = null;
            return true;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

	public function new() {}
    }

