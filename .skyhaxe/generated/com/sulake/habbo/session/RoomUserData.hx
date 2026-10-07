package com.sulake.habbo.session
;
     class RoomUserData
    {
        var _roomObjectId:Int = -1;
        var _name:String = "";
        var _type:Int = 0;
        var _sex:String = "";
        var _figure:String = "";
        var _custom:String = "";
        var _activityPoints:Int = 0;
        var _id:Int = 0;
        var _groupID:String = "";
        var _groupStatus:Int = 0;
        var _groupName:String = "";
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _petLevel:Int = 0;
        var _rarityLevel:Int = 0;
        var _hasSaddle:Bool = false;
        var _isRiding:Bool = false;
        var _canBreed:Bool = false;
        var _canHarvest:Bool = false;
        var _canRevive:Bool = false;
        var _hasBreedingPermission:Bool = false;
        var _botSkills:Array<ASAny>;
        var _botSkillData:Array<ASAny>;
        var _isModerator:Bool = false;

        public function new(k:Int)
        {
            this._roomObjectId = k;
        }

        public var roomObjectId(get,never):Int;
public function  get_roomObjectId():Int
        {
            return this._roomObjectId;
        }

        
        public var activityPoints(get,set):Int;
public function  get_activityPoints():Int
        {
            return this._activityPoints;
        }
public function  set_activityPoints(k:Int):Int        {
            return this._activityPoints = k;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var type(get,set):Int;
public function  get_type():Int
        {
            return this._type;
        }
public function  set_type(k:Int):Int        {
            return this._type = k;
        }

        
        public var sex(get,set):String;
public function  get_sex():String
        {
            return this._sex;
        }
public function  set_sex(k:String):String        {
            return this._sex = k;
        }

        
        public var figure(get,set):String;
public function  get_figure():String
        {
            return this._figure;
        }
public function  set_figure(k:String):String        {
            return this._figure = k;
        }

        
        public var custom(get,set):String;
public function  get_custom():String
        {
            return this._custom;
        }
public function  set_custom(k:String):String        {
            return this._custom = k;
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }

        
        public var groupID(get,set):String;
public function  get_groupID():String
        {
            return this._groupID;
        }
public function  set_groupID(k:String):String        {
            return this._groupID = k;
        }

        
        public var groupName(get,set):String;
public function  get_groupName():String
        {
            return this._groupName;
        }
public function  set_groupName(k:String):String        {
            return this._groupName = k;
        }

        
        public var groupStatus(get,set):Int;
public function  get_groupStatus():Int
        {
            return this._groupStatus;
        }
public function  set_groupStatus(k:Int):Int        {
            return this._groupStatus = k;
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

        
        public var rarityLevel(get,set):Int;
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }
public function  set_rarityLevel(k:Int):Int        {
            return this._rarityLevel = k;
        }

        
        public var hasSaddle(get,set):Bool;
public function  get_hasSaddle():Bool
        {
            return this._hasSaddle;
        }
public function  set_hasSaddle(k:Bool):Bool        {
            return this._hasSaddle = k;
        }

        
        public var isRiding(get,set):Bool;
public function  get_isRiding():Bool
        {
            return this._isRiding;
        }
public function  set_isRiding(k:Bool):Bool        {
            return this._isRiding = k;
        }

        
        public var canBreed(get,set):Bool;
public function  get_canBreed():Bool
        {
            return this._canBreed;
        }
public function  set_canBreed(k:Bool):Bool        {
            return this._canBreed = k;
        }

        
        public var canHarvest(get,set):Bool;
public function  get_canHarvest():Bool
        {
            return this._canHarvest;
        }
public function  set_canHarvest(k:Bool):Bool        {
            return this._canHarvest = k;
        }

        
        public var canRevive(get,set):Bool;
public function  get_canRevive():Bool
        {
            return this._canRevive;
        }
public function  set_canRevive(k:Bool):Bool        {
            return this._canRevive = k;
        }

        
        public var hasBreedingPermission(get,set):Bool;
public function  get_hasBreedingPermission():Bool
        {
            return this._hasBreedingPermission;
        }
public function  set_hasBreedingPermission(k:Bool):Bool        {
            return this._hasBreedingPermission = k;
        }

        
        public var petLevel(get,set):Int;
public function  get_petLevel():Int
        {
            return this._petLevel;
        }
public function  set_petLevel(k:Int):Int        {
            return this._petLevel = k;
        }

        
        public var botSkills(get,set):Array<ASAny>;
public function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
public function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }

        
        public var botSkillData(get,set):Array<ASAny>;
public function  get_botSkillData():Array<ASAny>
        {
            return this._botSkillData;
        }
public function  set_botSkillData(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkillData = k;
        }

        
        public var isModerator(get,set):Bool;
public function  get_isModerator():Bool
        {
            return this._isModerator;
        }
public function  set_isModerator(k:Bool):Bool        {
            return this._isModerator = k;
        }
    }

