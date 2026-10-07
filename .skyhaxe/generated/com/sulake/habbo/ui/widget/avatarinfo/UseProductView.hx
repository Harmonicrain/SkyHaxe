package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.events._Str_3858;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class UseProductView extends AvatarContextInfoButtonView 
    {
        static inline final MODE_NORMAL= 0;
        static inline final _Str_13718= 1;
        static inline final _Str_14146= 2;
        static inline final _Str_15667= 3;
        static inline final _Str_14658= 4;
        static inline final _Str_14165= 5;
        static inline final _Str_12577= 6;
        static inline final _Str_14611= 7;

        var _mode:Int = 0;
        var _useProductItem:_Str_3858;

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            _Str_3403 = false;
        }

        public static function setup(k:UseProductView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:_Str_3858)
        {
            k._useProductItem = _arg_6;
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._useProductItem.id;
        }

        public var _Str_3710(get,never):Int;
public function  get__Str_3710():Int
        {
            return this._useProductItem._Str_3710;
        }

        override public function dispose()
        {
            if (window != null)
            {
                window.removeEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                window.removeEventListener(WindowMouseEvent.OUT, onMouseOverOut);
            }
            if (this._useProductItem != null)
            {
                this._useProductItem.dispose();
            }
            this._useProductItem = null;
            super.dispose();
        }

        function _Str_18845()
        {
            var _local_3:IFurnitureData = null;
            var k= this.widget.handler.roomSession.roomId;
            var _local_2= this.widget.handler.roomEngine.getRoomObject(k, this._useProductItem._Str_3710, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (_local_2 != null)
            {
                _local_3 = this.widget.handler.getFurniData(_local_2);
            }
            else
            {
                _local_3 = this.widget.handler.container.sessionDataManager.getFloorItemData(this._useProductItem._Str_3710);
            }
            if (_local_3 == null)
            {
                return;
            }
            this._mode = MODE_NORMAL;
            switch (_local_3.category)
            {
                case FurniCategory.PET_SHAMPOO:
                    this._mode = _Str_13718;
                    return;
                case FurniCategory.PET_CUSTOM_PART:
                    this._mode = _Str_14146;
                    return;
                case FurniCategory.PET_CUSTOM_PART_SHAMPOO:
                    this._mode = _Str_15667;
                    return;
                case FurniCategory.PET_SADDLE:
                    this._mode = _Str_14658;
                    return;
                case FurniCategory.MONSTERPLANT_REVIVAL:
                    this._mode = _Str_14165;
                    return;
                case FurniCategory.MONSTERPLANT_REBREED:
                    this._mode = _Str_12577;
                    return;
                case FurniCategory.MONSTERPLANT_FERTILIZE:
                    this._mode = _Str_14611;
                    return;
                default:
                    Logger.log([("[UseProductView.open()] Unsupported furniture category: " + Std.string(_local_3.category))]);
            }
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            this._Str_18845();
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (_window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("use_product_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (_window == null)
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
                _buttons.procedure = this.buttonEventProc;
                _window.findChildByName("name").caption = _userName;
                _window.visible = false;
                activeView = window;
                this._Str_2771();
            }
        }

        public function _Str_2771()
        {
            if (((!(_window != null)) || (!(_buttons != null))))
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
            switch (this._mode)
            {
                case MODE_NORMAL:
                    showButton("use_product");
                    
                case _Str_13718:
                    showButton("use_product_shampoo");
                    
                case _Str_14146:
                    showButton("use_product_custom_part");
                    
                case _Str_15667:
                    showButton("use_product_custom_part_shampoo");
                    
                case _Str_14658:
                    if (this._useProductItem.replace)
                    {
                        showButton("replace_product_saddle");
                    }
                    else
                    {
                        showButton("use_product_saddle");
                    }
                    
                case _Str_14165:
                    showButton("revive_monsterplant");
                    
                case _Str_12577:
                    showButton("rebreed_monsterplant");
                    
                case _Str_14611:
                    showButton("fertilize_monsterplant");
                    
            }
            _buttons.autoArrangeItems = true;
            _buttons.visible = true;
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:RoomWidgetMessage = null;
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
                    switch (_arg_2.parent.name)
                    {
                        case "use_product"
                           | "use_product_shampoo"
                           | "use_product_custom_part"
                           | "use_product_custom_part_shampoo"
                           | "use_product_saddle"
                           | "replace_product_saddle"
                           | "revive_monsterplant"
                           | "rebreed_monsterplant"
                           | "fertilize_monsterplant":
                            this.widget.showUseProductConfirmation(this._useProductItem._Str_3710, this._useProductItem._Str_5563, this._useProductItem._Str_24139);
                            
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
                this.widget.removeUseProductViews();
            }
        }

        function _Str_6337(k:Int)
        {
            this._mode = k;
            this._Str_2771();
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }

