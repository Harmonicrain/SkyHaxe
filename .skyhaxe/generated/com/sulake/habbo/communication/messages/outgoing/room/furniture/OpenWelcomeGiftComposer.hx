package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class OpenWelcomeGiftComposer implements IMessageComposer
    {
        var _furniId:Int = 0;

        public function new(k:Int)
        {
            this._furniId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._furniId];
        }
    }

