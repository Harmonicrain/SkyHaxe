package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildEditData implements IGuildData
    {
        var _ownedRooms:Array<ASAny>;
        var _isOwner:Bool = false;
        var _groupId:Int = 0;
        var _groupName:String;
        var _groupDesc:String;
        var _baseRoomId:Int = 0;
        var _primaryColorId:Int = 0;
        var _secondaryColorId:Int = 0;
        var _locked:Bool = false;
        var _url:String;
        var _guildType:Int = 0;
        var _guildRightsLevel:Int = 0;
        var _badgeSettings:Array<ASAny>;
        var _badgeCode:String;
        var _membershipCount:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            var _local_2:Int;
            var _local_3:Int;
            this._ownedRooms = new Array<ASAny>();
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._ownedRooms.push(new RoomEntryData(k.readInteger(), k.readString(), k.readBoolean()));
                _local_2++;
            }
            this._isOwner = k.readBoolean();
            this._groupId = k.readInteger();
            this._groupName = k.readString();
            this._groupDesc = k.readString();
            this._baseRoomId = k.readInteger();
            this._primaryColorId = k.readInteger();
            this._secondaryColorId = k.readInteger();
            this._guildType = k.readInteger();
            this._guildRightsLevel = k.readInteger();
            this._locked = k.readBoolean();
            this._url = k.readString();
            this._badgeSettings = new Array<ASAny>();
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._badgeSettings.push(new GuildBadgeSettings(k));
                _local_2++;
            }
            this._badgeCode = k.readString();
            this._membershipCount = k.readInteger();
        }

        public var ownedRooms(get,never):Array<ASAny>;
function  get_ownedRooms():Array<ASAny>
        {
            return this._ownedRooms;
        }

        public var exists(get,never):Bool;
function  get_exists():Bool
        {
            return true;
        }

        public var isOwner(get,never):Bool;
function  get_isOwner():Bool
        {
            return this._isOwner;
        }

        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return this._groupId;
        }

        public var groupName(get,never):String;
function  get_groupName():String
        {
            return this._groupName;
        }

        public var groupDesc(get,never):String;
function  get_groupDesc():String
        {
            return this._groupDesc;
        }

        public var baseRoomId(get,never):Int;
function  get_baseRoomId():Int
        {
            return this._baseRoomId;
        }

        public var primaryColorId(get,never):Int;
function  get_primaryColorId():Int
        {
            return this._primaryColorId;
        }

        public var secondaryColorId(get,never):Int;
function  get_secondaryColorId():Int
        {
            return this._secondaryColorId;
        }

        public var badgeSettings(get,never):Array<ASAny>;
function  get_badgeSettings():Array<ASAny>
        {
            return this._badgeSettings;
        }

        public var locked(get,never):Bool;
function  get_locked():Bool
        {
            return this._locked;
        }

        public var url(get,never):String;
function  get_url():String
        {
            return this._url;
        }

        public var guildType(get,never):Int;
function  get_guildType():Int
        {
            return this._guildType;
        }

        public var guildRightsLevel(get,never):Int;
function  get_guildRightsLevel():Int
        {
            return this._guildRightsLevel;
        }

        public var badgeCode(get,never):String;
function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var membershipCount(get,never):Int;
function  get_membershipCount():Int
        {
            return this._membershipCount;
        }
    }

