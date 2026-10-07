package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.IStuffData;

     class RoomWidgetFurniInfostandUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final FURNI= "RWFIUE_FURNI";

        var _id:Int = 0;
        var _category:Int = 0;
        var _name:String = "";
        var _description:String = "";
        var _image:BitmapData = null;
        var _Str_4167:Bool = false;
        var _Str_21073:Bool = false;
        var _Str_7750:Bool = false;
        var _roomControllerLevel:Int = 0;
        var _isAnyRoomController:Bool = false;
        var _expiration:Int = -1;
        var _Str_25890:Int = -1;
        var _Str_6693:Int = -1;
        var _extraParam:String = "";
        var _isOwner:Bool = false;
        var _stuffData:IStuffData = null;
        var _groupId:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _usagePolicy:Int = 0;
        var _Str_26155:Int = -1;
        var _bcOfferId:Int = -1;
        var _Str_6586:Int = -1;
        var _Str_9981:Bool = false;
        var _Str_11465:Bool = false;
        var _Str_6871:Bool = false;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }

        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  get_id():Int
        {
            return this._id;
        }

        
        public var category(get,set):Int;
public function  set_category(k:Int):Int        {
            return this._category = k;
        }
public function  get_category():Int
        {
            return this._category;
        }

        
        public var name(get,set):String;
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  get_name():String
        {
            return this._name;
        }

        
        public var description(get,set):String;
public function  set_description(k:String):String        {
            return this._description = k;
        }
public function  get_description():String
        {
            return this._description;
        }

        
        public var image(get,set):BitmapData;
public function  set_image(k:BitmapData):BitmapData        {
            return this._image = k;
        }
public function  get_image():BitmapData
        {
            return this._image;
        }

        
        public var isWallItem(get,set):Bool;
public function  set_isWallItem(k:Bool):Bool        {
            return this._Str_4167 = k;
        }
public function  get_isWallItem():Bool
        {
            return this._Str_4167;
        }

        
        public var _Str_17541(get,set):Bool;
public function  set__Str_17541(k:Bool):Bool        {
            return this._Str_21073 = k;
        }
public function  get__Str_17541():Bool
        {
            return this._Str_21073;
        }

        
        public var isRoomOwner(get,set):Bool;
public function  set_isRoomOwner(k:Bool):Bool        {
            return this._Str_7750 = k;
        }
public function  get_isRoomOwner():Bool
        {
            return this._Str_7750;
        }

        
        public var roomControllerLevel(get,set):Int;
public function  set_roomControllerLevel(k:Int):Int        {
            return this._roomControllerLevel = k;
        }
public function  get_roomControllerLevel():Int
        {
            return this._roomControllerLevel;
        }

        
        public var isAnyRoomController(get,set):Bool;
public function  set_isAnyRoomController(k:Bool):Bool        {
            return this._isAnyRoomController = k;
        }
public function  get_isAnyRoomController():Bool
        {
            return this._isAnyRoomController;
        }

        
        public var expiration(get,set):Int;
public function  set_expiration(k:Int):Int        {
            return this._expiration = k;
        }
public function  get_expiration():Int
        {
            return this._expiration;
        }

        
        public var purchaseOfferId(get,set):Int;
public function  set_purchaseOfferId(k:Int):Int        {
            return this._Str_6693 = k;
        }
public function  get_purchaseOfferId():Int
        {
            return this._Str_6693;
        }

        
        public var bcOfferId(get,set):Int;
public function  set_bcOfferId(k:Int):Int        {
            return this._bcOfferId = k;
        }
public function  get_bcOfferId():Int
        {
            return this._bcOfferId;
        }

        
        public var extraParam(get,set):String;
public function  set_extraParam(k:String):String        {
            return this._extraParam = k;
        }
public function  get_extraParam():String
        {
            return this._extraParam;
        }

        
        public var isOwner(get,set):Bool;
public function  set_isOwner(k:Bool):Bool        {
            return this._isOwner = k;
        }
public function  get_isOwner():Bool
        {
            return this._isOwner;
        }

        
        public var stuffData(get,set):IStuffData;
public function  set_stuffData(k:IStuffData):IStuffData        {
            return this._stuffData = k;
        }
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        
        public var groupId(get,set):Int;
public function  set_groupId(k:Int):Int        {
            return this._groupId = k;
        }
public function  get_groupId():Int
        {
            return this._groupId;
        }

        
        public var ownerId(get,set):Int;
public function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        
        public var ownerName(get,set):String;
public function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var usagePolicy(get,set):Int;
public function  set_usagePolicy(k:Int):Int        {
            return this._usagePolicy = k;
        }
public function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }

        
        public var rentOfferId(get,set):Int;
public function  set_rentOfferId(k:Int):Int        {
            return this._Str_6586 = k;
        }
public function  get_rentOfferId():Int
        {
            return this._Str_6586;
        }

        
        public var purchaseCouldBeUsedForBuyout(get,set):Bool;
public function  get_purchaseCouldBeUsedForBuyout():Bool
        {
            return this._Str_9981;
        }
public function  set_purchaseCouldBeUsedForBuyout(k:Bool):Bool        {
            return this._Str_9981 = k;
        }

        
        public var rentCouldBeUsedForBuyout(get,set):Bool;
public function  get_rentCouldBeUsedForBuyout():Bool
        {
            return this._Str_11465;
        }
public function  set_rentCouldBeUsedForBuyout(k:Bool):Bool        {
            return this._Str_11465 = k;
        }

        
        public var availableForBuildersClub(get,set):Bool;
public function  get_availableForBuildersClub():Bool
        {
            return this._Str_6871;
        }
public function  set_availableForBuildersClub(k:Bool):Bool        {
            return this._Str_6871 = k;
        }
    }

