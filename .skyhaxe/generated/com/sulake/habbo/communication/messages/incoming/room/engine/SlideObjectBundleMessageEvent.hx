package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.SlideObjectBundleMessageParser;

     class SlideObjectBundleMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, SlideObjectBundleMessageParser);
        }

        public function getParser():SlideObjectBundleMessageParser
        {
            return Std.downcast(_parser , SlideObjectBundleMessageParser);
        }
    }

