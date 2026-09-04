package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredTriggerDataMessageParser;

     class WiredTriggerDataEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, WiredTriggerDataMessageParser);
        }

        public function getParser():WiredTriggerDataMessageParser
        {
            return Std.downcast(this._parser , WiredTriggerDataMessageParser);
        }
    }

