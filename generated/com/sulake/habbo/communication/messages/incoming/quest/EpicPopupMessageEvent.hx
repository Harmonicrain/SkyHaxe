package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.EpicPopupParser;

     class EpicPopupMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, EpicPopupParser);
        }

        public function getParser():EpicPopupParser
        {
            return Std.downcast(_parser , EpicPopupParser);
        }
    }

