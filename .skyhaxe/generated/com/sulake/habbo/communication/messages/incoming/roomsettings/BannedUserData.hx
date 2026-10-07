package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BannedUserData implements IFlatUser
    {
        var _userId:Int = 0;
        var _userName:String;

        public function new(k:IMessageDataWrapper)
        {
            this._userId = k.readInteger();
            this._userName = k.readString();
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

