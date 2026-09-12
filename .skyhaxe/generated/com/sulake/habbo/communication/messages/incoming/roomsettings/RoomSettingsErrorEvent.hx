package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.RoomSettingsErrorMessageParser;

     class RoomSettingsErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomSettingsErrorMessageParser);
        }

        public function getParser():RoomSettingsErrorMessageParser
        {
            return Std.downcast(this._parser , RoomSettingsErrorMessageParser);
        }
    }

