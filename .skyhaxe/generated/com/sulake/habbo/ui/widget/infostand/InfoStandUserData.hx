package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;

     class InfoStandUserData 
    {
        var _userId:Int = 0;
        var _userName:String = "";
        var _badges:Array<ASAny>;
        var _groupId:Int = 0;
        var _groupName:String = "";
        var _groupBadgeId:String = "";
        var _respectLeft:Int = 0;
        var _carryItem:Int = 0;
        var _userRoomId:Int = 0;
        var _type:String;
        var _petRespectLeft:Int = 0;

        public function new()
        {
            this._badges = [];
        }

        
        public var userId(get,set):Int;
public function  set_userId(k:Int):Int        {
            return this._userId = k;
        }

        
        public var userName(get,set):String;
public function  set_userName(k:String):String        {
            return this._userName = k;
        }

        
        public var badges(get,set):Array<ASAny>;
public function  set_badges(k:Array<ASAny>):Array<ASAny>        {
            return this._badges = k;
        }

        
        public var groupId(get,set):Int;
public function  set_groupId(k:Int):Int        {
            return this._groupId = k;
        }

        
        public var groupName(get,set):String;
public function  set_groupName(k:String):String        {
            return this._groupName = k;
        }

        
        public var groupBadgeId(get,set):String;
public function  set_groupBadgeId(k:String):String        {
            return this._groupBadgeId = k;
        }

        
        public var respectLeft(get,set):Int;
public function  set_respectLeft(k:Int):Int        {
            return this._respectLeft = k;
        }

        
        public var carryItem(get,set):Int;
public function  set_carryItem(k:Int):Int        {
            return this._carryItem = k;
        }

        
        public var userRoomId(get,set):Int;
public function  set_userRoomId(k:Int):Int        {
            return this._userRoomId = k;
        }

        
        public var type(get,set):String;
public function  set_type(k:String):String        {
            return this._type = k;
        }

        
        public var petRespectLeft(get,set):Int;
public function  set_petRespectLeft(k:Int):Int        {
            return this._petRespectLeft = k;
        }
public function  get_userId():Int
        {
            return this._userId;
        }
public function  get_userName():String
        {
            return this._userName;
        }
public function  get_badges():Array<ASAny>
        {
            return this._badges.slice(0);
        }
public function  get_groupId():Int
        {
            return this._groupId;
        }
public function  get_groupName():String
        {
            return this._groupName;
        }
public function  get_groupBadgeId():String
        {
            return this._groupBadgeId;
        }
public function  get_respectLeft():Int
        {
            return this._respectLeft;
        }
public function  get_carryItem():Int
        {
            return this._carryItem;
        }
public function  get_userRoomId():Int
        {
            return this._userRoomId;
        }
public function  get_type():String
        {
            return this._type;
        }
public function  get_petRespectLeft():Int
        {
            return this._petRespectLeft;
        }

        public function _Str_18577():Bool
        {
            return this.type == RoomWidgetUserInfoUpdateEvent.BOT;
        }

        public function _Str_5479(k:RoomWidgetUserInfoUpdateEvent)
        {
            this.userId = k.id;
            this.userName = k.name;
            this.badges = k.badges;
            this.groupId = k.groupId;
            this.groupName = k.groupName;
            this.groupBadgeId = k.groupBadgeId;
            this.respectLeft = k.respectLeft;
            this.carryItem = k.carryItem;
            this.userRoomId = k.userRoomId;
            this.type = k.type;
        }
    }

