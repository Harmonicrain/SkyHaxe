package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuestRoomData implements IDisposable
    {
        static inline final THUMBNAIL_BITMASK= 1;
        static inline final GROUPDATA_BITMASK= 2;
        static inline final ROOMAD_BITMASK= 4;
        static inline final SHOWOWNER_BITMASK= 8;
        static inline final ALLOWPETS_BITMASK= 16;
        static inline final DISPLAYROOMENTRYAD_BITMASK= 32;

        var _flatId:Int = 0;
        var _roomName:String;
        var _showOwner:Bool = false;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _doorMode:Int = 0;
        var _userCount:Int = 0;
        var _maxUserCount:Int = 0;
        var _description:String;
        var _tradeMode:Int = 0;
        var _score:Int = 0;
        var _ranking:Int = 0;
        var _categoryId:Int = 0;
        var _nStars:Int = 0;
        var _habboGroupId:Int = 0;
        var _groupName:String = "";
        var _groupBadgeCode:String = "";
        var _tags:Array<ASAny>;
        var _thumbnail:RoomThumbnailData;
        var _allowPets:Bool = false;
        var _displayRoomEntryAd:Bool = false;
        var _roomAdName:String = "";
        var _roomAdDescription:String = "";
        var _roomAdExpiresInMin:Int = 0;
        var _allInRoomMuted:Bool = false;
        var _canMute:Bool = false;
        var _disposed:Bool = false;
        var _officialRoomPicRef:String = null;

        public function new(k:IMessageDataWrapper)
        {
            var _local_5:String = null;
            this._tags = new Array<ASAny>();
            this._flatId = k.readInteger();
            this._roomName = k.readString();
            this._ownerId = k.readInteger();
            this._ownerName = k.readString();
            this._doorMode = k.readInteger();
            this._userCount = k.readInteger();
            this._maxUserCount = k.readInteger();
            this._description = k.readString();
            this._tradeMode = k.readInteger();
            this._score = k.readInteger();
            this._ranking = k.readInteger();
            this._categoryId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_5 = k.readString();
                this._tags.push(_local_5);
                _local_3++;
            }
            var _local_4= k.readInteger();
            if ((_local_4 & GuestRoomData.THUMBNAIL_BITMASK) > 0)
            {
                this._officialRoomPicRef = k.readString();
            }
            if ((_local_4 & GuestRoomData.GROUPDATA_BITMASK) > 0)
            {
                this._habboGroupId = k.readInteger();
                this._groupName = k.readString();
                this._groupBadgeCode = k.readString();
            }
            if ((_local_4 & GuestRoomData.ROOMAD_BITMASK) > 0)
            {
                this._roomAdName = k.readString();
                this._roomAdDescription = k.readString();
                this._roomAdExpiresInMin = k.readInteger();
            }
            this._showOwner = ((_local_4 & GuestRoomData.SHOWOWNER_BITMASK) > 0);
            this._allowPets = ((_local_4 & GuestRoomData.ALLOWPETS_BITMASK) > 0);
            this._displayRoomEntryAd = ((_local_4 & GuestRoomData.DISPLAYROOMENTRYAD_BITMASK) > 0);
            this._thumbnail = new RoomThumbnailData(null);
            this._thumbnail.setDefaults();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._tags = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        
        public var roomName(get,set):String;
public function  get_roomName():String
        {
            return this._roomName;
        }

        public var showOwner(get,never):Bool;
public function  get_showOwner():Bool
        {
            return this._showOwner;
        }

        public var ownerId(get,never):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        public var ownerName(get,never):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        public var doorMode(get,never):Int;
public function  get_doorMode():Int
        {
            return this._doorMode;
        }

        public var userCount(get,never):Int;
public function  get_userCount():Int
        {
            return this._userCount;
        }

        public var maxUserCount(get,never):Int;
public function  get_maxUserCount():Int
        {
            return this._maxUserCount;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public var tradeMode(get,never):Int;
public function  get_tradeMode():Int
        {
            return this._tradeMode;
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._score;
        }

        public var ranking(get,never):Int;
public function  get_ranking():Int
        {
            return this._ranking;
        }

        public var categoryId(get,never):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var habboGroupId(get,never):Int;
public function  get_habboGroupId():Int
        {
            return this._habboGroupId;
        }

        public var groupName(get,never):String;
public function  get_groupName():String
        {
            return this._groupName;
        }

        public var groupBadgeCode(get,never):String;
public function  get_groupBadgeCode():String
        {
            return this._groupBadgeCode;
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._tags;
        }

        public var thumbnail(get,never):RoomThumbnailData;
public function  get_thumbnail():RoomThumbnailData
        {
            return this._thumbnail;
        }

        public var allowPets(get,never):Bool;
public function  get_allowPets():Bool
        {
            return this._allowPets;
        }

        public var displayRoomEntryAd(get,never):Bool;
public function  get_displayRoomEntryAd():Bool
        {
            return this._displayRoomEntryAd;
        }

        public var roomAdName(get,never):String;
public function  get_roomAdName():String
        {
            return this._roomAdName;
        }

        public var roomAdDescription(get,never):String;
public function  get_roomAdDescription():String
        {
            return this._roomAdDescription;
        }

        public var roomAdExpiresInMin(get,never):Int;
public function  get_roomAdExpiresInMin():Int
        {
            return this._roomAdExpiresInMin;
        }

        
        public var allInRoomMuted(get,set):Bool;
public function  get_allInRoomMuted():Bool
        {
            return this._allInRoomMuted;
        }

        public var officialRoomPicRef(get,never):String;
public function  get_officialRoomPicRef():String
        {
            return this._officialRoomPicRef;
        }
public function  set_allInRoomMuted(k:Bool):Bool        {
            return this._allInRoomMuted = k;
        }
public function  set_roomName(k:String):String        {
            return this._roomName = k;
        }

        
        public var canMute(get,set):Bool;
public function  get_canMute():Bool
        {
            return this._canMute;
        }
public function  set_canMute(k:Bool):Bool        {
            return this._canMute = k;
        }
    }

