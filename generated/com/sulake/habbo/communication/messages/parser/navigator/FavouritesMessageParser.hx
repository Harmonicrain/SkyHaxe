package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FavouritesMessageParser implements IMessageParser
    {
        var _limit:Int = 0;
        var _Str_18010:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_18010 = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._limit = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_18010.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

        public var limit(get,never):Int;
function  get_limit():Int
        {
            return this._limit;
        }

        public var _Str_13809(get,never):Array<ASAny>;
function  get__Str_13809():Array<ASAny>
        {
            return this._Str_18010;
        }

	public function new() {}
    }

