package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2InArenaQueueMessageParser implements IMessageParser
    {
        var _position:Int = 0;


        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._position = k.readInteger();
            return true;
        }

	public function new() {}
    }

