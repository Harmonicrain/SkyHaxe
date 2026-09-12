package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredEnvironmentMessageParser;

     class WiredEnvironmentEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredEnvironmentMessageParser);
        }

        public function getParser():WiredEnvironmentMessageParser
        {
            return Std.downcast(this._parser , WiredEnvironmentMessageParser);
        }
    }

