package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredConditionDataMessageParser;

     class WiredConditionDataEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, WiredConditionDataMessageParser);
        }

        public function getParser():WiredConditionDataMessageParser
        {
            return Std.downcast(this._parser , WiredConditionDataMessageParser);
        }
    }

