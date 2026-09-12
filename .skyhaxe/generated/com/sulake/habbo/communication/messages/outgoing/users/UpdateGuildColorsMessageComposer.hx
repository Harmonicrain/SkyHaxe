package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class UpdateGuildColorsMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_2);
            this._array.push(_arg_3);
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

