package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetRoomBackgroundColorDataComposer implements IMessageComposer
    {
        var _furniId:Int = 0;
        var _Str_4256:Int = 0;
        var _Str_4302:Int = 0;
        var _Str_4257:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this._furniId = k;
            this._Str_4256 = _arg_2;
            this._Str_4302 = _arg_3;
            this._Str_4257 = _arg_4;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._furniId, this._Str_4256, this._Str_4302, this._Str_4257];
        }

        public function dispose()
        {
        }
    }

