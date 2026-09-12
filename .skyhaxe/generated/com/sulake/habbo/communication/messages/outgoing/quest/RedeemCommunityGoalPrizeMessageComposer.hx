package com.sulake.habbo.communication.messages.outgoing.quest
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RedeemCommunityGoalPrizeMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(communityGoalId:Int)
        {
            this._data = [];
            this._data.push(communityGoalId);
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

