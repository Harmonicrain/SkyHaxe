package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.JoinedQueueMessageParser;

     class JoinedQueueMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, JoinedQueueMessageParser);
        }

        public function getParser():JoinedQueueMessageParser
        {
            return Std.downcast(this._parser , JoinedQueueMessageParser);
        }
    }

