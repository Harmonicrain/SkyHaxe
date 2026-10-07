package com.sulake.habbo.catalog.purchase
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.IPurchasableOffer;

     class PlacedObjectPurchaseData implements IDisposable 
    {
        var _isDisposed:Bool = false;
        var _objectId:Int = 0;
        var _category:Int = 0;
        var _roomId:Int = 0;
        var _wallLocation:String = "";
        var _x:Int = 0;
        var _y:Int = 0;
        var _direction:Int = 0;
        var _offerId:Int = 0;
        var _productClassId:Int = 0;
        var _productData:IProductData;
        var _furniData:IFurnitureData;
        var _extraParameter:String;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:IPurchasableOffer)
        {
            this._roomId = k;
            this._objectId = _arg_2;
            this._category = _arg_3;
            this._wallLocation = _arg_4;
            this._x = _arg_5;
            this._y = _arg_6;
            this._direction = _arg_7;
            this._Str_25851(_arg_8);
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._productData = null;
            this._furniData = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        function _Str_25851(k:IPurchasableOffer)
        {
            this._offerId = k.offerId;
            this._productClassId = k.product.productClassId;
            this._productData = k.product.productData;
            this._furniData = k.product.furnitureData;
            this._extraParameter = k.product.extraParam;
        }

        public function toString():String
        {
            return ([this._roomId, this._objectId, this._category, this._wallLocation, this._x, this._y, this._direction, this._offerId, this._productClassId] : Array<Dynamic>).toString();
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var _Str_7031(get,never):String;
public function  get__Str_7031():String
        {
            return this._wallLocation;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._y;
        }

        public var direction(get,never):Int;
public function  get_direction():Int
        {
            return this._direction;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var productClassId(get,never):Int;
public function  get_productClassId():Int
        {
            return this._productClassId;
        }

        public var extraParameter(get,never):String;
public function  get_extraParameter():String
        {
            return this._extraParameter;
        }

        public var furniData(get,never):IFurnitureData;
public function  get_furniData():IFurnitureData
        {
            return this._furniData;
        }
    }

