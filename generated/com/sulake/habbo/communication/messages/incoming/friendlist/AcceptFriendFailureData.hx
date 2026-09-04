package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AcceptFriendFailureData
    {
        var _senderId:Int = 0;
        var _errorCode:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._senderId = k.readInteger();
            this._errorCode = k.readInteger();
        }

        public var senderId(get,never):Int;
function  get_senderId():Int
        {
            return this._senderId;
        }

        public var errorCode(get,never):Int;
function  get_errorCode():Int
        {
            return this._errorCode;
        }
    }

