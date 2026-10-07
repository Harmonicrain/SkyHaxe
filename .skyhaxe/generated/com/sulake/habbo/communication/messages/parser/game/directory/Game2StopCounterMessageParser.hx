package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2StopCounterMessageParser implements IMessageParser
    {


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            return false;
        }

	public function new() {}
    }

