package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FrontPageItem
    {
        public static inline final ITEM_CATALOGUE_PAGE= 0;
        public static inline final ITEM_PRODUCT_OFFER= 1;
        public static inline final ITEM_IAP= 2;

        var _type:Int = 0;
        var _position:Int = 0;
        var _itemName:String;
        var _itemPromoImage:String;
        var _cataloguePageLocation:String;
        var _productCode:String;
        var _productOfferID:Int = 0;
        var _expirationTime:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            if (k == null)
            {
                return;
            }
            this._position = k.readInteger();
            this._itemName = k.readString();
            this._itemPromoImage = k.readString();
            this._type = k.readInteger();
            switch (this._type)
            {
                case ITEM_CATALOGUE_PAGE:
                    this._cataloguePageLocation = k.readString();
                    
                case ITEM_IAP:
                    this._productCode = k.readString();
                    
                case ITEM_PRODUCT_OFFER:
                    this._productOfferID = k.readInteger();
                    
            }
            var _local_2= k.readInteger();
            this._expirationTime = ((_local_2 > 0) ? ((_local_2 * 1000) + flash.Lib.getTimer()) : 0);
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }

        public var itemName(get,never):String;
public function  get_itemName():String
        {
            return this._itemName;
        }

        public var itemPromoImage(get,never):String;
public function  get_itemPromoImage():String
        {
            return this._itemPromoImage;
        }

        public var cataloguePageLocation(get,never):String;
public function  get_cataloguePageLocation():String
        {
            return this._cataloguePageLocation;
        }

        public var offerExpires(get,never):Bool;
public function  get_offerExpires():Bool
        {
            return this._expirationTime > 0;
        }

        public var secondsToExpiration(get,never):Int;
public function  get_secondsToExpiration():Int
        {
            return this._expirationTime - flash.Lib.getTimer();
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var productOfferID(get,never):Int;
public function  get_productOfferID():Int
        {
            return this._productOfferID;
        }
    }

