package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendRequestData
    {
        var _requestId:Int = 0;
        var _requesterName:String;
        var _requesterUserId:Int = 0;
        var _figureString:String;

        public function new(k:IMessageDataWrapper)
        {
            this._requestId = k.readInteger();
            this._requesterName = k.readString();
            this._figureString = k.readString();
            this._requesterUserId = this._requestId;
        }

        public var requestId(get,never):Int;
function  get_requestId():Int
        {
            return this._requestId;
        }

        public var requesterName(get,never):String;
function  get_requesterName():String
        {
            return this._requesterName;
        }

        public var requesterUserId(get,never):Int;
function  get_requesterUserId():Int
        {
            return this._requesterUserId;
        }

        public var figureString(get,never):String;
function  get_figureString():String
        {
            return this._figureString;
        }
    }

