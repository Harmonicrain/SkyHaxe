package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FavouriteChangedMessageParser implements IMessageParser
    {
        var _flatId:Int = 0;
        var _Str_20029:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._flatId = k.readInteger();
            this._Str_20029 = k.readBoolean();
            return true;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var _Str_13819(get,never):Bool;
public function  get__Str_13819():Bool
        {
            return this._Str_20029;
        }

	public function new() {}
    }

