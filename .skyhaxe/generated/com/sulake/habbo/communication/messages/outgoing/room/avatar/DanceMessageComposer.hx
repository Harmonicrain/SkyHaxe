package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class DanceMessageComposer implements IMessageComposer
    {
        var _style:Int = 0;

        public function new(k:Int)
        {
            this._style = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._style];
        }
    }

