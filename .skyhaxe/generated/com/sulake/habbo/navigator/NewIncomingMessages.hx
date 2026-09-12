package com.sulake.habbo.navigator
;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.FlatControllersEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.FlatControllerAddedEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomsEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.RoomFilterSettingsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.NewNavigatorPreferencesEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsSaveErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomRatingEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.UserFlatCatsEvent;
    import com.sulake.habbo.communication.messages.incoming.competition.NoOwnedRoomsAlertMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.NavigatorLiftedRoomsEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.NavigatorSavedSearchesEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.FlatAccessibleMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.UserUnbannedFromRoomEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.MuteAllInRoomEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.CategoriesWithVisitorCountEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatAccessDeniedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomSearchResultEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.PopularRoomTagsResultEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.DoorbellMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.FlatControllerRemovedEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.NavigatorSearchResultBlocksEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsSavedEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomInfoUpdatedEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FavouriteChangedEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.BannedUsersFromRoomEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FavouritesEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.NoSuchFlatEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.CollapsedCategoriesEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CantConnectMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsDataEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.UserEventCatsEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.NavigatorMetaDataEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomEventEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.CompetitionRoomsDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCreatedEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListFragmentMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomEventCancelEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.CanCreateRoomEventEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultContainer;
    import com.sulake.habbo.navigator.domain.NavigatorData;
    import com.sulake.habbo.navigator.transitional.LegacyNavigator;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetUserFlatCatsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetUserEventCatsMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.RoomsTabPageDecorator;
    import com.sulake.habbo.communication.messages.parser.roomsettings.RoomSettingsDataMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.parser.room.session.CantConnectMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;

     class NewIncomingMessages 
    {
        var _navigator:HabboNewNavigator;
        var _messageListeners:Array<ASAny>;

        public function new(k:HabboNewNavigator)
        {
            this._messageListeners = [];
            this._navigator = k;
            var _local_2= this._navigator.communication;
            this.addMessageListeners();
        }

        public function addMessageListeners()
        {
            var k= this._navigator.communication;
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatControllersEvent(this._Str_8576)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatControllerAddedEvent(this._Str_9346)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FriendListUpdateEvent(this.onFriendListUpdate)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new OfficialRoomsEvent(this._Str_16321)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomFilterSettingsMessageEvent(this._Str_9592)));
            this._messageListeners.push({k.connection.addMessageEvent(new NewNavigatorPreferencesEvent(this.onNavigatorPreferences));ASCompat.undefinedValue();});
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomSettingsSaveErrorEvent(this._Str_8265)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomRatingEvent(this.onRoomRating)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new UserFlatCatsEvent(this._Str_16709)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new NoOwnedRoomsAlertMessageEvent(this.onNoOwnedRoomsAlert)));
            this._messageListeners.push({k.connection.addMessageEvent(new NavigatorLiftedRoomsEvent(this.onNavigatorLiftedRooms));ASCompat.undefinedValue();});
            this._messageListeners.push({k.connection.addMessageEvent(new NavigatorSavedSearchesEvent(this.onSavedSearches));ASCompat.undefinedValue();});
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatAccessibleMessageEvent(this.onDoorOpened)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new UserUnbannedFromRoomEvent(this.onUserUnbannedFromRoom)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new MuteAllInRoomEvent(this.onMuteAllEvent)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new CategoriesWithVisitorCountEvent(this._Str_18837)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatAccessDeniedMessageEvent(this.onFlatAccessDenied)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new GuestRoomSearchResultEvent(this.onGuestRoomSearch)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new PopularRoomTagsResultEvent(this._Str_17226)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new DoorbellMessageEvent(this.onDoorbell)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatControllerRemovedEvent(this._Str_8484)));
            this._messageListeners.push({k.connection.addMessageEvent(new NavigatorSearchResultBlocksEvent(this.onNavigatorSearchResultBlocks));ASCompat.undefinedValue();});
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomSettingsSavedEvent(this.onRoomSettingsSaved)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomInfoUpdatedEvent(this._Str_18125)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomSettingsErrorEvent(this._Str_18344)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new CloseConnectionMessageEvent(this.onRoomExit)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FavouriteChangedEvent(this._Str_16972)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new BannedUsersFromRoomEvent(this._Str_8907)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FavouritesEvent(this._Str_8561)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new NoSuchFlatEvent(this.onNoSuchFlat)));
            this._messageListeners.push({k.connection.addMessageEvent(new CollapsedCategoriesEvent(this._Str_18969));ASCompat.undefinedValue();});
            this._messageListeners.push({k.connection.addMessageEvent(new HabboGroupDetailsMessageEvent(this.onGroupDetails));ASCompat.undefinedValue();});
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new CantConnectMessageEvent(this.onCantConnect)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomSettingsDataEvent(this._Str_16485)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new UserEventCatsEvent(this._Str_15947)));
            this._messageListeners.push({k.connection.addMessageEvent(new NavigatorMetaDataEvent(this.onNavigatorMetaData));ASCompat.undefinedValue();});
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomEventEvent(this._Str_17647)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new CompetitionRoomsDataMessageEvent(this.onCompetitionData)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FlatCreatedEvent(this.onFlatCreated)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new FriendListFragmentMessageEvent(this.onFriendsListFragment)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new RoomEventCancelEvent(this.onRoomEventCancel)));
            this._messageListeners.push(k.addHabboConnectionMessageEvent(new CanCreateRoomEventEvent(this._Str_17011)));
        }

        public function removeLegacyMessageListeners()
        {
            var _local_2:IMessageEvent = null;
            var k= this._navigator.communication;
            final _iter_ = this._messageListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.removeHabboConnectionMessageEvent(_local_2);
            }
            this._messageListeners = [];
        }

        function onNavigatorMetaData(k:NavigatorMetaDataEvent)
        {
            this._navigator.initialize(k.getParser());
        }

        function onNavigatorSearchResultBlocks(k:NavigatorSearchResultBlocksEvent)
        {
            this._navigator.onSearchResult(new SearchResultContainer(k.getParser().searchResult));
        }

        function onNavigatorLiftedRooms(k:NavigatorLiftedRoomsEvent)
        {
            this._navigator.onLiftedRooms(k.getParser());
        }

        function onNavigatorPreferences(k:NewNavigatorPreferencesEvent)
        {
            this._navigator._Str_23415(k.getParser());
        }

        function onSavedSearches(k:NavigatorSavedSearchesEvent)
        {
            this._navigator.onSavedSearches(k.getParser());
        }

        function onGroupDetails(k:HabboGroupDetailsMessageEvent)
        {
            this._navigator.onGroupDetails(k.data);
        }

        function _Str_18969(k:CollapsedCategoriesEvent)
        {
            this._navigator._Str_18969(k.getParser()._Str_8273);
        }

        var data(get,never):NavigatorData;
function  get_data():NavigatorData
        {
            return this._navigator.data;
        }

        function onMuteAllEvent(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , MuteAllInRoomEvent);
            var _local_3= _local_2.getParser();
            var _local_4= this._navigator.data.enteredGuestRoom;
            if (_local_4 != null)
            {
                _local_4.allInRoomMuted = _local_3._Str_20186;
                if (cast(this._navigator.legacyNavigator, LegacyNavigator).roomInfoViewCtrl != null)
                {
                    cast(this._navigator.legacyNavigator, LegacyNavigator).roomInfoViewCtrl.refreshButtons(this._navigator.data.enteredGuestRoom);
                }
            }
        }

        function onNoSuchFlat(k:IMessageEvent)
        {
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= cast(k, UserObjectEvent).getParser();
            this._navigator.data.avatarId = _local_2.id;
            cast(this._navigator.legacyNavigator, LegacyNavigator).send(new GetUserFlatCatsMessageComposer());
            cast(this._navigator.legacyNavigator, LegacyNavigator).send(new GetUserEventCatsMessageComposer());
        }

        function onUserRights(k:IMessageEvent)
        {
            var _local_2:UserRightsMessageEvent = null;
            if (this._navigator != null)
            {
                _local_2 = cast(k, UserRightsMessageEvent);
                if (_local_2.securityLevel >= SecurityLevelEnum.MODERATOR)
                {
                    this._navigator.data.eventMod = true;
                }
                if (_local_2.securityLevel >= SecurityLevelEnum.COMMUNITY)
                {
                    this._navigator.data.roomPicker = true;
                }
            }
        }

        function _Str_18837(k:IMessageEvent)
        {
            var _local_2= cast(k, CategoriesWithVisitorCountEvent).getParser();
            this.data._Str_7267 = _local_2.data;
            Logger.log([("Received Categories with user count: " + Std.string(this.data._Str_7267.categoryToCurrentUserCountMap.length))]);
        }

        function _Str_16321(k:IMessageEvent)
        {
            var _local_2= cast(k, OfficialRoomsEvent).getParser();
            this.data._Str_5645 = _local_2.data;
            this.data._Str_5653 = _local_2._Str_5653;
            this.data.promotedRooms = _local_2.promotedRooms;
            Logger.log([("Received Official rooms: " + Std.string(this.data._Str_5645.entries.length))]);
        }

        function onGuestRoomSearch(k:IMessageEvent)
        {
            var _local_2= cast(k, GuestRoomSearchResultEvent).getParser().data;
            this.data.guestRoomSearchResults = _local_2;
            Logger.log([("Received GuestRoomSearch: " + ((this.data.guestRoomSearchResults.rooms != null) ? Std.string(this.data.guestRoomSearchResults.rooms.length) : " no rooms"))]);
        }

        function _Str_17226(k:IMessageEvent)
        {
            var _local_2= cast(k, PopularRoomTagsResultEvent).getParser().data;
            this.data._Str_6697 = _local_2;
            Logger.log([("Received popular room tags: " + Std.string(this.data._Str_6697.tags.length))]);
        }

        function _Str_17647(k:IMessageEvent)
        {
            var _local_2= cast(k, RoomEventEvent).getParser();
            Logger.log([((("Got room event: " + Std.string(_local_2.data._Str_13361)) + ", ") + _local_2.data.eventName)]);
            this.data.roomEventData = ((_local_2.data._Str_13361 > 0) ? _local_2.data : null);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomEventInfoCtrl.refresh();
        }

        function onRoomEventCancel(k:IMessageEvent)
        {
            this.data.roomEventData = null;
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomEventInfoCtrl.refresh();
        }

        function _Str_17011(k:IMessageEvent)
        {
            var _local_3:SimpleAlertView = null;
            var _local_2= cast(k, CanCreateRoomEventEvent).getParser();
            Logger.log([("CAN CREATE EVENT: " + Std.string(_local_2._Str_13420))]);
            if (_local_2._Str_13420)
            {
                cast(this._navigator.legacyNavigator, LegacyNavigator).roomEventViewCtrl.show();
            }
            else
            {
                _local_3 = new SimpleAlertView(cast(this._navigator.legacyNavigator, LegacyNavigator), "${navigator.cannotcreateevent.title}", (("${navigator.cannotcreateevent.error." + Std.string(_local_2.errorCode)) + "}"));
                _local_3.show();
                Logger.log(["Cannot create an event just now..."]);
            }
        }

        function _Str_19492()
        {
            if (this._navigator.getProperty("roomenterad.habblet.enabled") == "true")
            {
                HabboWebTools.openRoomEnterAd();
            }
        }

        function onFlatCreated(k:IMessageEvent)
        {
            var _local_2= cast(k, FlatCreatedEvent).getParser();
            ErrorReportStorage.addDebugData("IncomingEvent", ((("Flat created: " + Std.string(_local_2.flatId)) + ", ") + _local_2._Str_18439));
            this.data.createdFlatId = _local_2.flatId;
            // Close the active new-navigator creation UI before room entry or
            // result refresh can interrupt the remainder of this callback.
            cast(this._navigator.legacyNavigator, LegacyNavigator).goToMainView();
            cast(this._navigator.legacyNavigator, LegacyNavigator).closeNavigator();
            cast(this._navigator.legacyNavigator, LegacyNavigator).goToRoom(_local_2.flatId, true);
            cast(this._navigator.legacyNavigator, LegacyNavigator).mainViewCtrl.reloadRoomList(Tabs.SEARCHTYPE_MY_ROOMS);
        }

        function _Str_22297(k:IMessageEvent)
        {
            cast(this._navigator.legacyNavigator, LegacyNavigator).mainViewCtrl.close();
        }

        function onRoomExit(k:IMessageEvent)
        {
            Logger.log(["Navigator: exiting room"]);
            this.data.onRoomExit();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomInfoViewCtrl.close();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomEventInfoCtrl.close();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomEventViewCtrl.close();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl.close();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomFilterCtrl.close();
            var _local_2= this._navigator.getBoolean("news.auto_popup.enabled");
            if (_local_2)
            {
                HabboWebTools.openNews();
            }
        }

        function _Str_16709(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserFlatCatsEvent).getParser();
            this._navigator.data.categories = _local_2.nodes;
            var _local_3= cast(cast(this._navigator.legacyNavigator, LegacyNavigator).tabs.getTab(Tabs.TAB_ROOMS)._Str_5252, RoomsTabPageDecorator);
            _local_3.prepareRoomCategories();
        }

        function _Str_15947(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserEventCatsEvent).getParser();
            this._navigator.data._Str_10701 = _local_2._Str_10701;
        }

        function _Str_16485(event:IMessageEvent)
        {
            var parser:RoomSettingsDataMessageParser = null;
            try
            {
                parser = Std.downcast(event , RoomSettingsDataEvent).getParser();
                cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl.onRoomSettings(parser.data);
                Logger.log([((((("GOT ROOM SETTINGS DATA: " + parser.data.name) + ", ") + Std.string(parser.data.maximumVisitors)) + ", ") + Std.string(parser.data._Str_13128))]);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["CRASHED WHILE PROCESSING ROOM SETTINGS DATA!"]);
            }
 }        }

        function _Str_9592(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomFilterSettingsMessageEvent).getParser();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomFilterCtrl._Str_9592(_local_2.badWords);
            Logger.log([("GOT ROOM FILTER SETTINGS: " + ASCompat.toString(_local_2.badWords))]);
        }

        function _Str_18344(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomSettingsErrorEvent).getParser();
        }

        function onRoomSettingsSaved(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomSettingsSavedEvent).getParser();
            ErrorReportStorage.addDebugData("IncomingEvent", ("Room settings saved: " + Std.string(_local_2.roomId)));
            cast(this._navigator.legacyNavigator, LegacyNavigator).mainViewCtrl.reloadRoomList(Tabs.SEARCHTYPE_MY_ROOMS);
        }

        function _Str_8265(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomSettingsSaveErrorEvent).getParser();
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl._Str_8265(_local_2.roomId, _local_2.errorCode, _local_2.info);
        }

        function _Str_18125(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomInfoUpdatedEvent).getParser();
            Logger.log([("ROOM UPDATED: " + Std.string(_local_2.flatId))]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).send(new GetGuestRoomMessageComposer(_local_2.flatId, false, false));
        }

        function _Str_8561(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FavouritesEvent).getParser();
            Logger.log([((("Received favourites: " + Std.string(_local_2.limit)) + ", ") + Std.string(_local_2._Str_13809.length))]);
            this._navigator.data._Str_8561(_local_2);
        }

        function _Str_16972(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FavouriteChangedEvent).getParser();
            Logger.log([((("Received favourite changed: " + Std.string(_local_2.flatId)) + ", ") + Std.string(_local_2._Str_13819))]);
            this.data._Str_21350(_local_2.flatId, _local_2._Str_13819);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomInfoViewCtrl.reload();
            cast(this._navigator.legacyNavigator, LegacyNavigator).mainViewCtrl.refresh();
        }

        function _Str_8576(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FlatControllersEvent).getParser();
            Logger.log([((("Got flat controllers: " + Std.string(_local_2.roomId)) + ", ") + Std.string(_local_2.controllers.length))]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl._Str_8576(_local_2.roomId, _local_2.controllers);
        }

        function _Str_9346(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FlatControllerAddedEvent).getParser();
            Logger.log([((((("Flat controller added: " + Std.string(_local_2.flatId)) + ", ") + Std.string(_local_2.data.userId)) + ", ") + _local_2.data.userName)]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl._Str_9346(_local_2.flatId, _local_2.data);
        }

        function _Str_8484(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FlatControllerRemovedEvent).getParser();
            Logger.log([((("Flat controller removed: " + Std.string(_local_2.flatId)) + ", ") + Std.string(_local_2.userId))]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl._Str_8484(_local_2.flatId, _local_2.userId);
        }

        function _Str_8907(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , BannedUsersFromRoomEvent).getParser();
            Logger.log([((("Got Banned users for room: " + Std.string(_local_2.roomId)) + ", ") + Std.string(_local_2._Str_14901.length))]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl._Str_8907(_local_2.roomId, _local_2._Str_14901);
        }

        function onUserUnbannedFromRoom(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserUnbannedFromRoomEvent).getParser();
            Logger.log([((("User was unbanned from room. User Id: " + Std.string(_local_2.userId)) + " Room Id: ") + Std.string(_local_2.roomId))]);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl.onUserUnbannedFromRoom(_local_2.roomId, _local_2.userId);
        }

        function onDoorbell(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , DoorbellMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.userName != "")
            {
                return;
            }
            cast(this._navigator.legacyNavigator, LegacyNavigator).doorbell.showWaiting();
        }

        function onDoorOpened(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FlatAccessibleMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (((!(_local_3 == null)) && ((_local_3.userName == null) || (_local_3.userName.length == 0))))
            {
                cast(this._navigator.legacyNavigator, LegacyNavigator).doorbell.hide();
            }
        }

        function onRoomRating(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomRatingEvent).getParser();
            Logger.log([("Received room rating: " + Std.string(_local_2.rating))]);
            this.data._Str_15395 = _local_2.rating;
            this.data._Str_5090 = _local_2._Str_5090;
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomInfoViewCtrl.reload();
        }

        function onFlatAccessDenied(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FlatAccessDeniedMessageEvent).getParser();
            if (((_local_2.userName == null) || (_local_2.userName == "")))
            {
                cast(this._navigator.legacyNavigator, LegacyNavigator).doorbell.showNoAnswer();
            }
        }

        function onFriendsListFragment(k:IMessageEvent)
        {
            this.data.friendList.onFriendsListFragment(k);
        }

        function onFriendListUpdate(k:IMessageEvent)
        {
            this.data.friendList.onFriendListUpdate(k);
            cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl.onFriendListUpdate();
        }

        function onCompetitionData(k:CompetitionRoomsDataMessageEvent)
        {
            this.data._Str_4079 = k.getParser().data;
        }

        function forwardToRoom(k:Int)
        {
            cast(this._navigator.legacyNavigator, LegacyNavigator).send(new GetGuestRoomMessageComposer(k, false, true));
            cast(this._navigator.legacyNavigator, LegacyNavigator).trackNavigationDataPoint("Room Forward", "go.roomforward", "", k);
        }

        function onNoOwnedRoomsAlert(k:NoOwnedRoomsAlertMessageEvent)
        {
            cast(this._navigator.legacyNavigator, LegacyNavigator).startRoomCreation();
        }

        function closeOpenCantConnectAlerts()
        {
            var k:Array<ASAny> = null;
            var _local_2:IWindowContext = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IWindow = null;
            var _local_6:IWindow = null;
            var _local_7:AlertView = null;
            if (this._navigator != null)
            {
                k = new Array<ASAny>();
                _local_2 = this._navigator.windowManager.getWindowContext(2);
                _local_3 = _local_2.getDesktopWindow().numChildren;
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_5 = _local_2.getDesktopWindow().getChildAt(_local_4);
                    if (_local_5.tags.indexOf("SimpleAlertView") > -1)
                    {
                        k.push(_local_5);
                    }
                    _local_4++;
                }
                if (k.length > 0)
                {
                    if (checkNullIteratee(k)) for (_tmp_ in k)
                    {
_local_6  = _tmp_;
                        _local_7 = AlertView._Str_22232(_local_6);
                        if (_local_7 != null)
                        {
                            _local_7.dispose();
                        }
                    }
                }
            }
        }

        function onCantConnect(k:IMessageEvent)
        {
            var _local_3:SimpleAlertView = null;
            var _local_2= Std.downcast(k , CantConnectMessageEvent).getParser();
            Logger.log([("FAILED TO CONNECT: REASON: " + Std.string(_local_2.reason))]);
            switch (_local_2.reason)
            {
                case CantConnectMessageParser.REASON_FULL:
                    _local_3 = new SimpleAlertView(cast(this._navigator.legacyNavigator, LegacyNavigator), "${navigator.guestroomfull.title}", "${navigator.guestroomfull.text}");
                    _local_3.show();
                    
                case CantConnectMessageParser.REASON_QUEUE_ERROR:
                    _local_3 = new SimpleAlertView(cast(this._navigator.legacyNavigator, LegacyNavigator), "${room.queue.error.title}", (("${room.queue.error." + _local_2.parameter) + "}"));
                    _local_3.show();
                    
                case CantConnectMessageParser.REASON_BANNED:
                    _local_3 = new SimpleAlertView(cast(this._navigator.legacyNavigator, LegacyNavigator), "${navigator.banned.title}", "${navigator.banned.text}");
                    _local_3.show();
                    
                default:
                    _local_3 = new SimpleAlertView(cast(this._navigator.legacyNavigator, LegacyNavigator), "${room.queue.error.title}", "${room.queue.error.title}");
                    _local_3.show();
            }
            cast(this._navigator.legacyNavigator, LegacyNavigator).send(new QuitMessageComposer());
            var _local_4= new HabboToolbarEvent(HabboToolbarEvent.HTE_TOOLBAR_CLICK);
            _local_4.iconId = HabboToolbarIconEnum.RECEPTION;
            cast(this._navigator.legacyNavigator, LegacyNavigator).toolbar.events.dispatchEvent(_local_4);
        }
    }

