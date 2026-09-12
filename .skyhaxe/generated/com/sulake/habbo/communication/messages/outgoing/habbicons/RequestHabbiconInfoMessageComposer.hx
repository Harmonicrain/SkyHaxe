package com.sulake.habbo.communication.messages.outgoing.habbicons
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RequestHabbiconInfoMessageComposer implements IMessageComposer
    {
        var _habbiconId:Int = 0;

        public function new(habbiconId:Int)
        {
            this._habbiconId = habbiconId;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._habbiconId];
        }

        public function dispose()
        {
        }
    }

