package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetRentableBotInfoUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RENTABLE_BOT= "RWRBIUE_RENTABLE_BOT";
        public static inline final DEFAULT_BOT_BADGE_ID= "RENTABLE_BOT";

        var _name:String = "";
        var _motto:String = "";
        var _id:Int = 0;
        var _figure:String = "";
        var _badges:Array<ASAny>;
        var _carryItem:Int = 0;
        var _userRoomId:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _amIOwner:Bool = false;
        var _amIAnyRoomController:Bool = false;
        var _myRoomControllerLevel:Int = 0;
        var _botSkills:Array<ASAny>;

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            this._badges = [];
            super(RENTABLE_BOT, k, _arg_2);
        }

        
        public var name(get,set):String;
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  get_name():String
        {
            return this._name;
        }

        
        public var motto(get,set):String;
public function  set_motto(k:String):String        {
            return this._motto = k;
        }
public function  get_motto():String
        {
            return this._motto;
        }

        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  get_id():Int
        {
            return this._id;
        }

        
        public var figure(get,set):String;
public function  set_figure(k:String):String        {
            return this._figure = k;
        }
public function  get_figure():String
        {
            return this._figure;
        }

        
        public var badges(get,set):Array<ASAny>;
public function  set_badges(k:Array<ASAny>):Array<ASAny>        {
            return this._badges = k;
        }
public function  get_badges():Array<ASAny>
        {
            return this._badges;
        }

        
        public var ownerId(get,set):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }
public function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }

        
        public var ownerName(get,set):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }
public function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }

        
        public var amIOwner(get,set):Bool;
public function  set_amIOwner(k:Bool):Bool        {
            return this._amIOwner = k;
        }
public function  get_amIOwner():Bool
        {
            return this._amIOwner;
        }

        
        public var myRoomControllerLevel(get,set):Int;
public function  set_myRoomControllerLevel(k:Int):Int        {
            return this._myRoomControllerLevel = k;
        }
public function  get_myRoomControllerLevel():Int
        {
            return this._myRoomControllerLevel;
        }

        
        public var amIAnyRoomController(get,set):Bool;
public function  set_amIAnyRoomController(k:Bool):Bool        {
            return this._amIAnyRoomController = k;
        }
public function  get_amIAnyRoomController():Bool
        {
            return this._amIAnyRoomController;
        }

        
        public var carryItem(get,set):Int;
public function  set_carryItem(k:Int):Int        {
            return this._carryItem = k;
        }
public function  get_carryItem():Int
        {
            return this._carryItem;
        }

        
        public var userRoomId(get,set):Int;
public function  set_userRoomId(k:Int):Int        {
            return this._userRoomId = k;
        }
public function  get_userRoomId():Int
        {
            return this._userRoomId;
        }

        
        public var botSkills(get,set):Array<ASAny>;
public function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
public function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }
    }

