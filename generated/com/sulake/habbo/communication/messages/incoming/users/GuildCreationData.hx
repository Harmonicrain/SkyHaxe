package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildCreationData implements IGuildData
    {
        var _costInCredits:Int = 0;
        var _ownedRooms:Array<ASAny>;
        var _badgeSettings:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            var _local_2:Int;
            var _local_3:Int;
            this._costInCredits = k.readInteger();
            this._ownedRooms = new Array<ASAny>();
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._ownedRooms.push(new RoomEntryData(k.readInteger(), k.readString(), k.readBoolean()));
                _local_2++;
            }
            _local_3 = k.readInteger();
            this._badgeSettings = new Array<ASAny>();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._badgeSettings.push(new GuildBadgeSettings(k));
                _local_2++;
            }
        }

        public var costInCredits(get,never):Int;
function  get_costInCredits():Int
        {
            return this._costInCredits;
        }

        public var ownedRooms(get,never):Array<ASAny>;
function  get_ownedRooms():Array<ASAny>
        {
            return this._ownedRooms;
        }

        public var exists(get,never):Bool;
function  get_exists():Bool
        {
            return false;
        }

        public var isOwner(get,never):Bool;
function  get_isOwner():Bool
        {
            return true;
        }

        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return 0;
        }

        public var groupName(get,never):String;
function  get_groupName():String
        {
            return "";
        }

        public var groupDesc(get,never):String;
function  get_groupDesc():String
        {
            return "";
        }

        public var baseRoomId(get,never):Int;
function  get_baseRoomId():Int
        {
            return 0;
        }

        public var primaryColorId(get,never):Int;
function  get_primaryColorId():Int
        {
            return 0;
        }

        public var secondaryColorId(get,never):Int;
function  get_secondaryColorId():Int
        {
            return 0;
        }

        public var badgeSettings(get,never):Array<ASAny>;
function  get_badgeSettings():Array<ASAny>
        {
            return this._badgeSettings;
        }

        public var locked(get,never):Bool;
function  get_locked():Bool
        {
            return false;
        }

        public var url(get,never):String;
function  get_url():String
        {
            return "";
        }

        public var guildType(get,never):Int;
function  get_guildType():Int
        {
            return 0;
        }

        public var guildRightsLevel(get,never):Int;
function  get_guildRightsLevel():Int
        {
            return 0;
        }

        public var badgeCode(get,never):String;
function  get_badgeCode():String
        {
            return "";
        }

        public var membershipCount(get,never):Int;
function  get_membershipCount():Int
        {
            return 0;
        }
    }

