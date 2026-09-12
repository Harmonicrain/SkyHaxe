package com.sulake.habbo.communication.messages.outgoing.register
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class UpdateFigureDataMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:String, _arg_2:String)
        {
            this._data = [];
            this._data.push(_arg_2);
            this._data.push(k);
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

