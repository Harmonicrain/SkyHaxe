package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotInfoUpdateEvent;
    import com.sulake.habbo.communication.messages.parser.room.bots.BotSkillData;

     class RentableBotInfoData 
    {
        var _id:Int = -1;
        var _roomIndex:Int = 0;
        var _isIgnored:Bool = false;
        var _amIOwner:Bool = false;
        var _amIAnyRoomController:Bool = false;
        var _carryItemType:Int = 0;
        var _botSkills:Array<ASAny>;
        var _botSkillsWithCommands:Array<ASAny>;
        var _name:String;

        public function new()
        {
            this._botSkillsWithCommands = ASCompat.allocArray(0);
        }

        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }

        
        public var roomIndex(get,set):Int;
public function  set_roomIndex(k:Int):Int        {
            return this._roomIndex = k;
        }
public function  get_id():Int
        {
            return this._id;
        }
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        
        public var isIgnored(get,set):Bool;
public function  get_isIgnored():Bool
        {
            return this._isIgnored;
        }

        
        public var amIOwner(get,set):Bool;
public function  get_amIOwner():Bool
        {
            return this._amIOwner;
        }

        
        public var amIAnyRoomController(get,set):Bool;
public function  get_amIAnyRoomController():Bool
        {
            return this._amIAnyRoomController;
        }

        
        public var carryItemType(get,set):Int;
public function  get_carryItemType():Int
        {
            return this._carryItemType;
        }
public function  set_isIgnored(k:Bool):Bool        {
            return this._isIgnored = k;
        }
public function  set_amIOwner(k:Bool):Bool        {
            return this._amIOwner = k;
        }
public function  set_amIAnyRoomController(k:Bool):Bool        {
            return this._amIAnyRoomController = k;
        }
public function  set_carryItemType(k:Int):Int        {
            return this._carryItemType = k;
        }

        
        public var botSkills(get,set):Array<ASAny>;
public function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
public function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }

        
        public var _Str_10833(get,set):Array<ASAny>;
public function  get__Str_10833():Array<ASAny>
        {
            return this._botSkillsWithCommands;
        }
public function  set__Str_10833(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkillsWithCommands = k;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public function populate(k:RoomWidgetRentableBotInfoUpdateEvent)
        {
            if (k.id != this.id)
            {
                this._botSkillsWithCommands = ASCompat.allocArray(0);
            }
            this.id = k.id;
            this.roomIndex = k.userRoomId;
            this.amIOwner = k.amIOwner;
            this.amIAnyRoomController = k.amIAnyRoomController;
            this.carryItemType = k.carryItem;
            this.botSkills = k.botSkills;
            this._name = k.name;
        }

        public function _Str_19891(k:Array<ASAny>)
        {
            var _local_2:BotSkillData = null;
            this._botSkills = new Array<ASAny>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this.botSkills.push(_local_2.id);
            }
            this._botSkillsWithCommands = k.copy();
        }
    }

