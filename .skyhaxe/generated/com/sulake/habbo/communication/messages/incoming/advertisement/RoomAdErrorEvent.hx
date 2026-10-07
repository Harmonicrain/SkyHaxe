package com.sulake.habbo.communication.messages.incoming.advertisement
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.advertisement.RoomAdErrorMessageParser;

     class RoomAdErrorEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RoomAdErrorMessageParser);
        }

        public function getParser():RoomAdErrorMessageParser
        {
            return Std.downcast(this._parser , RoomAdErrorMessageParser);
        }
    }

