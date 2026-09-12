package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredCapabilitiesMessageParser;

     class WiredCapabilitiesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredCapabilitiesMessageParser);
        }

        public function getParser():WiredCapabilitiesMessageParser
        {
            return Std.downcast(this._parser , WiredCapabilitiesMessageParser);
        }
    }

