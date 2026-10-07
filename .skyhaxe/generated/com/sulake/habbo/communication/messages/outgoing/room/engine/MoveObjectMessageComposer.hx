package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class MoveObjectMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _direction:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this._objectId = k;
            this._x = _arg_2;
            this._y = _arg_3;
            this._direction = _arg_4;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._x, this._y, this._direction];
        }
    }

