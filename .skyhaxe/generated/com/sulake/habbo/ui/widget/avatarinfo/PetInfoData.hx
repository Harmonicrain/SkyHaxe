package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetInfostandUpdateEvent;

     class PetInfoData 
    {
        public var age:Int = 0;
        public var rarityLevel:Int = 0;
        public var _Str_5114:Bool = false;
        public var energy:Int = 0;
        public var maximumEnergy:Int = 0;
        public var experience:Int = 0;
        public var levelExperienceGoal:Int = 0;
        public var id:Int = 0;
        public var _Str_5175:Bool = false;
        public var level:Int = 0;
        public var maximumLevel:Int = 0;
        public var name:String = "";
        public var happyness:Int = 0;
        public var maximumHappyness:Int = 0;
        public var ownerId:Int = 0;
        public var ownerName:String = "";
        public var _Str_14767:Int = 0;
        public var respect:Int = 0;
        public var petRespectLeft:Int = 0;
        public var _Str_4355:Int = 0;
        public var saddle:Bool = false;
        public var rider:Bool = false;
        public var breedable:Bool = false;
        public var fullyGrown:Bool = false;
        public var dead:Bool = false;
        public var skillTresholds:Array<ASAny>;
        public var publiclyRideable:Int = 0;
        public var maximumTimeToLive:Int = 0;
        public var remainingTimeToLive:Int = 0;
        public var remainingGrowTime:Int = 0;
        public var publiclyBreedable:Bool = false;

        public function new()
        {
            this.skillTresholds = [];
        }

        public function populate(k:RoomWidgetPetInfostandUpdateEvent)
        {
            this.age = k.age;
            this.rarityLevel = k.rarityLevel;
            this._Str_5114 = k._Str_5114;
            this.energy = k.energy;
            this.maximumEnergy = k.maximumEnergy;
            this.experience = k.experience;
            this.levelExperienceGoal = k.levelExperienceGoal;
            this.id = k.id;
            this._Str_5175 = k._Str_5175;
            this.level = k.level;
            this.maximumLevel = k.maximumLevel;
            this.name = k.name;
            this.happyness = k.happyness;
            this.maximumHappyness = k.maximumHappyness;
            this.ownerId = k.ownerId;
            this.ownerName = k.ownerName;
            this._Str_14767 = k._Str_14767;
            this.respect = k.respect;
            this.petRespectLeft = k.petRespectLeft;
            this._Str_4355 = k._Str_4355;
            this.saddle = k.saddle;
            this.rider = k.rider;
            this.breedable = k.breedable;
            this.dead = k.dead;
            this.fullyGrown = k.fullyGrown;
            this.skillTresholds = k.skillTresholds;
            this.publiclyRideable = k.publiclyRideable;
            this.maximumTimeToLive = k.maximumTimeToLive;
            this.remainingTimeToLive = k.remainingTimeToLive;
            this.remainingGrowTime = k.remainingGrowTime;
            this.publiclyBreedable = k.publiclyBreedable;
        }
    }

