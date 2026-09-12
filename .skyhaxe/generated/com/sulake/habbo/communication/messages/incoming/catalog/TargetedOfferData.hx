package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TargetedOfferData 
    {
        var _id:Int = 0;
        var _identifier:String;
        var _type:Int = 0;
        var _title:String;
        var _Str_1858:String;
        var _Str_2991:String;
        var _Str_18782:String;
        var _productCode:String;
        var _Str_9772:Int = 0;
        var _expirationTime:UInt = 0;
        var _Str_3594:Int = 0;
        var _Str_3539:Int = 0;
        var _Str_2956:Int = 0;
        var _Str_11962:Vector<String>;
        var _Str_9163:Int = 0;

        public function new(k:TargetedOfferData=null)
        {
            if (k != null)
            {
                this._id = k.id;
                this._identifier = k.identifier;
                this._type = k.type;
                this._title = k.title;
                this._Str_1858 = k.description;
                this._Str_2991 = k.imageUrl;
                this._Str_18782 = k._Str_13452;
                this._productCode = k.productCode;
                this._Str_9772 = k.purchaseLimit;
                this._expirationTime = k.expirationTime;
                this._Str_3594 = k.priceInCredits;
                this._Str_3539 = k.priceInActivityPoints;
                this._Str_2956 = k.activityPointType;
                this._Str_11962 = k._Str_24978;
                this._Str_9163 = k._Str_11180;
            }
        }

        public function parse(k:IMessageDataWrapper):TargetedOfferData
        {
            this._Str_9163 = k.readInteger();
            this._id = k.readInteger();
            this._identifier = k.readString();
            this._productCode = k.readString();
            this._Str_3594 = k.readInteger();
            this._Str_3539 = k.readInteger();
            this._Str_2956 = k.readInteger();
            this._Str_9772 = k.readInteger();
            var _local_2= k.readInteger();
            this._expirationTime = ((_local_2 > 0) ? ((_local_2 * 1000) + flash.Lib.getTimer()) : 0);
            this._title = k.readString();
            this._Str_1858 = k.readString();
            this._Str_2991 = k.readString();
            this._Str_18782 = k.readString();
            this._type = k.readInteger();
            this._Str_11962 = new Vector<String>(0);
            var _local_3= k.readInteger();
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                this._Str_11962.push(k.readString());
                _local_4++;
            }
            return this;
        }

        public function _Str_24338(k:Int)
        {
            this._Str_9772 = (this._Str_9772 - k);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return this._identifier;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var title(get,never):String;
public function  get_title():String
        {
            return this._title;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._Str_1858;
        }

        public var imageUrl(get,never):String;
public function  get_imageUrl():String
        {
            return this._Str_2991;
        }

        public var _Str_13452(get,never):String;
public function  get__Str_13452():String
        {
            return this._Str_18782;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var purchaseLimit(get,never):Int;
public function  get_purchaseLimit():Int
        {
            return this._Str_9772;
        }

        public var expirationTime(get,never):Int;
public function  get_expirationTime():Int
        {
            return ASCompat.toInt(this._expirationTime);
        }

        public var priceInCredits(get,never):Int;
public function  get_priceInCredits():Int
        {
            return this._Str_3594;
        }

        public var priceInActivityPoints(get,never):Int;
public function  get_priceInActivityPoints():Int
        {
            return this._Str_3539;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return this._Str_2956;
        }

        public var _Str_24978(get,never):Vector<String>;
public function  get__Str_24978():Vector<String>
        {
            return this._Str_11962;
        }

        public var _Str_11180(get,never):Int;
public function  get__Str_11180():Int
        {
            return this._Str_9163;
        }
    }

