package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.MuteAllInRoomParser;

     class MuteAllInRoomEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MuteAllInRoomParser);
        }

        public function getParser():MuteAllInRoomParser
        {
            return Std.downcast(this._parser , MuteAllInRoomParser);
        }
    }

