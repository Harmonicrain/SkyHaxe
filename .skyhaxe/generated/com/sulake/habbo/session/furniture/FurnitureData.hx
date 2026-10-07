package com.sulake.habbo.session.furniture
;
     class FurnitureData implements IFurnitureData 
    {
        public static inline final I= "i";
        public static inline final S= "s";

        var _type:String;
        var _id:Int = 0;
        var _className:String;
        var _hasIndexedColor:Bool = false;
        var _colourIndex:Int = 0;
        var _revision:Int = 0;
        var _tileSizeX:Int = 0;
        var _tileSizeY:Int = 0;
        var _tileSizeZ:Int = 0;
        var _colours:Array<ASAny>;
        var _localizedName:String;
        var _description:String;
        var _adUrl:String;
        var _purchaseOfferId:Int = 0;
        var _bcOfferId:Int = 0;
        var _rentOfferId:Int = 0;
        var _customParams:String;
        var _category:Int = 0;
        var _purchaseCouldBeUsedForBuyout:Bool = false;
        var _rentCouldBeUsedForBuyout:Bool = false;
        var _availableForBuildersClub:Bool = false;
        var _fullName:String;
        var _canStandOn:Bool = false;
        var _canSitOn:Bool = false;
        var _canLayOn:Bool = false;
        var _excludedFromDynamic:Bool = false;
        var _furniLine:String;
        var _tradeable:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:Int, _arg_8:Int, _arg_9:Int, _arg_10:Int, _arg_11:Array<ASAny>, _arg_12:Bool, _arg_13:Int, _arg_14:String, _arg_15:Int, _arg_16:Bool, _arg_17:Int, _arg_18:Bool, _arg_19:Bool, _arg_20:String, _arg_21:Int, _arg_22:Bool, _arg_23:Bool, _arg_24:Bool, _arg_25:Bool, _arg_26:String, _arg_27:Int, _arg_28:Bool)
        {
            this._type = k;
            this._id = _arg_2;
            this._fullName = _arg_3;
            this._className = _arg_4;
            this._revision = _arg_7;
            this._tileSizeX = _arg_8;
            this._tileSizeY = _arg_9;
            this._tileSizeZ = _arg_10;
            this._colours = _arg_11;
            this._hasIndexedColor = _arg_12;
            this._colourIndex = _arg_13;
            this._localizedName = _arg_5;
            this._description = _arg_6;
            this._adUrl = _arg_14;
            this._purchaseOfferId = _arg_15;
            this._purchaseCouldBeUsedForBuyout = _arg_16;
            this._rentOfferId = _arg_17;
            this._rentCouldBeUsedForBuyout = _arg_18;
            this._availableForBuildersClub = _arg_19;
            this._customParams = _arg_20;
            this._category = _arg_21;
            this._canStandOn = _arg_22;
            this._canSitOn = _arg_23;
            this._canLayOn = _arg_24;
            this._excludedFromDynamic = _arg_25;
            this._furniLine = _arg_26;
            this._bcOfferId = _arg_27;
            this._tradeable = _arg_28;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var className(get,set):String;
public function  get_className():String
        {
            return this._className;
        }

        public var fullName(get,never):String;
public function  get_fullName():String
        {
            return this._fullName;
        }

        public var hasIndexedColor(get,never):Bool;
public function  get_hasIndexedColor():Bool
        {
            return this._hasIndexedColor;
        }

        public var colourIndex(get,never):Int;
public function  get_colourIndex():Int
        {
            return this._colourIndex;
        }

        public var revision(get,never):Int;
public function  get_revision():Int
        {
            return this._revision;
        }

        public var tileSizeX(get,never):Int;
public function  get_tileSizeX():Int
        {
            return this._tileSizeX;
        }

        public var tileSizeY(get,never):Int;
public function  get_tileSizeY():Int
        {
            return this._tileSizeY;
        }

        public var tileSizeZ(get,never):Int;
public function  get_tileSizeZ():Int
        {
            return this._tileSizeZ;
        }

        public var colours(get,never):Array<ASAny>;
public function  get_colours():Array<ASAny>
        {
            return this._colours;
        }

        public var localizedName(get,never):String;
public function  get_localizedName():String
        {
            return this._localizedName;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public var adUrl(get,never):String;
public function  get_adUrl():String
        {
            return this._adUrl;
        }

        public var purchaseOfferId(get,never):Int;
public function  get_purchaseOfferId():Int
        {
            return this._purchaseOfferId;
        }

        public var bcOfferId(get,never):Int;
public function  get_bcOfferId():Int
        {
            return this._bcOfferId;
        }

        public var customParams(get,never):String;
public function  get_customParams():String
        {
            return this._customParams;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
public function  set_className(k:String):String        {
            return this._className = k;
        }

        public var rentOfferId(get,never):Int;
public function  get_rentOfferId():Int
        {
            return this._rentOfferId;
        }

        public var purchaseCouldBeUsedForBuyout(get,never):Bool;
public function  get_purchaseCouldBeUsedForBuyout():Bool
        {
            return this._purchaseCouldBeUsedForBuyout;
        }

        public var rentCouldBeUsedForBuyout(get,never):Bool;
public function  get_rentCouldBeUsedForBuyout():Bool
        {
            return this._rentCouldBeUsedForBuyout;
        }

        public var availableForBuildersClub(get,never):Bool;
public function  get_availableForBuildersClub():Bool
        {
            return this._availableForBuildersClub;
        }

        public var canStandOn(get,never):Bool;
public function  get_canStandOn():Bool
        {
            return this._canStandOn;
        }

        public var canSitOn(get,never):Bool;
public function  get_canSitOn():Bool
        {
            return this._canSitOn;
        }

        public var canLayOn(get,never):Bool;
public function  get_canLayOn():Bool
        {
            return this._canLayOn;
        }

        public var isExternalImageType(get,never):Bool;
public function  get_isExternalImageType():Bool
        {
            return !(this._className.indexOf("external_image") == -1);
        }

        public var excludedFromDynamic(get,never):Bool;
public function  get_excludedFromDynamic():Bool
        {
            return this._excludedFromDynamic;
        }

        public var furniLine(get,never):String;
public function  get_furniLine():String
        {
            return this._furniLine;
        }

        public var tradeable(get,never):Bool;
public function  get_tradeable():Bool
        {
            return this._tradeable;
        }
    }

