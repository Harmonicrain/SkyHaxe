package com.sulake.habbo.navigator.inroom
;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.habbo.navigator.GuildInfoCtrl;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.navigator.TagRenderer;
    import flash.events.Event;
    import com.sulake.habbo.navigator.events.HabboRoomSettingsTrackingEvent;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.SimpleAlertView;
    import com.sulake.habbo.communication.messages.outgoing.navigator.AddFavouriteRoomMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.DeleteFavouriteRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.MuteAllInRoomComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.UpdateHomeRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.ToggleStaffPickMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.TogglePublicRoomMessageComposer;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;

     class RoomInfoViewCtrl
    {
        var _navigator:IHabboTransitionalNavigator;
        var _guildInfoCtrl:GuildInfoCtrl;
        var _window:IFrameWindow;
        var _tagRenderer:TagRenderer;
        var _embedExpanded:Bool = false;
        var _visible:Bool = false;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
            this._guildInfoCtrl = new GuildInfoCtrl(this._navigator);
            this._tagRenderer = new TagRenderer(this._navigator);
        }

        public function dispose()
        {
            this._navigator = null;
            this._visible = false;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._tagRenderer != null)
            {
                this._tagRenderer.dispose();
                this._tagRenderer = null;
            }
            if (this._guildInfoCtrl != null)
            {
                this._guildInfoCtrl.dispose();
                this._guildInfoCtrl = null;
            }
        }

        public function close()
        {
            if (this._window == null)
            {
                return;
            }
            this._visible = false;
            this._window.dispose();
            this._window = null;
            this._navigator.events.dispatchEvent(new Event(HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_CLOSED));
        }

        public function reload()
        {
            if (this._visible)
            {
                this.refresh();
            }
        }

        public function toggle()
        {
            if (this._visible)
            {
                this._visible = false;
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
            }
            else
            {
                this._visible = true;
                this.refresh();
                if (this._window != null)
                {
                    this._window.activate();
                }
            }
        }

        function refresh()
        {
            if (this._navigator.data.enteredGuestRoom == null)
            {
                return;
            }
            this._tagRenderer._Str_8651 = true;
            this.prepareWindow();
            Util.hideChildren(this._window.content);
            this.refreshRoomDetails(this._navigator.data.enteredGuestRoom);
            this.refreshEmbed();
            this._guildInfoCtrl.refresh(this._window.content, this._navigator.data.enteredGuestRoom);
            this.refreshButtons(this._navigator.data.enteredGuestRoom);
            Util.moveChildrenToColumn(this._window.content, ["room_details", "public_space_details", "guild_info", "embed_info", "buttons_cont"], 0, 3);
            this._window.findChildByName("guild_info").x = 11;
            this._window.height = (Util.getLowestPoint(this._window.content) + 45);
        }

        function isHome(k:GuestRoomData):Bool
        {
            return (!(k == null)) && (k.flatId == this._navigator.data.homeRoomId);
        }

        function refreshEmbed()
        {
            var _local_4:ITextWindow = null;
            var _local_5:ITextFieldWindow = null;
            var _local_6:IWindow = null;
            var k= cast(this.find("embed_info"), IWindowContainer);
            var _local_2= this._navigator.getBoolean("embed.showInRoomInfo");
            var _local_3:ASAny = (!(this._navigator.data.enteredGuestRoom == null));
            if ((ASCompat.toBool(_local_3) && _local_2))
            {
                _local_4 = cast(k.findChildByName("embed_info_txt"), ITextWindow);
                _local_5 = cast(k.findChildByName("embed_src_txt"), ITextFieldWindow);
                _local_6 = k.findChildByName("embed_info_region");
                k.visible = true;
                if (this._embedExpanded)
                {
                    _local_5.text = this.getEmbedData();
                }
                _local_4.visible = this._embedExpanded;
                _local_5.visible = this._embedExpanded;
                _local_6.visible = false;
                k.height = (Util.getLowestPoint(k) + 5);
                _local_6.visible = true;
                _local_6.height = (this._embedExpanded ? _local_5.y : k.height);
            }
            else
            {
                k.visible = false;
            }
        }

        function refreshRoomDetails(k:GuestRoomData)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= cast(this.find("room_details"), IWindowContainer);
            var _local_3= cast(this.find("room_name"), ITextWindow);
            _local_3.text = k.roomName;
            _local_3.height = Std.int(_local_3.textHeight + 5);
            var _local_4= cast(this.find("owner_name"), ITextWindow);
            if ((k.showOwner && (k.ownerId > 0)))
            {
                this.find("owner_name_cont").visible = true;
                _local_4.visible = true;
                _local_4.text = k.ownerName;
                _Str_3521._Str_3927(false, _local_2);
            }
            else
            {
                this.find("owner_name_cont").visible = false;
            }
            var _local_5= cast(this.find("room_desc"), ITextWindow);
            _local_5.text = k.description;
            this._tagRenderer._Str_19120(_local_2, k.tags);
            _local_5.visible = false;
            if (k.description != "")
            {
                _local_5.height = Std.int(_local_5.textHeight + 5);
                _local_5.visible = true;
            }
            this.find("rating_region").visible = this._navigator.data._Str_5090;
            cast(this.find("rating_txt"), ITextWindow).text = ("" + Std.string(this._navigator.data._Str_15395));
            var _local_6= this._window.findChildByName("rating_txt");
            this._window.findChildByName("rating_region").x = ((_local_6.x + _local_6.width) + 5);
            this.find("ranking_cont").visible = (k.ranking > 0);
            cast(this.find("ranking_txt"), ITextWindow).text = ("" + Std.string(k.ranking));
            this._navigator.refreshButton(_local_2, "home", this.isHome(k), null, 0);
            this._window.findChildByName("make_home_region").visible = (!this.isHome(k));
            this._window.findChildByName("make_favourite_region").visible = ((!this._navigator.data._Str_12763) && (!this._navigator.data._Str_21092()));
            this._window.findChildByName("favourite_region").visible = ((!this._navigator.data._Str_12763) && this._navigator.data._Str_21092());
            this._window.findChildByName("floor_plan_editor_button").visible = this._navigator.data.canEditRoomSettings;
            this.refreshThumbnail(k);
            Util.moveChildrenToColumn(_local_2, ["room_name", "owner_name_cont", "rating_cont", "ranking_cont", "padding_cont", "tags", "room_desc", "thumbnail_container"], _local_3.y, 0);
            _local_2.visible = true;
            _local_2.height = Util.getLowestPoint(_local_2);
        }

        function refreshThumbnail(k:GuestRoomData)
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:IStaticBitmapWrapperWindow = null;
            if (((this._window == null) || (!this._navigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_ROOM_THUMBNAIL_CAMERA))))
            {
                return;
            }
            if (k.officialRoomPicRef != null)
            {
                if (this._navigator.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))
                {
                    _local_2 = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(k.flatId)) + ".png");
                }
                else
                {
                    _local_2 = (this._navigator.getProperty("image.library.url") + k.officialRoomPicRef);
                }
            }
            else
            {
                _local_2 = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(k.flatId)) + ".png");
            }
            _local_3 = this._navigator.data.getRoomThumbnailRefreshKey(k.flatId);
            if (((!(_local_3 == null)) && (!(_local_3 == ""))))
            {
                _local_2 = (_local_2 + ("?v=" + _local_3));
            }
            _local_4 = cast(this._window.findChildByName("thumbnail_image"), IStaticBitmapWrapperWindow);
            if (_local_4.assetUri == _local_2)
            {
                _local_4.assetUri = null;
            }
            _local_4.assetUri = _local_2;
        }

        function refreshStaffPick(k:Bool=false)
        {
            var _local_2:IWindow = null;
            if (this._window != null)
            {
                _local_2 = this._window.findChildByName("staff_pick_button");
                if (!this._navigator.data.roomPicker)
                {
                    _local_2.visible = false;
                    return;
                }
                _local_2.visible = true;
                if (k)
                {
                    _local_2.caption = this._navigator.getText((this._navigator.data._Str_8299 ? "navigator.staffpicks.pick" : "navigator.staffpicks.unpick"));
                }
                else
                {
                    _local_2.caption = this._navigator.getText((this._navigator.data._Str_8299 ? "navigator.staffpicks.unpick" : "navigator.staffpicks.pick"));
                }
            }
        }

        function refreshPublicRoom(k:Bool=false)
        {
            var _local_2:IWindow = null;
            if (this._window != null)
            {
                _local_2 = this._window.findChildByName("public_room_button");
                if (!this._navigator.data.canPublicPick)
                {
                    _local_2.visible = false;
                    return;
                }
                _local_2.visible = true;
                if (k)
                {
                    _local_2.caption = this._navigator.getText((this._navigator.data.currentRoomIsPublic ? "navigator.publicrooms.pick" : "navigator.publicrooms.unpick"));
                }
                else
                {
                    _local_2.caption = this._navigator.getText((this._navigator.data.currentRoomIsPublic ? "navigator.publicrooms.unpick" : "navigator.publicrooms.pick"));
                }
            }
        }

        public function refreshButtons(k:GuestRoomData)
        {
            var _local_7:IWindowContainer = null;
            var _local_8 = false;
            if (((this._navigator.data.enteredGuestRoom == null) || (this._window == null)))
            {
                return;
            }
            _local_8 = this._navigator.hasRoomRightsButIsNotOwner(this._navigator.data.enteredGuestRoom.flatId);
            this.find("remove_rights_region").visible = _local_8;
            this._navigator.refreshButton(cast(this.find("remove_rights_region"), IRegionWindow), "remove_rights", _local_8, null, 0);
            this.find("room_settings_button").visible = this._navigator.data.canEditRoomSettings;
            this.find("room_filter_button").visible = (this._navigator.data.canEditRoomSettings && this._navigator.getBoolean("room.custom.filter.enabled"));
            if (!this._navigator.getBoolean("room.report.enabled"))
            {
                _local_7 = cast(this.find("room_report_button"), IWindowContainer);
                if (_local_7 != null)
                {
                    _local_7.visible = false;
                }
            }
            this.refreshStaffPick();
            this.refreshPublicRoom();
            var _local_2= this.find("room_muteall_button");
            _local_2.visible = (this._navigator.data.enteredGuestRoom.canMute && this._navigator.getBoolean("room_moderation.mute_all.enabled"));
            var _local_3= this._navigator.data.enteredGuestRoom.allInRoomMuted;
            _local_2.caption = (_local_3 ? "${navigator.muteall_on}" : "${navigator.muteall_off}");
            var _local_4= this._navigator.roomSessionManager.getSession(this._navigator.data.enteredGuestRoom.flatId);
            this.find("floor_plan_editor_button").visible = (_local_4.roomControllerLevel >= RoomControllerLevel.GUEST);
            var _local_5= cast(this._window.findChildByName("buttons_cont"), IWindowContainer);
            var _local_6:Array<ASAny> = ["room_settings_button", "room_filter_button", "floor_plan_editor_button", "staff_pick_button", "public_room_button", "room_report_button", "room_muteall_button"];
            Util.moveChildrenToColumn(_local_5, _local_6, 0, 3);
            _local_5.visible = Util._Str_13639(_local_5);
            _local_5.height = Util.getLowestPoint(_local_5);
        }

        function prepareWindow()
        {
            this._visible = true;
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._navigator.getXmlWindow("iro_room_details_framed"), IFrameWindow);
            this._window.center();
            this.addMouseClickListener(this.find("make_favourite_region"), this.onAddFavouriteClick);
            this.addMouseClickListener(this.find("favourite_region"), this.onRemoveFavouriteClick);
            this.addMouseClickListener(this.find("room_settings_button"), this.onRoomSettingsClick);
            this.addMouseClickListener(this.find("room_filter_button"), this.onRoomFilterButtonClick);
            this.addMouseClickListener(this.find("floor_plan_editor_button"), this.onFloorPlanEditorButtonClick);
            this.addMouseClickListener(this.find("room_muteall_button"), this.onMuteAllClick);
            this.addMouseClickListener(this.find("make_home_region"), this.onMakeHomeClick);
            this.addMouseClickListener(this.find("remove_rights_region"), this.onRemoveRights);
            this.addMouseClickListener(this.find("embed_src_txt"), this.onEmbedSrcClick);
            this.addMouseClickListener(this.find("staff_pick_button"), this.onStaffPick);
            this.addMouseClickListener(this.find("public_room_button"), this.onPublicRoom);
            this.addMouseClickListener(this.find("room_report_button"), this.onRoomReport);
            var _local_5= this._navigator.hasRoomRightsButIsNotOwner(this._navigator.data.enteredGuestRoom.flatId);
            this.find("remove_rights_region").visible = _local_5;
            this._navigator.refreshButton(cast(this.find("remove_rights_region"), IRegionWindow), "remove_rights", _local_5, null, 0);
            this._navigator.refreshButton(cast(this.find("make_home_region"), IRegionWindow), "make_home", true, null, 0);
            this._navigator.refreshButton(cast(this.find("favourite_region"), IRegionWindow), "favourite", true, null, 0);
            this._navigator.refreshButton(cast(this.find("make_favourite_region"), IRegionWindow), "make_favourite", true, null, 0);
            this._navigator.refreshButton(cast(this.find("embed_info"), IWindowContainer), "icon_weblink", true, null, 0);
            this.addMouseClickListener(this._window.findChildByTag("close"), this.onCloseButtonClick);
            var _local_2= cast(this._window.findChildByName("owner_name_cont"), IWindowContainer);
            _local_2.procedure = this.onOwnerName;
            Util._Str_7173(_local_2, 1000, 10, 2, 5);
            this.setupLabelAndValue("rating_cont", "rating_caption", "rating_txt");
            this.setupLabelAndValue("ranking_cont", "ranking_caption", "ranking_txt");
            var _local_3= cast(this.find("embed_info"), IWindowContainer);
            var _local_4= cast(this.find("embed_info_txt"), ITextWindow);
            _local_4.height = Std.int(_local_4.textHeight + 5);
            Util.moveChildrenToColumn(_local_3, ["embed_info_txt", "embed_src_txt"], _local_4.y, 2);
            _local_3.height = (Util.getLowestPoint(_local_3) + 5);
            _local_3.findChildByName("embed_info_region").procedure = this.onEmbedInfo;
            if (this._navigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_ROOM_THUMBNAIL_CAMERA))
            {
                this._window.findChildByName("add_thumbnail_region").visible = this._navigator.data.canEditRoomSettings;
                if (this._navigator.data.canEditRoomSettings)
                {
                    this.addMouseClickListener(this.find("add_thumbnail_region"), this.onAddRoomThumbnail);
                }
                this.refreshThumbnail(this._navigator.data.enteredGuestRoom);
            }
            else
            {
                this._window.findChildByName("thumbnail_container").visible = false;
            }
        }

        function setupLabelAndValue(k:String, _arg_2:String, _arg_3:String)
        {
            var _local_4= cast(this.find(k), IWindowContainer);
            var _local_5= cast(_local_4.findChildByName(_arg_2), ITextWindow);
            _local_5.width = Std.int(_local_5.textWidth);
            Util._Str_5055(_local_4, [_arg_2, _arg_3], _local_5.x, _local_5.y, 3);
        }

        function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function find(k:String):IWindow
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 == null)
            {
                throw new ASError((("Window element with name: " + k) + " cannot be found!"));
            }
            return _local_2;
        }

        public function onAddFavouriteClick(k:WindowEvent)
        {
            var _local_2:SimpleAlertView = null;
            if (this._navigator.data.enteredGuestRoom == null)
            {
                return;
            }
            if (this._navigator.data._Str_23152())
            {
                _local_2 = new SimpleAlertView(this._navigator, "${navigator.favouritesfull.title}", "${navigator.favouritesfull.body}");
                _local_2.show();
            }
            else
            {
                this._navigator.trackGoogle("roomInfo", "addFavourite");
                this._navigator.send(new AddFavouriteRoomMessageComposer(this._navigator.data.enteredGuestRoom.flatId));
            }
        }

        public function onRemoveFavouriteClick(k:WindowEvent)
        {
            if (this._navigator.data.enteredGuestRoom == null)
            {
                return;
            }
            this._navigator.trackGoogle("roomInfo", "removeFavourite");
            this._navigator.send(new DeleteFavouriteRoomMessageComposer(this._navigator.data.enteredGuestRoom.flatId));
        }

        function onRoomSettingsClick(k:WindowEvent)
        {
            var _local_2= this._navigator.data.enteredGuestRoom;
            if (_local_2 == null)
            {
                Logger.log(["No entered room data?!"]);
                return;
            }
            this._navigator.trackGoogle("roomInfo", "editRoomSettings");
            this._navigator.roomSettingsCtrl.startRoomSettingsEdit(_local_2.flatId);
            this.close();
        }

        function onRoomFilterButtonClick(k:WindowEvent)
        {
            var _local_2= this._navigator.data.enteredGuestRoom;
            if (_local_2 == null)
            {
                Logger.log(["No entered room data?!"]);
                return;
            }
            this._navigator.trackGoogle("roomInfo", "editRoomFilter");
            this._navigator.roomFilterCtrl.startRoomFilterEdit(_local_2.flatId);
            this.close();
        }

        function onFloorPlanEditorButtonClick(k:WindowEvent)
        {
            this._navigator.trackGoogle("roomInfo", "floorPlanEditor");
            this._navigator.windowManager.displayFloorPlanEditor();
            this.close();
        }

        function onMuteAllClick(k:WindowEvent)
        {
            this._navigator.send(new MuteAllInRoomComposer());
        }

        function onMakeHomeClick(k:WindowEvent)
        {
            var _local_2= this._navigator.data.enteredGuestRoom;
            if (_local_2 == null)
            {
                Logger.log(["No entered room data?!"]);
                return;
            }
            Logger.log([("SETTING HOME ROOM TO: " + Std.string(_local_2.flatId))]);
            this._navigator.trackGoogle("roomInfo", "makeHome");
            this._navigator.send(new UpdateHomeRoomMessageComposer(_local_2.flatId));
        }

        function onCloseButtonClick(k:WindowEvent)
        {
            this.hideInfo(null);
        }

        function onRemoveRights(k:WindowEvent)
        {
            this._navigator.removeRoomRights(this._navigator.enteredGuestRoomData.flatId);
            this.find("remove_rights_region").visible = false;
        }

        function onStaffPick(k:WindowEvent)
        {
            this.refreshStaffPick(true);
            this._navigator.send(new ToggleStaffPickMessageComposer(this._navigator.data.enteredGuestRoom.flatId, this._navigator.data._Str_8299));
        }

        function onPublicRoom(k:WindowEvent)
        {
            var _local_2= this._navigator.data.currentRoomIsPublic;
            this._navigator.data.currentRoomIsPublic = (!_local_2);
            this.refreshPublicRoom();
            this._navigator.send(new TogglePublicRoomMessageComposer(this._navigator.data.enteredGuestRoom.flatId, _local_2));
        }

        function onRoomReport(k:WindowEvent)
        {
            this._navigator.trackGoogle("roomInfo", "reportRoom");
            var _local_2= this._navigator.data.enteredGuestRoom;
            this._navigator.habboHelp.reportRoom(_local_2.flatId, _local_2.roomName, _local_2.description);
            this.close();
        }

        function onEmbedSrcClick(k:WindowEvent)
        {
            var _local_2= cast(this.find("embed_src_txt"), ITextFieldWindow);
            _local_2.setSelection(0, _local_2.text.length);
            this._navigator.trackGoogle("roomInfo", "embedSrc");
        }

        function onAddRoomThumbnail(k:WindowEvent)
        {
            ASCompat.reinterpretAs(this._navigator.windowManager , Component).context.createLinkEvent("roomThumbnailCamera/open");
            this.close();
            var _local_2:ASAny = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(this._navigator.data.enteredGuestRoom.flatId)) + ".png");
            this._navigator.windowManager.resourceManager.removeAsset(_local_2);
            this._navigator.trackGoogle("roomInfo", "addThumbnail");
        }

        function hideInfo(k:Event)
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._visible = false;
        }

        function getEmbedData():String
        {
            var k:String = null;
            var _local_2:String = null;
            if (this._navigator.data.enteredGuestRoom != null)
            {
                k = "private";
                _local_2 = ("" + Std.string(this._navigator.data.enteredGuestRoom.flatId));
            }
            var _local_3= this._navigator.getProperty("user.hash");
            this._navigator.registerParameter("navigator.embed.src", "roomType", k);
            this._navigator.registerParameter("navigator.embed.src", "embedCode", _local_3);
            this._navigator.registerParameter("navigator.embed.src", "roomId", _local_2);
            return this._navigator.getText("navigator.embed.src");
        }

        function onEmbedInfo(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._embedExpanded = (!this._embedExpanded);
            this.refresh();
        }

        function onOwnerName(k:WindowEvent, _arg_2:IWindow)
        {
            _Str_3521._Str_6514(k, _arg_2);
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator.trackGoogle("roomInfo", "extendedProfile");
                this._navigator.trackGoogle("extendedProfile", "navigator_roomInfo");
                this._navigator.send(new GetExtendedProfileMessageComposer(this._navigator.data.enteredGuestRoom.ownerId));
            }
        }
    }

