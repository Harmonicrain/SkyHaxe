package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LookToMessageComposer implements IMessageComposer
    {
        var _Str_10055:Int = 0;
        var _Str_20799:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._Str_10055 = k;
            this._Str_20799 = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_10055, this._Str_20799];
        }

        public function dispose()
        {
        }
    }

