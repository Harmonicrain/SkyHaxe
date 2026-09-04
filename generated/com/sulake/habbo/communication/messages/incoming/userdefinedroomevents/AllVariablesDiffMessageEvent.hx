package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.AllVariablesDiffMessageParser;

     class AllVariablesDiffMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AllVariablesDiffMessageParser);
        }

        public function getParser():AllVariablesDiffMessageParser
        {
            return Std.downcast(this._parser , AllVariablesDiffMessageParser);
        }
    }

