package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.FlatControllerRemovedMessageParser;

     class FlatControllerRemovedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FlatControllerRemovedMessageParser);
        }

        public function getParser():FlatControllerRemovedMessageParser
        {
            return Std.downcast(this._parser , FlatControllerRemovedMessageParser);
        }
    }

