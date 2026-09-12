package com.sulake.habbo.ui.widget.infostand
;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetInfostandUpdateEvent;

     class InfoStandPetData 
    {
        var _level:Int = 0;
        var _levelMax:Int = 0;
        var _experience:Int = 0;
        var _experienceMax:Int = 0;
        var _energy:Int = 0;
        var _energyMax:Int = 0;
        var _nutrition:Int = 0;
        var _nutritionMax:Int = 0;
        var _petRespect:Int = 0;
        var _name:String = "";
        var _petId:Int = -1;
        var _type:Int = 0;
        var _race:Int = 0;
        var _image:BitmapData;
        var _isOwnPet:Bool = false;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _canRemovePet:Bool = false;
        var _roomIndex:Int = 0;
        var _age:Int = 0;
        var _breedId:Int = 0;
        var _skillTresholds:Array<ASAny>;
        var _accessRights:Int = 0;
        var _rarityLevel:Int = 0;
        var _hasBreedingPermission:Bool = false;
        var _maxWellBeingSeconds:Int = 0;
        var _remainingWellBeingSeconds:Int = 0;
        var _remainingGrowingSeconds:Int = 0;


        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._petId;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var race(get,never):Int;
public function  get_race():Int
        {
            return this._race;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }

        public var _Str_5175(get,never):Bool;
public function  get__Str_5175():Bool
        {
            return this._isOwnPet;
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

        public var _Str_5114(get,never):Bool;
public function  get__Str_5114():Bool
        {
            return this._canRemovePet;
        }

        public var age(get,never):Int;
public function  get_age():Int
        {
            return this._age;
        }

        public var unknownRarityLevel(get,never):Int;
public function  get_unknownRarityLevel():Int
        {
            return this._breedId;
        }

        public var skillTresholds(get,never):Array<ASAny>;
public function  get_skillTresholds():Array<ASAny>
        {
            return this._skillTresholds;
        }

        public var publiclyRideable(get,never):Int;
public function  get_publiclyRideable():Int
        {
            return this._accessRights;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var _Str_4276(get,never):Int;
public function  get__Str_4276():Int
        {
            return this._levelMax;
        }

        public var experience(get,never):Int;
public function  get_experience():Int
        {
            return this._experience;
        }

        public var _Str_4095(get,never):Int;
public function  get__Str_4095():Int
        {
            return this._experienceMax;
        }

        public var energy(get,never):Int;
public function  get_energy():Int
        {
            return this._energy;
        }

        public var _Str_3966(get,never):Int;
public function  get__Str_3966():Int
        {
            return this._energyMax;
        }

        public var happyness(get,never):Int;
public function  get_happyness():Int
        {
            return this._nutrition;
        }

        public var _Str_4448(get,never):Int;
public function  get__Str_4448():Int
        {
            return this._nutritionMax;
        }

        public var _Str_6943(get,never):Int;
public function  get__Str_6943():Int
        {
            return this._petRespect;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var rarityLevel(get,never):Int;
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        public var maximumTimeToLive(get,never):Int;
public function  get_maximumTimeToLive():Int
        {
            return this._maxWellBeingSeconds;
        }

        public var remainingTimeToLive(get,never):Int;
public function  get_remainingTimeToLive():Int
        {
            return this._remainingWellBeingSeconds;
        }

        public var remainingGrowTime(get,never):Int;
public function  get_remainingGrowTime():Int
        {
            return this._remainingGrowingSeconds;
        }

        public var publiclyBreedable(get,never):Bool;
public function  get_publiclyBreedable():Bool
        {
            return this._hasBreedingPermission;
        }

        public function _Str_5479(k:RoomWidgetPetInfostandUpdateEvent)
        {
            this._name = k.name;
            this._petId = k.id;
            this._type = k._Str_4355;
            this._race = k._Str_14767;
            this._image = k.image;
            this._isOwnPet = k._Str_5175;
            this._ownerId = k.ownerId;
            this._ownerName = k.ownerName;
            this._canRemovePet = k._Str_5114;
            this._level = k.level;
            this._levelMax = k.maximumLevel;
            this._experience = k.experience;
            this._experienceMax = k.levelExperienceGoal;
            this._energy = k.energy;
            this._energyMax = k.maximumEnergy;
            this._nutrition = k.happyness;
            this._nutritionMax = k.maximumHappyness;
            this._petRespect = k.respect;
            this._roomIndex = k.roomIndex;
            this._age = k.age;
            this._breedId = k.unknownRarityLevel;
            this._skillTresholds = k.skillTresholds;
            this._accessRights = k.publiclyRideable;
            this._maxWellBeingSeconds = k.maximumTimeToLive;
            this._remainingWellBeingSeconds = k.remainingTimeToLive;
            this._remainingGrowingSeconds = k.remainingGrowTime;
            this._rarityLevel = k.rarityLevel;
            this._hasBreedingPermission = k.publiclyBreedable;
        }
public function new(){}
    }

