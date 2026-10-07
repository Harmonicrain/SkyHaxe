package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.IFlatUser;

     class FriendEntryData implements IFlatUser
    {
        var _userId:Int = 0;
        var _userName:String;

        public function new(k:Int, _arg_2:String)
        {
            this._userId = k;
            this._userName = _arg_2;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

