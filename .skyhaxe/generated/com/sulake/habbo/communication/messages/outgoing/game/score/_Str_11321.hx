package com.sulake.habbo.communication.messages.outgoing.game.score
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _Str_11321 implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
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

