package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UnloadGameMessageParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _gameClientId:String;


        public var gameTypeId(get,never):Int;
function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var _Str_12486(get,never):String;
function  get__Str_12486():String
        {
            return this._gameClientId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._gameClientId = k.readString();
            return true;
        }

	public function new() {}
    }

