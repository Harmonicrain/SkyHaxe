package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.JoiningQueueFailedMessageParser;

     class JoiningQueueFailedMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, JoiningQueueFailedMessageParser);
        }

        public function getParser():JoiningQueueFailedMessageParser
        {
            return Std.downcast(this._parser , JoiningQueueFailedMessageParser);
        }
    }

