package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PassCarryItemMessageComposer implements IMessageComposer
    {
        var _Str_2306:Int = 0;

        public function new(k:Int)
        {
            this._Str_2306 = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_2306];
        }
    }

