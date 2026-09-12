package com.sulake.habbo.communication.messages.outgoing.room.session
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GoToFlatMessageComposer implements IMessageComposer
    {
        var _roomId:Int = 0;

        public function new(k:Int)
        {
            this._roomId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._roomId];
        }
    }

