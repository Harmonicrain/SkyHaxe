package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetGuildEditInfoMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int)
        {
            this._array = [];
            this._array.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }
    }

