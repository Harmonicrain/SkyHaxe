package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ConfigurationItemStatesMessageParser;

     class ConfigurationItemStatesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ConfigurationItemStatesMessageParser);
        }

        public function getParser():ConfigurationItemStatesMessageParser
        {
            return Std.downcast(_parser , ConfigurationItemStatesMessageParser);
        }
    }

