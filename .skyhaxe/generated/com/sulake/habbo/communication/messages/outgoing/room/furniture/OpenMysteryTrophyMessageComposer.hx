package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class OpenMysteryTrophyMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _Str_19716:String;

        public function new(k:Int, _arg_2:String)
        {
            this._objectId = k;
            this._Str_19716 = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._Str_19716];
        }

        public function dispose()
        {
        }
    }

