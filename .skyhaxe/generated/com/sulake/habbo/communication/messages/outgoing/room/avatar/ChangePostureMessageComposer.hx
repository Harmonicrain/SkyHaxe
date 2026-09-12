package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ChangePostureMessageComposer implements IMessageComposer
    {
        var _posture:Int = 0;

        public function new(k:Int)
        {
            this._posture = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._posture];
        }

        public function dispose()
        {
        }
    }

