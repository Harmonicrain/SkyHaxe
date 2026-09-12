package com.sulake.habbo.quest.rewardtrack.data
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RewardTrackPrize
    {
        var _id:String;
        var _requiredPoints:Int = 0;
        var _productItemTypeId:Int = 0;
        var _rewardTypeId:String;
        var _extraParams:String;
        var _rewardAmount:Int = 0;
        var _premium:Bool = false;
        var _available:Bool = false;
        var _claimed:Bool = false;

        public function new(wrapper:IMessageDataWrapper)
        {
            this._id = wrapper.readString();
            this._requiredPoints = wrapper.readInteger();
            this._productItemTypeId = wrapper.readShort();
            this._rewardTypeId = wrapper.readString();
            this._extraParams = wrapper.readString();
            this._rewardAmount = wrapper.readInteger();
            this._premium = wrapper.readBoolean();
            this._available = wrapper.readBoolean();
            this._claimed = wrapper.readBoolean();
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var requiredPoints(get,never):Int;
public function  get_requiredPoints():Int
        {
            return this._requiredPoints;
        }

        public var productItemTypeId(get,never):Int;
public function  get_productItemTypeId():Int
        {
            return this._productItemTypeId;
        }

        public var rewardTypeId(get,never):String;
public function  get_rewardTypeId():String
        {
            return this._rewardTypeId;
        }

        public var extraParams(get,never):String;
public function  get_extraParams():String
        {
            return this._extraParams;
        }

        public var rewardAmount(get,never):Int;
public function  get_rewardAmount():Int
        {
            return this._rewardAmount;
        }

        public var premium(get,never):Bool;
public function  get_premium():Bool
        {
            return this._premium;
        }

        public var available(get,never):Bool;
public function  get_available():Bool
        {
            return this._available;
        }

        
        public var claimed(get,set):Bool;
public function  get_claimed():Bool
        {
            return this._claimed;
        }
public function  set_claimed(value:Bool):Bool        {
            return this._claimed = value;
        }

        public function isPremiumLocked(track:RewardTrack):Bool
        {
            return this._premium && track != null && !track.premium;
        }

        public function hasEnoughPoints(track:RewardTrack):Bool
        {
            return track != null && track.points >= this._requiredPoints;
        }

        public function isAvailable(track:RewardTrack):Bool
        {
            return !this.isPremiumLocked(track) && this.hasEnoughPoints(track);
        }

        public function refreshAvailability(track:RewardTrack)
        {
            this._available = this.isAvailable(track);
        }

        public function isClaimable(track:RewardTrack):Bool
        {
            return this.isAvailable(track) && !this._claimed;
        }
    }

