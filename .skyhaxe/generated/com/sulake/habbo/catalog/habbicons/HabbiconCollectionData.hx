package com.sulake.habbo.catalog.habbicons
;
     class HabbiconCollectionData
    {
        public var collectionId:Int = 0;
        public var name:String;
        public var completed:Bool = false;
        public var rewardHabbiconId:Int = 0;
        public var rewardState:Int = 0;
        public var priceCredits:Int = 0;
        public var priceActivityPoints:Int = 0;
        public var activityPointType:Int = 0;
        public var habbicons:Array<ASAny>;

        public function new()
        {
            this.habbicons = [];
        }
    }

