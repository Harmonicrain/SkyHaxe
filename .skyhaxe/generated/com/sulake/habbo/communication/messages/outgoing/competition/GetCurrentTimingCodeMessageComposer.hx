package com.sulake.habbo.communication.messages.outgoing.competition
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetCurrentTimingCodeMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:String)
        {
            this._data = [];
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

