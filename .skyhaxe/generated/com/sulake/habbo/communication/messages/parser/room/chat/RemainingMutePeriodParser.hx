package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RemainingMutePeriodParser implements IMessageParser 
    {
        var _muteSecondsRemaining:Int = 0;


        public var secondsRemaining(get,never):Int;
public function  get_secondsRemaining():Int
        {
            return this._muteSecondsRemaining;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._muteSecondsRemaining = k.readInteger();
            return true;
        }

	public function new() {}
    }

