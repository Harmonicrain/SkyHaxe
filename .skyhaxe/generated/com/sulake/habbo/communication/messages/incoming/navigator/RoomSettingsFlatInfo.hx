package com.sulake.habbo.communication.messages.incoming.navigator
;
     class RoomSettingsFlatInfo
    {
        public static inline final DOORMODE_OPEN= 0;
        public static inline final DOORMODE_CLOSED= 1;
        public static inline final DOORMODE_PASSWORD= 2;
        public static inline final DOORMODE_INVISIBLE= 3;
        public static inline final DOORMODE_NOOBS_ONLY= 4;

        var _allowFurniMoving:Bool = false;
        var _doorMode:Int = 0;
        var _id:Int = 0;
        var _ownerName:String;
        var _type:String;
        var _name:String;
        var _description:String;
        var _showOwnerName:Bool = false;
        var _allowTrading:Bool = false;
        var _categoryAlertKey:Bool = false;
        var _password:String;


        
        public var allowFurniMoving(get,set):Bool;
public function  get_allowFurniMoving():Bool
        {
            return this._allowFurniMoving;
        }

        
        public var doorMode(get,set):Int;
public function  get_doorMode():Int
        {
            return this._doorMode;
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var ownerName(get,set):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var type(get,set):String;
public function  get_type():String
        {
            return this._type;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._description;
        }

        
        public var showOwnerName(get,set):Bool;
public function  get_showOwnerName():Bool
        {
            return this._showOwnerName;
        }

        
        public var allowTrading(get,set):Bool;
public function  get_allowTrading():Bool
        {
            return this._allowTrading;
        }

        
        public var categoryAlertKey(get,set):Bool;
public function  get_categoryAlertKey():Bool
        {
            return this._categoryAlertKey;
        }

        
        public var password(get,set):String;
public function  get_password():String
        {
            return this._password;
        }
public function  set_allowFurniMoving(k:Bool):Bool        {
            return this._allowFurniMoving = k;
        }
public function  set_doorMode(k:Int):Int        {
            return this._doorMode = k;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
public function  set_type(k:String):String        {
            return this._type = k;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  set_description(k:String):String        {
            return this._description = k;
        }
public function  set_showOwnerName(k:Bool):Bool        {
            return this._showOwnerName = k;
        }
public function  set_allowTrading(k:Bool):Bool        {
            return this._allowTrading = k;
        }
public function  set_categoryAlertKey(k:Bool):Bool        {
            return this._categoryAlertKey = k;
        }
public function  set_password(k:String):String        {
            return this._password = k;
        }

	public function new() {}
    }

