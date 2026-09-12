package com.sulake.habbo.communication.messages.outgoing.room.action
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RoomUserMuteMessageComposer implements IMessageComposer 
    {
        var _Str_2306:Int = 0;
        var _roomId:Int = 0;
        var _Str_22053:Int = 0;

        public function new(userId:Int, minutes:Int, roomId:Int=0)
        {
            this._Str_2306 = userId;
            this._roomId = roomId;
            this._Str_22053 = minutes;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_2306, this._roomId, this._Str_22053];
        }
    }

