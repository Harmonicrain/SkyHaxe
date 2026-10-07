package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.RoomSettingsSaveErrorMessageParser;

     class RoomSettingsSaveErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomSettingsSaveErrorMessageParser);
        }

        public function getParser():RoomSettingsSaveErrorMessageParser
        {
            return Std.downcast(this._parser , RoomSettingsSaveErrorMessageParser);
        }
    }

