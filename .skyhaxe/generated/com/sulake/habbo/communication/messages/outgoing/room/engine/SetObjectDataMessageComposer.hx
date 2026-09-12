package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.utils.Map;

     class SetObjectDataMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Map)
        {
            var _local_3:String = null;
            this._array = [];
            this._array.push(k);
            this._array.push((_arg_2.length * 2));
            final _iter_ = _arg_2.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._array.push(_local_3);
                this._array.push(_arg_2.getValue(_local_3));
            }
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

