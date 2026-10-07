package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.OpenMessageParser;

     class OpenEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OpenMessageParser);
        }

        public function getParser():OpenMessageParser
        {
            return Std.downcast(this._parser , OpenMessageParser);
        }
    }

