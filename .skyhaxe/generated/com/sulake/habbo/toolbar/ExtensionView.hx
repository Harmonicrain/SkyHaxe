package com.sulake.habbo.toolbar
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.Core;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.toolbar.events.ExtensionViewEvent;
    import flash.geom.Rectangle;

     class ExtensionView implements IExtensionView 
    {
        static inline final MARGIN= 3;
        static inline final _Str_18425= -8;

        var _toolbar:HabboToolbar;
        var _itemWindow:IItemListWindow;
        var _items:Map;
        var _disposed:Bool = false;
        var _landingView:Bool = false;
        var _itemWindowElements:Array<ASAny>;
        var _windowManager:IHabboWindowManager;
        var _extraMargin:Int = 0;

        public function new(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:HabboToolbar)
        {
            this._itemWindowElements = [];
            this._toolbar = _arg_3;
            this._windowManager = k;
            var _local_4= Std.downcast(_arg_2.getAssetByName("extension_grid_xml") , XmlAsset);
            if (_local_4 != null)
            {
                this._itemWindow = Std.downcast(k.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) ), 1) , IItemListWindow);
            }
            var _local_5:IWindowContainer = this._itemWindow.desktop;
            if (this._itemWindow != null)
            {
                this._itemWindow.x = (((_local_5.width - this._itemWindow.width) - MARGIN) - this.extraMargin);
                this._itemWindow.y = MARGIN;
                this._itemWindow.visible = true;
            }
            else
            {
                Core.error("Unable to initialize Toolbar Extension view window from xml asset", false);
            }
            this._items = new Map();
        }

        public function dispose()
        {
            var k:Array<ASAny> = null;
            var _local_2:String = null;
            if (!this._disposed)
            {
                k = this._items.getKeys();
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_2  = _tmp_;
                    this.detachExtension(_local_2);
                }
                if (this._itemWindow != null)
                {
                    this._itemWindow.dispose();
                    this._itemWindow = null;
                }
                this._itemWindowElements = null;
                this._toolbar = null;
                this._items = null;
                this._disposed = true;
            }
        }

        
        public var visible(get,set):Bool;
public function  get_visible():Bool
        {
            return (this._itemWindow != null) && this._itemWindow.visible;
        }

        public var screenHeight(get,never):UInt;
public function  get_screenHeight():UInt
        {
            if (this._itemWindow == null)
            {
                return 0;
            }
            return this._itemWindow.height + this._itemWindow.y;
        }

        public function attachExtension(k:String, _arg_2:IWindow, _arg_3:Int=-1, _arg_4:Array<ASAny>=null)
        {
            if (!this._disposed)
            {
                if (this._items.getValue(k))
                {
                    return;
                }
                this._items.add(k, _arg_2);
                _arg_3 = ((_arg_4 != null) ? this._Str_25816(_arg_4) : _arg_3);
                if (_arg_3 == -1)
                {
                    this._itemWindowElements.push(_arg_2);
                }
                else
                {
                    this._itemWindowElements.insert(_arg_3, _arg_2);
                }
                if (this._itemWindow != null)
                {
                    this._toolbar.createAndAttachDimmerWindow(Std.downcast(_arg_2 , IWindowContainer));
                    this.refreshItemWindow();
                }
                this._Str_21932();
            }
        }

        public function hasExtension(k:String):Bool
        {
            return !(this._items.getValue(k) == null);
        }

        function _Str_23065(k:IWindow):String
        {
            var _local_2= this._items.getValues().indexOf(k);
            if (_local_2 != -1)
            {
                return this._items.getKeys()[_local_2];
            }
            return "";
        }

        public function refreshItemWindow()
        {
            var k:IWindow = null;
            var _local_2:String = null;
            this._itemWindow.removeListItems();
            final _iter_ = this._itemWindowElements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = this._Str_23065(k);
                switch (_local_2)
                {
                    case ToolbarDisplayExtensionIds.LOGOUT_TOOLS
                       | ToolbarDisplayExtensionIds.PURSE_CREDITS
                       | ToolbarDisplayExtensionIds.PURSE_ENGAGEMENT_CURRENCY
                       | ToolbarDisplayExtensionIds.PURSE_HABBO_CLUB
                       | ToolbarDisplayExtensionIds.PURSE_SEASONAL_CURRENCY
                       | ToolbarDisplayExtensionIds.TALENT_PROMO
                       | ToolbarDisplayExtensionIds.CLUB_PROMO
                       | ToolbarDisplayExtensionIds.VIP_QUESTS
                       | ToolbarDisplayExtensionIds.VIDEO_OFFERS
                       | ToolbarDisplayExtensionIds.SETTINGS
                       | ToolbarDisplayExtensionIds.PHONE_NUMBER
                       | ToolbarDisplayExtensionIds.VERIFICATION_CODE
                       | ToolbarDisplayExtensionIds.RETURN_GIFT
                       | ToolbarDisplayExtensionIds.TARGETED_OFFER:
                        this._itemWindow.addListItem(k);
                        
                    case ToolbarDisplayExtensionIds.PURSE:
                        this._itemWindow.addListItem(k);
                        this._itemWindow.y = (MARGIN + _Str_18425);
                        
                    default:
                        if (!this._landingView)
                        {
                            this._itemWindow.addListItem(k);
                        }
                }
            }
            this._itemWindow.arrangeListItems();
            this._itemWindow.invalidate();
        }

        function _Str_25816(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            while (_local_2 < this._itemWindowElements.length)
            {
                if (k.indexOf(this._itemWindowElements[_local_2].name) > -1)
                {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }

        public function detachExtension(k:String)
        {
            var _local_2:IWindowContainer = null;
            if (!this._disposed)
            {
                _local_2 = this._items.getValue(k);
                if (_local_2 != null)
                {
                    this._itemWindowElements.splice(this._itemWindowElements.indexOf(_local_2), 1);
                    if (this._itemWindow != null)
                    {
                        this._toolbar.removeDimmer(_local_2);
                        this.refreshItemWindow();
                    }
                }
                this._items.remove(k);
                this._Str_21932();
            }
        }

        function _Str_21932()
        {
            var k= new Timer(25, 1);
            k.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onResizeTimer : ASAny));
            k.start();
        }

        function onResizeTimer(k:TimerEvent)
        {
            if (this._toolbar != null)
            {
                this._toolbar.events.dispatchEvent(new ExtensionViewEvent(ExtensionViewEvent.EVE_EXTENSION_VIEW_RESIZED));
            }
        }
public function  set_visible(k:Bool):Bool        {
            if (this._itemWindow != null)
            {
                this._itemWindow.visible = k;
            }
return k;
        }

        public function _Str_22962()
        {
            var k:IWindowContainer = null;
            final _iter_ = this._itemWindowElements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._toolbar.removeDimmer(k);
            }
        }

        public function getIconLocation(k:String):Rectangle
        {
            var _local_2:IWindow = null;
            var _local_3:Rectangle = null;
            switch (k)
            {
                case HabboToolbarIconEnum.EXT_GROUP:
                    _local_2 = ASCompat.dynamicAs(this._items.getValue("room_group_info"), IWindow);
                    
            }
            if (((!(_local_2 == null)) && _local_2.visible))
            {
                _local_3 = new Rectangle();
                _local_2.getGlobalRectangle(_local_3);
                return _local_3;
            }
            return null;
        }

        public function _Str_6621(k:String):IWindow
        {
            var _local_2:IWindow = null;
            if (k == HabboToolbarIconEnum.EXT_GROUP)
            {
                _local_2 = ASCompat.dynamicAs(this._items.getValue("room_group_info"), IWindow);
            }
            return _local_2;
        }

        
        public var landingView(get,set):Bool;
public function  get_landingView():Bool
        {
            return this._landingView;
        }
public function  set_landingView(k:Bool):Bool        {
            this._landingView = k;
            this.refreshItemWindow();
return k;
        }

        
        public var extraMargin(get,set):Int;
public function  set_extraMargin(k:Int):Int        {
            this._extraMargin = k;
            if (this._itemWindow != null)
            {
                this._itemWindow.x = (((this._itemWindow.desktop.width - this._itemWindow.width) - MARGIN) - this.extraMargin);
            }
return k;
        }
public function  get_extraMargin():Int
        {
            return this._extraMargin;
        }
    }

