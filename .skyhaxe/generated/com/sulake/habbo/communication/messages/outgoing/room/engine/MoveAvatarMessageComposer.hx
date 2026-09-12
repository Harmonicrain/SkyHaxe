package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class MoveAvatarMessageComposer implements IMessageComposer
    {
        var _x:Int = 0;
        var _y:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._x = k;
            this._y = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._x, this._y];
        }
    }

