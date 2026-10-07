package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangePostureMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarExpressionMessage;
    import com.sulake.habbo.ui.widget.enums.AvatarExpressionEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDanceMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;

     class OwnAvatarMenuView extends AvatarContextInfoButtonView 
    {
        static inline final MODE_NORMAL= 0;
        static inline final MODE_CLUB_DANCES= 1;
        static inline final MODE_NAME_CHANGE= 2;
        static inline final MODE_EXPRESSIONS= 3;
        static inline final MODE_SIGNS= 4;
        static inline final MODE_CHANGE_LOOKS= 5;
        static var _newIdentityChangeLooksMenuHasBeenShown:Bool = false;

        var _data:AvatarInfoData;
        var _mode:Int = 0;

        public function new(k:AvatarInfoWidget)
        {
            super(k );
            _Str_3403 = false;
        }

        public static function setup(k:OwnAvatarMenuView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:AvatarInfoData)
        {
            k._data = _arg_6;
            if ((((!_newIdentityChangeLooksMenuHasBeenShown) && (k.widget.configuration.getInteger("new.identity", 0) > 0)) && k.widget.configuration.getBoolean("new.user.reception.enabled")))
            {
                k._mode = MODE_NORMAL;
                OwnAvatarMenuView._newIdentityChangeLooksMenuHasBeenShown = true;
            }
            else
            {
                if (((k.widget.isDancing && k.widget._Str_6454) && (!k.widget.hasEffectOn)))
                {
                    k._mode = MODE_CLUB_DANCES;
                }
                else
                {
                    if ((_arg_6.allowNameChange && k.widget.useMinimizedOwnAvatarMenu))
                    {
                        k._mode = MODE_NAME_CHANGE;
                    }
                    else
                    {
                        k._mode = MODE_NORMAL;
                    }
                }
            }
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        override public function dispose()
        {
            this._data = null;
            super.dispose();
        }

        override function updateWindow()
        {
            var _local_1:IItemGridWindow = null;
            var _local_2:IIterator = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IRegionWindow = null;
            var k:com.sulake.core.utils.xml.XML = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IWindowContainer = null;
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
                if (_window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("own_avatar_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (window == null)
                    {
                        return;
                    }
                    _window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    _window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                }
                _buttons = Std.downcast(_window.findChildByName("buttons") , IItemListWindow);
                this.ensureTextButton("wired_inspect",
                    "${infostand.button.wired_inspect}");
                _buttons.procedure = this.buttonEventProc;
                _local_1 = Std.downcast(_window.findChildByName("signs_grid") , IItemGridWindow);
                _local_2 = _local_1.iterator;
                _local_3 = ASCompat.toInt(_local_2.length);
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_7 = ASCompat.dynamicAs(com.sulake.core.utils.ASProxy.get(_local_2, _local_4), IWindowContainer);
                    _local_8 = Std.downcast(_local_7.findChildByName("button") , IWindowContainer);
                    _local_8.procedure = this._Str_23693;
                    _local_4++;
                }
                _local_5 = Std.downcast(window.findChildByName("profile_link") , IRegionWindow);
                if (_local_5 != null)
                {
                    _local_5.procedure = this.buttonEventProc;
                    _local_5.toolTipCaption = this.widget.localizations.getLocalization("infostand.profile.link.tooltip", "Click to view profile");
                _local_5.toolTipDelay = 100;
                }
                _window.findChildByName("name").caption = _userName;
                _window.visible = false;
                activeView = _window;
                this._Str_2771();
            }
        }

        public function _Str_2771()
        {
            var _local_4 = false;
            var _local_5 = false;
            if ((((!(_window != null)) || (!(this._data != null))) || (!(_buttons != null))))
            {
                return;
            }
            _buttons.autoArrangeItems = false;
            var k= _buttons.numListItems;
            var _local_2 = 0;
            while (_local_2 < k)
            {
                _buttons.getListItemAt(_local_2).visible = false;
                _local_2++;
            }
            var _local_3= this.widget._Str_25831;
            switch (this._mode)
            {
                case MODE_NORMAL:
                    showButton("change_name", this._data.allowNameChange);
                    showButton("decorate", (this._Str_22241() && ((this._data.myRoomControllerLevel >= RoomControllerLevel.GUEST) || this._data.amIOwner)));
                    showButton("change_looks");
                    showButton("dance_menu", (this.widget._Str_6454 && (!_local_3)), (!this.widget.hasEffectOn));
                    showButton("dance", (((!this.widget._Str_6454) && (!this.widget.isDancing)) && (!_local_3)), (!this.widget.hasEffectOn));
                    showButton("dance_stop", (((!this.widget._Str_6454) && this.widget.isDancing) && (!_local_3)));
                    if (!ASCompat.reinterpretAs(_widget.windowManager , Component).getBoolean("memenu.effects.widget.disabled"))
                    {
                        showButton("effects", (!_local_3));
                    }
                    showButton("handitem", (((this._data.carryItemType > 0)
                        && (this._data.carryItemType < 999999))
                        && this.widget.configuration.getBoolean("handitem.drop.enabled")
                        && !this.widget.handler.roomEngine
                            .activeRoomHasHanditemControlBlocked));
                    _local_4 = this.widget.configuration.getBoolean("avatar.expressions_menu.enabled");
                    showButton((_local_4 ? "expressions" : "wave"));
                    _local_5 = this.widget.configuration.getBoolean("avatar.signs.enabled");
                    showButton("signs", _local_5);
                    showButton("wired_inspect",
                        this.widget.handler.container.userDefinedRoomEvents
                            .showInspectButton());
                    
                case MODE_CLUB_DANCES:
                    showButton("dance_stop", true, this.widget.isDancing);
                    showButton("dance_1");
                    showButton("dance_2");
                    showButton("dance_3");
                    showButton("dance_4");
                    showButton("back");
                    
                case MODE_NAME_CHANGE:
                    showButton("change_name");
                    showButton("more");
                    
                case MODE_CHANGE_LOOKS:
                    showButton("change_looks");
                    showButton("more");
                    
                case MODE_EXPRESSIONS:
                    showButton("wave", true, (!this.widget.isSwimming));
                    showButton("laugh", true, (((!this.widget.hasEffectOn) && (!this.widget.isSwimming)) && this.widget.hasVip), (!this.widget.hasVip));
                    showButton("blow", true, (((!this.widget.hasEffectOn) && (!this.widget.isSwimming)) && this.widget.hasVip), (!this.widget.hasVip));
                    showButton("67", this.widget.configuration.getBoolean("avatar.expression.67.enabled"), (((!this.widget.hasEffectOn) && (!this.widget.isSwimming)) && this.widget.hasVip), (!this.widget.hasVip));
                    showButton("idle", true);
                    if (((this.widget.configuration.getBoolean("avatar.sitting.enabled") && (!this.widget.isSwimming)) && (!_local_3)))
                    {
                        showButton("sit", (this.widget._Str_22586 == AvatarAction.POSTURE_STAND));
                        showButton("stand", this.widget.canStandUp);
                    }
                    showButton("back");
                    
                case MODE_SIGNS:
                    showButtonGrid("signs_grid");
                    showButton("back");
                    
            }
            _buttons.autoArrangeItems = true;
            this.updateMinimizeRegion();
            _buttons.visible = true;
        }

        function updateMinimizeRegion()
        {
            var k:IWindow = null;
            if (((!(_window != null)) || (!(_buttons != null))))
            {
                return;
            }
            k = _window.findChildByName("minimize");
            if (k != null)
            {
                k.y = (_buttons.y + _buttons.height);
                k.visible = true;
            }
        }

        function _Str_23693(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7 = 0;
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_3 = true;
                    _local_4 = "_";
                    _local_5 = (ASCompat.stringAsBool(_arg_2.parent.name) ? _arg_2.parent.name : "");
                    _local_6 = _local_5.substr(0, _local_5.lastIndexOf(_local_4));
                    _local_7 = ASCompat.parseInt(_local_5.substr((_local_5.lastIndexOf(_local_4) + 1)));
                    switch (_local_6)
                    {
                        case "sign":
                            this.widget.sendSignRequest(_local_7);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "sign", null, _local_7);
                            
                    }
                }
            }
            else
            {
                super.buttonEventProc(k, _arg_2);
            }
            if (_local_3)
            {
                _widget.removeView(this, false);
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:RoomWidgetMessage = null;
            var _local_5:IWindow = null;
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_5 = Std.downcast(_arg_2 , IWindowContainer).getChildByName("icon_vip");
                    if (((!(_local_5 == null)) && _local_5.visible))
                    {
                        _widget.catalog.openClubCenter();
                        return;
                    }
                    _local_3 = true;
                    switch (_arg_2.parent.name)
                    {
                        case "wired_inspect":
                            _local_4 = new RoomWidgetUserActionMessage(
                                RoomWidgetUserActionMessage
                                    .RWUAM_WIRED_INSPECT, _Str_2306);
                            
                        case "change_name":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_START_NAME_CHANGE);
                            
                        case "decorate":
                            if (this._Str_22241())
                            {
                                this.widget.isUserDecorating = true;
                            }
                            
                        case "change_looks":
                            this.widget._Str_25121();
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "clothes");
                            
                        case "expressions":
                            _local_3 = false;
                            this._Str_6337(MODE_EXPRESSIONS);
                            
                        case "sit":
                            _local_4 = new RoomWidgetChangePostureMessage(RoomWidgetChangePostureMessage._Str_2016);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "sit");
                            
                        case "stand":
                            _local_4 = new RoomWidgetChangePostureMessage(RoomWidgetChangePostureMessage._Str_1553);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "stand");
                            
                        case "wave":
                            _local_4 = new RoomWidgetAvatarExpressionMessage(AvatarExpressionEnum.WAVE);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "wave");
                            
                        case "blow":
                            _local_4 = new RoomWidgetAvatarExpressionMessage(AvatarExpressionEnum.BLOW);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "blow");
                            
                        case "67":
                            if (this.widget.configuration.getBoolean("avatar.expression.67.enabled"))
                            {
                                _local_4 = new RoomWidgetAvatarExpressionMessage(AvatarExpressionEnum.EXPRESSION_67);
                                HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "67");
                            }
                            
                        case "jump":
                            
                        case "laugh":
                            _local_4 = new RoomWidgetAvatarExpressionMessage(AvatarExpressionEnum.LAUGH);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "laugh");
                            
                        case "idle":
                            _local_4 = new RoomWidgetAvatarExpressionMessage(AvatarExpressionEnum.IDLE);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "idle");
                            
                        case "dance_menu":
                            _local_3 = false;
                            this._Str_6337(MODE_CLUB_DANCES);
                            
                        case "dance":
                            _local_4 = new RoomWidgetDanceMessage(1);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "dance_start");
                            
                        case "dance_stop":
                            _local_4 = new RoomWidgetDanceMessage(0);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "dance_stop");
                            
                        case "dance_1"
                           | "dance_2"
                           | "dance_3"
                           | "dance_4":
                            _local_4 = new RoomWidgetDanceMessage(ASCompat.parseInt(_arg_2.parent.name.charAt((_arg_2.parent.name.length - 1))));
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "dance_start");
                            
                        case "effects":
                            _local_4 = new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_EFFECTS);
                            HabboTracking.getInstance().trackEventLog("OwnAvatarMenu", "click", "effects");
                            
                        case "signs":
                            _local_3 = false;
                            this._Str_6337(MODE_SIGNS);
                            
                        case "back":
                            _local_3 = false;
                            this._Str_6337(MODE_NORMAL);
                            
                        case "more":
                            _local_3 = false;
                            this.widget.useMinimizedOwnAvatarMenu = false;
                            this._Str_6337(MODE_NORMAL);
                            
                        case "handitem":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_DROP_CARRY_ITEM, _Str_2306);
                            
                    }
                }
                if (_arg_2.name == "profile_link")
                {
                    _local_3 = true;
                    _local_4 = new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, userId, "ownAvatarContextMenu");
                }
                if (_local_4 != null)
                {
                    _widget.messageListener.processWidgetMessage(_local_4);
                }
            }
            else
            {
                super.buttonEventProc(k, _arg_2);
            }
            if ((_local_3 && (!_disposed)))
            {
                _widget.removeView(this, false);
            }
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }

        function _Str_6337(k:Int)
        {
            this._mode = k;
            this._Str_2771();
        }

        function _Str_22241():Bool
        {
            return this.widget._Str_6454;
        }
    }

