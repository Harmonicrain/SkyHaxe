package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.RoomThumbnailUpdateResultMessageParser;

     class RoomThumbnailUpdateResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomThumbnailUpdateResultMessageParser);
        }

        public function getParser():RoomThumbnailUpdateResultMessageParser
        {
            return Std.downcast(this._parser , RoomThumbnailUpdateResultMessageParser);
        }
    }

