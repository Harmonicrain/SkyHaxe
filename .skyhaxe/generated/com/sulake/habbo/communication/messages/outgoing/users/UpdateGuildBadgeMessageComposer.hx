package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class UpdateGuildBadgeMessageComposer implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2.length);
            var _local_3 = 0;
            while (_local_3 < _arg_2.length)
            {
                this._data.push(ASCompat.toInt(_arg_2[_local_3]));
                _local_3++;
            }
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

