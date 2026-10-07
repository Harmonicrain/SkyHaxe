package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RemoveBotFromFlatMessageComposer implements IMessageComposer
    {
        var _botId:Int = 0;

        public function new(k:Int)
        {
            this._botId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._botId];
        }
    }

