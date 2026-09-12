package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SaveAreaHideMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:Int, rootX:Int, rootY:Int, width:Int, length:Int, invisibility:Bool, wallItems:Bool, invert:Bool)
        {
            this._data = [k, rootX, rootY, width, length, invisibility, wallItems, invert];
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

