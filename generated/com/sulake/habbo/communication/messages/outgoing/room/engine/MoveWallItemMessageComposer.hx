package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class MoveWallItemMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_3);
        }

        public function dispose()
        {
            this._array = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }
    }

