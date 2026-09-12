package com.sulake.habbo.communication.messages.outgoing.room.action
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class BanUserWithDurationMessageComposer implements IMessageComposer
    {
        var _Str_2306:Int = 0;
        var _roomId:Int = 0;
        var _banType:String;

        public function new(k:Int, _arg_2:String, _arg_3:Int=0)
        {
            this._Str_2306 = k;
            this._roomId = _arg_3;
            this._banType = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_2306, this._roomId, this._banType];
        }
    }

