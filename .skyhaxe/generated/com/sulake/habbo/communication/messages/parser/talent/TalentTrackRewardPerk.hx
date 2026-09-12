package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TalentTrackRewardPerk
    {
        var _perkId:String;

        public function new(k:IMessageDataWrapper)
        {
            this._perkId = k.readString();
        }

        public var _Str_10964(get,never):String;
public function  get__Str_10964():String
        {
            return this._perkId;
        }
    }

