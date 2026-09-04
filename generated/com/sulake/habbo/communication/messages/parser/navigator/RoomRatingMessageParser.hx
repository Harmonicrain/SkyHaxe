package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomRatingMessageParser implements IMessageParser
    {
        var _rating:Int = 0;
        var _Str_10405:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._rating = k.readInteger();
            this._Str_10405 = k.readBoolean();
            return true;
        }

        public var rating(get,never):Int;
function  get_rating():Int
        {
            return this._rating;
        }

        public var _Str_5090(get,never):Bool;
function  get__Str_5090():Bool
        {
            return this._Str_10405;
        }

	public function new() {}
    }

