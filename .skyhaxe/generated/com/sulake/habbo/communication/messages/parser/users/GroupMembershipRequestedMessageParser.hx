package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.MemberData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GroupMembershipRequestedMessageParser implements IMessageParser 
    {
        var _groupId:Int = 0;
        var _requester:MemberData;


        public function flush():Bool
        {
            this._requester = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._groupId = k.readInteger();
            this._requester = new MemberData(k);
            return true;
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        public var requester(get,never):MemberData;
public function  get_requester():MemberData
        {
            return this._requester;
        }

	public function new() {}
    }

