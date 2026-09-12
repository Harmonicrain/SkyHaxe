package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TalentLevelUpMessageParser implements IMessageParser 
    {
        var _talentTrackName:String;
        var _level:Int = 0;
        var _rewardPerks:Vector<TalentTrackRewardPerk>;
        var _rewardProducts:Vector<TalentTrackRewardProduct>;


        public function flush():Bool
        {
            this._talentTrackName = null;
            this._rewardPerks = null;
            this._rewardProducts = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            this._talentTrackName = k.readString();
            this._level = k.readInteger();
            this._rewardPerks = new Vector<TalentTrackRewardPerk>();
            var _local_3= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._rewardPerks.push(new TalentTrackRewardPerk(k));
                _local_2++;
            }
            this._rewardProducts = new Vector<TalentTrackRewardProduct>();
            var _local_4= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_4)
            {
                this._rewardProducts.push(new TalentTrackRewardProduct(k));
                _local_2++;
            }
            return true;
        }

        public var talentTrackName(get,never):String;
public function  get_talentTrackName():String
        {
            return this._talentTrackName;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var _Str_8893(get,never):Vector<TalentTrackRewardPerk>;
public function  get__Str_8893():Vector<TalentTrackRewardPerk>
        {
            return this._rewardPerks;
        }

        public var _Str_7068(get,never):Vector<TalentTrackRewardProduct>;
public function  get__Str_7068():Vector<TalentTrackRewardProduct>
        {
            return this._rewardProducts;
        }

	public function new() {}
    }

