package com.sulake.habbo.communication.messages.outgoing.quest
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AcceptQuestMessageComposer implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(k:Int)
        {
            this._data = [];
            this._data.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

