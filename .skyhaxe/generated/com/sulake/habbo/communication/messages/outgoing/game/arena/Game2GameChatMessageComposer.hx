package com.sulake.habbo.communication.messages.outgoing.game.arena
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class Game2GameChatMessageComposer implements IMessageComposer
    {
        var _chatLine:String;

        public function new(k:String)
        {
            this._chatLine = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._chatLine];
        }

        public function dispose()
        {
            this._chatLine = null;
        }
    }

