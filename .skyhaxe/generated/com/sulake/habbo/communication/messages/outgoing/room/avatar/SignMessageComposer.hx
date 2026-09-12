package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SignMessageComposer implements IMessageComposer
    {
        var _signID:Int = 0;

        public function new(k:Int)
        {
            this._signID = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._signID];
        }

        public function dispose()
        {
        }
    }

