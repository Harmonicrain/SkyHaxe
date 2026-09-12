package com.sulake.habbo.inventory
;
    import flash.geom.Point;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils._Str_3942;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.recycler._Str_3718;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;

     class InventoryMainView 
    {
        static inline final _Str_3504= 3;

        final _Str_6092:Point = new Point(120, 150);

        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _mainWindow:IFrameWindow;
        var _lastViewId:String;
        var _lastView:IWindowContainer;
        var _lastSubViewId:String;
        var _lastSubView:IWindowContainer;
        var _controller:HabboInventory;
        var _toolbar:IHabboToolbar;
        var _unseenFurniCounter:IWindowContainer;
        var _unseenRentedFurniCounter:IWindowContainer;
        var _unseenBadgeCounter:IWindowContainer;
        var _unseenPetsCounter:IWindowContainer;
        var _unseenBotCounter:IWindowContainer;
        var _inventoryViews:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._controller = k;
            this._assetLibrary = _arg_3;
            this._windowManager = _arg_2;
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return (this._mainWindow != null) ? this._mainWindow.visible : false;
        }

        public var isActive(get,never):Bool;
public function  get_isActive():Bool
        {
            return (this._mainWindow != null) ? this._mainWindow.getStateFlag(WindowState.ACTIVE) : false;
        }

        public var _Str_11062(get,never):IWindowContainer;
public function  get__Str_11062():IWindowContainer
        {
            if (this._mainWindow == null)
            {
                return null;
            }
            return Std.downcast(this._mainWindow.findChildByName("empty_container") , IWindowContainer);
        }

        public var _Str_10034(get,never):IWindowContainer;
public function  get__Str_10034():IWindowContainer
        {
            if (this._mainWindow == null)
            {
                return null;
            }
            return Std.downcast(this._mainWindow.findChildByName("loading_container") , IWindowContainer);
        }

        public var mainContainer(get,never):IWindowContainer;
public function  get_mainContainer():IWindowContainer
        {
            if (this._mainWindow == null)
            {
                return null;
            }
            return Std.downcast(this._mainWindow.findChildByName("contentArea") , IWindowContainer);
        }

        public function dispose()
        {
            this._unseenFurniCounter = null;
            this._unseenRentedFurniCounter = null;
            this._unseenBotCounter = null;
            this._unseenPetsCounter = null;
            this._unseenBadgeCounter = null;
            this._controller = null;
            this._lastView = null;
            this._lastSubView = null;
            if (this._mainWindow != null)
            {
                this._mainWindow.dispose();
                this._mainWindow = null;
            }
            if (this._toolbar != null)
            {
                if (this._toolbar.events != null)
                {
                    this._toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this._Str_3304);
                }
                this._toolbar = null;
            }
            this._windowManager = null;
            this._assetLibrary = null;
        }

        function _Str_5493():IFrameWindow
        {
            var k:IAsset = null;
            var _local_2:XmlAsset = null;
            var _local_3:ITabContextWindow = null;
            var _local_4:Array<ASAny> = null;
            var _local_5:ITabButtonWindow = null;
            if (this._mainWindow == null)
            {
                k = this._assetLibrary.getAssetByName("inventory_xml");
                _local_2 = cast(k, XmlAsset);
                this._inventoryViews = new ASDictionary<ASAny,ASAny>();
                this._mainWindow = Std.downcast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_2.content)) , IFrameWindow);
                if (this._mainWindow != null)
                {
                    this._mainWindow.position = this._Str_6092;
                    this._mainWindow.visible = false;
                    this._mainWindow.procedure = this.windowEventProc;
                    this._mainWindow.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET, this._controller.getBoolean("inventory.allow.scaling"));
                    this._Str_15287(InventoryCategory.FURNI);
                    this._Str_15287(InventoryCategory.PETS);
                    this._Str_15287(InventoryCategory.BOTS);
                    this._Str_15287(InventoryCategory.BADGES);
                    _local_3 = Std.downcast(this._mainWindow.findChildByName("tabs") , ITabContextWindow);
                    _local_4 = [];
                    while (_local_3.numTabs > 0)
                    {
                        _local_5 = _local_3.getTabButtonAt(0);
                        _local_4.push(_local_5);
                        _local_3._Str_5897(_local_5);
                    }
                    if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                    {
_local_5  = _tmp_;
                        switch (_local_5.name)
                        {
                            case InventoryCategory.BOTS:
                                if (this._controller.getBoolean("inventory.bots.enabled"))
                                {
                                    _local_3._Str_5377(_local_5);
                                }
                                
                            case InventoryCategory.RENTABLES:
                                if (this._controller.getBoolean("duckets.enabled"))
                                {
                                    _local_3._Str_5377(_local_5);
                                }
                                
                            default:
                                _local_3._Str_5377(_local_5);
                        }
                    }
                    this._controller._Str_24810();
                }
                this._controller._Str_6956();
            }
            if (this._mainWindow.y < 0)
            {
                this._mainWindow.y = 0;
            }
            if (this._mainWindow.x < 0)
            {
                this._mainWindow.x = 0;
            }
            return this._mainWindow;
        }

        public function _Str_26395():String
        {
            return this._lastViewId;
        }

        public function _Str_18332():String
        {
            return this._lastSubViewId;
        }

        public function _Str_15430()
        {
            this._controller.onInventoryClose();
            var k:IWindow = this._Str_5493();
            if (k == null)
            {
                return;
            }
            k.visible = false;
        }

        public function _Str_24385()
        {
            var k:IWindow = this._Str_5493();
            if (k == null)
            {
                return;
            }
            k.visible = true;
            this._controller._Str_18877(((ASCompat.stringAsBool(this._lastSubViewId) && (this._lastSubViewId.length > 0)) ? this._lastSubViewId : this._lastViewId));
        }

        public function toggleCategoryView(k:String, _arg_2:Bool=true, _arg_3:Bool=false):Bool
        {
            var _local_4:IWindow = this._Str_5493();
            if (_local_4 == null)
            {
                return false;
            }
            if (_local_4.visible)
            {
                if (this._lastViewId == k)
                {
                    if (_arg_2)
                    {
                        if (_Str_3942._Str_9211(_local_4))
                        {
                            _local_4.activate();
                        }
                        else
                        {
                            this._Str_15430();
                            return false;
                        }
                    }
                }
                else
                {
                    this.setViewToCategory(k);
                }
            }
            else
            {
                if (((_arg_3 && (!(this._lastViewId == null))) && (!(this._lastViewId == k))))
                {
                    this.setViewToCategory(k);
                }
                _local_4.visible = true;
                _local_4.activate();
                if (((!(k == this._lastViewId)) || (!this._controller._Str_18826(k))))
                {
                    this.setViewToCategory(k);
                }
                this._controller._Str_18877(k);
            }
            return true;
        }

        public function _Str_24934(k:String, _arg_2:Bool=true)
        {
            var _local_3:IWindow = this._Str_5493();
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3.visible)
            {
                if (this._lastSubViewId == k)
                {
                    if (_arg_2)
                    {
                        _local_3.visible = false;
                    }
                }
                else
                {
                    this._Str_16548(k);
                }
            }
            else
            {
                _local_3.visible = true;
                if (k != this._lastSubViewId)
                {
                    this._Str_16548(k);
                }
            }
        }

        public function _Str_23647()
        {
            if (this._lastSubViewId == null)
            {
                return;
            }
            this._Str_16548(this._lastSubViewId);
        }

        public function _Str_26316(k:IHabboToolbar)
        {
            this._toolbar = k;
            this._toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this._Str_3304);
        }

        public function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                _local_3 = cast(_arg_2, ITabContextWindow).selector.getSelected().name;
                if (_local_3 != this._lastViewId)
                {
                    this.resetUnseenCounters(this._lastViewId);
                    this._controller.toggleInventoryPage(_local_3);
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    if (_arg_2.name == "header_button_close")
                    {
                        this._Str_15430();
                    }
                    if (_arg_2.name == "open_catalog_btn")
                    {
                        this._controller.catalog.openCatalog();
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.DOUBLE_CLICK)
                    {
                        if (_arg_2.name == "titlebar")
                        {
                            this._mainWindow.height = this._mainWindow.limits.minHeight;
                        }
                    }
                }
            }
        }

        public function _Str_23205(k:Int)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            if (this._unseenFurniCounter == null)
            {
                this._unseenFurniCounter = this._Str_11957(InventoryCategory.FURNI);
            }
            this._Str_6423(this._unseenFurniCounter, k);
            this._controller.furniModel.updateView();
        }

        public function _Str_25138(k:Int)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            if (this._unseenRentedFurniCounter == null)
            {
                this._unseenRentedFurniCounter = this._Str_11957(InventoryCategory.RENTABLES);
            }
            this._Str_6423(this._unseenRentedFurniCounter, k);
            this._controller.furniModel.updateView();
        }

        public function _Str_22445(k:Int)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            if (this._unseenPetsCounter == null)
            {
                this._unseenPetsCounter = this._Str_11957(InventoryCategory.PETS);
            }
            this._Str_6423(this._unseenPetsCounter, k);
            this._controller._Str_4524.updateView();
        }

        public function _Str_24193(k:Int)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            if (this._unseenBadgeCounter == null)
            {
                this._unseenBadgeCounter = this._Str_11957(InventoryCategory.BADGES);
            }
            this._Str_6423(this._unseenBadgeCounter, k);
            this._controller.badgesModel.updateView();
        }

        public function _Str_24185(k:Int)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            if (this._unseenBotCounter == null)
            {
                this._unseenBotCounter = this._Str_11957(InventoryCategory.BOTS);
            }
            this._Str_6423(this._unseenBotCounter, k);
            this._controller._Str_8302.updateView();
        }

        public function _Str_9043(k:String):IWindowContainer
        {
            return ASCompat.dynamicAs(this._inventoryViews[k] , IWindowContainer);
        }

        function _Str_15287(k:String)
        {
            var _local_2= this.mainContainer.getChildByName(k);
            if (_local_2 != null)
            {
                this._inventoryViews[k] = this.mainContainer.removeChild(_local_2);
            }
        }

        function resetUnseenCounters(k:String)
        {
            switch (k)
            {
                case InventoryCategory.FURNI:
                    this._controller.furniModel._Str_4409();
                    return;
                case InventoryCategory.RENTABLES:
                    this._controller.furniModel._Str_4409();
                    return;
                case InventoryCategory.PETS:
                    this._controller._Str_4524._Str_4409();
                    return;
                case InventoryCategory.BADGES:
                    this._controller.badgesModel._Str_4409();
                    return;
                case InventoryCategory.BOTS:
                    this._controller._Str_8302._Str_4409();
                    return;
            }
        }

        function setViewToCategory(k:String)
        {
            if (k == null)
            {
                return;
            }
            if (k == "")
            {
                return;
            }
            if (this._Str_11062 != null)
            {
                this._Str_11062.visible = false;
            }
            if (this._Str_10034 != null)
            {
                this._Str_10034.visible = false;
            }
            this._controller.checkCategoryInitilization(k);
            if (this.mainContainer == null)
            {
                return;
            }
            this.mainContainer.removeChild(this._lastView);
            this.mainContainer.invalidate();
            var _local_2= this._controller.getCategoryWindowContainer(k);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.visible = true;
            this.mainContainer.addChild(_local_2);
            _local_2.width = this.mainContainer.width;
            _local_2.height = this.mainContainer.height;
            this._controller.updateView(k);
            this._lastView = _local_2;
            this._lastViewId = k;
            var _local_3= Std.downcast(this._mainWindow.findChildByName("tabs") , ITabContextWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.selector.setSelected(_local_3.selector.getSelectableByName(k));
            this._Str_24643();
        }

        function _Str_24643()
        {
            var _local_2 = 0;
            var _local_3:_Str_3718 = null;
            var k= this._controller.catalog.getRecycler();
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.numberOfSlots)
                {
                    _local_3 = k._Str_18924(_local_2);
                    if (_local_3 != null)
                    {
                        k.releaseSlot(_local_2);
                    }
                    _local_2++;
                }
            }
        }

        function enableScaling()
        {
            this._mainWindow.height = this._mainWindow.limits.minHeight;
            this._mainWindow.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET, true);
            this._mainWindow.findChildByName("top_content").setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH, true);
        }

        function _Str_22922()
        {
            this._mainWindow.height = this._mainWindow.limits.minHeight;
            this._mainWindow.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET, false);
            this._mainWindow.findChildByName("top_content").setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH, false);
        }

        function _Str_16548(k:String)
        {
            if (((k == null) || (k == "")))
            {
                return;
            }
            this._controller.checkCategoryInitilization(k);
            var _local_2= Std.downcast(this._mainWindow.findChildByName("subContentArea") , IWindowContainer);
            while (_local_2.numChildren > 0)
            {
                _local_2.removeChildAt(0);
            }
            var _local_3= this._controller._Str_24435(k);
            if (_local_3 != null)
            {
                this._Str_22922();
                _local_2.visible = true;
                _local_3.visible = true;
                _local_2.height = _local_3.height;
                _local_2.addChild(_local_3);
            }
            else
            {
                this.enableScaling();
                _local_2.visible = false;
                _local_2.height = 0;
            }
            _local_2.y = Std.int(this._mainWindow.findChildByName("top_content").rectangle.bottom + 5);
            this._mainWindow._Str_5665();
            if (this._mainWindow.parent != null)
            {
                if ((this._mainWindow.x + this._mainWindow.width) > this._mainWindow.parent.width)
                {
                    this._mainWindow.x = (this._mainWindow.parent.width - this._mainWindow.width);
                }
                if ((this._mainWindow.y + this._mainWindow.height) > this._mainWindow.parent.height)
                {
                    this._mainWindow.y = Std.int((this._mainWindow.parent.height - this._mainWindow.height) * 0.5);
                }
                if (this._mainWindow.y < 0)
                {
                    this._mainWindow.y = 0;
                }
            }
            this._lastSubView = _local_3;
            this._lastSubViewId = k;
        }

        function _Str_11957(k:String):IWindowContainer
        {
            var _local_2= this._windowManager.createUnseenItemCounter();
            var _local_3= Std.downcast(this._mainWindow.findChildByName(k) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.addChild(_local_2);
                _local_2.x = ((_local_3.width - _local_2.width) - _Str_3504);
                _local_2.y = _Str_3504;
            }
            return _local_2;
        }

        function _Str_6423(k:IWindowContainer, _arg_2:Int)
        {
            var _local_5:ILabelWindow = null;
            k.findChildByName("count").caption = Std.string(_arg_2);
            k.visible = (_arg_2 > 0);
            var _local_3= "";
            switch (k)
            {
                case (_ == this._unseenBotCounter => true):
                    _local_3 = InventoryCategory.BOTS;
                    
                case (_ == this._unseenPetsCounter => true):
                    _local_3 = InventoryCategory.PETS;
                    
                case (_ == this._unseenBadgeCounter => true):
                    _local_3 = InventoryCategory.BADGES;
                    
                case (_ == this._unseenFurniCounter => true):
                    _local_3 = InventoryCategory.FURNI;
                    
                case (_ == this._unseenRentedFurniCounter => true):
                    _local_3 = InventoryCategory.RENTABLES;
                    

default:
            }
            var _local_4= Std.downcast(this._mainWindow.findChildByName(_local_3) , IWindowContainer);
            if (_local_4 != null)
            {
                _local_5 = Std.downcast(_local_4.getChildByTag("TITLE") , ILabelWindow);
                if (_local_5 != null)
                {
                    if (k.visible)
                    {
                        _local_5.margins.right = (k.width + (2 * _Str_3504));
                    }
                    else
                    {
                        _local_5.margins.right = _local_5.margins.left;
                    }
                    _local_4.width = _local_5.width;
                    k.x = ((_local_4.width - k.width) - _Str_3504);
                }
            }
        }

        public function _Str_3304(k:HabboToolbarEvent)
        {
            if (k.iconId != HabboToolbarIconEnum.INVENTORY)
            {
                return;
            }
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                if (this._lastViewId == InventoryCategory.PETS)
                {
                    this.toggleCategoryView(InventoryCategory.PETS);
                }
                else
                {
                    if (this._lastViewId == InventoryCategory.FURNI)
                    {
                        this.toggleCategoryView(InventoryCategory.FURNI);
                    }
                    else
                    {
                        if (this._lastViewId == InventoryCategory.RENTABLES)
                        {
                            this.toggleCategoryView(InventoryCategory.RENTABLES);
                        }
                        else
                        {
                            if (this._lastViewId == InventoryCategory.BADGES)
                            {
                                this.toggleCategoryView(InventoryCategory.BADGES);
                            }
                            else
                            {
                                if (this._lastViewId == InventoryCategory.BOTS)
                                {
                                    this.toggleCategoryView(InventoryCategory.BOTS);
                                }
                                else
                                {
                                    if (this._controller != null)
                                    {
                                        this._controller.toggleInventoryPage(InventoryCategory.FURNI);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

