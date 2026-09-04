package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.AllVariablesHashMessageParser;

     class AllVariablesHashMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AllVariablesHashMessageParser);
        }

        public function getParser():AllVariablesHashMessageParser
        {
            return Std.downcast(this._parser , AllVariablesHashMessageParser);
        }
    }

