package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatAccessDeniedMessageParser implements IMessageParser
    {
        var _userName:String = null;


        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 0)
            {
                this._userName = k.readString();
            }
            return true;
        }

        public function flush():Bool
        {
            this._userName = null;
            return true;
        }

	public function new() {}
    }

