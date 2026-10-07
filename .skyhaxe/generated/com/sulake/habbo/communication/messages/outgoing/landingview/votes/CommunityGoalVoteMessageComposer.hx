package com.sulake.habbo.communication.messages.outgoing.landingview.votes
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class CommunityGoalVoteMessageComposer implements IMessageComposer
    {
        var _voteOption:Int = 0;

        public function new(k:Int)
        {
            this._voteOption = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._voteOption];
        }
    }

