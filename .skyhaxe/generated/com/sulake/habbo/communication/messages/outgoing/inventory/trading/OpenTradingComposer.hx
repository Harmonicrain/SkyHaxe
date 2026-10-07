package com.sulake.habbo.communication.messages.outgoing.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class OpenTradingComposer implements IMessageComposer
    {
        var _userRoomIndex:Int = 0;

        public function new(k:Int)
        {
            this._userRoomIndex = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._userRoomIndex];
        }
    }

