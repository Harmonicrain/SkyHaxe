package com.sulake.habbo.catalog.navigation
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.catalog.NodeData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window._enum._Str_8057;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class CatalogNodeRenderable extends CatalogNode 
    {
        static inline final _Str_17404:Float = 0xFFFFFFFF;

        var _window:IWindowContainer;
        var _childList:IItemListWindow;
        var _isOpen:Bool = false;
        var _active:Bool = false;
        var _itemNormalColor:UInt = 0;
        var _itemSelectedEtchingColor:UInt = 0;

        public function new(k:ICatalogNavigator, _arg_2:NodeData, _arg_3:Int, _arg_4:ICatalogNode)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        override public function  get_isOpen():Bool
        {
            return this._isOpen;
        }

        override public function  get_visible():Bool
        {
            return true;
        }

        override public function dispose()
        {
            if (this._isOpen)
            {
                this.close();
                this.deactivate();
            }
            this._window = null;
            this._childList = null;
            super.dispose();
        }

        public function _Str_11512(k:IItemListWindow, _arg_2:Bool=true)
        {
            if (this._window == null)
            {
                this.createWindow();
                this._Str_14783();
            }
            k.addListItem(this._window);
            if (isBranch)
            {
                if (this._childList == null)
                {
                    this._Str_19530();
                }
                k.addListItem(this._childList);
                this._Str_23363();
            }
            k.arrangeListItems();
        }

        public function _Str_19623(k:IItemListWindow)
        {
            k.removeListItem(this._window);
            if (isBranch)
            {
                k.removeListItem(this._childList);
            }
        }

        override public function activate()
        {
            this._Str_21224();
            this._active = true;
        }

        override public function deactivate()
        {
            this._Str_14783();
            this._active = false;
        }

        override public function open()
        {
            var k:IWindow = null;
            this._Str_21358();
            this._isOpen = true;
            if ((isBranch && (!(this._window == null))))
            {
                k = this._window.findChildByTag("DOWNBTN");
                if (k != null)
                {
                    k.style = _Str_8057._Str_17212;
                }
            }
        }

        override public function close()
        {
            var k:IWindow = null;
            this._Str_19979();
            this._isOpen = false;
            if ((isBranch && (!(this._window == null))))
            {
                k = this._window.findChildByTag("DOWNBTN");
                if (k != null)
                {
                    k.style = _Str_8057._Str_17556;
                }
            }
        }

        function _Str_23363()
        {
            var k:ICatalogNode = null;
            var _local_2:CatalogNodeRenderable = null;
            if (this._childList == null)
            {
                return;
            }
            final _iter_ = children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = Std.downcast(k , CatalogNodeRenderable);
                if (_local_2 != null)
                {
                    if (_local_2.visible)
                    {
                        _local_2._Str_11512(this._childList);
                        _local_2._Str_14783();
                    }
                    else
                    {
                        _local_2._Str_19623(this._childList);
                    }
                }
            }
            this._childList.arrangeListItems();
        }

        function _Str_21358()
        {
            var k:ICatalogNode = null;
            var _local_2 = 0;
            var _local_3 = 0;
            if (this._childList == null)
            {
                this._Str_19530();
            }
            final _iter_ = children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.visible)
                {
                    Std.downcast(k , CatalogNodeRenderable)._Str_11512(this._childList);
                }
            }
            if (this._childList != null)
            {
                this._childList.visible = true;
                _local_2 = 0;
                _local_3 = 0;
                while (_local_3 < this._childList.numListItems)
                {
                    if (this._childList.getListItemAt(_local_3).visible)
                    {
                        _local_2++;
                    }
                    _local_3++;
                }
                this._childList.height = (_local_2 * 21);
            }
        }

        function _Str_19979()
        {
            var k:ICatalogNode = null;
            final _iter_ = children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.visible)
                {
                    Std.downcast(k , CatalogNodeRenderable)._Str_19623(this._childList);
                }
            }
            if (this._childList != null)
            {
                this._childList.height = 0;
                this._childList.visible = false;
                this._childList.x = 0;
            }
        }

        function _Str_19530()
        {
            this._childList = Std.downcast(navigator.listTemplate.clone() , IItemListWindow);
            this._Str_19979();
        }

        function createWindow()
        {
            this._window = Std.downcast(navigator.getItemTemplate(depth).clone() , IWindowContainer);
            var k= Std.downcast(this._window.findChildByTag("ITEM_TITLE") , ITextWindow);
            var _local_2= this._window.findChildByTag("DOWNBTN");
            if (k != null)
            {
                k.caption = localization;
                this._itemNormalColor = k.textColor;
                this._itemSelectedEtchingColor = k.etchingColor;
            }
            var _local_3= this._window.findChildByTag("SELECTION_HILIGHT");
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
            if (_local_2 != null)
            {
                _local_2.visible = (!isLeaf);
            }
            cast(this._window.findChildByName("icon"), IStaticBitmapWrapperWindow).assetUri = ((navigator.catalog.imageGalleryHost + iconName) + ".png");
            if (navigator.isDeepHierarchy)
            {
                if (depth == 1)
                {
                    this._window.findChildByName("icon").visible = true;
                }
                if (depth > 3)
                {
                    this._window.findChildByName("icon").visible = isBranch;
                    this._window.findChildByTag("ITEM_TITLE").x = (42 + (5 * (depth - 3)));
                }
            }
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            this._window.addEventListener(WindowMouseEvent.OVER, this._Str_23473);
            this._window.addEventListener(WindowMouseEvent.OUT, this._Str_25078);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
        }

        function _Str_25078(k:WindowMouseEvent)
        {
            if (!this._active)
            {
                this._Str_14783();
            }
        }

        function _Str_23473(k:WindowMouseEvent)
        {
            if (!this._active)
            {
                this._Str_21224();
            }
        }

        function _Str_14783()
        {
            var k:ITextWindow = null;
            var _local_2:IWindow = null;
            if (this._window != null)
            {
                k = Std.downcast(this._window.findChildByTag("SELECTION_COLOR") , ITextWindow);
                if (k != null)
                {
                    k.textColor = this._itemNormalColor;
                    k.etchingColor = 0;
                }
                _local_2 = this._window.findChildByTag("SELECTION_HILIGHT");
                if (_local_2 != null)
                {
                    _local_2.visible = false;
                }
            }
        }

        function _Str_21224()
        {
            var k:ITextWindow = null;
            var _local_2:IWindowContainer = null;
            if (this._window != null)
            {
                k = Std.downcast(this._window.findChildByTag("SELECTION_COLOR") , ITextWindow);
                if (k != null)
                {
                    k.textColor = Std.int(_Str_17404);
                    k.etchingColor = this._itemSelectedEtchingColor;
                }
                _local_2 = Std.downcast(this._window.findChildByTag("SELECTION_HILIGHT") , IWindowContainer);
                if (_local_2 != null)
                {
                    _local_2.visible = true;
                }
            }
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            navigator.activateNode(this);
        }

        public function _Str_21669()
        {
            var _local_2 = 0;
            if (this._childList == null)
            {
                return;
            }
            this._childList.height = 0;
            if (this._childList != null)
            {
                _local_2 = 0;
                while (_local_2 < this._childList.numListItems)
                {
                    if (this._childList.getListItemAt(_local_2).visible)
                    {
                        this._childList.height = (this._childList.height + this._childList.getListItemAt(_local_2).height);
                    }
                    _local_2++;
                }
            }
            var k= Std.downcast(parent , CatalogNodeRenderable);
            if (k != null)
            {
                k._Str_21669();
            }
        }

        override public function  get_offsetV():Int
        {
            return this._window.y + 21;
        }
    }




