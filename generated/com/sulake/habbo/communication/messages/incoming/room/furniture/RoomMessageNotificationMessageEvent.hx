package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RoomMessageNotificationMessageParser;

     class RoomMessageNotificationMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomMessageNotificationMessageParser);
        }

        public function getParser():RoomMessageNotificationMessageParser
        {
            return Std.downcast(_parser , RoomMessageNotificationMessageParser);
        }
    }

