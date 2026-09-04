package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LoadGameUrlMessageParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _url:String;
        var _gameClientId:String;


        public var gameTypeId(get,never):Int;
function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var url(get,never):String;
function  get_url():String
        {
            return this._url;
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
            this._url = k.readString();
            return true;
        }

	public function new() {}
    }

