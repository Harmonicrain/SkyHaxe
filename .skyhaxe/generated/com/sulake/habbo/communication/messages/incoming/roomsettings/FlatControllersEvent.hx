package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.FlatControllersMessageParser;

     class FlatControllersEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FlatControllersMessageParser);
        }

        public function getParser():FlatControllersMessageParser
        {
            return Std.downcast(this._parser , FlatControllersMessageParser);
        }
    }

