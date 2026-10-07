package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredSavedMessageParser;

     class WiredSavedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, WiredSavedMessageParser);
        }

        public function getParser():WiredSavedMessageParser
        {
            return Std.downcast(this._parser , WiredSavedMessageParser);
        }
    }

