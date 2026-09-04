package com.sulake.habbo.room.events
;
    import com.sulake.habbo.communication.messages.parser.games.OpenLeaderboardMessageParser;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

     class RoomEngineLeaderboardEvent extends RoomEngineObjectEvent
    {
        public static inline final OPEN= "REGHE_LEADERBOARD_OPEN";

        var _parser:OpenLeaderboardMessageParser;

        public function new(roomId:Int, parser:OpenLeaderboardMessageParser)
        {
            super(OPEN, roomId, 0, RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN);
            this._parser = parser;
        }

        public var parser(get,never):OpenLeaderboardMessageParser;
function  get_parser():OpenLeaderboardMessageParser
        {
            return this._parser;
        }
    }

