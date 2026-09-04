package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class BuildersClubPlaceRoomItemMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Bool = false)
        {
            this._array = [];
            this._array = [k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7];
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

