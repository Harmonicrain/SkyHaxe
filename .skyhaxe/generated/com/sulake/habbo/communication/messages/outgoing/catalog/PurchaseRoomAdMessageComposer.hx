package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PurchaseRoomAdMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Bool, _arg_6:String, _arg_7:Int)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_2);
            this._array.push(_arg_3);
            this._array.push(_arg_4);
            this._array.push(_arg_5);
            this._array.push(_arg_6);
            this._array.push(_arg_7);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
        }
    }

