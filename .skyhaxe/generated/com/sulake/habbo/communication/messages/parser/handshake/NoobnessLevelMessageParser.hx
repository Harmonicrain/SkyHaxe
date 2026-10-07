package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NoobnessLevelMessageParser implements IMessageParser 
    {
        var _noobnessLevel:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._noobnessLevel = k.readInteger();
            return true;
        }

        public var noobnessLevel(get,never):Int;
public function  get_noobnessLevel():Int
        {
            return this._noobnessLevel;
        }

	public function new() {}
    }

