package com.sulake.habbo.navigator
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.session._enum.RoomTradingLevelEnum;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class RoomPopupCtrl extends PopupCtrl 
    {
        var _details:IWindowContainer;
        var _room:GuestRoomData;
        var _tagRenderer:TagRenderer;
        var _navigator__com_sulake_habbo_navigator_RoomPopupCtrl/*redefined private*/:IHabboTransitionalNavigator;
        var _guildInfoCtrl:GuildInfoCtrl;

        public function new(k:IHabboTransitionalNavigator, _arg_2:Int, _arg_3:Int)
        {
            super(cast(k, HabboNavigator), _arg_2, _arg_3, "grs_guest_room_details_long");
            this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl = k;
            this._tagRenderer = new TagRenderer(k, _Str_14696);
            this._guildInfoCtrl = new GuildInfoCtrl(this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl);
        }

        public var room(never,set):GuestRoomData;
public function  set_room(k:GuestRoomData):GuestRoomData        {
            return this._room = k;
        }

        override public function refreshContent(k:IWindowContainer)
        {
            if (this._details == null)
            {
                this._details = cast(k.findChildByName("details_container"), IWindowContainer);
            }
            this._details.visible = true;
            this._tagRenderer._Str_8651 = true;
            Util.hideChildren(this._details);
            this._guildInfoCtrl.refresh(this._details, this._room);
            this.refreshRoomName(this._details, this._room);
            this.refreshOwnerName();
            this.refreshTextWithCaption("roomctg", this._details, this.getRoomCtg(this._room.categoryId));
            this.refreshRoomDesc(this._details, this._room);
            this.refreshExtraCont();
            this.refreshEventInfo(this._room);
            this.refreshRoomSettings();
            this.refreshInfo(this._details, "trading_allowed", (this._room.tradeMode == RoomTradingLevelEnum.FREE_TRADING));
            this.refreshInfo(this._details, "doormode_doorbell", (this._room.doorMode == 1));
            this.refreshInfo(this._details, "doormode_password", (this._room.doorMode == 2));
            this.refreshInfo(this._details, "doormode_invisible", (this._room.doorMode == 3));
            Util.moveChildrenToColumn(this._details, ["guild_info", "roomname", "roomctg_cont", "roomowner_cont", "roomdesc", "extra_cont", "doormode_doorbell", "doormode_password", "doormode_invisible", "trading_allowed", "eventinfo_cont", "roomsettings_cont"], 0, 0);
            this._details.findChildByName("guild_info").x = 2;
            this._details.height = Util.getLowestPoint(this._details);
        }

        function refreshOwnerName()
        {
            var k= cast(this._details.findChildByName("roomowner"), ITextWindow);
            var _local_2= cast(this._details.findChildByName("roomowner_cont"), IRegionWindow);
            _local_2.procedure = this.onOwnerName;
            k.caption = (this._room.showOwner ? this._room.ownerName : "");
            _local_2.visible = ((this._room.showOwner && (!(this._room.ownerName == ""))) && (!(this._room.ownerName == "-")));
            _Str_3521._Str_3927(false, _local_2);
            Util._Str_7173(_local_2, 1000, 10, 2);
        }

        function refreshRoomSettings()
        {
            var _local_2:IRegionWindow = null;
            var _local_3:ITextWindow = null;
            var _local_4:IWindow = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var k= true;
            if (k)
            {
                _local_2 = cast(this._details.findChildByName("roomsettings_cont"), IRegionWindow);
                _local_3 = cast(this._details.findChildByName("roomsettings"), ITextWindow);
                _local_2.procedure = this.onRoomSettings;
                _local_2.visible = (k && (this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.sessionData.userId == this._room.ownerId));
                _local_3.width = Std.int(_local_3.textWidth + 5);
                _local_3.height = Std.int(_local_3.textHeight + 3);
                Util._Str_7173(_local_2, 1000, 10, 2);
                while (_local_7 < _local_2.numChildren)
                {
                    _local_4 = _local_2.getChildAt(_local_7);
                    if (_local_4.visible)
                    {
                        _local_5 = Std.int(Math.max(_local_5, (_local_4.x + _local_4.width)));
                        _local_6 = Std.int(Math.max(_local_6, (_local_4.y + _local_4.height)));
                    }
                    _local_7++;
                }
                _local_2.width = _local_5;
                _local_2.height = _local_6;
            }
        }

        function refreshExtraCont()
        {
            var k= cast(this._details.findChildByName("extra_cont"), IWindowContainer);
            Util.hideChildren(k);
            this._tagRenderer._Str_19120(k, this._room.tags);
            if (this._room.score > 0)
            {
                this.refreshTextWithCaption("rating", k, ("" + Std.string(this._room.score)));
                k.findChildByName("rating_cont").visible = true;
            }
            if (Util._Str_13639(k))
            {
                Util.moveChildrenToColumn(k, ["tags", "startedat_cont", "rating_cont"], 0, 3);
                k.height = (Util.getLowestPoint(k) + 4);
                k.visible = true;
            }
        }

        function refreshEventInfo(k:GuestRoomData)
        {
            if (((k.roomAdName == null) || (k.roomAdName.length == 0)))
            {
                return;
            }
            var _local_2= cast(this._details.findChildByName("eventinfo_cont"), IWindowContainer);
            Util.hideChildren(_local_2);
            var _local_3= cast(_local_2.findChildByName("eventinfo_name"), ITextWindow);
            var _local_4= cast(_local_2.findChildByName("eventinfo_desc"), ITextWindow);
            var _local_5= cast(_local_2.findChildByName("eventinfo_expirationtime"), ITextWindow);
            var _local_6= cast(_local_2.findChildByName("eventinfo.caption"), ITextWindow);
            _local_3.caption = k.roomAdName;
            _local_4.caption = k.roomAdDescription;
            _local_5.caption = FriendlyTime.format(this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.localization, (k.roomAdExpiresInMin * 60));
            _local_4.height = Std.int(_local_4.textHeight + 10);
            _local_5.y = (_local_4.y + _local_4.height);
            _local_2.height = (((_local_3.height + _local_4.height) + _local_5.height) + 20);
            var _local_7= Std.downcast(_local_2.findChildByName("eventinfo_child_container") , IWindowContainer);
            _local_7.x = Std.int(_local_6.textWidth + 5);
            _local_7.height = (Util.getLowestPoint(_local_7) + 5);
            _local_2.visible = true;
            _local_6.visible = true;
            _local_7.visible = true;
        }

        function refreshRoomName(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            var _local_3= cast(k.getChildByName("roomname"), ITextWindow);
            _local_3.visible = true;
            _local_3.text = _arg_2.roomName;
            _local_3.height = Std.int(_local_3.textHeight + 3);
        }

        function refreshRoomDesc(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            if (_arg_2.description == "")
            {
                return;
            }
            var _local_3= "roomdesc";
            var _local_4= cast(k.getChildByName(_local_3), ITextWindow);
            _local_4.text = _arg_2.description;
            _local_4.height = Std.int(_local_4.textHeight + 10);
            _local_4.y = Util.getLowestPoint(k);
            _local_4.visible = true;
        }

        function refreshTextWithCaption(k:String, _arg_2:IWindowContainer, _arg_3:String)
        {
            var _local_4= cast(_arg_2.findChildByName((k + "_cont")), IWindowContainer);
            _local_4.visible = true;
            var _local_5= cast(_local_4.getChildByName(k), ITextWindow);
            var _local_6= cast(_local_4.getChildByName((k + ".caption")), ITextWindow);
            _local_5.text = _arg_3;
            Util._Str_5055(_local_4, [(k + ".caption"), k], _local_6.x, 0, 2);
        }

        function refreshInfo(k:IWindowContainer, _arg_2:String, _arg_3:Bool)
        {
            if (!_arg_3)
            {
                return;
            }
            var _local_4= cast(k.findChildByName(_arg_2), IWindowContainer);
            _local_4.visible = true;
            navigator.refreshButton(_local_4, _arg_2, true, null, 0);
        }

        function getEventCtg(k:Int):String
        {
            var _local_2= ("roomevent_type_" + Std.string(k));
            var _local_3= navigator.getText(_local_2);
            return (_local_3 == null) ? "" : _local_3;
        }

        function getRoomCtg(k:Int):String
        {
            var _local_2:FlatCategory = null;
            final _iter_ = navigator.data.allCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.nodeId == k)
                {
                    return _local_2.nodeName;
                }
            }
            return "";
        }

        function onOwnerName(k:WindowEvent, _arg_2:IWindow)
        {
            _Str_3521._Str_6514(k, _arg_2);
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.trackGoogle("extendedProfile", "navigator_roomPopup");
                this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.send(new GetExtendedProfileMessageComposer(this._room.ownerId));
                this._Str_14696();
            }
        }

        function onRoomSettings(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.trackGoogle("roomInfo", "editRoomSettings");
                this._navigator__com_sulake_habbo_navigator_RoomPopupCtrl.roomSettingsCtrl.startRoomSettingsEditFromNavigator(this._room.flatId, this._room.habboGroupId);
                this._Str_14696();
            }
        }
    }

