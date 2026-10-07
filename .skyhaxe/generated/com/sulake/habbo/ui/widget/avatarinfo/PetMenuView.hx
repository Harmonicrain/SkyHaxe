package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.handler.AvatarInfoWidgetHandler;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class PetMenuView extends AvatarContextInfoButtonView 
    {
        static inline final MODE_NORMAL:UInt = 0;
        static inline final MODE_SADDLED_UP= 1;
        static inline final MODE_RIDING= 2;
        static inline final MODE_MONSTER_PLANT= 3;

        var _data:PetInfoData;
        var _mode:Int = 0;

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            _Str_3403 = false;
        }

        public static function setup(k:PetMenuView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:PetInfoData)
        {
            k._data = _arg_6;
            var _local_7= k.widget._Str_3859;
            var _local_8= k.widget.isRiding;
            if (k.widget._Str_20290())
            {
                k._mode = MODE_MONSTER_PLANT;
            }
            else
            {
                if ((_local_7 && (!_local_8)))
                {
                    k._mode = MODE_SADDLED_UP;
                }
                else
                {
                    if (_local_8)
                    {
                        k._mode = MODE_RIDING;
                    }
                    else
                    {
                        k._mode = ASCompat.toInt(MODE_NORMAL);
                    }
                }
            }
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

        function _Str_2771()
        {
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8:AvatarInfoWidgetHandler = null;
            var _local_9 = 0;
            var _local_10:IRoomObject = null;
            var _local_11 = 0;
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
            var _local_4= this.widget.handler.roomSession;
            var _local_5= this.widget.handler.container.sessionDataManager;
            if (((_local_4.isRoomOwner || _local_5.isAnyRoomController) || (_local_4.roomControllerLevel >= RoomControllerLevel.GUEST)))
            {
                showButton("pick_up");
            }
            switch (this._mode)
            {
                case MODE_NORMAL:
                    showButton("respect", (this._data.petRespectLeft > 0));
                    
                case MODE_SADDLED_UP:
                    if (this.widget.configuration.getBoolean("sharedhorseriding.enabled"))
                    {
                        showButton("mount");
                    }
                    showButton("respect", (this._data.petRespectLeft > 0));
                    
                case MODE_RIDING:
                    if (this.widget.configuration.getBoolean("sharedhorseriding.enabled"))
                    {
                        showButton("dismount");
                    }
                    showButton("respect", (this._data.petRespectLeft > 0));
                    
                case MODE_MONSTER_PLANT:
                    if (!this._data.dead)
                    {
                        showButton("respect", false);
                        _local_6 = ASCompat.asNumber(this._data.energy );
                        _local_7 = ASCompat.asNumber(this._data.maximumEnergy );
                        showButton("treat", true, ((_local_6 / _local_7) < 0.98));
                    }
                    
            }
            this.widget.localizations.registerParameter("infostand.button.petrespect", "count", Std.string(this._data.petRespectLeft));
            if (this.widget.configuration.getBoolean("handitem.give.pet.enabled"))
            {
                _local_8 = this.widget.handler;
                _local_9 = _local_8.container.roomSession.ownUserRoomId;
                _local_10 = _local_8.container.roomEngine.getRoomObject(_local_8.roomSession.roomId, _local_9, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                if (_local_10 != null)
                {
                    _local_11 = Std.int(_local_10.getModel().getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT));
                    if (((_local_11 > 0) && (_local_11 < 999999)))
                    {
                        showButton("pass_handitem");
                    }
                }
            }
            showButton("wired_inspect",
                this.widget.handler.container.userDefinedRoomEvents
                    .showInspectButton());
            k.autoArrangeItems = true;
            k.visible = true;
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
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
                    k = ((cast(_widget.assets.getAssetByName("pet_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
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
                window.findChildByName("name").caption = _userName;
                window.visible = false;
                activeView = window;
                this._Str_2771();
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_5:String = null;
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
                            _local_4 = new RoomWidgetUserActionMessage(
                                RoomWidgetUserActionMessage
                                    .RWUAM_WIRED_INSPECT_PET, userId);
                            
                        case "mount":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_MOUNT_PET, userId);
                            
                        case "dismount":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_DISMOUNT_PET, userId);
                            
                        case "respect":
                            this._data.petRespectLeft--;
                            this._Str_2771();
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RESPECT_PET, userId);
                            
                        case "treat":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TREAT_PET, userId);
                            
                        case "pass_handitem":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_GIVE_CARRY_ITEM_TO_PET, userId);
                            
                        case "pick_up":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_PICKUP_PET, userId);
                            
                    }
                }
                if (_arg_2.name == "profile_link")
                {
                    _local_4 = new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, _Str_2306, "petContextMenu");
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
                this._Str_2771();
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

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }

