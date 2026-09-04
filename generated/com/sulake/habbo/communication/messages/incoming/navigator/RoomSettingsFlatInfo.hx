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
function  get_allowFurniMoving():Bool
        {
            return this._allowFurniMoving;
        }

        
        public var doorMode(get,set):Int;
function  get_doorMode():Int
        {
            return this._doorMode;
        }

        
        public var id(get,set):Int;
function  get_id():Int
        {
            return this._id;
        }

        
        public var ownerName(get,set):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var type(get,set):String;
function  get_type():String
        {
            return this._type;
        }

        
        public var name(get,set):String;
function  get_name():String
        {
            return this._name;
        }

        
        public var description(get,set):String;
function  get_description():String
        {
            return this._description;
        }

        
        public var showOwnerName(get,set):Bool;
function  get_showOwnerName():Bool
        {
            return this._showOwnerName;
        }

        
        public var allowTrading(get,set):Bool;
function  get_allowTrading():Bool
        {
            return this._allowTrading;
        }

        
        public var categoryAlertKey(get,set):Bool;
function  get_categoryAlertKey():Bool
        {
            return this._categoryAlertKey;
        }

        
        public var password(get,set):String;
function  get_password():String
        {
            return this._password;
        }
function  set_allowFurniMoving(k:Bool):Bool        {
            return this._allowFurniMoving = k;
        }
function  set_doorMode(k:Int):Int        {
            return this._doorMode = k;
        }
function  set_id(k:Int):Int        {
            return this._id = k;
        }
function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
function  set_type(k:String):String        {
            return this._type = k;
        }
function  set_name(k:String):String        {
            return this._name = k;
        }
function  set_description(k:String):String        {
            return this._description = k;
        }
function  set_showOwnerName(k:Bool):Bool        {
            return this._showOwnerName = k;
        }
function  set_allowTrading(k:Bool):Bool        {
            return this._allowTrading = k;
        }
function  set_categoryAlertKey(k:Bool):Bool        {
            return this._categoryAlertKey = k;
        }
function  set_password(k:String):String        {
            return this._password = k;
        }

	public function new() {}
    }

