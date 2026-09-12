package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetDirectClubBuyAvailableComposer implements IMessageComposer
    {
        var _days:Int = 0;

        public function new(k:Int)
        {
            this._days = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._days];
        }

        public function dispose()
        {
        }
    }

