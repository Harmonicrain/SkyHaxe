package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetInfoMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _name:String;
        var _level:Int = 0;
        var _maximumLevel:Int = 0;
        var _experience:Int = 0;
        var _energy:Int = 0;
        var _happyness:Int = 0;
        var _levelExperienceGoal:Int = 0;
        var _maximumEnergy:Int = 0;
        var _maximumHappyness:Int = 0;
        var _respect:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _age:Int = 0;
        var _rarityLevel:Int = 0;
        var _saddle:Bool = false;
        var _rider:Bool = false;
        var _breedable:Bool = false;
        var _fullyGrown:Bool = false;
        var _dead:Bool = false;
        var _maximumTimeToLive:Int = 0;
        var _remainingTimeToLive:Int = 0;
        var _remainingGrowTime:Int = 0;
        var _skillTresholds:Array<ASAny>;
        var _publiclyRideable:Int = 0;
        var _unknownRarity:Int = 0;
        var _publiclyBreedable:Bool = false;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var maximumLevel(get,never):Int;
public function  get_maximumLevel():Int
        {
            return this._maximumLevel;
        }

        public var experience(get,never):Int;
public function  get_experience():Int
        {
            return this._experience;
        }

        public var energy(get,never):Int;
public function  get_energy():Int
        {
            return this._energy;
        }

        public var happyness(get,never):Int;
public function  get_happyness():Int
        {
            return this._happyness;
        }

        public var levelExperienceGoal(get,never):Int;
public function  get_levelExperienceGoal():Int
        {
            return this._levelExperienceGoal;
        }

        public var maximumEnergy(get,never):Int;
public function  get_maximumEnergy():Int
        {
            return this._maximumEnergy;
        }

        public var maximumHappyness(get,never):Int;
public function  get_maximumHappyness():Int
        {
            return this._maximumHappyness;
        }

        public var respect(get,never):Int;
public function  get_respect():Int
        {
            return this._respect;
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

        public var age(get,never):Int;
public function  get_age():Int
        {
            return this._age;
        }

        public var rarityLevel(get,never):Int;
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        public var saddle(get,never):Bool;
public function  get_saddle():Bool
        {
            return this._saddle;
        }

        public var rider(get,never):Bool;
public function  get_rider():Bool
        {
            return this._rider;
        }

        public var breedable(get,never):Bool;
public function  get_breedable():Bool
        {
            return this._breedable;
        }

        public var fullyGrown(get,never):Bool;
public function  get_fullyGrown():Bool
        {
            return this._fullyGrown;
        }

        public var dead(get,never):Bool;
public function  get_dead():Bool
        {
            return this._dead;
        }

        public var maximumTimeToLive(get,never):Int;
public function  get_maximumTimeToLive():Int
        {
            return this._maximumTimeToLive;
        }

        public var remainingTimeToLive(get,never):Int;
public function  get_remainingTimeToLive():Int
        {
            return this._remainingTimeToLive;
        }

        public var remainingGrowTime(get,never):Int;
public function  get_remainingGrowTime():Int
        {
            return this._remainingGrowTime;
        }

        public var skillTresholds(get,never):Array<ASAny>;
public function  get_skillTresholds():Array<ASAny>
        {
            return this._skillTresholds;
        }

        public var publiclyRideable(get,never):Int;
public function  get_publiclyRideable():Int
        {
            return this._publiclyRideable;
        }

        public var unknownRarity(get,never):Int;
public function  get_unknownRarity():Int
        {
            return this._unknownRarity;
        }

        public var publiclyBreedable(get,never):Bool;
public function  get_publiclyBreedable():Bool
        {
            return this._publiclyBreedable;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._skillTresholds = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._id = k.readInteger();
            this._name = k.readString();
            this._level = k.readInteger();
            this._maximumLevel = k.readInteger();
            this._experience = k.readInteger();
            this._levelExperienceGoal = k.readInteger();
            this._energy = k.readInteger();
            this._maximumEnergy = k.readInteger();
            this._happyness = k.readInteger();
            this._maximumHappyness = k.readInteger();
            this._respect = k.readInteger();
            this._ownerId = k.readInteger();
            this._age = k.readInteger();
            this._ownerName = k.readString();
            this._rarityLevel = k.readInteger();
            this._saddle = k.readBoolean();
            this._rider = k.readBoolean();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._skillTresholds.push(k.readInteger());
                _local_3++;
            }
            ASCompat.ASArray.sortWithOptions(this._skillTresholds, ASCompat.ASArray.NUMERIC);
            this._publiclyRideable = k.readInteger();
            this._breedable = k.readBoolean();
            this._fullyGrown = k.readBoolean();
            this._dead = k.readBoolean();
            this._unknownRarity = k.readInteger();
            this._maximumTimeToLive = k.readInteger();
            this._remainingTimeToLive = k.readInteger();
            this._remainingGrowTime = k.readInteger();
            this._publiclyBreedable = k.readBoolean();
            return true;
        }

	public function new() {}
    }

