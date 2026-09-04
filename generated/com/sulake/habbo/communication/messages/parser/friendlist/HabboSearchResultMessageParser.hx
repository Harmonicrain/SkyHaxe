package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.HabboSearchResultData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboSearchResultMessageParser implements IMessageParser
    {
        var _friends:Array<ASAny>;
        var _others:Array<ASAny>;


        public function flush():Bool
        {
            this._friends = new Array<ASAny>();
            this._others = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._friends.push(new HabboSearchResultData(k));
                _local_3++;
            }
            var _local_4= k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                this._others.push(new HabboSearchResultData(k));
                _local_3++;
            }
            return true;
        }

        public var friends(get,never):Array<ASAny>;
function  get_friends():Array<ASAny>
        {
            return this._friends;
        }

        public var others(get,never):Array<ASAny>;
function  get_others():Array<ASAny>
        {
            return this._others;
        }

	public function new() {}
    }

