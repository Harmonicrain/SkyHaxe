package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class RoomWidgetPetInfostandUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final PET_INFO= "RWPIUE_PET_INFO";

        var _level:Int = 0;
        var _maximumLevel:Int = 0;
        var _experience:Int = 0;
        var _levelExperienceGoal:Int = 0;
        var _energy:Int = 0;
        var _maximumEnergy:Int = 0;
        var _happyness:Int = 0;
        var _maximumHappyness:Int = 0;
        var _petRespectLeft:Int = 0;
        var _respect:Int = 0;
        var _age:Int = 0;
        var _name:String;
        var _id:Int = 0;
        var _image:BitmapData;
        var _Str_6689:Int = 0;
        var _Str_20932:Int = 0;
        var _Str_10121:Bool = false;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _Str_11149:Bool = false;
        var _roomIndex:Int = 0;
        var _unknownRarityLevel:Int = 0;
        var _saddle:Bool = false;
        var _rider:Bool = false;
        var _breedable:Bool = false;
        var _skillTresholds:Array<ASAny>;
        var _publiclyRideable:Int = 0;
        var _fullyGrown:Bool = false;
        var _dead:Bool = false;
        var _rarityLevel:Int = 0;
        var _maximumTimeToLive:Int = 0;
        var _remainingTimeToLive:Int = 0;
        var _remainingGrowTime:Int = 0;
        var _publiclyBreedable:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:BitmapData, _arg_6:Bool, _arg_7:Int, _arg_8:String, _arg_9:Int, _arg_10:Int, _arg_11:Bool=false, _arg_12:Bool=false)
        {
            super(RoomWidgetPetInfostandUpdateEvent.PET_INFO, _arg_11, _arg_12);
            this._Str_6689 = k;
            this._Str_20932 = _arg_2;
            this._name = _arg_3;
            this._id = _arg_4;
            this._image = _arg_5;
            this._Str_10121 = _arg_6;
            this._ownerId = _arg_7;
            this._ownerName = _arg_8;
            this._roomIndex = _arg_9;
            this._unknownRarityLevel = _arg_10;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var _Str_4355(get,never):Int;
public function  get__Str_4355():Int
        {
            return this._Str_6689;
        }

        public var _Str_14767(get,never):Int;
public function  get__Str_14767():Int
        {
            return this._Str_20932;
        }

        public var _Str_5175(get,never):Bool;
public function  get__Str_5175():Bool
        {
            return this._Str_10121;
        }

        public var ownerId(get,never):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        public var ownerName(get,never):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var _Str_5114(get,set):Bool;
public function  get__Str_5114():Bool
        {
            return this._Str_11149;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        
        public var age(get,set):Int;
public function  get_age():Int
        {
            return this._age;
        }

        public var unknownRarityLevel(get,never):Int;
public function  get_unknownRarityLevel():Int
        {
            return this._unknownRarityLevel;
        }

        
        public var saddle(get,set):Bool;
public function  get_saddle():Bool
        {
            return this._saddle;
        }

        
        public var rider(get,set):Bool;
public function  get_rider():Bool
        {
            return this._rider;
        }

        
        public var breedable(get,set):Bool;
public function  get_breedable():Bool
        {
            return this._breedable;
        }

        
        public var fullyGrown(get,set):Bool;
public function  get_fullyGrown():Bool
        {
            return this._fullyGrown;
        }

        
        public var dead(get,set):Bool;
public function  get_dead():Bool
        {
            return this._dead;
        }

        
        public var rarityLevel(get,set):Int;
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        
        public var skillTresholds(get,set):Array<ASAny>;
public function  get_skillTresholds():Array<ASAny>
        {
            return this._skillTresholds;
        }

        
        public var publiclyRideable(get,set):Int;
public function  get_publiclyRideable():Int
        {
            return this._publiclyRideable;
        }

        
        public var level(get,set):Int;
public function  get_level():Int
        {
            return this._level;
        }

        
        public var maximumLevel(get,set):Int;
public function  get_maximumLevel():Int
        {
            return this._maximumLevel;
        }

        
        public var experience(get,set):Int;
public function  get_experience():Int
        {
            return this._experience;
        }

        
        public var levelExperienceGoal(get,set):Int;
public function  get_levelExperienceGoal():Int
        {
            return this._levelExperienceGoal;
        }

        
        public var energy(get,set):Int;
public function  get_energy():Int
        {
            return this._energy;
        }

        
        public var maximumEnergy(get,set):Int;
public function  get_maximumEnergy():Int
        {
            return this._maximumEnergy;
        }

        
        public var happyness(get,set):Int;
public function  get_happyness():Int
        {
            return this._happyness;
        }

        
        public var maximumHappyness(get,set):Int;
public function  get_maximumHappyness():Int
        {
            return this._maximumHappyness;
        }

        
        public var petRespectLeft(get,set):Int;
public function  get_petRespectLeft():Int
        {
            return this._petRespectLeft;
        }

        
        public var respect(get,set):Int;
public function  get_respect():Int
        {
            return this._respect;
        }
public function  set_level(k:Int):Int        {
            return this._level = k;
        }
public function  set_maximumLevel(k:Int):Int        {
            return this._maximumLevel = k;
        }
public function  set_experience(k:Int):Int        {
            return this._experience = k;
        }
public function  set_levelExperienceGoal(k:Int):Int        {
            return this._levelExperienceGoal = k;
        }
public function  set_energy(k:Int):Int        {
            return this._energy = k;
        }
public function  set_maximumEnergy(k:Int):Int        {
            return this._maximumEnergy = k;
        }
public function  set_happyness(k:Int):Int        {
            return this._happyness = k;
        }
public function  set_maximumHappyness(k:Int):Int        {
            return this._maximumHappyness = k;
        }
public function  set_petRespectLeft(k:Int):Int        {
            return this._petRespectLeft = k;
        }
public function  set__Str_5114(k:Bool):Bool        {
            return this._Str_11149 = k;
        }
public function  set_respect(k:Int):Int        {
            return this._respect = k;
        }
public function  set_age(k:Int):Int        {
            return this._age = k;
        }
public function  set_saddle(k:Bool):Bool        {
            return this._saddle = k;
        }
public function  set_rider(k:Bool):Bool        {
            return this._rider = k;
        }
public function  set_breedable(k:Bool):Bool        {
            return this._breedable = k;
        }
public function  set_skillTresholds(k:Array<ASAny>):Array<ASAny>        {
            return this._skillTresholds = k;
        }
public function  set_publiclyRideable(k:Int):Int        {
            return this._publiclyRideable = k;
        }
public function  set_fullyGrown(k:Bool):Bool        {
            return this._fullyGrown = k;
        }
public function  set_dead(k:Bool):Bool        {
            return this._dead = k;
        }
public function  set_rarityLevel(k:Int):Int        {
            return this._rarityLevel = k;
        }

        
        public var maximumTimeToLive(get,set):Int;
public function  get_maximumTimeToLive():Int
        {
            return this._maximumTimeToLive;
        }
public function  set_maximumTimeToLive(k:Int):Int        {
            return this._maximumTimeToLive = k;
        }

        
        public var remainingTimeToLive(get,set):Int;
public function  get_remainingTimeToLive():Int
        {
            return this._remainingTimeToLive;
        }
public function  set_remainingTimeToLive(k:Int):Int        {
            return this._remainingTimeToLive = k;
        }

        
        public var remainingGrowTime(get,set):Int;
public function  get_remainingGrowTime():Int
        {
            return this._remainingGrowTime;
        }
public function  set_remainingGrowTime(k:Int):Int        {
            return this._remainingGrowTime = k;
        }

        
        public var publiclyBreedable(get,set):Bool;
public function  get_publiclyBreedable():Bool
        {
            return this._publiclyBreedable;
        }
public function  set_publiclyBreedable(k:Bool):Bool        {
            return this._publiclyBreedable = k;
        }
    }

