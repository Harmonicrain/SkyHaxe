package com.sulake.habbo.session
;
     class RoomPetData
    {
        var _id:Int = 0;
        var _level:Int = 0;
        var _maximumLevel:Int = 0;
        var _experience:Int = 0;
        var _levelExperienceGoal:Int = 0;
        var _energy:Int = 0;
        var _maximumEnergy:Int = 0;
        var _happyness:Int = 0;
        var _maximumHappyness:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _respect:Int = 0;
        var _age:Int = 0;
        var _unknownRarity:Int = 0;
        var _saddle:Bool = false;
        var _rider:Bool = false;
        var _breedable:Bool = false;
        var _skillTresholds:Array<ASAny>;
        var _publiclyRideable:Int = 0;
        var _fullyGrown:Bool = false;
        var _dead:Bool = false;
        var _maximumTimeToLive:Int = 0;
        var _remainingTimeToLive:Int = 0;
        var _remainingGrowTime:Int = 0;
        var _rarityLevel:Int = 0;
        var _publiclyBreedable:Bool = false;
        var _Str_24910:Int = 7;


        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
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

        
        public var ownerId(get,set):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        
        public var ownerName(get,set):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        
        public var respect(get,set):Int;
public function  get_respect():Int
        {
            return this._respect;
        }

        
        public var age(get,set):Int;
public function  get_age():Int
        {
            return this._age;
        }

        
        public var unknownRarity(get,set):Int;
public function  get_unknownRarity():Int
        {
            return this._unknownRarity;
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
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  set_level(level:Int):Int        {
            return this._level = level;
        }
public function  set_maximumLevel(k:Int):Int        {
            return this._maximumLevel = k;
        }
public function  set_experience(experience:Int):Int        {
            return this._experience = experience;
        }
public function  set_levelExperienceGoal(k:Int):Int        {
            return this._levelExperienceGoal = k;
        }
public function  set_energy(energy:Int):Int        {
            return this._energy = energy;
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
public function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }
public function  set_ownerName(ownerName:String):String        {
            return this._ownerName = ownerName;
        }
public function  set_respect(k:Int):Int        {
            return this._respect = k;
        }
public function  set_age(age:Int):Int        {
            return this._age = age;
        }
public function  set_unknownRarity(k:Int):Int        {
            return this._unknownRarity = k;
        }
public function  set_saddle(k:Bool):Bool        {
            return this._saddle = k;
        }
public function  set_rider(k:Bool):Bool        {
            return this._rider = k;
        }
public function  set_skillTresholds(k:Array<ASAny>):Array<ASAny>        {
            return this._skillTresholds = k;
        }
public function  set_publiclyRideable(k:Int):Int        {
            return this._publiclyRideable = k;
        }
public function  set_breedable(k:Bool):Bool        {
            return this._breedable = k;
        }
public function  set_fullyGrown(k:Bool):Bool        {
            return this._fullyGrown = k;
        }
public function  set_dead(k:Bool):Bool        {
            return this._dead = k;
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
public function  set_rarityLevel(rarityLevel:Int):Int        {
            return this._rarityLevel = rarityLevel;
        }

        
        public var publiclyBreedable(get,set):Bool;
public function  get_publiclyBreedable():Bool
        {
            return this._publiclyBreedable;
        }
public function  set_publiclyBreedable(k:Bool):Bool        {
            return this._publiclyBreedable = k;
        }

        public var _Str_20651(get,never):Int;
public function  get__Str_20651():Int
        {
            return this._Str_24910;
        }
public function new(){}
    }

