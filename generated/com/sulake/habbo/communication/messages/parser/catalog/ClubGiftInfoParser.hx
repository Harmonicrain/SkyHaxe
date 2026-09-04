package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftData;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubGiftInfoParser implements IMessageParser
    {
        var _Str_10647:Int = 0;
        var _Str_5369:Int = 0;
        var _offers:Array<ASAny>;
        var _Str_5759:Map;


        public function flush():Bool
        {
            if (this._Str_5759 != null)
            {
                this._Str_5759.dispose();
                this._Str_5759 = null;
            }
            this._offers = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:Int;
            var _local_4:ClubGiftData;
            this._Str_10647 = k.readInteger();
            this._Str_5369 = k.readInteger();
            this._offers = new Array<ASAny>();
            var _local_2= k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._offers.push(new CatalogPageMessageOfferData(k));
                _local_3++;
            }
            this._Str_5759 = new Map();
            _local_2 = k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new ClubGiftData(k);
                this._Str_5759.add(_local_4.offerId, _local_4);
                _local_3++;
            }
            return true;
        }

        public var _Str_12860(get,never):Int;
function  get__Str_12860():Int
        {
            return this._Str_10647;
        }

        public var _Str_7574(get,never):Int;
function  get__Str_7574():Int
        {
            return this._Str_5369;
        }

        public var offers(get,never):Array<ASAny>;
function  get_offers():Array<ASAny>
        {
            return this._offers;
        }

        public var _Str_24398(get,never):Map;
function  get__Str_24398():Map
        {
            return this._Str_5759;
        }

	public function new() {}
    }

