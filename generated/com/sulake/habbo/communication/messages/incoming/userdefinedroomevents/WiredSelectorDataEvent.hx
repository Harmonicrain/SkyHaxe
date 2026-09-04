package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredSelectorDataMessageParser;

     class WiredSelectorDataEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredSelectorDataMessageParser);
        }

        public function getParser():WiredSelectorDataMessageParser
        {
            return Std.downcast(this._parser , WiredSelectorDataMessageParser);
        }
    }

