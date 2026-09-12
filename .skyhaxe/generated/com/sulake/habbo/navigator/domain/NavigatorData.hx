package com.sulake.habbo.navigator.domain
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.communication.messages.incoming.navigator.MsgWithRequestId;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomEventData;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomEntryData;
    import com.sulake.habbo.communication.messages.incoming.navigator.PromotedRoomsData;
    import com.sulake.habbo.navigator.roomsettings.FriendList;
    import com.sulake.habbo.communication.messages.incoming.navigator.CompetitionRoomsData;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.communication.messages.parser.room.engine.RoomEntryInfoMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.PopularRoomTagsData;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomSearchResultData;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomsData;
    import com.sulake.habbo.communication.messages.incoming.navigator.CategoriesWithVisitorCountData;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.habbo.communication.messages.incoming.navigator.EventCategory;
    import com.sulake.habbo.communication.messages.parser.navigator.FavouritesMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.*;
    import com.sulake.habbo.navigator.*;
    import com.sulake.habbo.communication.messages.parser.navigator.*;

     class NavigatorData 
    {
        static inline final MAX_HISTORY_LENGTH= 10;

        var _navigator:HabboNavigator;
        var _lastMsg:MsgWithRequestId;
        var _roomEventData:RoomEventData;
        var _eventMod:Bool = false;
        var _roomPicker:Bool = false;
        var _currentRoomOwner:Bool = false;
        var _currentRoomId:Int = 0;
        var _avatarId:Int = 0;
        var _enteredGuestRoom:GuestRoomData;
        var _hcMember:Bool = false;
        var _createdFlatId:Int = 0;
        var _hotRoomPopupOpen:Bool = false;
        var _homeRoomId:Int = 0;
        var _settingsReceived:Bool = false;
        var _allCategories:Array<ASAny>;
        var _visibleCategories:Array<ASAny>;
        var _allEventCategories:Array<ASAny>;
        var _visibleEventCategories:Array<ASAny>;
        var _favouriteLimit:Int = 0;
        var _favouriteCount:Int = 0;
        var _favouriteIds:ASDictionary<ASAny,ASAny>;
        var _loading:Bool = false;
        var _currentRoomRating:Int = 0;
        var _canRate:Bool = false;
        var _currentRoomIsStaffPick:Bool = false;
        var _currentRoomIsPublic:Bool = false;
        var _canPublicPick:Bool = false;
        var _adIndex:Int = 0;
        var _adRoomData:OfficialRoomEntryData;
        var _promotedRooms:PromotedRoomsData;
        var _friendList:FriendList;
        var _roomSessionTags:RoomSessionTags;
        var _competitionRoomsData:CompetitionRoomsData;
        var _roomThumbnailRefreshKeys:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboNavigator)
        {
            this._allCategories = new Array<ASAny>();
            this._visibleCategories = new Array<ASAny>();
            this._allEventCategories = new Array<ASAny>();
            this._visibleEventCategories = new Array<ASAny>();
            this._favouriteIds = new ASDictionary<ASAny,ASAny>();
            this._roomThumbnailRefreshKeys = new ASDictionary<ASAny,ASAny>();
            this._friendList = new FriendList();
            this._navigator = k;
        }

        public var canAddFavourite(get,never):Bool;
public function  get_canAddFavourite():Bool
        {
            return (!(this._enteredGuestRoom == null)) && (!this._currentRoomOwner);
        }

        public var canEditRoomSettings(get,never):Bool;
public function  get_canEditRoomSettings():Bool
        {
            return (!(this._enteredGuestRoom == null)) && (this._currentRoomOwner || this._navigator.sessionData.hasSecurity(SecurityLevelEnum.MODERATOR));
        }

        public function onRoomEnter(k:RoomEntryInfoMessageParser)
        {
            this._enteredGuestRoom = null;
            this._currentRoomOwner = false;
            this._currentRoomOwner = k.owner;
            this._currentRoomId = k.guestRoomId;
        }

        public function onRoomExit()
        {
            if (this._roomEventData != null)
            {
                this._roomEventData.dispose();
                this._roomEventData = null;
            }
            if (this._enteredGuestRoom != null)
            {
                this._enteredGuestRoom.dispose();
                this._enteredGuestRoom = null;
            }
            this._currentRoomOwner = false;
        }

        public var enteredRoom(never,set):GuestRoomData;
public function  set_enteredRoom(k:GuestRoomData):GuestRoomData        {
            if (this._enteredGuestRoom != null)
            {
                this._enteredGuestRoom.dispose();
            }
            return this._enteredGuestRoom = k;
        }

        
        public var roomEventData(get,set):RoomEventData;
public function  set_roomEventData(k:RoomEventData):RoomEventData        {
            if (this._roomEventData != null)
            {
                this._roomEventData.dispose();
            }
            return this._roomEventData = k;
        }

        public var popularTagsArrived(get,never):Bool;
public function  get_popularTagsArrived():Bool
        {
            return (!(this._lastMsg == null)) && (!(Std.downcast(this._lastMsg , PopularRoomTagsData) == null));
        }

        public var guestRoomSearchArrived(get,never):Bool;
public function  get_guestRoomSearchArrived():Bool
        {
            return (!(this._lastMsg == null)) && (!(Std.downcast(this._lastMsg , GuestRoomSearchResultData) == null));
        }

        public var _Str_23411(get,never):Bool;
public function  get__Str_23411():Bool
        {
            return (!(this._lastMsg == null)) && (!(Std.downcast(this._lastMsg , OfficialRoomsData) == null));
        }

        public var _Str_26351(get,never):Bool;
public function  get__Str_26351():Bool
        {
            return (!(this._lastMsg == null)) && (!(Std.downcast(this._lastMsg , CategoriesWithVisitorCountData) == null));
        }

        
        public var guestRoomSearchResults(get,set):GuestRoomSearchResultData;
public function  set_guestRoomSearchResults(k:GuestRoomSearchResultData):GuestRoomSearchResultData        {
            var _local_2= this._adRoomData;
            var _local_3= Std.downcast(this._lastMsg , GuestRoomSearchResultData);
            if (((!(_local_3 == null)) && (_local_3.ad == this._adRoomData)))
            {
                _local_2 = _local_3.releaseAd();
            }
            this._Str_12759();
            this._lastMsg = k;
            if (k.ad != null)
            {
                this._adRoomData = k.ad;
            }
            else
            {
                this._adRoomData = _local_2;
            }
            this._loading = false;
return k;
        }

        
        public var _Str_6697(get,set):PopularRoomTagsData;
public function  set__Str_6697(k:PopularRoomTagsData):PopularRoomTagsData        {
            this._Str_12759();
            this._lastMsg = k;
            this._loading = false;
return k;
        }

        
        public var _Str_5645(get,set):OfficialRoomsData;
public function  set__Str_5645(k:OfficialRoomsData):OfficialRoomsData        {
            this._Str_12759();
            this._lastMsg = k;
            this._loading = false;
return k;
        }

        
        public var _Str_7267(get,set):CategoriesWithVisitorCountData;
public function  set__Str_7267(k:CategoriesWithVisitorCountData):CategoriesWithVisitorCountData        {
            this._Str_12759();
            this._lastMsg = k;
            this._loading = false;
return k;
        }

        function _Str_12759()
        {
            if (this._lastMsg == null)
            {
                return;
            }
            this._lastMsg.dispose();
            this._lastMsg = null;
        }

        
        public var _Str_5653(get,set):OfficialRoomEntryData;
public function  set__Str_5653(k:OfficialRoomEntryData):OfficialRoomEntryData        {
            return this._adRoomData = k;
        }

        
        public var promotedRooms(get,set):PromotedRoomsData;
public function  set_promotedRooms(k:PromotedRoomsData):PromotedRoomsData        {
            return this._promotedRooms = k;
        }
public function  get__Str_5653():OfficialRoomEntryData
        {
            return this._adRoomData;
        }
public function  get_guestRoomSearchResults():GuestRoomSearchResultData
        {
            return Std.downcast(this._lastMsg , GuestRoomSearchResultData);
        }
public function  get__Str_6697():PopularRoomTagsData
        {
            return Std.downcast(this._lastMsg , PopularRoomTagsData);
        }
public function  get__Str_5645():OfficialRoomsData
        {
            return Std.downcast(this._lastMsg , OfficialRoomsData);
        }
public function  get__Str_7267():CategoriesWithVisitorCountData
        {
            return Std.downcast(this._lastMsg , CategoriesWithVisitorCountData);
        }
public function  get_promotedRooms():PromotedRoomsData
        {
            return this._promotedRooms;
        }

        public function setRoomThumbnailRefreshKey(k:Int, _arg_2:String)
        {
            this._roomThumbnailRefreshKeys[k] = _arg_2;
        }

        public function getRoomThumbnailRefreshKey(k:Int):String
        {
            return this._roomThumbnailRefreshKeys[k];
        }
public function  get_roomEventData():RoomEventData
        {
            return this._roomEventData;
        }

        
        public var avatarId(get,set):Int;
public function  get_avatarId():Int
        {
            return this._avatarId;
        }

        
        public var eventMod(get,set):Bool;
public function  get_eventMod():Bool
        {
            return this._eventMod;
        }

        
        public var roomPicker(get,set):Bool;
public function  get_roomPicker():Bool
        {
            return this._roomPicker;
        }

        public var _Str_12763(get,never):Bool;
public function  get__Str_12763():Bool
        {
            return this._currentRoomOwner;
        }

        public var enteredGuestRoom(get,never):GuestRoomData;
public function  get_enteredGuestRoom():GuestRoomData
        {
            return this._enteredGuestRoom;
        }

        
        public var hcMember(get,set):Bool;
public function  get_hcMember():Bool
        {
            return this._hcMember;
        }

        
        public var createdFlatId(get,set):Int;
public function  get_createdFlatId():Int
        {
            return this._createdFlatId;
        }

        
        public var homeRoomId(get,set):Int;
public function  get_homeRoomId():Int
        {
            return this._homeRoomId;
        }

        
        public var hotRoomPopupOpen(get,set):Bool;
public function  get_hotRoomPopupOpen():Bool
        {
            return this._hotRoomPopupOpen;
        }

        
        public var _Str_15395(get,set):Int;
public function  get__Str_15395():Int
        {
            return this._currentRoomRating;
        }

        
        public var _Str_5090(get,set):Bool;
public function  get__Str_5090():Bool
        {
            return this._canRate;
        }

        
        public var _Str_17024(get,set):Bool;
public function  get__Str_17024():Bool
        {
            return this._settingsReceived;
        }

        
        public var _Str_6357(get,set):Int;
public function  get__Str_6357():Int
        {
            return this._adIndex;
        }

        
        public var _Str_8299(get,set):Bool;
public function  get__Str_8299():Bool
        {
            return this._currentRoomIsStaffPick;
        }

        
        public var currentRoomIsPublic(get,set):Bool;
public function  get_currentRoomIsPublic():Bool
        {
            return this._currentRoomIsPublic;
        }

        
        public var canPublicPick(get,set):Bool;
public function  get_canPublicPick():Bool
        {
            return this._canPublicPick;
        }

        public var _Str_20386(get,never):Int;
public function  get__Str_20386():Int
        {
            return this._currentRoomId;
        }
public function  set_avatarId(k:Int):Int        {
            return this._avatarId = k;
        }
public function  set_createdFlatId(k:Int):Int        {
            return this._createdFlatId = k;
        }
public function  set_hcMember(k:Bool):Bool        {
            return this._hcMember = k;
        }
public function  set_eventMod(k:Bool):Bool        {
            return this._eventMod = k;
        }
public function  set_roomPicker(k:Bool):Bool        {
            return this._roomPicker = k;
        }
public function  set_hotRoomPopupOpen(k:Bool):Bool        {
            return this._hotRoomPopupOpen = k;
        }
public function  set_homeRoomId(k:Int):Int        {
            return this._homeRoomId = k;
        }
public function  set__Str_15395(k:Int):Int        {
            return this._currentRoomRating = k;
        }
public function  set__Str_5090(k:Bool):Bool        {
            return this._canRate = k;
        }
public function  set__Str_17024(k:Bool):Bool        {
            return this._settingsReceived = k;
        }
public function  set__Str_6357(k:Int):Int        {
            return this._adIndex = k;
        }
public function  set__Str_8299(k:Bool):Bool        {
            return this._currentRoomIsStaffPick = k;
        }
public function  set_currentRoomIsPublic(k:Bool):Bool        {
            return this._currentRoomIsPublic = k;
        }
public function  set_canPublicPick(k:Bool):Bool        {
            return this._canPublicPick = k;
        }

        public var categories(never,set):Array<ASAny>;
public function  set_categories(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:FlatCategory = null;
            this._allCategories = k;
            this._visibleCategories = new Array<ASAny>();
            final _iter_ = this._allCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.visible)
                {
                    this._visibleCategories.push(_local_2);
                }
            }
return k;
        }

        public var allCategories(get,never):Array<ASAny>;
public function  get_allCategories():Array<ASAny>
        {
            return this._allCategories;
        }

        public var _Str_11717(get,never):Array<ASAny>;
public function  get__Str_11717():Array<ASAny>
        {
            return this._visibleCategories;
        }

        public function _Str_26045(k:Int):FlatCategory
        {
            var _local_2:FlatCategory = null;
            final _iter_ = this._allCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.nodeId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public var _Str_10701(never,set):Array<ASAny>;
public function  set__Str_10701(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:EventCategory = null;
            this._allEventCategories = k;
            this._visibleEventCategories = new Array<ASAny>();
            final _iter_ = this._allEventCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.visible)
                {
                    this._visibleEventCategories.push(_local_2);
                }
            }
return k;
        }

        public var _Str_26015(get,never):Array<ASAny>;
public function  get__Str_26015():Array<ASAny>
        {
            return this._allEventCategories;
        }

        public var _Str_8075(get,never):Array<ASAny>;
public function  get__Str_8075():Array<ASAny>
        {
            return this._visibleEventCategories;
        }

        public function _Str_26114(k:Int):EventCategory
        {
            var _local_2:EventCategory = null;
            final _iter_ = this._allCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.categoryId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_8561(k:FavouritesMessageParser)
        {
            var _local_2 = 0;
            this._favouriteLimit = k.limit;
            this._favouriteCount = k._Str_13809.length;
            this._favouriteIds = new ASDictionary<ASAny,ASAny>();
            final _iter_ = k._Str_13809; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                this._favouriteIds[_local_2] = "yes";
            }
        }

        public function _Str_21350(k:Int, _arg_2:Bool)
        {
            this._favouriteIds[k] = (_arg_2 ? "yes" : null);
            this._favouriteCount = (this._favouriteCount + (_arg_2 ? 1 : -1));
        }

        public function _Str_21092():Bool
        {
            var k= this._enteredGuestRoom.flatId;
            return !(this._favouriteIds[k] == null);
        }

        public function _Str_26257():Bool
        {
            if (this._enteredGuestRoom == null)
            {
                return false;
            }
            var k= this._enteredGuestRoom.flatId;
            return this._homeRoomId == k;
        }

        public function _Str_20543(k:Int):Bool
        {
            return !(this._favouriteIds[k] == null);
        }

        public function _Str_23152():Bool
        {
            return this._favouriteCount >= this._favouriteLimit;
        }

        public function _Str_8458(k:Int):Bool
        {
            return k == this._homeRoomId;
        }

        public function _Str_23771()
        {
            this._loading = true;
        }

        public function _Str_19838():Bool
        {
            return this._loading;
        }

        public var friendList(get,never):FriendList;
public function  get_friendList():FriendList
        {
            return this._friendList;
        }

        public function getAndResetSessionTags():RoomSessionTags
        {
            var k= this._roomSessionTags;
            this._roomSessionTags = null;
            return k;
        }

        public var roomSessionTags(never,set):RoomSessionTags;
public function  set_roomSessionTags(k:RoomSessionTags):RoomSessionTags        {
            return this._roomSessionTags = k;
        }

        
        public var _Str_4079(get,set):CompetitionRoomsData;
public function  get__Str_4079():CompetitionRoomsData
        {
            return this._competitionRoomsData;
        }
public function  set__Str_4079(k:CompetitionRoomsData):CompetitionRoomsData        {
            return this._competitionRoomsData = k;
        }
    }

