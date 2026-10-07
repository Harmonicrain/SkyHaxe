package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketPlaceOffer;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.habbo.room.object.data.StuffDataFactory;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketPlaceOwnOffersParser implements IMessageParser
    {
        static inline final MAX_LIST_LENGTH= 500;

        var _offers:Array<ASAny>;
        var _creditsWaiting:Int = 0;


        public function flush():Bool
        {
            this._offers = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_7:IStuffData = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_13:MarketPlaceOffer = null;
            this._offers = new Array<ASAny>();
            var _local_6= "";
            this._creditsWaiting = k.readInteger();
            var _local_11= k.readInteger();
            var _local_12 = 0;
            while (_local_12 < _local_11)
            {
                _local_2 = k.readInteger();
                _local_3 = k.readInteger();
                _local_4 = k.readInteger();
                if (_local_4 == MarketPlaceOffersParser.FURNITYPE_STUFF)
                {
                    _local_5 = k.readInteger();
                    _local_7 = ObjectDataParser.parseStuffData(k);
                }
                else
                {
                    if (_local_4 == MarketPlaceOffersParser.FURNITYPE_WALL)
                    {
                        _local_5 = k.readInteger();
                        _local_6 = k.readString();
                    }
                    else
                    {
                        if (_local_4 == MarketPlaceOffersParser.FAKE_FURNITYPE_UNIQUE)
                        {
                            _local_5 = k.readInteger();
                            _local_7 = StuffDataFactory.getStuffDataWrapperForType(LegacyStuffData.FORMAT_KEY);
                            _local_7.uniqueSerialNumber = k.readInteger();
                            _local_7.uniqueSeriesSize = k.readInteger();
                            _local_4 = MarketPlaceOffersParser.FURNITYPE_STUFF;
                        }
                    }
                }
                _local_8 = k.readInteger();
                _local_9 = k.readInteger();
                _local_10 = k.readInteger();
                _local_13 = new MarketPlaceOffer(_local_2, _local_5, _local_4, _local_6, _local_7, _local_8, _local_3, _local_9, _local_10);
                if (_local_12 < MarketPlaceOwnOffersParser.MAX_LIST_LENGTH)
                {
                    this._offers.push(_local_13);
                }
                _local_12++;
            }
            return true;
        }

        public var offers(get,never):Array<ASAny>;
public function  get_offers():Array<ASAny>
        {
            return this._offers;
        }

        public var creditsWaiting(get,never):Int;
public function  get_creditsWaiting():Int
        {
            return this._creditsWaiting;
        }

	public function new() {}
    }

