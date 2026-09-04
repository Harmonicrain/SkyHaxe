package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomsData;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomEntryData;
    import com.sulake.habbo.communication.messages.incoming.navigator.PromotedRoomsData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OfficialRoomsMessageParser implements IMessageParser
    {
        var _data:OfficialRoomsData;
        var _Str_8807:OfficialRoomEntryData;
        var _Str_12284:PromotedRoomsData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new OfficialRoomsData(k);
            var _local_2= k.readInteger();
            if (_local_2 > 0)
            {
                this._Str_8807 = new OfficialRoomEntryData(k);
            }
            this._Str_12284 = new PromotedRoomsData(k);
            return true;
        }

        public var data(get,never):OfficialRoomsData;
function  get_data():OfficialRoomsData
        {
            return this._data;
        }

        public var _Str_5653(get,never):OfficialRoomEntryData;
function  get__Str_5653():OfficialRoomEntryData
        {
            return this._Str_8807;
        }

        public var promotedRooms(get,never):PromotedRoomsData;
function  get_promotedRooms():PromotedRoomsData
        {
            return this._Str_12284;
        }

	public function new() {}
    }

