package com.sulake.habbo.navigator.view
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.session._enum.RoomTradingLevelEnum;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.navigator.roomsettings.RoomSettingsCtrl;
    import com.sulake.habbo.navigator.transitional.LegacyNavigator;
    import com.sulake.habbo.communication.messages.outgoing.navigator.AddFavouriteRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.DeleteFavouriteRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.UpdateHomeRoomMessageComposer;

     class RoomInfoPopup 
    {
        var _window:IWindowContainer;
        var _navigator:HabboNewNavigator;
        var _displayedTags:Vector<String>;
        var _guestRoomData:GuestRoomData = null;
        var _lastWindowPosition:Point;
        var _roomHomeAltered:Bool = false;
        var _roomHomeAlteredValue:Bool = false;
        var _roomFavoriteAltered:Bool = false;
        var _roomFavoriteAlteredValue:Bool = false;

        public function new(k:HabboNewNavigator)
        {
            this._displayedTags = new Vector<String>(0);
            this._lastWindowPosition = new Point(-1, -1);
            this._navigator = k;
        }

        public function show(k:Bool)
        {
            if (k)
            {
                if (this._window == null)
                {
                    this.createWindow();
                }
                this.populate();
                this._window.visible = true;
                this._roomHomeAltered = false;
                this._roomFavoriteAltered = false;
            }
            else
            {
                if (this._window != null)
                {
                    this._window.visible = false;
                }
            }
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            if (this._window == null)
            {
                return false;
            }
            return this._window.visible;
        }

        public function _Str_23392(k:Bool, _arg_2:Int, _arg_3:Int)
        {
            var _local_5:Point = null;
            var _local_4:ASAny = (!this.visible);
            this.show(k);
            if (k)
            {
                _local_5 = new Point(_arg_2, (_arg_3 - (this._window.height / 2)));
                if (this._lastWindowPosition != _local_5)
                {
                    if (((ASCompat.toBool(_local_4) && k) && (this._guestRoomData != null)))
                    {
                        this._navigator.trackEventLog("browse.openroominfo", "Results", this._guestRoomData.roomName, this._guestRoomData.flatId);
                    }
                }
                this.position = _local_5;
                this._window.activate();
            }
        }

        public function _Str_5479(k:GuestRoomData)
        {
            this._guestRoomData = k;
        }

        public function getGlobalRectangle(k:Rectangle)
        {
            this._window.getGlobalRectangle(k);
        }

        var position(never,set):Point;
function  set_position(k:Point):Point        {
            this._window.position = k;
            return this._lastWindowPosition = k;
        }

        
        var _Str_11907(get,set):Bool;
function  get__Str_11907():Bool
        {
            if (this._roomHomeAltered)
            {
                return this._roomHomeAlteredValue;
            }
            return this._navigator.legacyNavigator._Str_8458(this._guestRoomData.flatId);
        }
function  set__Str_11907(k:Bool):Bool        {
            this._roomHomeAltered = true;
            return this._roomHomeAlteredValue = k;
        }

        
        var _Str_9158(get,set):Bool;
function  get__Str_9158():Bool
        {
            if (this._roomFavoriteAltered)
            {
                return this._roomFavoriteAlteredValue;
            }
            return this._navigator.legacyNavigator._Str_12281(this._guestRoomData.flatId);
        }
function  set__Str_9158(k:Bool):Bool        {
            this._roomFavoriteAltered = true;
            return this._roomFavoriteAlteredValue = k;
        }

        function populate()
        {
            var _local_8:HabboGroupDetailsData = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_12:IStaticBitmapWrapperWindow = null;
            if (this._guestRoomData == null)
            {
                return;
            }
            var k= cast(this._window.findChildByName("main_content"), IItemListWindow);
            var _local_2= cast(this._window.findChildByName("header_content"), IItemListWindow);
            var _local_3= cast(this._window.findChildByName("bottom_itemlist"), IItemListWindow);
            this._window.findChildByName("room_owner_region").visible = this._guestRoomData.showOwner;
            this._window.findChildByName("room_group_region").visible = (!(this._guestRoomData.groupBadgeCode == ""));
            this._window.findChildByName("room_name").caption = this._guestRoomData.roomName;
            this._window.findChildByName("room_desc").caption = this._guestRoomData.description;
            this._window.findChildByName("owner_name").caption = this._guestRoomData.ownerName;
            this._window.findChildByName("room_owner_region").id = this._guestRoomData.ownerId;
            this._window.findChildByName("room_owner_region").procedure = this._Str_24359;
            this._window.findChildByName("favorite_region").procedure = this._Str_24499;
            this._window.findChildByName("home_region").procedure = this._Str_24346;
            this._window.findChildByName("settings_region").procedure = this._Str_23718;
            this._window.findChildByName("settings_container").visible = (this._guestRoomData.ownerName == this._navigator.sessionData.userName);
            if ((this._navigator.context.configuration.getBoolean("room.report.enabled") && (!(this._guestRoomData.ownerName == this._navigator.sessionData.userName))))
            {
                this._window.findChildByName("report_region").id = this._guestRoomData.ownerId;
                this._window.findChildByName("report_region").procedure = this._Str_24003;
                this._window.findChildByName("report_region").visible = true;
                this._window.findChildByName("report_container").visible = true;
            }
            else
            {
                this._window.findChildByName("report_region").visible = false;
                this._window.findChildByName("report_container").visible = false;
            }
            cast(this._window.findChildByName("midBottom_itemlist"), IItemListWindow).arrangeListItems();
            this._Str_25725();
            cast(this._window.findChildByName("favorite_icon"), IStaticBitmapWrapperWindow).assetUri = ("newnavigator_icon_fav_" + (this._Str_9158 ? "yes" : "no"));
            cast(this._window.findChildByName("home_icon"), IStaticBitmapWrapperWindow).assetUri = ("newnavigator_icon_home_" + (this._Str_11907 ? "yes" : "no"));
            var _local_4:ASAny = (!(this._guestRoomData.groupBadgeCode == ""));
            this._window.findChildByName("room_group_badge").visible = _local_4;
            this._window.findChildByName("room_owner_region").visible = this._guestRoomData.showOwner;
            this._window.findChildByName("room_group_region").visible = _local_4;
            this._window.findChildByName("room_group_owner_container").visible = (ASCompat.toBool(_local_4) || this._guestRoomData.showOwner);
            if (_local_4)
            {
                cast(cast(this._window.findChildByName("room_group_badge"), IWidgetWindow).widget, IBadgeImageWidget).badgeId = this._guestRoomData.groupBadgeCode;
                this._window.findChildByName("group_name").caption = this._guestRoomData.groupName;
                this._window.findChildByName("group_name").id = this._guestRoomData.habboGroupId;
                this._window.findChildByName("room_group_region").id = this._guestRoomData.habboGroupId;
                this._window.findChildByName("room_group_region").procedure = this._Str_25360;
                _local_8 = this._navigator._Str_20693(this._guestRoomData.habboGroupId);
                if (_local_8 != null)
                {
                    if (_local_8.isOwner)
                    {
                        cast(this._window.findChildByName("group_mode_admin"), IStaticBitmapWrapperWindow).assetUri = "newnavigator_icon_group_owner";
                    }
                    else
                    {
                        if (_local_8.isAdmin)
                        {
                            cast(this._window.findChildByName("group_mode_admin"), IStaticBitmapWrapperWindow).assetUri = "newnavigator_icon_group_admin";
                        }
                        else
                        {
                            cast(this._window.findChildByName("group_mode_admin"), IStaticBitmapWrapperWindow).assetUri = null;
                        }
                    }
                    cast(this._window.findChildByName("group_mode_size"), IStaticBitmapWrapperWindow).assetUri = (("${image.library.url}guilds/grouptype_icon_" + Std.string(_local_8.type)) + ".png");
                    cast(this._window.findChildByName("group_mode_furnish"), IStaticBitmapWrapperWindow).assetUri = (_local_8._Str_17307 ? "${image.library.url}guilds/group_decorate_icon.png" : null);
                }
            }
            else
            {
                cast(this._window.findChildByName("group_mode_admin"), IStaticBitmapWrapperWindow).assetUri = null;
                cast(this._window.findChildByName("group_mode_size"), IStaticBitmapWrapperWindow).assetUri = null;
                cast(this._window.findChildByName("group_mode_furnish"), IStaticBitmapWrapperWindow).assetUri = null;
            }
            var _local_5:ASAny = (this._guestRoomData.roomAdExpiresInMin > 0);
            if (_local_5)
            {
                _local_9 = ((this._navigator.localization.getLocalizationWithParams("navigator.eventsettings.name") + ": ") + this._guestRoomData.roomAdName);
                _local_10 = (((this._navigator.localization.getLocalizationWithParams("navigator.eventsettings.desc") + ": ") + this._guestRoomData.roomAdDescription) + "\n");
                _local_10 = (_local_10 + (this._navigator.localization.getLocalizationWithParams("roomad.event.expiration_time") + FriendlyTime.format(this._navigator.localization, (this._guestRoomData.roomAdExpiresInMin * 60))));
                this._window.findChildByName("event_name").caption = _local_9;
                this._window.findChildByName("event_desc").caption = _local_10;
            }
            _local_3.getListItemByName("event_info").visible = _local_5;
            _local_2.arrangeListItems();
            this._displayedTags = new Vector<String>(0);
            var _local_6= cast(this._window.findChildByName("tag_list"), IItemListWindow);
            _local_6.destroyListItems();
            var _local_7 = 0;
            while (_local_7 < this._guestRoomData.tags.length)
            {
                this._displayedTags.push(this._guestRoomData.tags[_local_7]);
                _local_6.addListItem(this._Str_25580(this._guestRoomData.tags[_local_7], _local_7));
                _local_7++;
            }
            this._Str_25406();
            this._Str_16458("properties", "${navigator.roompopup.property.trading}", RoomTradingLevelEnum._Str_22614(this._guestRoomData.tradeMode));
            if (this._navigator.context.configuration.getBoolean("room.ranking.enabled"))
            {
                this._Str_16458("properties", "${navigator.roompopup.property.ranking}", Std.string(this._guestRoomData.ranking));
            }
            this._Str_16458("properties", "${navigator.roompopup.property.max_users}", Std.string(this._guestRoomData.maxUserCount));
            _local_12 = cast(this._window.findChildByName("room_thumbnail"), IStaticBitmapWrapperWindow);
            _local_11 = "newnavigator_default_room";
            if (this._navigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_ROOM_THUMBNAIL_CAMERA))
            {
                if (this._guestRoomData.officialRoomPicRef != null)
                {
                    if (this._navigator.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))
                    {
                        _local_11 = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(this._guestRoomData.flatId)) + ".png");
                    }
                    else
                    {
                        _local_11 = (this._navigator.getProperty("image.library.url") + this._guestRoomData.officialRoomPicRef);
                    }
                }
                else
                {
                    _local_11 = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(this._guestRoomData.flatId)) + ".png");
                }
            }
            _local_9 = this._navigator.data.getRoomThumbnailRefreshKey(this._guestRoomData.flatId);
            if (((!(_local_9 == null)) && (!(_local_9 == "")) && (!(_local_11 == "newnavigator_default_room"))))
            {
                _local_11 = (_local_11 + ("?v=" + _local_9));
            }
            if (_local_12.assetUri == _local_11)
            {
                _local_12.assetUri = null;
            }
            _local_12.assetUri = _local_11;
            _local_3.arrangeListItems();
            k.arrangeListItems();
        }

        function _Str_25406()
        {
            cast(this._window.findChildByName("properties"), IItemListWindow).destroyListItems();
        }

        function _Str_25725()
        {
            var k= cast(this._window.findChildByName("settings_container"), IWindowContainer);
            if (!k.visible)
            {
                return;
            }
            var _local_2= cast(this._window.findChildByName("settings_region"), IRegionWindow);
            var _local_3= new Rectangle();
            k.getGlobalRectangle(_local_3);
            _local_2.setGlobalRectangle(_local_3);
        }

        function _Str_16458(k:String, _arg_2:String, _arg_3:String)
        {
            var _local_4= cast(this._window.findChildByName(k), IItemListWindow);
            var _local_5= cast(this._navigator.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._navigator.assets.getAssetByName("property_xml").content)), IWindowContainer);
            _local_5.findChildByName("property_name").caption = _arg_2;
            _local_5.findChildByName("property_value").caption = _arg_3;
            _local_4.addListItem(_local_5);
        }

        function _Str_25580(k:String, _arg_2:Int):IWindow
        {
            var _local_3= cast(this._navigator.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._navigator.assets.getAssetByName("tag_xml").content)), IWindowContainer);
            var _local_4= cast(_local_3.findChildByName("tag_region"), IRegionWindow);
            _local_4.id = _arg_2;
            _local_4.procedure = this._Str_22669;
            _local_4.findChildByName("tag_text").caption = ("#" + k);
            return _local_4;
        }

        function createWindow()
        {
            this._window = cast(this._navigator.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._navigator.assets.getAssetByName("room_info_popup_bubble_xml").content)), IWindowContainer);
        }

        function _Str_24359(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator._Str_12024(_arg_2.id);
                this.destroy();
            }
        }

        function _Str_25360(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator.getGuildInfo(_arg_2.id);
                this.destroy();
            }
        }

        function _Str_24003(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator.habboHelp.reportRoom(this._guestRoomData.flatId, this._guestRoomData.roomName, this._guestRoomData.description);
                this.destroy();
            }
        }

        function _Str_22669(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator.performTagSearch(this._displayedTags[_arg_2.id]);
                this.destroy();
            }
        }

        function _Str_23718(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:RoomSettingsCtrl = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = cast(this._navigator.legacyNavigator, LegacyNavigator).roomSettingsCtrl;
                _local_3.startRoomSettingsEditFromNavigator(this._guestRoomData.flatId, this._guestRoomData.habboGroupId);
                this.destroy();
            }
        }

        function _Str_24499(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (!this._Str_9158)
                {
                    this._navigator.communication.connection.send(new AddFavouriteRoomMessageComposer(this._guestRoomData.flatId));
                    this._Str_9158 = true;
                }
                else
                {
                    this._navigator.communication.connection.send(new DeleteFavouriteRoomMessageComposer(this._guestRoomData.flatId));
                    this._Str_9158 = false;
                }
                cast(this._window.findChildByName("favorite_icon"), IStaticBitmapWrapperWindow).assetUri = ("newnavigator_icon_fav_" + (this._Str_9158 ? "yes" : "no"));
            }
        }

        function _Str_24346(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (!this._Str_11907)
                {
                    this._navigator.communication.connection.send(new UpdateHomeRoomMessageComposer(this._guestRoomData.flatId));
                    this._Str_11907 = true;
                }
                cast(this._window.findChildByName("home_icon"), IStaticBitmapWrapperWindow).assetUri = ("newnavigator_icon_home_" + (this._Str_11907 ? "yes" : "no"));
            }
        }

        function destroy()
        {
            if (this._window != null)
            {
                this._window.destroy();
            }
            this._window = null;
        }
    }













