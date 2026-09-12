package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class CreateGuildMessageComposer implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(k:String, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Array<ASAny>)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
            this._data.push(_arg_3);
            this._data.push(_arg_4);
            this._data.push(_arg_5);
            this._data.push(_arg_6.length);
            var _local_7 = 0;
            while (_local_7 < _arg_6.length)
            {
                this._data.push(ASCompat.toInt(_arg_6[_local_7]));
                _local_7++;
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

