package com.sulake.habbo.communication.messages.outgoing.game.score
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _Str_16422 implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
            this._data.push(_arg_3);
            this._data.push(_arg_4);
            this._data.push(_arg_5);
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

