package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.AcceptFriendFailureData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AcceptFriendResultMessageParser implements IMessageParser
    {
        var _Str_17671:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_17671 = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_17671.push(new AcceptFriendFailureData(k));
                _local_3++;
            }
            return true;
        }

        public var _Str_22533(get,never):Array<ASAny>;
function  get__Str_22533():Array<ASAny>
        {
            return this._Str_17671;
        }

	public function new() {}
    }

