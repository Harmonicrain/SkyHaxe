package com.sulake.habbo.communication.messages.outgoing.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SaveWardrobeOutfitMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:String, _arg_3:String)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
            this._data.push(_arg_3);
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

