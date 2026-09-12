package com.sulake.habbo.communication.messages.outgoing.games
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RequestLeaderboardMessageComposer implements IMessageComposer
    {
        var _leaderboardId:Int = 0;
        var _period:String;
        var _offset:Int = 0;
        var _limit:Int = 0;

        public function new(leaderboardId:Int=0, period:String="WEEKLY", offset:Int=0, limit:Int=10)
        {
            this._leaderboardId = leaderboardId;
            this._period = period;
            this._offset = offset;
            this._limit = limit;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._leaderboardId, this._period, this._offset, this._limit];
        }

        public function dispose()
        {
        }
    }

