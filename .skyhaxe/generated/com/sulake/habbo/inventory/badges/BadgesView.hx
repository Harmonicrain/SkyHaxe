package com.sulake.habbo.inventory.badges
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.Core;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;

     class BadgesView implements IInventoryView 
    {
        var _windowManager:IHabboWindowManager;
        var _view:IWindowContainer;
        var _model:BadgesModel;
        var _inactiveGrid:IItemGridWindow;
        var _activeGrid:IItemGridWindow;
        var _disposed:Bool = false;
        var _isInitialized:Bool = false;
        var _filteredBadges:Array<ASAny>;

        public function new(k:BadgesModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._model = k;
            this._windowManager = _arg_2;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return ((this._view != null) && (!(this._view.parent == null))) && this._view.visible;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._windowManager = null;
            this._model = null;
            this._inactiveGrid = null;
            this._activeGrid = null;
            this._filteredBadges = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (((this._view == null) || this._view.disposed))
            {
                return null;
            }
            return this._view;
        }

        public function _Str_18918(k:String)
        {
            this._Str_13242(k);
            this._Str_2944();
        }

        public function _Str_2944()
        {
            var _local_3:Array<ASAny> = null;
            if (!this._isInitialized)
            {
                return;
            }
            if (((this._view == null) || this._view.disposed))
            {
                return;
            }
            var k= Std.downcast(this._view.findChildByName("wearBadge_button") , IButtonWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= this._model._Str_17378();
            if (_local_2 == null)
            {
                k.disable();
                this._Str_19119(null);
                this._Str_20172(null);
                this._view.findChildByName("badge_image").visible = false;
            }
            else
            {
                if (_local_2.isInUse)
                {
                    k.caption = "${inventory.badges.clearbadge}";
                }
                else
                {
                    k.caption = "${inventory.badges.wearbadge}";
                }
                this._Str_19119(this._model.controller.localization.getBadgeName(_local_2.badgeId));
                this._Str_20172(this._model.controller.localization.getBadgeDesc(_local_2.badgeId));
                cast(cast(this._view.findChildByName("badge_image"), IWidgetWindow).widget, IBadgeImageWidget).badgeId = _local_2.badgeId;
                this._view.findChildByName("badge_image").visible = true;
                _local_3 = this._model._Str_5453(BadgesModel._Str_6557);
                if ((((!(_local_3 == null)) && (_local_3.length >= this._model._Str_23348())) && (!_local_2.isInUse)))
                {
                    k.disable();
                }
                else
                {
                    k.enable();
                }
            }
        }

        function init()
        {
            this._view = this._model.controller.view._Str_9043(InventoryCategory.BADGES);
            this._view.procedure = this.windowEventProc;
            this._view.visible = false;
            var k= this._view.findChildByName("wearBadge_button");
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_24890);
            }
            this._inactiveGrid = Std.downcast(this._view.findChildByName("inactive_items") , IItemGridWindow);
            this._inactiveGrid.addEventListener(WindowMouseEvent.CLICK, this._Str_20827);
            this._activeGrid = Std.downcast(this._view.findChildByName("active_items") , IItemGridWindow);
            this._activeGrid.addEventListener(WindowMouseEvent.CLICK, this._Str_20205);
            this._view.findChildByName("filter").caption = "";
            this._view.findChildByName("clear_filter_button").visible = false;
            this._filteredBadges = new Array<ASAny>();
            this._isInitialized = true;
        }

        function _Str_13242(k:String)
        {
            var _local_4:Badge = null;
            var _local_7 = false;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            if (!this._isInitialized)
            {
                return;
            }
            if (((this._view == null) || this._view.disposed))
            {
                return;
            }
            var _local_2= this._inactiveGrid.scrollV;
            this._inactiveGrid.removeGridItems();
            this._activeGrid.removeGridItems();
            this._filteredBadges.resize(0);
            var _local_3= this._model._Str_5453(BadgesModel._Str_8369);
            var _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_4 = ASCompat.dynamicAs(_local_3[_local_5] , Badge);
                if (!_local_4.isInUse)
                {
                    _local_7 = false;
                    if (((k == null) || (k.length == 0)))
                    {
                        _local_7 = true;
                    }
                    else
                    {
                        _local_8 = k.toLowerCase();
                        _local_9 = this._model.controller.localization.getBadgeName(_local_4.badgeId);
                        _local_10 = this._model.controller.localization.getBadgeDesc(_local_4.badgeId);
                        if (((_local_9 == null) || (_local_10 == null)))
                        {
                            Core.error(("Missing localization for badge " + _local_4.badgeId), false);
                        }
                        else
                        {
                            _local_9 = _local_9.toLowerCase();
                            _local_10 = _local_10.toLowerCase();
                            if (((_local_9.indexOf(_local_8) >= 0) || (_local_10.indexOf(_local_8) >= 0)))
                            {
                                _local_7 = true;
                            }
                        }
                    }
                    if (_local_7)
                    {
                        this._inactiveGrid.addGridItem(_local_4.window);
                        this._filteredBadges.push(_local_4);
                        _local_4.window.addEventListener(WindowMouseEvent.CLICK, this._Str_20827);
                    }
                }
                _local_5++;
            }
            if (_local_2 > 0)
            {
                this._inactiveGrid.scrollV = _local_2;
            }
            var _local_6= this._model._Str_5453(BadgesModel._Str_6557);
            _local_5 = 0;
            while (_local_5 < _local_6.length)
            {
                _local_4 = ASCompat.dynamicAs(_local_6[_local_5] , Badge);
                this._activeGrid.addGridItem(_local_4.window);
                _local_4.window.addEventListener(WindowMouseEvent.CLICK, this._Str_20205);
                _local_5++;
            }
        }

        function _Str_19119(k:String)
        {
            if (((this._view == null) || this._view.disposed))
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("badgeName") , ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            if (k == null)
            {
                _local_2.text = "";
            }
            else
            {
                _local_2.text = "";
                _local_2.text = k;
            }
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:WindowKeyboardEvent = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "clear_filter_button":
                        this._view.findChildByName("filter").caption = "";
                        _arg_2.visible = false;
                        this._Str_18918(null);
                        
                }
            }
            else
            {
                if (k.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_UP)
                {
                    _local_3 = Std.downcast(k , WindowKeyboardEvent);
                    switch (_arg_2.name)
                    {
                        case "filter":
                            this._view.findChildByName("clear_filter_button").visible = (_arg_2.caption.length > 0);
                            if (_local_3.keyCode == 13)
                            {
                                this._Str_18918(_arg_2.caption);
                            }
                            return;
                    }
                }
            }
        }

        function _Str_20172(k:String)
        {
            if (((this._view == null) || this._view.disposed))
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("badgeDescriptionText") , ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            if (k == null)
            {
                _local_2.text = "${inventory.effects.defaultdescription}";
            }
            else
            {
                _local_2.text = "";
                _local_2.text = k;
            }
        }

        function _Str_20827(k:WindowEvent)
        {
            var _local_2= this._inactiveGrid.getGridItemIndex(k.window);
            var _local_3:Badge = this._filteredBadges[_local_2];
            if (_local_3 != null)
            {
                this._model._Str_17509(_local_3.badgeId);
            }
        }

        function _Str_20205(k:WindowEvent)
        {
            var _local_2= this._activeGrid.getGridItemIndex(k.window);
            var _local_3= this._model._Str_24207(_local_2);
            if (_local_3 != null)
            {
                this._model._Str_17509(_local_3.badgeId);
            }
        }

        function _Str_24890(k:WindowEvent)
        {
            var _local_2= this._model._Str_17378();
            if (_local_2 != null)
            {
                this._model._Str_24883(_local_2.badgeId);
            }
        }
    }

