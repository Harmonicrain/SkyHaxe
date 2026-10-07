package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubGiftNotificationParser implements IMessageParser
    {
        var _numGifts:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._numGifts = k.readInteger();
            return true;
        }

        public var numGifts(get,never):Int;
public function  get_numGifts():Int
        {
            return this._numGifts;
        }

	public function new() {}
    }

