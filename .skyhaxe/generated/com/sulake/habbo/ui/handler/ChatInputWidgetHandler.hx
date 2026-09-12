package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputWidget;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatTypingMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatSelectAvatarMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.ui.widget.enums.AvatarExpressionEnum;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.room.events.RoomZoomEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import flash.ui.Mouse;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.ui.widget.events.HideRoomWidgetEvent;
    import com.sulake.habbo.friendbar.events.FriendBarResizeEvent;
    import com.sulake.habbo.session.events.SessionDataToWidgetEvent;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.events._Str_6300;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.HabboWindowManagerComponent;

     class ChatInputWidgetHandler implements IRoomWidgetHandler
    {
        var _isDisposed:Bool = false;
        var _mouseToggle:Bool = true;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:RoomChatInputWidget;


        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var widget(never,set):RoomChatInputWidget;
public function  set_widget(k:RoomChatInputWidget):RoomChatInputWidget        {
            return this._widget = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CHAT_INPUT_WIDGET;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
            this._widget = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetChatTypingMessage.RWCTM_TYPING_STATUS);
            k.push(RoomWidgetChatMessage.RWCM_MESSAGE_CHAT);
            k.push(RoomWidgetChatSelectAvatarMessage.RWCSAM_MESSAGE_SELECT_AVATAR);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:RoomWidgetChatTypingMessage = null;
            var _local_6:RoomWidgetChatSelectAvatarMessage = null;
            var _local_7:RoomWidgetChatMessage = null;
            var _local_8:String = null;
            var _local_9:RoomWidgetRequestWidgetMessage = null;
            var _local_10:Array<ASAny> = null;
            var _local_11 = 0;
            var _local_12:String = null;
            var commandArgument:String = null;
            var _local_14 = 0;
            var _local_15:RoomUserData = null;
            var _local_16:String = null;
            var _local_17:GuestRoomData = null;
            var userToKick:RoomUserData = null;
            var userToMute:RoomUserData = null;
            var userToAlert:RoomUserData = null;
            var _local_21:HabboToolbarEvent = null;
            var _local_22:Date = null;
            var _local_23:String = null;
            var _local_24:RoomUserData = null;
            switch (k.type)
            {
                case RoomWidgetChatTypingMessage.RWCTM_TYPING_STATUS:
                    _local_5 = Std.downcast(k , RoomWidgetChatTypingMessage);
                    if (_local_5 != null)
                    {
                        this._container.roomSession.sendChatTypingMessage(_local_5.isTyping);
                    }
                    
                case RoomWidgetChatMessage.RWCM_MESSAGE_CHAT:
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        _local_7 = Std.downcast(k , RoomWidgetChatMessage);
                        if (_local_7 != null)
                        {
                            if (_local_7.text == "")
                            {
                                return null;
                            }
                            _local_8 = _local_7.text;
                            _local_9 = null;
                            _local_10 = (cast _local_7.text.split(" "));
                            if (_local_10.length > 0)
                            {
                                _local_12 = _local_10[0];
                                commandArgument = "";
                                if (_local_10.length > 1)
                                {
                                    commandArgument = _local_10[1];
                                }
                                if (((_local_12.charAt(0) == ":") && (commandArgument == "x")))
                                {
                                    _local_14 = this._container.roomEngine.getSelectedAvatarId();
                                    if (_local_14 > -1)
                                    {
                                        _local_15 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_14);
                                        if (_local_15 != null)
                                        {
                                            commandArgument = _local_15.name;
                                            _local_8 = ASCompat.stringReplace(_local_7.text, " x", (" " + _local_15.name));
                                        }
                                    }
                                }
                                switch (_local_12.toLowerCase())
                                {
                                    case ":wf"
                                       | ":wired":
                                        if (this._container.userDefinedRoomEvents != null)
                                        {
                                            this._container.userDefinedRoomEvents.openWiredMenu("monitor");
                                        }
                                        return null;
                                    case ":var"
                                       | ":variables":
                                        if (this._container.userDefinedRoomEvents != null)
                                        {
                                            this._container.userDefinedRoomEvents.openWiredMenu("variable_overview");
                                        }
                                        return null;
                                    case ":inspect"
                                       | ":inspection":
                                        if (this._container.userDefinedRoomEvents != null)
                                        {
                                            this._container.userDefinedRoomEvents.openWiredMenu("inspection");
                                        }
                                        return null;
                                    case ":d"
                                       | ";d":
                                        if (this._container.sessionDataManager.clubLevel == HabboClubLevelEnum.VIP)
                                        {
                                            this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.LAUGH.ordinal);
                                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "laugh");
                                        }
                                        
                                    case "o/"
                                       | "_o/":
                                        this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.WAVE.ordinal);
                                        return null;
                                    case ":kiss":
                                        if (this._container.sessionDataManager.clubLevel == HabboClubLevelEnum.VIP)
                                        {
                                            this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.BLOW.ordinal);
                                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "blow");
                                            return null;
                                        }
                                        
                                    case ":67":
                                        if ((this._container.config.getBoolean("avatar.expression.67.enabled") && (this._container.sessionDataManager.clubLevel == HabboClubLevelEnum.VIP)))
                                        {
                                            this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.EXPRESSION_67.ordinal);
                                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "67");
                                            return null;
                                        }
                                        
                                    case ":jump":
                                        if (this._container.sessionDataManager.clubLevel == HabboClubLevelEnum.VIP)
                                        {
                                            this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.JUMP.ordinal);
                                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "jump");
                                            return null;
                                        }
                                        
                                    case ":idle":
                                        this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.IDLE.ordinal);
                                        HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "idle");
                                        return null;
                                    case "_b":
                                        this._container.roomSession.sendAvatarExpressionMessage(AvatarExpressionEnum.RESPECT.ordinal);
                                        HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "respect");
                                        return null;
                                    case ":sign":
                                        this._container.roomSession.sendSignMessage(ASCompat.toInt(commandArgument));
                                        HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "chat", "sign", null, ASCompat.toInt(commandArgument));
                                        return null;
                                    case ":chooser":
                                        if ((!this._container.roomEngine.activeRoomHasChooserDisabled)
                                            || (this._container.roomSession.roomControllerLevel
                                                >= RoomControllerLevel.GUEST))
                                        {
                                            _local_9 = new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER);
                                            this._container.processWidgetMessage(_local_9);
                                        }
                                        return null;
                                    case ":furni":
                                        if (((((this._container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB) && (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST)) || this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.PARTNER)) || this._container.sessionDataManager.isAmbassador))
                                        {
                                            _local_9 = new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER);
                                            this._container.processWidgetMessage(_local_9);
                                        }
                                        return null;
                                    case ":pickall":
                                        this._container.sessionDataManager.pickAllFurniture(this._container.roomSession.roomId);
                                        return null;
                                    case ":pickallbc":
                                        this._container.sessionDataManager.pickAllBuilderFurniture(this._container.roomSession.roomId);
                                        return null;
                                    case ":ejectall":
                                        this._container.sessionDataManager.ejectAllFurniture(this._container.roomSession.roomId, _local_8);
                                        return null;
                                    case ":ejectpets":
                                        this._container.sessionDataManager.ejectPets(this._container.roomSession.roomId);
                                        return null;
                                    case ":moonwalk":
                                        this._container.sessionDataManager.sendSpecialCommandMessage(":moonwalk");
                                        return null;
                                    case ":habnam":
                                        this._container.sessionDataManager.sendSpecialCommandMessage(":habnam");
                                        return null;
                                    case ":yyxxabxa":
                                        this._container.sessionDataManager.sendSpecialCommandMessage(":yyxxabxa");
                                        return null;
                                    case ":mutepets":
                                        this._container.sessionDataManager.sendSpecialCommandMessage(":mutepets");
                                        return null;
                                    case ":mpgame":
                                        this._container.sessionDataManager.sendSpecialCommandMessage(_local_8);
                                        return null;
                                    case ":news":
                                        if (this._container.config.getBoolean("client.news.embed.enabled"))
                                        {
                                            HabboWebTools.openNews();
                                            return null;
                                        }
                                        
                                    case ":mail":
                                        if (this._container.config.getBoolean("client.minimail.embed.enabled"))
                                        {
                                            HabboWebTools.openMinimail("#mail/inbox/");
                                            return null;
                                        }
                                        
                                    case ":crashme":
                                        
                                    case ":tgl":
                                        
                                    case ":li":
                                        
                                    case ":2"
                                       | ":kick":
                                        if (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST)
                                        {
                                            userToKick = this._container.roomSession.userDataManager.getUserDataByName(commandArgument);
                                            if (userToKick != null)
                                            {
                                                this._container.roomSession.kickUser(userToKick.id);
                                            }
                                        }
                                        return null;
                                    case ":shutup"
                                       | ":mute":
                                        if (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST)
                                        {
                                            userToMute = this._container.roomSession.userDataManager.getUserDataByName(commandArgument);
                                            if (userToMute != null)
                                            {
                                                this._container.roomSession.muteUser(userToMute.id, 2);
                                            }
                                        }
                                        return null;
                                    case ":floor"
                                       | ":bcfloor":
                                        if (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.ROOM_OWNER)
                                        {
                                            this._container.windowManager.displayFloorPlanEditor();
                                        }
                                        return null;
                                    case ":daybreak":
                                        this.showDaybreakAlert();
                                        return null;
                                    case ":lang":
                                        this._container.localization .activateLocalizationDefinition(commandArgument);
                                        return null;
                                    case ":uc":
                                        if (this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE))
                                        {
                                            if (commandArgument == "hotel")
                                            {
                                                this._container.roomSession.sendPeerUsersClassificationMessage(_local_10[2]);
                                            }
                                            else
                                            {
                                                this._container.roomSession.sendRoomUsersClassificationMessage(commandArgument);
                                            }
                                        }
                                        return null;
                                    case ":anew":
                                        if ((this._container.sessionDataManager.isAmbassador || this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)))
                                        {
                                            this._container.roomSession.sendRoomUsersClassificationMessage("new");
                                        }
                                        return null;
                                    case ":avisit":
                                        if ((this._container.sessionDataManager.isAmbassador || this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)))
                                        {
                                            if ("group" == commandArgument)
                                            {
                                                ASCompat.reinterpretAs(this._container.roomEngine , Component).context.createLinkEvent("navigator/goto/predefined_group_lobby");
                                            }
                                            else
                                            {
                                                ASCompat.reinterpretAs(this._container.roomEngine , Component).context.createLinkEvent("navigator/goto/predefined_noob_lobby");
                                            }
                                        }
                                        return null;
                                    case ":aalert":
                                        if ((this._container.sessionDataManager.isAmbassador || this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)))
                                        {
                                            userToAlert = this._container.roomSession.userDataManager.getUserDataByName(commandArgument);
                                            if (userToAlert != null)
                                            {
                                                this._container.roomSession.ambassadorAlert(userToAlert.id);
                                            }
                                        }
                                        return null;
                                    case ":visit":
                                        if (this._container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB)
                                        {
                                            this._container.roomSession.sendVisitUserMessage(commandArgument);
                                        }
                                        return null;
                                    case ":roomid":
                                        if (this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE))
                                        {
											if (commandArgument != null && commandArgument != "")
											{
												this._container.roomSession.sendVisitFlatMessage(ASCompat.parseInt(commandArgument));
											}
                                        }
                                        return null;
                                    case ":link":
                                        
                                    case ":zoom":
                                        this._container.roomEngine.events.dispatchEvent(new RoomZoomEvent(this._container.roomEngine.activeRoomId, ASCompat.toNumber(commandArgument)));
                                        return null;
                                    case ":cam"
                                       | ":camera":
                                        if (this._container.sessionDataManager.isPerkAllowed(PerkEnum.CAMERA))
                                        {
                                            _local_21 = new HabboToolbarEvent(HabboToolbarEvent.HTE_ICON_CAMERA);
                                            _local_21.iconName = HabboToolbarEvent.CHATCAMERACOMMAND;
                                            this._container.toolbar.events.dispatchEvent(_local_21);
                                        }
                                        return null;
                                    case ":q":
                                        
                                    case ":screenshot":
                                        _local_17 = this._container.navigator.enteredGuestRoomData;
                                        if (_local_17 != null)
                                        {
                                            _local_16 = _local_17.roomName;
                                        }
                                        if (((_local_16 == null) || (_local_16.length == 0)))
                                        {
                                            _local_22 = Date.now();
                                            _local_23 = ((([_local_22.getFullYear(), _local_22.getMonth(), _local_22.getDate()] : Array<Dynamic>).join("-") + " ") + ([_local_22.getHours(), _local_22.getMinutes(), _local_22.getSeconds()] : Array<Dynamic>).join("."));
                                            _local_16 = ("Habbo " + _local_23);
                                        }
                                        this._container.roomEngine.createScreenShot(this._container.roomSession.roomId, this._container.getFirstCanvasId(), (_local_16 + ".png"));
                                        return null;
                                    case ":iddqd":
                                        this._container.roomEngine.events.dispatchEvent(new RoomZoomEvent(this._container.roomEngine.activeRoomId, -1, true));
                                        return null;
                                    case ":hidemouse":
                                        if (this._mouseToggle)
                                        {
                                            Mouse.hide();
                                            this._container.roomEngine.setTileCursorState(this._container.roomEngine.activeRoomId, 0);
                                        }
                                        else
                                        {
                                            Mouse.show();
                                            this._container.roomEngine.setTileCursorState(this._container.roomEngine.activeRoomId, 1);
                                        }
                                        this._container.roomEngine.toggleTileCursorVisibility(this._container.roomEngine.activeRoomId, (!this._mouseToggle));
                                        this._mouseToggle = (!this._mouseToggle);
                                        return null;
									case ":modtools":
										this._container.moderation.setVisible(true);
										return null;
									case ":csmm":
                                        if (this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE))
                                        {
                                            this._container.gameManager._SafeStr_7624();
                                            return null;
                                        }
                                        
                                }
                            }
                            _local_11 = _local_7.styleId;
                            if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                            {
                                if (this._container.freeFlowChat != null)
                                {
                                    if (((!(this._container.freeFlowChat.preferedChatStyle == _local_7.styleId)) && (!(_local_7.styleId == -1))))
                                    {
                                        this._container.freeFlowChat.preferedChatStyle = _local_7.styleId;
                                    }
                                    _local_11 = this._container.freeFlowChat.preferedChatStyle;
                                }
                                switch (_local_7.chatType)
                                {
                                    case RoomWidgetChatMessage.CHAT_TYPE_SPEAK:
                                        this._container.roomSession.sendChatMessage(_local_8, _local_11);
                                        
                                    case RoomWidgetChatMessage.CHAT_TYPE_SHOUT:
                                        this._container.roomSession.sendShoutMessage(_local_8, _local_11);
                                        
                                    case RoomWidgetChatMessage.CHAT_TYPE_WHISPER:
                                        this._container.roomSession.sendWhisperMessage(_local_7._Str_23716, _local_8, _local_11);
                                        
                                }
                            }
                        }
                    }
                    
                case RoomWidgetChatSelectAvatarMessage.RWCSAM_MESSAGE_SELECT_AVATAR:
                    _local_6 = Std.downcast(k , RoomWidgetChatSelectAvatarMessage);
                    if (_local_6 != null)
                    {
                        this._container.roomEngine.selectAvatar(_local_6.roomId, _local_6.objectId);
                        _local_24 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_6.objectId);
                        if (_local_24 != null)
                        {
                            this._container.moderation.userSelected(_local_24.id, _local_6.userName, _local_24.figure, _local_24.sex);
                        }
                    }
                    
            }
            return null;
        }

        function showDaybreakAlert()
        {
            var asset= this._container.windowManager.assets.getAssetByName("daybreak_alert_xml");
            if (asset == null)
            {
                this._container.windowManager.simpleAlert("Daybreak", "", " ");
                return;
            }
            var wm= Std.downcast(this._container.windowManager , HabboWindowManagerComponent);
            if (wm == null)
            {
                this._container.windowManager.simpleAlert("Daybreak", "", " ");
                return;
            }
            var window= Std.downcast(wm.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) , 1) , IWindowContainer);
            if (window == null)
            {
                return;
            }
            var desktop:IWindowContainer = wm.getWindowContext(1).getDesktopWindow() ;
            if (desktop != null)
            {
                desktop.addChild(window);
            }
            window.procedure = function (event:com.sulake.core.window.events.WindowEvent, target:com.sulake.core.window.IWindow)
            {
                if (((event.type == WindowMouseEvent.CLICK) && (target != null) && ((target.name == "close_button") || (target.name == "header_button_close"))))
                {
                    window.dispose();
                }
            };
            window.center();
            window.activate();
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionChatEvent.RSCE_FLOOD_EVENT, HideRoomWidgetEvent.HRWE_HIDE_ROOM_WIDGET, FriendBarResizeEvent.FBE_BAR_RESIZE_EVENT, SessionDataToWidgetEvent.PURCHASABLE_STYLES_UPDATED];
        }

        public function update()
        {
        }

        public function processEvent(k:Event)
        {
            var _local_3:RoomSessionChatEvent = null;
            var _local_4 = 0;
            var _local_5:FriendBarResizeEvent = null;
            var _local_2:Event = null;
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionChatEvent.RSCE_FLOOD_EVENT:
                    _local_3 = Std.downcast(k , RoomSessionChatEvent);
                    _local_4 = ASCompat.parseInt(_local_3.text);
                    _local_2 = new _Str_6300(_local_4);
                    
                case HideRoomWidgetEvent.HRWE_HIDE_ROOM_WIDGET:
                    this._Str_22488(Std.downcast(k , HideRoomWidgetEvent));
                    return;
                case FriendBarResizeEvent.FBE_BAR_RESIZE_EVENT:
                    _local_5 = Std.downcast(k , FriendBarResizeEvent);
                    this._widget._Str_24485();
                    
                case SessionDataToWidgetEvent.PURCHASABLE_STYLES_UPDATED:
                    if (this._widget != null)
                    {
                        this._widget.refreshChatStyles();
                    }
                    return;
            }
            if ((((!(this._container == null)) && (!(this._container.events == null))) && (!(_local_2 == null))))
            {
                this._container.events.dispatchEvent(_local_2);
            }
        }

        function _Str_22488(k:HideRoomWidgetEvent)
        {
            if (((k != null) && (k.widgetType == this.type)))
            {
                this._widget.hide();
            }
        }
public function new(){}
    }

