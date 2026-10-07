package com.sulake.habbo.communication.messages.outgoing.poll
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PollStartComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int)
        {
            this._array = [k];
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

