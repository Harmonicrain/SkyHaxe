package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredVariableDataMessageParser;

     class WiredVariableDataEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredVariableDataMessageParser);
        }

        public function getParser():WiredVariableDataMessageParser
        {
            return Std.downcast(this._parser , WiredVariableDataMessageParser);
        }
    }

