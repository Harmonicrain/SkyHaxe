package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomModerationSettings;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GetGuestRoomResultMessageParser implements IMessageParser implements  IDisposable
    {
        var _enterRoom:Bool = false;
        var _roomForward:Bool = false;
        var _staffPick:Bool = false;
        var _publicRoom:Bool = false;
        var _canPublicPick:Bool = false;
        var _data:GuestRoomData;
        var _isGroupMember:Bool = false;
        var _roomModerationSettings:RoomModerationSettings;
        var _chatSettings:RoomChatSettings;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._enterRoom = k.readBoolean();
            this._data = new GuestRoomData(k);
            this._roomForward = k.readBoolean();
            this._staffPick = k.readBoolean();
            this._publicRoom = k.readBoolean();
            this._canPublicPick = k.readBoolean();
            this._isGroupMember = k.readBoolean();
            var _local_2= k.readBoolean();
            this._roomModerationSettings = new RoomModerationSettings(k);
            this._data.allInRoomMuted = _local_2;
            this._data.canMute = k.readBoolean();
            this._chatSettings = new RoomChatSettings(k);
            return true;
        }

        public function dispose()
        {
            this._roomModerationSettings = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._roomModerationSettings == null;
        }

        public var _Str_15487(get,never):Bool;
public function  get__Str_15487():Bool
        {
            return this._enterRoom;
        }

        public var data(get,never):GuestRoomData;
public function  get_data():GuestRoomData
        {
            return this._data;
        }

        public var _Str_18882(get,never):Bool;
public function  get__Str_18882():Bool
        {
            return this._roomForward;
        }

        public var _Str_21489(get,never):Bool;
public function  get__Str_21489():Bool
        {
            return this._staffPick;
        }

        public var publicRoom(get,never):Bool;
public function  get_publicRoom():Bool
        {
            return this._publicRoom;
        }

        public var canPublicPick(get,never):Bool;
public function  get_canPublicPick():Bool
        {
            return this._canPublicPick;
        }

        public var _Str_22141(get,never):Bool;
public function  get__Str_22141():Bool
        {
            return this._isGroupMember;
        }

        public var roomModerationSettings(get,never):RoomModerationSettings;
public function  get_roomModerationSettings():RoomModerationSettings
        {
            return this._roomModerationSettings;
        }

        public var chatSettings(get,never):RoomChatSettings;
public function  get_chatSettings():RoomChatSettings
        {
            return this._chatSettings;
        }

	public function new() {}
    }

