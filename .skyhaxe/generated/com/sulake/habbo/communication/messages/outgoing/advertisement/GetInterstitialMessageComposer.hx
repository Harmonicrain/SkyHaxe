package com.sulake.habbo.communication.messages.outgoing.advertisement
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetInterstitialMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new()
        {
            this._data = [];
        }

        public function dispose()
        {
            this._data = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }
    }

