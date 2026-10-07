package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.RoomEntryData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomAdPurchaseInfoEventParser implements IMessageParser
    {
        var _isVip:Bool = false;
        var _rooms:Array<ASAny>;


        public function flush():Bool
        {
            return false;
        }

        public var rooms(get,never):Array<ASAny>;
public function  get_rooms():Array<ASAny>
        {
            return this._rooms;
        }

        public var _Str_12313(get,never):Bool;
public function  get__Str_12313():Bool
        {
            return this._isVip;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5:String = null;
            var _local_6 = false;
            var _local_7:RoomEntryData = null;
            this._rooms = new Array<ASAny>();
            this._isVip = k.readBoolean();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readString();
                _local_6 = k.readBoolean();
                _local_7 = new RoomEntryData(_local_4, _local_5, _local_6);
                this._rooms.push(_local_7);
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

