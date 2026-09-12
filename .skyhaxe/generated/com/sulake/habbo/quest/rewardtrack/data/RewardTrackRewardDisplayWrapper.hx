package com.sulake.habbo.quest.rewardtrack.data
;
    import com.sulake.habbo.window.widgets.IProductDisplayInfo;

     class RewardTrackRewardDisplayWrapper implements IProductDisplayInfo
    {
        var _prize:RewardTrackPrize;

        public function new(prize:RewardTrackPrize)
        {
            this._prize = prize;
        }

        public var productTypeId(get,never):Int;
public function  get_productTypeId():Int
        {
            if ("habbicon" == this._prize.rewardTypeId)
            {
                return 7300;
            }
            if (this._prize.productItemTypeId == 0 && this.isCurrencyReward())
            {
                return 9;
            }
            return this._prize.productItemTypeId;
        }

        public var itemTypeId(get,never):String;
public function  get_itemTypeId():String
        {
            if (this._prize.productItemTypeId == 0)
            {
                if ("credits" == this._prize.rewardTypeId)
                {
                    return "-1";
                }
                if ("pixels" == this._prize.rewardTypeId)
                {
                    return "0";
                }
                if ("activity_points" == this._prize.rewardTypeId || "currency" == this._prize.rewardTypeId)
                {
                    return this._prize.extraParams != null && this._prize.extraParams != "" ? this._prize.extraParams : "0";
                }
                if ("habbicon" == this._prize.rewardTypeId)
                {
                    return this._prize.extraParams != null && this._prize.extraParams != "" ? this._prize.extraParams : this._prize.id;
                }
            }
            return this._prize.rewardTypeId;
        }

        public var extraData(get,never):String;
public function  get_extraData():String
        {
            return this._prize.extraParams;
        }

        public var petFigureString(get,never):String;
public function  get_petFigureString():String
        {
            return this._prize.extraParams;
        }

        public var botFigureString(get,never):String;
public function  get_botFigureString():String
        {
            return this._prize.extraParams;
        }

        public var figureSetIds(get,never):Vector<Int>;
public function  get_figureSetIds():Vector<Int>
        {
            return new Vector<Int>();
        }

        function isCurrencyReward():Bool
        {
            return this._prize.rewardTypeId == "credits" || this._prize.rewardTypeId == "pixels" || this._prize.rewardTypeId == "activity_points" || this._prize.rewardTypeId == "currency";
        }
    }

