package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetClothingChangeDataMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _gender:String;
        var _Str_20428:String;

        public function new(k:Int, _arg_2:String, _arg_3:String="")
        {
            this._objectId = k;
            this._gender = _arg_2;
            this._Str_20428 = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._gender, this._Str_20428];
        }
    }

