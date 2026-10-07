package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class FollowFriendMessageComposer implements IMessageComposer 
    {
        var _Str_5549:String;

        public function new(k:String)
        {
            this._Str_5549 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_5549];
        }

        public function dispose()
        {
            this._Str_5549 = null;
        }
    }

