package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2UserLeftGameMessageParser implements IMessageParser
    {
        var _userId:Int = 0;


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            return true;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

