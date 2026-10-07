package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewFriendRequestMessageParser implements IMessageParser
    {
        var _req:FriendRequestData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._req = new FriendRequestData(k);
            return true;
        }

        public var req(get,never):FriendRequestData;
public function  get_req():FriendRequestData
        {
            return this._req;
        }

	public function new() {}
    }

