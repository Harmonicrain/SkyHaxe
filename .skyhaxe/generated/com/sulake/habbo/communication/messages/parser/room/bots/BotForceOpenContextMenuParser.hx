package com.sulake.habbo.communication.messages.parser.room.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotForceOpenContextMenuParser implements IMessageParser 
    {
        var _botId:Int = 0;


        public function flush():Bool
        {
            this._botId = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._botId = k.readInteger();
            return true;
        }

        public var botId(get,never):Int;
public function  get_botId():Int
        {
            return this._botId;
        }

	public function new() {}
    }

