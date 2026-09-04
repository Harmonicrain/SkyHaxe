package com.sulake.habbo.communication.messages.parser.room.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotCommandConfigurationParser implements IMessageParser 
    {
        var _botId:Int = 0;
        var _commandId:Int = 0;
        var _data:String;


        public var botId(get,never):Int;
function  get_botId():Int
        {
            return this._botId;
        }

        public var commandId(get,never):Int;
function  get_commandId():Int
        {
            return this._commandId;
        }

        public var data(get,never):String;
function  get_data():String
        {
            return this._data;
        }

        public function flush():Bool
        {
            this._botId = -1;
            this._commandId = -1;
            this._data = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._botId = k.readInteger();
            this._commandId = k.readInteger();
            this._data = k.readString();
            return true;
        }

	public function new() {}
    }

