package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetItemDataMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _array:String;
        var _colorHex:String;

        public function new(k:Int, _arg_2:String="", _arg_3:String="")
        {
            this._objectId = k;
            this._array = _arg_3;
            this._colorHex = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._colorHex, this._array];
        }
    }

