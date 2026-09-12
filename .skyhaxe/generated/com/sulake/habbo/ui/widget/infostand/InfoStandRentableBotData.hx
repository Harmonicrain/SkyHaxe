package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotInfoUpdateEvent;

     class InfoStandRentableBotData 
    {
        var _userId:Int = 0;
        var _name:String = "";
        var _badges:Array<ASAny>;
        var _carryItem:Int = 0;
        var _userRoomId:Int = 0;
        var _amIOwner:Bool = false;
        var _amIAnyRoomController:Bool = false;
        var _botSkills:Array<ASAny>;

        public function new()
        {
            this._badges = [];
        }

        
        public var userId(get,set):Int;
public function  set_userId(k:Int):Int        {
            return this._userId = k;
        }

        
        public var name(get,set):String;
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var badges(get,set):Array<ASAny>;
public function  set_badges(k:Array<ASAny>):Array<ASAny>        {
            return this._badges = k;
        }

        
        public var carryItem(get,set):Int;
public function  set_carryItem(k:Int):Int        {
            return this._carryItem = k;
        }

        
        public var userRoomId(get,set):Int;
public function  set_userRoomId(k:Int):Int        {
            return this._userRoomId = k;
        }

        
        public var amIOwner(get,set):Bool;
public function  set_amIOwner(k:Bool):Bool        {
            return this._amIOwner = k;
        }

        
        public var amIAnyRoomController(get,set):Bool;
public function  set_amIAnyRoomController(k:Bool):Bool        {
            return this._amIAnyRoomController = k;
        }
public function  get_userId():Int
        {
            return this._userId;
        }
public function  get_name():String
        {
            return this._name;
        }
public function  get_badges():Array<ASAny>
        {
            return this._badges.slice(0);
        }
public function  get_carryItem():Int
        {
            return this._carryItem;
        }
public function  get_userRoomId():Int
        {
            return this._userRoomId;
        }
public function  get_amIOwner():Bool
        {
            return this._amIOwner;
        }
public function  get_amIAnyRoomController():Bool
        {
            return this._amIAnyRoomController;
        }

        
        public var botSkills(get,set):Array<ASAny>;
public function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
public function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }

        public function _Str_5479(k:RoomWidgetRentableBotInfoUpdateEvent)
        {
            this.userId = k.id;
            this.name = k.name;
            this.badges = k.badges;
            this.carryItem = k.carryItem;
            this.userRoomId = k.userRoomId;
            this.amIOwner = k.amIOwner;
            this.amIAnyRoomController = k.amIAnyRoomController;
            this.botSkills = k.botSkills;
        }
    }

