package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetHabboGroupDetailsMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(groupId:Int, openDetails:Bool)
        {
            this._data = [];
            this._data.push(groupId);
            this._data.push(openDetails);
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

