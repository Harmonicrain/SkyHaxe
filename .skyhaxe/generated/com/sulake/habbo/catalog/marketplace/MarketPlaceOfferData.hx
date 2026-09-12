package com.sulake.habbo.catalog.marketplace
;
    import com.sulake.habbo.room.IStuffData;
    import flash.display.BitmapData;

     class MarketPlaceOfferData implements IMarketPlaceOfferData 
    {
        public static inline final TYPE_FLOOR= 1;
        public static inline final TYPE_WALL= 2;

        var _offerId:Int = 0;
        var _furniId:Int = 0;
        var _furniType:Int = 0;
        var _extraData:String;
        var _stuffData:IStuffData;
        var _price:Int = 0;
        var _averagePrice:Int = 0;
        var _imageCallback:Int = 0;
        var _status:Int = 0;
        var _timeLeftMinutes:Int = -1;
        var _offerCount:Int = 0;
        var _image:BitmapData;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:IStuffData, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Int=-1)
        {
            this._offerId = k;
            this._furniId = _arg_2;
            this._furniType = _arg_3;
            this._extraData = _arg_4;
            this._stuffData = _arg_5;
            this._price = _arg_6;
            this._status = _arg_7;
            this._averagePrice = _arg_8;
            this._offerCount = _arg_9;
        }

        public function dispose()
        {
            if (this._image != null)
            {
                this._image.dispose();
                this._image = null;
            }
            if (this._stuffData != null)
            {
                this._stuffData = null;
            }
        }

        
        public var offerId(get,set):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var furniType(get,never):Int;
public function  get_furniType():Int
        {
            return this._furniType;
        }

        public var extraData(get,never):String;
public function  get_extraData():String
        {
            return this._extraData;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        
        public var price(get,set):Int;
public function  get_price():Int
        {
            return this._price;
        }

        public var averagePrice(get,never):Int;
public function  get_averagePrice():Int
        {
            return this._averagePrice;
        }

        
        public var image(get,set):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }
public function  set_image(k:BitmapData):BitmapData        {
            if (this._image != null)
            {
                this._image.dispose();
            }
            return this._image = k;
        }

        
        public var imageCallback(get,set):Int;
public function  set_imageCallback(k:Int):Int        {
            return this._imageCallback = k;
        }
public function  get_imageCallback():Int
        {
            return this._imageCallback;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        
        public var timeLeftMinutes(get,set):Int;
public function  get_timeLeftMinutes():Int
        {
            return this._timeLeftMinutes;
        }
public function  set_timeLeftMinutes(k:Int):Int        {
            return this._timeLeftMinutes = k;
        }
public function  set_price(k:Int):Int        {
            return this._price = k;
        }
public function  set_offerId(k:Int):Int        {
            return this._offerId = k;
        }

        
        public var offerCount(get,set):Int;
public function  get_offerCount():Int
        {
            return this._offerCount;
        }
public function  set_offerCount(k:Int):Int        {
            return this._offerCount = k;
        }

        public var isUniqueLimitedItem(get,never):Bool;
public function  get_isUniqueLimitedItem():Bool
        {
            return (!(this.stuffData == null)) && (this.stuffData.uniqueSerialNumber > 0);
        }
    }

