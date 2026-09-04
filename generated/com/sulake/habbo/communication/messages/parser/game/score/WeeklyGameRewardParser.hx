package com.sulake.habbo.communication.messages.parser.game.score
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WeeklyGameRewardParser implements IMessageParser
    {
        var _gameTypeId:Int = 0;
        var _products:Array<ASAny>;
        var _Str_17600:Int = 0;
        var _Str_16182:Bool = false;

        public function new()
        {
            this._products = [];
        }

        public var gameTypeId(get,never):Int;
function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var products(get,never):Array<ASAny>;
function  get_products():Array<ASAny>
        {
            return this._products;
        }

        public var _Str_25946(get,never):Int;
function  get__Str_25946():Int
        {
            return this._Str_17600;
        }

        public var _Str_26137(get,never):Bool;
function  get__Str_26137():Bool
        {
            return this._Str_16182;
        }

        public function flush():Bool
        {
            this._gameTypeId = -1;
            this._products = [];
            this._Str_17600 = 0;
            this._Str_16182 = true;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._products.push(new CatalogPageMessageProductData(k));
                _local_3++;
            }
            this._Str_17600 = k.readInteger();
            this._Str_16182 = k.readBoolean();
            return true;
        }
    }

