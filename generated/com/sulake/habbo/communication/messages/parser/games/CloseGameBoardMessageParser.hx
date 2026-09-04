package com.sulake.habbo.communication.messages.parser.games
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CloseGameBoardMessageParser implements IMessageParser
    {
        var _stationId:Int = 0;
        var _reason:String = "";

        public var stationId(get,never):Int;
function  get_stationId():Int
        {
            return this._stationId;
        }

        public var reason(get,never):String;
function  get_reason():String
        {
            return this._reason;
        }

        public function flush():Bool
        {
            this._stationId = 0;
            this._reason = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._reason = k.readString();
            return true;
        }

	public function new() {}
    }

