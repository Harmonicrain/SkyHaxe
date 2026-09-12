package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredClickUserResponseMessageParser;

     class WiredClickUserResponseEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredClickUserResponseMessageParser);
        }

        public function getParser():WiredClickUserResponseMessageParser
        {
            return Std.downcast(this._parser , WiredClickUserResponseMessageParser);
        }
    }

