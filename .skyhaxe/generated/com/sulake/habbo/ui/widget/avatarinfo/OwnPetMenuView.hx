package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPetCommandMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class OwnPetMenuView extends AvatarContextInfoButtonView 
    {
        static inline final MODE_NORMAL= 0;
        static inline final MODE_SADDLED_UP= 1;
        static inline final MODE_RIDING= 2;
        static inline final MODE_MONSTERPLANT= 3;

        var _data:PetInfoData;
        var _mode:Int = 0;
        var _Str_11220:IFurnitureData;
        var _Str_18260:IFurnitureData;
        var _catalog:IHabboCatalog;
        var _habboTracking:IHabboTracking;

        public function new(k:AvatarInfoWidget, _arg_2:IHabboCatalog)
        {
            super(k);
            _Str_3403 = false;
            this._habboTracking = HabboTracking.getInstance();
            this._catalog = _arg_2;
        }

        public static function setup(k:OwnPetMenuView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:PetInfoData)
        {
            k._data = _arg_6;
            var _local_7= k.widget._Str_3859;
            var _local_8= k.widget.isRiding;
            if (k.widget._Str_20290())
            {
                k._mode = MODE_MONSTERPLANT;
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
                        k._mode = MODE_NORMAL;
                    }
                }
            }
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        override public function dispose()
        {
            this._data = null;
            this._Str_11220 = null;
            this._Str_18260 = null;
            this._catalog = null;
            this._habboTracking = null;
            super.dispose();
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
                    k = ((cast(_widget.assets.getAssetByName("own_pet_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
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
                _window.findChildByName("name").caption = _userName;
                _window.visible = false;
                activeView = _window;
                this._Str_2771();
            }
        }

        public function _Str_2771()
        {
            var _local_4 = Math.NaN;
            var _local_5 = Math.NaN;
            var _local_6 = 0;
            var _local_7:IRoomObject = null;
            var _local_8 = 0;
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
            this._Str_11220 = null;
            var _local_3= this.widget.handler;
            switch (this._mode)
            {
                case MODE_NORMAL:
                    showButton("respect", (this._data.petRespectLeft > 0));
                    showButton("train");
                    showButton("pick_up");
                    if (this._data._Str_4355 == PetTypeEnum.HORSE)
                    {
                        this._Str_11220 = this._Str_20669(FurniCategory.PET_SADDLE, PetTypeEnum.HORSE);
                        if (this._Str_11220 != null)
                        {
                            showButton("buy_saddle");
                        }
                    }
                    if (this.widget.configuration.getBoolean("nest.breeding.bear.enabled"))
                    {
                        if (this._data._Str_4355 == PetTypeEnum.BEAR)
                        {
                            showButton("breed");
                        }
                    }
                    if (this.widget.configuration.getBoolean("nest.breeding.terrier.enabled"))
                    {
                        if (this._data._Str_4355 == PetTypeEnum.TERRIER)
                        {
                            showButton("breed");
                        }
                    }
                    if (this.widget.configuration.getBoolean("nest.breeding.cat.enabled"))
                    {
                        if (this._data._Str_4355 == PetTypeEnum.CAT)
                        {
                            showButton("breed");
                        }
                    }
                    if (this.widget.configuration.getBoolean("nest.breeding.dog.enabled"))
                    {
                        if (this._data._Str_4355 == PetTypeEnum.DOG)
                        {
                            showButton("breed");
                        }
                    }
                    if (this.widget.configuration.getBoolean("nest.breeding.pig.enabled"))
                    {
                        if (this._data._Str_4355 == PetTypeEnum.PIG)
                        {
                            showButton("breed");
                        }
                    }
                    
                case MODE_SADDLED_UP:
                    showButton("mount");
                    if (this.widget.configuration.getBoolean("sharedhorseriding.enabled"))
                    {
                        showButton("toggle_riding_permission");
                        this._Str_13657("toggle_riding_permission", ((this._data != null) ? (this._data.publiclyRideable == PetAccessRightTypeEnum._Str_18396) : false));
                    }
                    showButton("respect", (this._data.petRespectLeft > 0));
                    showButton("train");
                    showButton("pick_up");
                    showButton("saddle_off");
                    
                case MODE_RIDING:
                    showButton("dismount");
                    showButton("respect", (this._data.petRespectLeft > 0));
                    
                case MODE_MONSTERPLANT:
                    showButton("pick_up");
                    if (this._data.dead)
                    {
                        this._Str_18260 = this._Str_20669(FurniCategory.MONSTERPLANT_REVIVAL, PetTypeEnum.MONSTERPLANT);
                        showButton("revive");
                        if ((this.widget.configuration.getBoolean("monsterplants.composting.enabled") && _local_3.container.roomSession.isRoomOwner))
                        {
                            showButton("compost");
                        }
                    }
                    else
                    {
                        _local_4 = ASCompat.asNumber(this._data.energy );
                        _local_5 = ASCompat.asNumber(this._data.maximumEnergy );
                        showButton("treat", true, ((_local_4 / _local_5) < 0.98));
                        if (this._data.level == this._data.maximumLevel)
                        {
                            if (this._data.breedable)
                            {
                                showButton("toggle_breeding_permission");
                                this._Str_13657("toggle_breeding_permission", this._data.publiclyBreedable);
                                showButton("breed");
                            }
                        }
                    }
                    
            }
            if (this.widget.configuration.getBoolean("handitem.give.pet.enabled"))
            {
                _local_6 = _local_3.container.roomSession.ownUserRoomId;
                _local_7 = _local_3.container.roomEngine.getRoomObject(_local_3.roomSession.roomId, _local_6, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                if (_local_7 != null)
                {
                    _local_8 = Std.int(_local_7.getModel().getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT));
                    if (((_local_8 > 0) && (_local_8 < 999999)))
                    {
                        showButton("pass_handitem");
                    }
                }
            }
            this.widget.localizations.registerParameter("infostand.button.petrespect", "count", Std.string(this._data.petRespectLeft));
            showButton("wired_inspect",
                this.widget.handler.container.userDefinedRoomEvents
                    .showInspectButton());
            _buttons.autoArrangeItems = true;
            _buttons.visible = true;
        }

        function _Str_20669(k:Int, _arg_2:Int):IFurnitureData
        {
            var _local_5:IFurnitureData = null;
            var _local_6:Array<ASAny> = null;
            var _local_7 = 0;
            var _local_3:IFurnitureData = null;
            var _local_4= this.widget.handler.container.sessionDataManager.getFloorItemsDataByCategory(k);
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                _local_6 = (cast _local_5.customParams.split(" "));
                _local_7 = (((_local_6 != null) && (_local_6.length >= 1)) ? ASCompat.parseInt(_local_6[0]) : -1);
                if (_local_7 == _arg_2)
                {
                    _local_3 = _local_5;
                    break;
                }
            }
            return _local_3;
        }

        function openCatalogPage(k:IFurnitureData):Bool
        {
            if ((((this._catalog == null) || (k == null)) || (k.purchaseOfferId < 0)))
            {
                return false;
            }
            this._catalog.openCatalogPageByOfferId(k.purchaseOfferId, CatalogType.NORMAL);
            if (((this._habboTracking != null) && (!this._habboTracking.disposed)))
            {
                this._habboTracking.trackGoogle("infostandCatalogButton", "offer", k.purchaseOfferId);
            }
            return true;
        }

        function _Str_8946(k:IFurnitureData):IRoomObject
        {
            var _local_7:IRoomObject = null;
            var _local_8 = 0;
            if (((this.widget == null) || (k == null)))
            {
                return null;
            }
            var _local_2= this.widget.handler.container;
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= _local_2.roomEngine;
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= _local_2.roomSession.roomId;
            var _local_5= _local_3.getRoomObjectCount(_local_4, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            var _local_6 = 0;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_3.getRoomObjectWithIndex(_local_4, _local_6, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                if (_local_7 != null)
                {
                    _local_8 = Std.int(_local_7.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                    if (_local_8 == k.id)
                    {
                        return _local_7;
                    }
                }
                _local_6++;
            }
            return null;
        }

        function _Str_13657(k:String, _arg_2:Bool)
        {
            var _local_3= this._Str_18445(k);
            if (_local_3 == null)
            {
                return;
            }
            if (_arg_2)
            {
                _local_3.select();
            }
            else
            {
                _local_3.unselect();
            }
        }

        function _Str_18445(k:String):ICheckBoxWindow
        {
            if (_buttons == null)
            {
                return null;
            }
            var _local_2= Std.downcast(_buttons.getListItemByName(k) , IWindowContainer);
            if (_local_2 == null)
            {
                return null;
            }
            return Std.downcast(_local_2.findChildByName((k + "_checkbox")) , ICheckBoxWindow);
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:RoomWidgetMessage = null;
            var _local_5:ICheckBoxWindow = null;
            var _local_6 = false;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:String = null;
            if (disposed)
            {
                return;
            }
            if (((!(_window != null)) || _window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_3 = true;
                    Logger.log([("Own pet menu was clicked: " + _arg_2.parent.name)]);
                    switch (_arg_2.parent.name)
                    {
                        case "wired_inspect":
                            _local_4 = new RoomWidgetUserActionMessage(
                                RoomWidgetUserActionMessage
                                    .RWUAM_WIRED_INSPECT_PET, this.petId);
                            
                        case "respect":
                            this._data.petRespectLeft--;
                            this._Str_2771();
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RESPECT_PET, this.petId);
                            
                        case "treat":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TREAT_PET, this.petId);
                            
                        case "pass_handitem":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_GIVE_CARRY_ITEM_TO_PET, this.petId);
                            
                        case "train":
                            this.widget._Str_23877();
                            
                        case "pick_up":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_PICKUP_PET, this.petId);
                            this.widget._Str_25401();
                            
                        case "mount":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_MOUNT_PET, this.petId);
                            
                        case "toggle_riding_permission":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TOGGLE_PET_RIDING_PERMISSION, this.petId);
                            _local_5 = this._Str_18445("toggle_riding_permission");
                            if (_local_5 != null)
                            {
                                this._Str_13657("toggle_riding_permission", (!_local_5.Selected));
                            }
                            
                        case "toggle_breeding_permission":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TOGGLE_PET_BREEDING_PERMISSION, this.petId);
                            _local_5 = this._Str_18445("toggle_breeding_permission");
                            if (_local_5 != null)
                            {
                                this._Str_13657("toggle_breeding_permission", (!_local_5.Selected));
                            }
                            
                        case "dismount":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_DISMOUNT_PET, this.petId);
                            
                        case "saddle_off":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_SADDLE_OFF, this.petId);
                            
                        case "breed":
                            if (this._mode == MODE_NORMAL)
                            {
                                _local_7 = RoomWidgetPetCommandMessage._Str_16282;
                                _local_8 = ("pet.command." + Std.string(_local_7));
                                _local_9 = _widget.catalog.localization.getLocalization(_local_8);
                                _local_4 = new RoomWidgetPetCommandMessage(RoomWidgetPetCommandMessage.RWPCM_PET_COMMAND, this._data.id, ((this._data.name + " ") + _local_9));
                            }
                            else
                            {
                                if (this._mode == MODE_MONSTERPLANT)
                                {
                                    _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_REQUEST_BREED_PET, this.petId);
                                }
                            }
                            
                        case "harvest":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_HARVEST_PET, this.petId);
                            
                        case "revive":
                            _local_6 = this.openCatalogPage(this._Str_18260);
                            if (!_local_6)
                            {
                            }
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_REVIVE_PET, this.petId);
                            
                        case "compost":
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_COMPOST_PLANT, this.petId);
                            
                        case "buy_saddle":
                            this.openCatalogPage(this._Str_11220);
                            
                    }
                }
                else
                {
                    if (_arg_2.name == "profile_link")
                    {
                        _local_4 = new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, this.petId, "ownPetContextMenu");
                    }
                    else
                    {
                        if (_arg_2.name == "toggle_riding_permission_checkbox")
                        {
                            _local_3 = true;
                            _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TOGGLE_PET_RIDING_PERMISSION, this.petId);
                        }
                        else
                        {
                            if (_arg_2.name == "toggle_breeding_permission_checkbox")
                            {
                                _local_3 = true;
                                _local_4 = new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_TOGGLE_PET_BREEDING_PERMISSION, this.petId);
                            }
                        }
                    }
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
            if (_local_3)
            {
                _widget.removeView(this, false);
            }
        }

        public var widget(get,never):AvatarInfoWidget;
public function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }

        function _Str_6337(k:Int)
        {
            this._mode = k;
            this._Str_2771();
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return userId;
        }
    }

