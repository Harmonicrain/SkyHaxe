package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendRequestsMessageParser implements IMessageParser
    {
        var _Str_18741:Int = 0;
        var _Str_18290:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_18290 = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_18741 = k.readInteger();
            var _local_2= k.readInteger();
            Logger.log(((("Received friend requests: " + this._Str_18741) + ", ") + _local_2));
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_18290.push(new FriendRequestData(k));
                _local_3++;
            }
            return true;
        }

        public var _Str_26150(get,never):Int;
function  get__Str_26150():Int
        {
            return this._Str_18741;
        }

        public var _Str_17539(get,never):Array<ASAny>;
function  get__Str_17539():Array<ASAny>
        {
            return this._Str_18290;
        }

	public function new() {}
    }

