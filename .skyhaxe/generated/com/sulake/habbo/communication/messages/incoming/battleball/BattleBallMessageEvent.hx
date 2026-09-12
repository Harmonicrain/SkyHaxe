package com.sulake.habbo.communication.messages.incoming.battleball
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.battleball.BattleBallMessageParser;

     class BattleBallMessageEvent extends MessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, BattleBallMessageParser);
        }

        public function getParser():BattleBallMessageParser
        {
            return Std.downcast(this._parser , BattleBallMessageParser);
        }
    }

