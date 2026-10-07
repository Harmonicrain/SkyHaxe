package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredValidationErrorParser;

     class WiredValidationErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredValidationErrorParser);
        }

        public function getParser():WiredValidationErrorParser
        {
            return Std.downcast(this._parser , WiredValidationErrorParser);
        }
    }

