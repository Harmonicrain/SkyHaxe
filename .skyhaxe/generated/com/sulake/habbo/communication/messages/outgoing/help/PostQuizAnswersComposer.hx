package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PostQuizAnswersComposer implements IMessageComposer 
    {
        var _array:Array<ASAny>;

        public function new(k:String, _arg_2:Array<ASAny>)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_2.length);
            var _local_3 = 0;
            while (_local_3 < _arg_2.length)
            {
                this._array.push(_arg_2[_local_3]);
                _local_3++;
            }
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

