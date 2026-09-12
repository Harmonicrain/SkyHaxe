package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.handler.AvatarInfoWidgetHandler;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.friendlist.RelationshipStatusEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class AvatarMenuView extends AvatarContextInfoButtonView 
    {
        static inline final _Str_10122:UInt = 1;
        static inline final _Str_15297:UInt = 2;
        static inline final _Str_15024:UInt = 4;
        static inline final _Str_14752:UInt = 5;
        static inline final _Str_15459:UInt = 6;
        static inline final _Str_15427:UInt = 7;
        static var _Str_14054:UInt = _Str_10122;//1

        var _data:AvatarInfoData;
        var _mode:UInt = 1;
        var _Str_7982:Bool = false;

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            _Str_3403 = false;
        }

        public static function setup(k:AvatarMenuView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:AvatarInfoData)
        {
            k._data = _arg_6;
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        override public function dispose()
        {
            if (window != null)
            {
                window.removeEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                window.removeEventListener(WindowMouseEvent.OUT, onMouseOverOut);
            }
            this._data = null;
            super.dispose();
        }

        function updateButtons()
        {
            var _local_4 = 0;
            var _local_5:AvatarInfoWidgetHandler = null;
            var _local_6 = false;
            var _local_7:String = null;
            var _local_8 = 0;
            var _local_9:IRoomObject = null;
            var _local_10 = 0;
            if (((!(window != null)) || (!(this._data != null))))
            {
                return;
            }
            var k= Std.downcast(window.findChildByName("buttons") , IItemListWindow);
            if (k == null)
            {
                return;
            }
            k.procedure = this.buttonEventProc;
            this.ensureTextButton("wired_inspect",
                "${infostand.button.wired_inspect}");
            k.autoArrangeItems = false;
            var _local_2= k.numListItems;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                k.getListItemAt(_local_3).visible = false;
                _local_3++;
            }
            if (this._mode == _Str_10122)
            {
                showButton("moderate", this.moderateMenuHasContent());
                showButton("friend", this._data.canBeAskedForAFriend);
                showButton("ignore", (!this._data.isIgnored));
                showButton("unignore", this._data.isIgnored);
                showButton("report", ((this.widget.configuration != null) && this.widget.configuration.getBoolean("infostand.report.show")));
                _local_4 = this._data.petRespectLeft;
                this.widget.localizations.registerParameter("infostand.button.respect", "count", Std.string(_local_4));
                showButton("respect", (_local_4 > 0));
                _local_5 = this.widget.handler;
                _local_6 = _local_5.container.sessionDataManager.isAccountSafetyLocked();
                showButton("trade", (this.citizenshipTalentTrackEnabled || ((!_local_6) && this._data.canTrade)));
                switch (this._data.canTradeReason)
                {
                    case RoomWidgetUserInfoUpdateEvent.TRADE_REASON_SHUTDOWN:
                        _local_7 = "${infostand.button.trade.tooltip.shutdown}";
                        
                    case RoomWidgetUserInfoUpdateEvent.TRADE_REASON_NO_TRADINGROOM:
                        _local_7 = "${infostand.button.trade.tooltip.tradingroom}";
                        
                    default:
                        _local_7 = "";
                }
                cast(cast(k.getListItemByName("trade"), IWindowContainer).getChildByName("button"), IInteractiveWindow).toolTipCaption = _local_7;
                showButton("whisper");
                showButton("group");
                if (this.widget.configuration.getBoolean("handitem.give.enabled")
                    && !this.widget.handler.container.roomEngine
                        .activeRoomHasHanditemControlBlocked)
                {
                    _local_8 = _local_5.container.roomSession.ownUserRoomId;
                    _local_9 = _local_5.container.roomEngine.getRoomObject(_local_5.roomSession.roomId, _local_8, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    if (_local_9 != null)
                    {
                        _local_10 = Std.int(_local_9.getModel().getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT));
                        if (((_local_10 > 0) && (_local_10 < 999999)))
                        {
                            showButton("pass_handitem");
                        }
                    }
                }
                showButton("relationship", (this.widget.configuration.getBoolean("relationship.status.enabled") && this._data.isFriend));
                showButton("ambassador", this.ambassadorMenuHasContent());
                showButton("wired_inspect",
                    this.widget.handler.container.userDefinedRoomEvents
                        .showInspectButton());
            }
            if (this._mode == _Str_15297)
            {
                showButton("kick", this._data.canBeKicked);
                showButton("ban_with_duration", this._data.canBeBanned);
                showButton("mute", this._data.canBeMuted);
                showButton("give_rights", this.isShowGiveRights());
                showButton("remove_rights", this.isShowRemoveRights());
                showButton("actions");
            }
            if (this._mode == _Str_15024)
            {
                showButton("ban_hour");
                showButton("ban_day");
                showButton("perm_ban");
                showButton("actions");
            }
            if (this._mode == _Str_14752)
            {
                showButton("mute_2min");
                showButton("mute_5min");
                showButton("mute_10min");
                showButton("actions");
            }
            if (this._mode == _Str_15459)
            {
                showButtonGrid("relationship_grid");
                showButton("no_relationship");
                showButton("actions");
            }
            if (this._mode == _Str_15427)
            {
                showButton("ambassador_kick");
                showButton("ambassador_alert");
                showButton("ambassador_mute_60min");
                showButton("ambassador_mute_18hour");
                showButton("actions");
            }
            k.autoArrangeItems = true;
            k.visible = true;
            _Str_14054 = this._mode;
            this._Str_7982 = false;
        }

        function ambassadorMenuHasContent():Bool
        {
            return this._data.isAmbassador;
        }

        function moderateMenuHasContent():Bool
        {
            return (((this._data.canBeKicked || this._data.canBeBanned) || this._data.canBeMuted) || this.isShowGiveRights()) || this.isShowRemoveRights();
        }

        function isShowGiveRights():Bool
        {
            return (this._data.amIOwner && (this._data.targetRoomControllerLevel < RoomControllerLevel.GUEST));// && (!(this._data.isGuildRoom));
        }

        function isShowRemoveRights():Bool
        {
            return (this._data.amIOwner && (this._data.targetRoomControllerLevel == RoomControllerLevel.GUEST));// && (!(this._data.isGuildRoom));
        }

        override function updateWindow()
        {
            var _local_1:IItemGridWindow = null;
            var _local_2:IIterator = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var k:com.sulake.core.utils.xml.XML = null;
            var _local_6:IWindowContainer = null;
            var _local_7:IWindowContainer = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("avatar_menu_widget"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (window == null)
                    {
                        return;
                    }
                    window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                }
                _buttons = Std.downcast(window.findChildByName("buttons") , IItemListWindow);
                _buttons.procedure = this.buttonEventProc;
                window.findChildByName("profile_link").procedure = this.buttonEventProc;
                window.findChildByName("name").caption = _userName;
                window.visible = false;
                activeView = window;
                this.updateButtons();
                _Str_11603();
                _local_1 = Std.downcast(window.findChildByName("relationship_grid") , IItemGridWindow);
                _local_2 = _local_1.iterator;
                _local_3 = ASCompat.toInt(_local_2.length);
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_6 = ASCompat.dynamicAs(com.sulake.core.utils.ASProxy.get(_local_2, _local_4), IWindowContainer);
                    _local_7 = Std.downcast(_local_6.findChildByName("button") , IWindowContainer);
                    _local_7.procedure = this.buttonEventProc;
                    _local_4++;
                }
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_5:String = null;
            var _local_6 = 0;
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            var _local_3 = false;
            var _local_4:RoomWidgetMessage = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_3 = true;
                    switch (_arg_2.parent.name)
                    {
                        case "wired_inspect":
                            _local_5 =
                                RoomWidgetUserActionMessage.RWUAM_WIRED_INSPECT;
                            
                        case "whisper":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_WHISPER_USER;
                            
                        case "group":
                            _local_5 = RoomWidgetUserActionMessage.GROUP_WHISPER;
                            
                        case "friend":
                            _arg_2.disable();
                            this._data.canBeAskedForAFriend = false;
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_SEND_FRIEND_REQUEST;
                            
                        case "respect":
                            this._data.petRespectLeft--;
                            _local_6 = this._data.petRespectLeft;
                            this.widget.localizations.registerParameter("infostand.button.respect", "count", Std.string(_local_6));
                            showButton("respect", (this._data.petRespectLeft > 0));
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_RESPECT_USER;
                            if (_local_6 > 0)
                            {
                                _local_3 = false;
                            }
                            
                        case "ignore":
                            _arg_2.parent.visible = false;
                            window.findChildByName("unignore").visible = true;
                            this._data.isIgnored = true;
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_IGNORE_USER;
                            
                        case "unignore":
                            _arg_2.parent.visible = false;
                            window.findChildByName("ignore").visible = true;
                            this._data.isIgnored = false;
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_UNIGNORE_USER;
                            
                        case "kick":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_KICK_USER;
                            
                        case "ban_hour":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_BAN_USER_HOUR;
                            
                        case "ban_day":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_BAN_USER_DAY;
                            
                        case "perm_ban":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_BAN_USER_PERM;
                            
                        case "mute_2min":
                            _local_5 = RoomWidgetUserActionMessage.MUTE_USER_2MIN;
                            
                        case "mute_5min":
                            _local_5 = RoomWidgetUserActionMessage.MUTE_USER_5MIN;
                            
                        case "mute_10min":
                            _local_5 = RoomWidgetUserActionMessage.MUTE_USER_10MIN;
                            
                        case "ban_with_duration":
                            this._mode = _Str_15024;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "mute":
                            this._mode = _Str_14752;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "give_rights":
                            _arg_2.parent.visible = false;
                            window.findChildByName("remove_rights").visible = true;
                            this._data.myRoomControllerLevel = RoomControllerLevel.GUEST;
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_GIVE_RIGHTS;
                            
                        case "remove_rights":
                            _arg_2.parent.visible = false;
                            window.findChildByName("give_rights").visible = true;
                            this._data.myRoomControllerLevel = RoomControllerLevel.NONE;
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_TAKE_RIGHTS;
                            
                        case "trade":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_START_TRADING;
                            
                        case "moderate":
                            this._mode = _Str_15297;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "report":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_REPORT_CFH_OTHER;
                            
                        case "actions":
                            this._mode = _Str_10122;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "relationship":
                            this._mode = _Str_15459;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "pass_handitem":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_PASS_CARRY_ITEM;
                            
                        case "relationship_heart":
                            this.setRelationship(RelationshipStatusEnum._Str_9205);
                            
                        case "relationship_smile":
                            this.setRelationship(RelationshipStatusEnum._Str_8388);
                            
                        case "relationship_bobba":
                            this.setRelationship(RelationshipStatusEnum._Str_8824);
                            
                        case "no_relationship":
                            this.setRelationship(RelationshipStatusEnum.NONE);
                            
                        case "ambassador":
                            this._mode = _Str_15427;
                            this._Str_7982 = true;
                            _local_3 = false;
                            
                        case "ambassador_alert":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_AMBASSADOR_ALERT_USER;
                            
                        case "ambassador_kick":
                            _local_5 = RoomWidgetUserActionMessage.RWUAM_AMBASSADOR_KICK_USER;
                            
                        case "ambassador_mute_2min":
                            _local_5 = RoomWidgetUserActionMessage.AMBASSADOR_MUTE_USER_2MIN;
                            
                        case "ambassador_mute_10min":
                            _local_5 = RoomWidgetUserActionMessage.AMBASSADOR_MUTE_USER_10MIN;
                            
                        case "ambassador_mute_60min":
                            _local_5 = RoomWidgetUserActionMessage.AMBASSADOR_MUTE_USER_60MIN;
                            
                        case "ambassador_mute_18hour":
                            _local_5 = RoomWidgetUserActionMessage.AMBASSADOR_MUTE_USER_18HOUR;
                            
                    }
                }
                if (_arg_2.name == "profile_link")
                {
                    _local_3 = true;
                    _local_4 = new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, _Str_2306, "avatarContextMenu");
                }
                if (_local_5 != null)
                {
                    _local_4 = new RoomWidgetUserActionMessage(_local_5, _Str_2306);
                    HabboTracking.getInstance().trackEventLog("InfoStand", "click", _local_5);
                }
                if (_local_4 != null)
                {
                    _widget.messageListener.processWidgetMessage(_local_4);
                }
                this.updateButtons();
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    if (_arg_2.name == "button")
                    {
                        switch (_arg_2.parent.name)
                        {
                            case "kick":
                                HabboTracking.getInstance().trackEventLogOncePerSession("InterfaceExplorer", "hover", "avatar.kick.hover");
                                
                            case "perm_ban"
                               | "ban_hour"
                               | "ban_day"
                               | "ban_with_duration":
                                HabboTracking.getInstance().trackEventLogOncePerSession("InterfaceExplorer", "hover", "avatar.ban.hover");
                                
                            case "mute"
                               | "mute_2min"
                               | "mute_5min"
                               | "mute_10min":
                                HabboTracking.getInstance().trackEventLogOncePerSession("InterfaceExplorer", "hover", "avatar.mute.hover");
                                
                            case "unignore"
                               | "ignore":
                                HabboTracking.getInstance().trackEventLogOncePerSession("InterfaceExplorer", "hover", "avatar.ignore.hover");
                                
                        }
                    }
                }
                else
                {
                    super.buttonEventProc(k, _arg_2);
                }
            }
            if (_local_3)
            {
                _widget.removeView(this, false);
            }
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }

        var citizenshipTalentTrackEnabled(get,never):Bool;
function  get_citizenshipTalentTrackEnabled():Bool
        {
            return cast(_widget, AvatarInfoWidget).configuration.getBoolean("talent.track.citizenship.enabled");
        }

        function setRelationship(k:Int)
        {
            _widget.friendList.setRelationshipStatus(_Str_2306, k);
        }
    }

