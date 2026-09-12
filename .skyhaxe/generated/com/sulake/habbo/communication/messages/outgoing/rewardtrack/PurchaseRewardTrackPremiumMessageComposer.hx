package com.sulake.habbo.communication.messages.outgoing.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PurchaseRewardTrackPremiumMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(trackId:String)
        {
            this._data = [trackId];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

