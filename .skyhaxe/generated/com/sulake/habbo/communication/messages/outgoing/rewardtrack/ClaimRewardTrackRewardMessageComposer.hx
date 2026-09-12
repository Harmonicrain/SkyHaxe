package com.sulake.habbo.communication.messages.outgoing.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ClaimRewardTrackRewardMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(trackId:String, rewardId:String)
        {
            this._data = [trackId, rewardId];
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

