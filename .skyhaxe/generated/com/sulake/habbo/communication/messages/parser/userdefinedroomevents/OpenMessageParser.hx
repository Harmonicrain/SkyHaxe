package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OpenMessageParser implements IMessageParser
    {
        var _stuffId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffId = k.readInteger();
            return true;
        }

        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

	public function new() {}
    }

