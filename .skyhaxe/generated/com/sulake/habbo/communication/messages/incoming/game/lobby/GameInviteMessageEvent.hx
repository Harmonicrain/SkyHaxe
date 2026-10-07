package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameInviteMessageParser;

     class GameInviteMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GameInviteMessageParser);
        }

        public function getParser():GameInviteMessageParser
        {
            return Std.downcast(this._parser , GameInviteMessageParser);
        }
    }

