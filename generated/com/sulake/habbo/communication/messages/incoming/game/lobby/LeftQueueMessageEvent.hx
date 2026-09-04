package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.LeftQueueMessageParser;

     class LeftQueueMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, LeftQueueMessageParser);
        }

        public function getParser():LeftQueueMessageParser
        {
            return Std.downcast(this._parser , LeftQueueMessageParser);
        }
    }

