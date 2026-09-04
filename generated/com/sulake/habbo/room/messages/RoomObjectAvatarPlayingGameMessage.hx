package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarPlayingGameMessage extends RoomObjectUpdateStateMessage 
    {
        var _isPlayingGame:Bool = false;

        public function new(k:Bool=false)
        {
            super();
            this._isPlayingGame = k;
        }

        public var isPlayingGame(get,never):Bool;
function  get_isPlayingGame():Bool
        {
            return this._isPlayingGame;
        }
    }

