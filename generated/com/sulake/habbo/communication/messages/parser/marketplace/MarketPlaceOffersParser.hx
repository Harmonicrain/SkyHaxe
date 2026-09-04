package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketPlaceOffer;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.habbo.room.object.data.StuffDataFactory;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketPlaceOffersParser implements IMessageParser
    {
        public static inline final FURNITYPE_STUFF= 1;
        public static inline final FURNITYPE_WALL= 2;
        public static inline final FAKE_FURNITYPE_UNIQUE= 3;

        static inline final MAX_LIST_LENGTH= 500;

        var _offers:Array<ASAny>;
        var _totalItemsFound:Int = 0;


        public function flush():Bool
        {
            this._offers = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2:Int;
            var _local_3:Int;
            var _local_4:Int;
            var _local_5 = 0;
            var _local_8:Int;
            var _local_9:Int;
            var _local_10:Int;
            var _local_11:Int;
            var _local_14:MarketPlaceOffer;
            this._offers = new Array<ASAny>();
            var _local_6= "";
            var _local_7:IStuffData;
            var _local_12= k.readInteger();
            var _local_13 = 0;
            while (_local_13 < _local_12)
            {
                _local_7 = null;
                _local_2 = k.readInteger();
                _local_3 = k.readInteger();
                _local_4 = k.readInteger();
                if (_local_4 == FURNITYPE_STUFF)
                {
                    _local_5 = k.readInteger();
                    _local_7 = ObjectDataParser.parseStuffData(k);
                }
                else
                {
                    if (_local_4 == FURNITYPE_WALL)
                    {
                        _local_5 = k.readInteger();
                        _local_6 = k.readString();
                    }
                    else
                    {
                        if (_local_4 == FAKE_FURNITYPE_UNIQUE)
                        {
                            _local_5 = k.readInteger();
                            _local_7 = StuffDataFactory.getStuffDataWrapperForType(LegacyStuffData.FORMAT_KEY);
                            _local_7.uniqueSerialNumber = k.readInteger();
                            _local_7.uniqueSeriesSize = k.readInteger();
                            _local_4 = FURNITYPE_STUFF;
                        }
                    }
                }
                _local_8 = k.readInteger();
                _local_9 = k.readInteger();
                _local_10 = k.readInteger();
                _local_11 = k.readInteger();
                _local_14 = new MarketPlaceOffer(_local_2, _local_5, _local_4, _local_6, _local_7, _local_8, _local_3, _local_9, _local_10, _local_11);
                if (_local_13 < MarketPlaceOffersParser.MAX_LIST_LENGTH)
                {
                    this._offers.push(_local_14);
                }
                _local_13++;
            }
            this._totalItemsFound = k.readInteger();
            return true;
        }

        public var offers(get,never):Array<ASAny>;
function  get_offers():Array<ASAny>
        {
            return this._offers;
        }

        public var totalItemsFound(get,never):Int;
function  get_totalItemsFound():Int
        {
            return this._totalItemsFound;
        }

	public function new() {}
    }

