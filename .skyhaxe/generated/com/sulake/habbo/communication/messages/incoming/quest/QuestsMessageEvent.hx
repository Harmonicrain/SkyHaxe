package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.QuestsParser;

     class QuestsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, QuestsParser);
        }

        public function getParser():QuestsParser
        {
            return Std.downcast(_parser , QuestsParser);
        }
    }

