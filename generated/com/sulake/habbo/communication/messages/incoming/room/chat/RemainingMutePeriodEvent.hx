package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.RemainingMutePeriodParser;

     class RemainingMutePeriodEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RemainingMutePeriodParser);
        }

        public var secondsRemaining(get,never):Int;
function  get_secondsRemaining():Int
        {
            return cast(_parser, RemainingMutePeriodParser).secondsRemaining;
        }
    }

