package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.PopularRoomTagsResultMessageParser;

     class PopularRoomTagsResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PopularRoomTagsResultMessageParser);
        }

        public function getParser():PopularRoomTagsResultMessageParser
        {
            return Std.downcast(this._parser , PopularRoomTagsResultMessageParser);
        }
    }

