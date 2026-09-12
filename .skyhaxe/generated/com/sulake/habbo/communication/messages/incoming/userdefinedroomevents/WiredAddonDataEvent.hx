package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredAddonDataMessageParser;

     class WiredAddonDataEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredAddonDataMessageParser);
        }

        public function getParser():WiredAddonDataMessageParser
        {
            return Std.downcast(this._parser , WiredAddonDataMessageParser);
        }
    }

