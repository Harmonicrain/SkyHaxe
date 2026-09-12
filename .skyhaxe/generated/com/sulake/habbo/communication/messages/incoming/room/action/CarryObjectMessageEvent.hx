package com.sulake.habbo.communication.messages.incoming.room.action
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.action.CarryObjectMessageParser;

     class CarryObjectMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CarryObjectMessageParser);
        }

        public function getParser():CarryObjectMessageParser
        {
            return Std.downcast(_parser , CarryObjectMessageParser);
        }
    }

