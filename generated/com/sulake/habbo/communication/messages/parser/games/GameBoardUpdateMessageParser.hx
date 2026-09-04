package com.sulake.habbo.communication.messages.parser.games
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GameBoardUpdateMessageParser implements IMessageParser
    {
        var _stationId:Int = 0;
        var _verb:String = "";
        var _args:Array<ASAny> = null;

        public var stationId(get,never):Int;
function  get_stationId():Int
        {
            return this._stationId;
        }

        public var verb(get,never):String;
function  get_verb():String
        {
            return this._verb;
        }

        public var args(get,never):Array<ASAny>;
function  get_args():Array<ASAny>
        {
            return this._args;
        }

        public function flush():Bool
        {
            this._stationId = 0;
            this._verb = "";
            this._args = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._verb = k.readString();
            this._args = [];
            var argCount= k.readInteger();
            for (i in 0...argCount)
            {
                this._args.push(k.readString());
            }
            return true;
        }

	public function new() {}
    }

