package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.BannedUserData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BannedUsersFromRoomParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _Str_17279:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_17279 = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_17279.push(new BannedUserData(k));
                _local_3++;
            }
            return true;
        }

        public var roomId(get,never):Int;
function  get_roomId():Int
        {
            return this._roomId;
        }

        public var _Str_14901(get,never):Array<ASAny>;
function  get__Str_14901():Array<ASAny>
        {
            return this._Str_17279;
        }

	public function new() {}
    }

