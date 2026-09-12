package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboGroupDetailsData
    {
        public static inline final TYPE_REGULAR= 0;
        public static inline final TYPE_EXCLUSIVE= 1;
        public static inline final TYPE_CLOSED= 2;
        public static inline final TYPE_LARGE= 3;
        public static inline final TYPE_LARGE_CLOSED= 4;
        public static inline final STATUS_NOT_MEMBER= 0;
        public static inline final STATUS_MEMBER= 1;
        public static inline final STATUS_PENDING= 2;

        var _groupId:Int = 0;
        var _isGuild:Bool = false;
        var _type:Int = 0;
        var _groupName:String;
        var _description:String;
        var _badgeCode:String;
        var _roomId:Int = -1;
        var _roomName:String = "";
        var _status:Int = 0;
        var _totalMembers:Int = 0;
        var _favourite:Bool = false;
        var _creationDate:String;
        var _isOwner:Bool = false;
        var _isAdmin:Bool = false;
        var _ownerName:String;
        var _openDetails:Bool = false;
        var _hasBoard:Bool = false;
        var _membersCanDecorate:Bool = false;
        var _pendingMemberCount:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._groupId = k.readInteger();
            this._isGuild = k.readBoolean();
            this._type = k.readInteger();
            this._groupName = k.readString();
            this._description = k.readString();
            this._badgeCode = k.readString();
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._status = k.readInteger();
            this._totalMembers = k.readInteger();
            this._favourite = k.readBoolean();
            this._creationDate = k.readString();
            this._isOwner = k.readBoolean();
            this._isAdmin = k.readBoolean();
            this._ownerName = k.readString();
            this._openDetails = k.readBoolean();
            this._membersCanDecorate = k.readBoolean();
            this._pendingMemberCount = k.readInteger();
            this._hasBoard = k.readBoolean();
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        public var _Str_6444(get,never):Bool;
public function  get__Str_6444():Bool
        {
            return this._isGuild;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var groupName(get,never):String;
public function  get_groupName():String
        {
            return this._groupName;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomName(get,never):String;
public function  get_roomName():String
        {
            return this._roomName;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public var totalMembers(get,never):Int;
public function  get_totalMembers():Int
        {
            return this._totalMembers;
        }

        public var favourite(get,never):Bool;
public function  get_favourite():Bool
        {
            return this._favourite;
        }

        public var creationDate(get,never):String;
public function  get_creationDate():String
        {
            return this._creationDate;
        }

        public var isOwner(get,never):Bool;
public function  get_isOwner():Bool
        {
            return this._isOwner;
        }

        public var isAdmin(get,never):Bool;
public function  get_isAdmin():Bool
        {
            return this._isAdmin;
        }

        public var ownerName(get,never):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        public var _Str_8199(get,never):Bool;
public function  get__Str_8199():Bool
        {
            return this._openDetails;
        }

        public var _Str_17307(get,never):Bool;
public function  get__Str_17307():Bool
        {
            return this._membersCanDecorate;
        }

        public var _Str_18324(get,never):Int;
public function  get__Str_18324():Int
        {
            return this._pendingMemberCount;
        }

        public var _Str_25156(get,never):Bool;
public function  get__Str_25156():Bool
        {
            return this._hasBoard;
        }

        public var _Str_19430(get,never):Bool;
public function  get__Str_19430():Bool
        {
            return (this._status == HabboGroupDetailsData.STATUS_NOT_MEMBER) && ((this._type == TYPE_REGULAR) || (this._type == TYPE_LARGE_CLOSED));
        }

        public var _Str_21531(get,never):Bool;
public function  get__Str_21531():Bool
        {
            return (this._status == HabboGroupDetailsData.STATUS_NOT_MEMBER) && (this._type == HabboGroupDetailsData.TYPE_EXCLUSIVE);
        }

        public var _Str_24358(get,never):Bool;
public function  get__Str_24358():Bool
        {
            return (this._isGuild && (!this._isOwner)) && (this._status == HabboGroupDetailsData.STATUS_MEMBER);
        }
    }

