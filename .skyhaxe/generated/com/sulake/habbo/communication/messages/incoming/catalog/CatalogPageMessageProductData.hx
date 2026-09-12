package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogPageMessageProductData
    {
        public static inline final PRODUCT_TYPE_ITEM= "i";
        public static inline final PRODUCT_TYPE_STUFF= "s";
        public static inline final PRODUCT_TYPE_EFFECT= "e";
        public static inline final PRODUCT_TYPE_BADGE= "b";

        var _productType:String;
        var _furniClassId:Int = 0;
        var _extraParam:String;
        var _productCount:Int = 0;
        var _uniqueLimitedItem:Bool = false;
        var _uniqueLimitedItemSeriesSize:Int = 0;
        var _uniqueLimitedItemsLeft:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._productType = k.readString();
            switch (this._productType)
            {
                case PRODUCT_TYPE_BADGE:
                    this._extraParam = k.readString();
                    this._productCount = 1;
                    return;
                default:
                    this._furniClassId = k.readInteger();
                    this._extraParam = k.readString();
                    this._productCount = k.readInteger();
                    this._uniqueLimitedItem = k.readBoolean();
                    if (this._uniqueLimitedItem)
                    {
                        this._uniqueLimitedItemSeriesSize = k.readInteger();
                        this._uniqueLimitedItemsLeft = k.readInteger();
                    }
            }
        }

        public var productType(get,never):String;
public function  get_productType():String
        {
            return this._productType;
        }

        public var furniClassId(get,never):Int;
public function  get_furniClassId():Int
        {
            return this._furniClassId;
        }

        public var extraParam(get,never):String;
public function  get_extraParam():String
        {
            return this._extraParam;
        }

        public var productCount(get,never):Int;
public function  get_productCount():Int
        {
            return this._productCount;
        }

        public var uniqueLimitedItem(get,never):Bool;
public function  get_uniqueLimitedItem():Bool
        {
            return this._uniqueLimitedItem;
        }

        public var uniqueLimitedItemSeriesSize(get,never):Int;
public function  get_uniqueLimitedItemSeriesSize():Int
        {
            return this._uniqueLimitedItemSeriesSize;
        }

        public var uniqueLimitedItemsLeft(get,never):Int;
public function  get_uniqueLimitedItemsLeft():Int
        {
            return this._uniqueLimitedItemsLeft;
        }
    }

