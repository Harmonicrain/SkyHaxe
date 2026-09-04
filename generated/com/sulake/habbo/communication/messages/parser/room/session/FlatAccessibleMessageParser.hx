package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatAccessibleMessageParser implements IMessageParser
    {
        var _userName:String = null;


        public var userName(get,never):String;
function  get_userName():String
        {
            return this._userName;
        }

        public function flush():Bool
        {
            this._userName = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userName = k.readString();
            return true;
        }

	public function new() {}
    }

