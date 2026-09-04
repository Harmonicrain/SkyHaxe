package com.sulake.habbo.communication.messages.parser.competition
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IsUserPartOfCompetitionMessageParser implements IMessageParser
    {
        var _Str_8579:Bool = false;
        var _Str_6987:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8579 = k.readBoolean();
            this._Str_6987 = k.readInteger();
            return true;
        }

        public var _Str_25348(get,never):Bool;
function  get__Str_25348():Bool
        {
            return this._Str_8579;
        }

        public var _Str_10760(get,never):Int;
function  get__Str_10760():Int
        {
            return this._Str_6987;
        }

	public function new() {}
    }

