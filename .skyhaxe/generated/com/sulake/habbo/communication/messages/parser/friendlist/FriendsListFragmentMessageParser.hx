package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendsListFragmentMessageParser implements IMessageParser
    {
        var _totalFragments:Int = 0;
        var _fragmentNo:Int = 0;
        var _friendFragment:Array<ASAny>;


        public var totalFragments(get,never):Int;
public function  get_totalFragments():Int
        {
            return this._totalFragments;
        }

        public var fragmentNo(get,never):Int;
public function  get_fragmentNo():Int
        {
            return this._fragmentNo;
        }

        public var friendFragment(get,never):Array<ASAny>;
public function  get_friendFragment():Array<ASAny>
        {
            return this._friendFragment;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._totalFragments = k.readInteger();
            this._fragmentNo = k.readInteger();
            this._friendFragment = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._friendFragment.push(new FriendParser(k));
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            this._friendFragment = new Array<ASAny>();
            return true;
        }

	public function new() {}
    }

