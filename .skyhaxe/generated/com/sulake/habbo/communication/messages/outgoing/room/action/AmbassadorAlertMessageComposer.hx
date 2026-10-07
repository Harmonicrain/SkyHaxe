package com.sulake.habbo.communication.messages.outgoing.room.action
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AmbassadorAlertMessageComposer implements IMessageComposer 
    {
        var _Str_2306:Int = 0;

        public function new(k:Int)
        {
            this._Str_2306 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_2306];
        }

        public function dispose()
        {
        }
    }

