package com.sulake.habbo.communication.messages.outgoing.game.arena
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class Game2PlayAgainMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new()
        {
            this._data = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = [];
        }
    }

