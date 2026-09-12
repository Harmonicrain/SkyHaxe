package com.sulake.habbo.catalog.purchase
;
     class RoomAdPurchaseData 
    {
        var _name:String;
        var _description:String = "";
        var _flatId:Int = 0;
        var _offerId:Int = 0;
        var _extended:Bool = false;
        var _extendedFlatId:Int = 0;
        var _roomName:String;
        var _expirationTime:Date;
        var _categoryId:Int = -1;


        public function clear()
        {
            this._name = null;
            this._description = "";
            this._flatId = 0;
            this._extended = false;
            this._roomName = null;
            this._extendedFlatId = -1;
            this._categoryId = -1;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._description;
        }
public function  set_description(k:String):String        {
            return this._description = k;
        }

        
        public var flatId(get,set):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }
public function  set_flatId(k:Int):Int        {
            return this._flatId = k;
        }

        
        public var offerId(get,set):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }
public function  set_offerId(k:Int):Int        {
            return this._offerId = k;
        }

        
        public var _Str_8314(get,set):Bool;
public function  get__Str_8314():Bool
        {
            return this._extended;
        }

        
        public var _Str_16649(get,set):Int;
public function  get__Str_16649():Int
        {
            return this._extendedFlatId;
        }
public function  set__Str_16649(k:Int):Int        {
            return this._extendedFlatId = k;
        }
public function  set__Str_8314(k:Bool):Bool        {
            return this._extended = k;
        }

        
        public var roomName(get,set):String;
public function  get_roomName():String
        {
            return this._roomName;
        }
public function  set_roomName(k:String):String        {
            return this._roomName = k;
        }

        
        public var expirationTime(get,set):Date;
public function  get_expirationTime():Date
        {
            return this._expirationTime;
        }
public function  set_expirationTime(k:Date):Date        {
            return this._expirationTime = k;
        }

        
        public var categoryId(get,set):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }
public function  set_categoryId(k:Int):Int        {
            return this._categoryId = k;
        }
public function new(){}
    }

