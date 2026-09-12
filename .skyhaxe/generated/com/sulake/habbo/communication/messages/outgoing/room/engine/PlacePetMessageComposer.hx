package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PlacePetMessageComposer implements IMessageComposer
    {
        var _petId:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._petId = k;
            this._x = _arg_2;
            this._y = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._petId, this._x, this._y];
        }
    }

