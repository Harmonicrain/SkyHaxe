package com.sulake.habbo.ui.widget.infostand
;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.ui.widget.events.RoomWidgetFurniInfostandUpdateEvent;

     class InfoStandFurniData 
    {
        var _id:Int = 0;
        var _category:Int = 0;
        var _name:String = "";
        var _description:String = "";
        var _image:BitmapData;
        var _purchaseOfferId:Int = -1;
        var _bcOfferId:Int = -1;
        var _extraParam:String = "";
        var _stuffData:IStuffData = null;
        var _groupId:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _rentOfferId:Int = -1;
        var _availableForBuildersClub:Bool = false;


        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }

        
        public var category(get,set):Int;
public function  set_category(k:Int):Int        {
            return this._category = k;
        }

        
        public var name(get,set):String;
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var description(get,set):String;
public function  set_description(k:String):String        {
            return this._description = k;
        }

        
        public var image(get,set):BitmapData;
public function  set_image(k:BitmapData):BitmapData        {
            return this._image = k;
        }

        
        public var purchaseOfferId(get,set):Int;
public function  set_purchaseOfferId(k:Int):Int        {
            return this._purchaseOfferId = k;
        }

        
        public var bcOfferId(get,set):Int;
public function  set_bcOfferId(k:Int):Int        {
            return this._bcOfferId = k;
        }

        
        public var extraParam(get,set):String;
public function  set_extraParam(k:String):String        {
            return this._extraParam = k;
        }

        
        public var stuffData(get,set):IStuffData;
public function  set_stuffData(k:IStuffData):IStuffData        {
            return this._stuffData = k;
        }

        
        public var groupId(get,set):Int;
public function  set_groupId(k:Int):Int        {
            return this._groupId = k;
        }

        
        public var ownerId(get,set):Int;
public function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }

        
        public var ownerName(get,set):String;
public function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
public function  get_id():Int
        {
            return this._id;
        }
public function  get_category():Int
        {
            return this._category;
        }
public function  get_name():String
        {
            return this._name;
        }
public function  get_description():String
        {
            return this._description;
        }
public function  get_image():BitmapData
        {
            return this._image;
        }
public function  get_purchaseOfferId():Int
        {
            return this._purchaseOfferId;
        }
public function  get_bcOfferId():Int
        {
            return this._bcOfferId;
        }
public function  get_extraParam():String
        {
            return this._extraParam;
        }
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }
public function  get_groupId():Int
        {
            return this._groupId;
        }
public function  get_ownerId():Int
        {
            return this._ownerId;
        }
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var rentOfferId(get,set):Int;
public function  get_rentOfferId():Int
        {
            return this._rentOfferId;
        }
public function  set_rentOfferId(k:Int):Int        {
            return this._rentOfferId = k;
        }

        public var availableForBuildersClub(get,never):Bool;
public function  get_availableForBuildersClub():Bool
        {
            return this._availableForBuildersClub;
        }

        public function _Str_5479(k:RoomWidgetFurniInfostandUpdateEvent)
        {
            this.id = k.id;
            this.category = k.category;
            this.name = k.name;
            this.description = k.description;
            this.image = k.image;
            this.purchaseOfferId = k.purchaseOfferId;
            this.bcOfferId = k.bcOfferId;
            this.extraParam = k.extraParam;
            this.stuffData = k.stuffData;
            this.groupId = k.groupId;
            this.ownerName = k.ownerName;
            this.ownerId = k.ownerId;
            this.rentOfferId = k.rentOfferId;
            this._availableForBuildersClub = k.availableForBuildersClub;
        }
public function new(){}
    }

