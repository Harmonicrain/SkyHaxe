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
function  get_roomObjectId():Int
        {
            return this._roomObjectId;
        }

        
        public var activityPoints(get,set):Int;
function  get_activityPoints():Int
        {
            return this._activityPoints;
        }
function  set_activityPoints(k:Int):Int        {
            return this._activityPoints = k;
        }

        
        public var name(get,set):String;
function  get_name():String
        {
            return this._name;
        }
function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var type(get,set):Int;
function  get_type():Int
        {
            return this._type;
        }
function  set_type(k:Int):Int        {
            return this._type = k;
        }

        
        public var sex(get,set):String;
function  get_sex():String
        {
            return this._sex;
        }
function  set_sex(k:String):String        {
            return this._sex = k;
        }

        
        public var figure(get,set):String;
function  get_figure():String
        {
            return this._figure;
        }
function  set_figure(k:String):String        {
            return this._figure = k;
        }

        
        public var custom(get,set):String;
function  get_custom():String
        {
            return this._custom;
        }
function  set_custom(k:String):String        {
            return this._custom = k;
        }

        
        public var id(get,set):Int;
function  get_id():Int
        {
            return this._id;
        }
function  set_id(k:Int):Int        {
            return this._id = k;
        }

        
        public var groupID(get,set):String;
function  get_groupID():String
        {
            return this._groupID;
        }
function  set_groupID(k:String):String        {
            return this._groupID = k;
        }

        
        public var groupName(get,set):String;
function  get_groupName():String
        {
            return this._groupName;
        }
function  set_groupName(k:String):String        {
            return this._groupName = k;
        }

        
        public var groupStatus(get,set):Int;
function  get_groupStatus():Int
        {
            return this._groupStatus;
        }
function  set_groupStatus(k:Int):Int        {
            return this._groupStatus = k;
        }

        
        public var ownerId(get,set):Int;
function  get_ownerId():Int
        {
            return this._ownerId;
        }
function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }

        
        public var ownerName(get,set):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }
function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }

        
        public var rarityLevel(get,set):Int;
function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }
function  set_rarityLevel(k:Int):Int        {
            return this._rarityLevel = k;
        }

        
        public var hasSaddle(get,set):Bool;
function  get_hasSaddle():Bool
        {
            return this._hasSaddle;
        }
function  set_hasSaddle(k:Bool):Bool        {
            return this._hasSaddle = k;
        }

        
        public var isRiding(get,set):Bool;
function  get_isRiding():Bool
        {
            return this._isRiding;
        }
function  set_isRiding(k:Bool):Bool        {
            return this._isRiding = k;
        }

        
        public var canBreed(get,set):Bool;
function  get_canBreed():Bool
        {
            return this._canBreed;
        }
function  set_canBreed(k:Bool):Bool        {
            return this._canBreed = k;
        }

        
        public var canHarvest(get,set):Bool;
function  get_canHarvest():Bool
        {
            return this._canHarvest;
        }
function  set_canHarvest(k:Bool):Bool        {
            return this._canHarvest = k;
        }

        
        public var canRevive(get,set):Bool;
function  get_canRevive():Bool
        {
            return this._canRevive;
        }
function  set_canRevive(k:Bool):Bool        {
            return this._canRevive = k;
        }

        
        public var hasBreedingPermission(get,set):Bool;
function  get_hasBreedingPermission():Bool
        {
            return this._hasBreedingPermission;
        }
function  set_hasBreedingPermission(k:Bool):Bool        {
            return this._hasBreedingPermission = k;
        }

        
        public var petLevel(get,set):Int;
function  get_petLevel():Int
        {
            return this._petLevel;
        }
function  set_petLevel(k:Int):Int        {
            return this._petLevel = k;
        }

        
        public var botSkills(get,set):Array<ASAny>;
function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }

        
        public var botSkillData(get,set):Array<ASAny>;
function  get_botSkillData():Array<ASAny>
        {
            return this._botSkillData;
        }
function  set_botSkillData(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkillData = k;
        }

        
        public var isModerator(get,set):Bool;
function  get_isModerator():Bool
        {
            return this._isModerator;
        }
function  set_isModerator(k:Bool):Bool        {
            return this._isModerator = k;
        }
    }

