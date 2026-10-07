package com.sulake.habbo.communication.messages.outgoing.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class CheckUserNameMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:String)
        {
            this._data = new Array<ASAny>();
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

