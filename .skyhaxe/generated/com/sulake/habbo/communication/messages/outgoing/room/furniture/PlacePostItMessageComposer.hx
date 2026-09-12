package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PlacePostItMessageComposer implements IMessageComposer
    {
        var _itemId:Int = 0;
        var _location:String;

        public function new(k:Int, _arg_2:String)
        {
            this._itemId = k;
            this._location = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._itemId, this._location];
        }
    }

