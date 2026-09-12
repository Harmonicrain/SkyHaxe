package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetRentOrBuyoutOfferMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Bool, _arg_2:String, _arg_3:Bool)
        {
            this._array = [k, _arg_2, _arg_3];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }
    }

