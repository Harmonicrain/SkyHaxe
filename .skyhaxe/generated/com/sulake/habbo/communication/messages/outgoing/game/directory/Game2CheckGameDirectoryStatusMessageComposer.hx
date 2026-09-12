package com.sulake.habbo.communication.messages.outgoing.game.directory
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class Game2CheckGameDirectoryStatusMessageComposer implements IMessageComposer
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

