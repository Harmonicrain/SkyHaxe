package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class UserMessageData 
    {
        public static inline final USER_SEX_MALE= "M";
        public static inline final USER_SEX_FEMALE= "F";

        var _roomIndex:Int = 0;
        var _x:Float = 0;
        var _y:Float = 0;
        var _z:Float = 0;
        var _dir:Int = 0;
        var _name:String = "";
        var _userType:Int = 0;
        var _sex:String = "";
        var _figure:String = "";
        var _custom:String = "";
        var _activityPoints:Int = 0;
        var _id:Int = 0;
        var _groupID:String = "";
        var _groupStatus:Int = 0;
        var _groupName:String = "";
        var _subType:String = "";
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _rarityLevel:Int = 0;
        var _hasSaddle:Bool = false;
        var _isRiding:Bool = false;
        var _canBreed:Bool = false;
        var _canHarvest:Bool = false;
        var _canRevive:Bool = false;
        var _hasBreedingPermission:Bool = false;
        var _petLevel:Int = 0;
        var _petPosture:String = "";
        var _botSkills:Array<ASAny>;
        var _isModerator:Bool = false;
        var _isReadOnly:Bool = false;

        public function new(k:Int)
        {
            this._roomIndex = k;
        }

        public function setReadOnly()
        {
            this._isReadOnly = true;
        }

        public var roomIndex(get,never):Int;
function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        
        public var x(get,set):Float;
function  get_x():Float
        {
            return this._x;
        }
function  set_x(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._x = k;
            }
return k;
        }

        
        public var y(get,set):Float;
function  get_y():Float
        {
            return this._y;
        }
function  set_y(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._y = k;
            }
return k;
        }

        
        public var z(get,set):Float;
function  get_z():Float
        {
            return this._z;
        }
function  set_z(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._z = k;
            }
return k;
        }

        
        public var dir(get,set):Int;
function  get_dir():Int
        {
            return this._dir;
        }
function  set_dir(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._dir = k;
            }
return k;
        }

        
        public var name(get,set):String;
function  get_name():String
        {
            return this._name;
        }
function  set_name(k:String):String        {
            if (!this._isReadOnly)
            {
                this._name = k;
            }
return k;
        }

        
        public var userType(get,set):Int;
function  get_userType():Int
        {
            return this._userType;
        }
function  set_userType(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._userType = k;
            }
return k;
        }

        
        public var sex(get,set):String;
function  get_sex():String
        {
            return this._sex;
        }
function  set_sex(k:String):String        {
            if (!this._isReadOnly)
            {
                this._sex = k;
            }
return k;
        }

        
        public var figure(get,set):String;
function  get_figure():String
        {
            return this._figure;
        }
function  set_figure(k:String):String        {
            if (!this._isReadOnly)
            {
                this._figure = k;
            }
return k;
        }

        
        public var custom(get,set):String;
function  get_custom():String
        {
            return this._custom;
        }
function  set_custom(k:String):String        {
            if (!this._isReadOnly)
            {
                this._custom = k;
            }
return k;
        }

        
        public var activityPoints(get,set):Int;
function  get_activityPoints():Int
        {
            return this._activityPoints;
        }
function  set_activityPoints(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._activityPoints = k;
            }
return k;
        }

        
        public var id(get,set):Int;
function  get_id():Int
        {
            return this._id;
        }
function  set_id(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._id = k;
            }
return k;
        }

        
        public var groupID(get,set):String;
function  get_groupID():String
        {
            return this._groupID;
        }
function  set_groupID(k:String):String        {
            if (!this._isReadOnly)
            {
                this._groupID = k;
            }
return k;
        }

        
        public var groupName(get,set):String;
function  get_groupName():String
        {
            return this._groupName;
        }
function  set_groupName(k:String):String        {
            if (!this._isReadOnly)
            {
                this._groupName = k;
            }
return k;
        }

        
        public var groupStatus(get,set):Int;
function  get_groupStatus():Int
        {
            return this._groupStatus;
        }
function  set_groupStatus(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._groupStatus = k;
            }
return k;
        }

        
        public var subType(get,set):String;
function  get_subType():String
        {
            return this._subType;
        }
function  set_subType(k:String):String        {
            if (!this._isReadOnly)
            {
                this._subType = k;
            }
return k;
        }

        
        public var ownerId(get,set):Int;
function  get_ownerId():Int
        {
            return this._ownerId;
        }
function  set_ownerId(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._ownerId = k;
            }
return k;
        }

        
        public var ownerName(get,set):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }
function  set_ownerName(k:String):String        {
            if (!this._isReadOnly)
            {
                this._ownerName = k;
            }
return k;
        }

        
        public var rarityLevel(get,set):Int;
function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }
function  set_rarityLevel(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._rarityLevel = k;
            }
return k;
        }

        
        public var hasSaddle(get,set):Bool;
function  get_hasSaddle():Bool
        {
            return this._hasSaddle;
        }
function  set_hasSaddle(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._hasSaddle = k;
            }
return k;
        }

        
        public var isRiding(get,set):Bool;
function  get_isRiding():Bool
        {
            return this._isRiding;
        }
function  set_isRiding(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._isRiding = k;
            }
return k;
        }

        
        public var canBreed(get,set):Bool;
function  get_canBreed():Bool
        {
            return this._canBreed;
        }
function  set_canBreed(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._canBreed = k;
            }
return k;
        }

        
        public var canHarvest(get,set):Bool;
function  get_canHarvest():Bool
        {
            return this._canHarvest;
        }
function  set_canHarvest(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._canHarvest = k;
            }
return k;
        }

        
        public var canRevive(get,set):Bool;
function  get_canRevive():Bool
        {
            return this._canRevive;
        }
function  set_canRevive(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._canRevive = k;
            }
return k;
        }

        
        public var hasBreedingPermission(get,set):Bool;
function  get_hasBreedingPermission():Bool
        {
            return this._hasBreedingPermission;
        }
function  set_hasBreedingPermission(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._hasBreedingPermission = k;
            }
return k;
        }

        
        public var petLevel(get,set):Int;
function  get_petLevel():Int
        {
            return this._petLevel;
        }
function  set_petLevel(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._petLevel = k;
            }
return k;
        }

        
        public var petPosture(get,set):String;
function  get_petPosture():String
        {
            return this._petPosture;
        }
function  set_petPosture(k:String):String        {
            if (!this._isReadOnly)
            {
                this._petPosture = k;
            }
return k;
        }

        
        public var botSkills(get,set):Array<ASAny>;
function  get_botSkills():Array<ASAny>
        {
            return this._botSkills;
        }
function  set_botSkills(k:Array<ASAny>):Array<ASAny>        {
            return this._botSkills = k;
        }

        
        public var isModerator(get,set):Bool;
function  get_isModerator():Bool
        {
            return this._isModerator;
        }
function  set_isModerator(k:Bool):Bool        {
            if (!this._isReadOnly)
            {
                this._isModerator = k;
            }
return k;
        }
    }

