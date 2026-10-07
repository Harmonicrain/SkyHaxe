package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.UserSongDisksInventoryMessageParser;

     class UserSongDisksInventoryMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserSongDisksInventoryMessageParser);
        }

        public function getParser():UserSongDisksInventoryMessageParser
        {
            return Std.downcast(this._parser , UserSongDisksInventoryMessageParser);
        }
    }

