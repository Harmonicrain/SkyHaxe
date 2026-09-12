package com.sulake.habbo.communication.messages.outgoing.game.arena
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class Game2ExitGameMessageComposer implements IMessageComposer
    {
        var _exitToRoomBeforeGame:Bool = false;

        public function new(k:Bool=true)
        {
            this._exitToRoomBeforeGame = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._exitToRoomBeforeGame];
        }

        public function dispose()
        {
        }
    }

