package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AddSpamWallPostItMessageComposer implements IMessageComposer
    {
        var _itemId:Int = 0;
        var _location:String;
        var _message:String;
        var _colorHex:String;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            this._itemId = k;
            this._location = _arg_2;
            this._message = _arg_4;
            this._colorHex = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._itemId, this._location, this._colorHex, this._message];
        }
    }

