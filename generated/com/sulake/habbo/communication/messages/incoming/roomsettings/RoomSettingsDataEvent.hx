package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.RoomSettingsDataMessageParser;

     class RoomSettingsDataEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomSettingsDataMessageParser);
        }

        public function getParser():RoomSettingsDataMessageParser
        {
            return Std.downcast(this._parser , RoomSettingsDataMessageParser);
        }
    }

