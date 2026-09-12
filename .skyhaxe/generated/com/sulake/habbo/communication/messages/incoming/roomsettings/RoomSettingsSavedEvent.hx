package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.RoomSettingsSavedMessageParser;

     class RoomSettingsSavedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomSettingsSavedMessageParser);
        }

        public function getParser():RoomSettingsSavedMessageParser
        {
            return Std.downcast(this._parser , RoomSettingsSavedMessageParser);
        }
    }

