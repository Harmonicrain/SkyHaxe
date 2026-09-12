package com.sulake.habbo.toolbar
;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IBoxSizerWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.toolbar.memenu.MeMenuNewController;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowParam;
    import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.motion.Queue;
    import com.sulake.core.window.motion.Wait;
    import com.sulake.core.window.motion.DropBounce;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.JumpBy;
    import com.sulake.core.window.motion.Dispose;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.habbo.session.SecurityLevelEnum;

     class BottomBarLeft implements ILinkEventTracker 
    {
        static final DEFAULT_LOCATION:Point = new Point(0, 500);
        static final _Str_7220:Point = new Point(0, 500);
        static inline final _Str_7111:UInt = 7433577;
        static inline final _Str_7665:UInt = 5723213;
        static inline final _HOVER= "_hover";
        static inline final _NORMAL= "_normal";
        static inline final _Str_3504= 0;
        static inline final ICON_ME_MENU= "icon_me_menu";
        static inline final _Str_16891= 45;
        static inline final _Str_8952= 20;
        static inline final _Str_16288= 10;
        static inline final COLLAPSED_MARGIN= 185;

        var _window:IWindowContainer;
        var _events:IEventDispatcher;
        var _disposed:Bool = false;
        var _toolbar:HabboToolbar;
        var _assets:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _unseenItemCounters:Map;
        var _newItemsNotification:IWindowContainer;
        var _newItemsNotificationEnabled:Bool = false;
        var _meMenuNormalBitmap:BitmapData;
        var _left_arrow:IRegionWindow;
        var _right_arrow:IRegionWindow;
        var _buttonContainer:IBoxSizerWindow;
        var _verticalLine:IStaticBitmapWrapperWindow;
        var _previousState:String;
        var _unseenMiniMailMessageCount:Int = 0;
        var _unseenAchievementCount:Int = 0;
        var _unseenForumsCount:Int = 0;
        var _collapsed:Bool = false;
        var _memenu:MeMenuNewController;

        public function new(k:HabboToolbar, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IEventDispatcher)
        {
            var _local_9:IWindow = null;
            var _local_10 = false;
            var _local_12:IWindowContainer = null;
            this._toolbar = k;
            this._windowManager = _arg_2;
            this._assets = _arg_3;
            this._events = _arg_4;
            this._memenu = new MeMenuNewController(this._toolbar, this);
            this._unseenItemCounters = new Map();
            var _local_5= Std.downcast(_arg_3.getAssetByName("bottom_bar_left_xml") , XmlAsset);
            this._window = Std.downcast(_arg_2.buildFromXML(((_local_5.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this._Str_16256);
            this._buttonContainer = Std.downcast(this._window.getChildByName("toolbar_items") , IBoxSizerWindow);
            var _local_6= Std.downcast(this._window.getChildByName("arrow_container_left") , IWindowContainer);
            var _local_7= Std.downcast(this._window.getChildByName("arrow_container_right") , IWindowContainer);
            this._left_arrow = Std.downcast(_local_6.getChildByName("collapse_left") , IRegionWindow);
            this._right_arrow = Std.downcast(_local_7.getChildByName("collapse_right") , IRegionWindow);
            if (this._left_arrow != null)
            {
                this._left_arrow.addEventListener(WindowMouseEvent.CLICK, this._Str_21630);
            }
            if (this._right_arrow != null)
            {
                this._right_arrow.addEventListener(WindowMouseEvent.CLICK, this._Str_21630);
            }
            this._verticalLine = Std.downcast(this._buttonContainer.getChildByName("line") , IStaticBitmapWrapperWindow);
            var _local_8:Array<ASAny> = [];
            this._window.groupChildrenWithTag("TOGGLE", _local_8, -1);
            if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
            {
_local_9  = _tmp_;
                if (((_local_9 != null) && Std.is(_local_9 , IRegionWindow)))
                {
                    _local_9.addEventListener(WindowMouseEvent.CLICK, this._Str_16033);
                }
            }
            this._Str_4600(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.MEMENU), false);
            this._Str_4600(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.INVENTORY), false);
            _local_10 = k.getBoolean("games_icon_enabled");
            if (_local_10)
            {
                this._Str_4600(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.GAMES), true);
            }
            else
            {
                this._Str_4600(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.GAMES), false);
            }
            var _local_11= Std.downcast(_arg_3.getAssetByName("new_items_label_xml") , XmlAsset);
            this._newItemsNotification = Std.downcast(_arg_2.buildFromXML(((_local_11.content : com.sulake.core.utils.xml.XML) ), 2) , IWindowContainer);
            if (this._newItemsNotification == null)
            {
                throw new ASError("Failed to construct toolbar label from XML!");
            }
            _local_12 = Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.NAVIGATOR)) , IWindowContainer);
            if (_local_12 != null)
            {
                this._windowManager.registerHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.NAVIGATOR), _local_12);
            }
            _local_12 = Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.MEMENU)) , IWindowContainer);
            if (_local_12 != null)
            {
                this._windowManager.registerHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.MEMENU), _local_12);
            }
            _local_12 = Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.INVENTORY)) , IWindowContainer);
            if (_local_12 != null)
            {
                this._windowManager.registerHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.INVENTORY), _local_12);
            }
            _local_12 = Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.PROGRESSION)) , IWindowContainer);
            if (_local_12 != null)
            {
                this._windowManager.registerHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.PROGRESSION), _local_12);
            }
            var _local_13= Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE)) , IWindowContainer);
            _local_13.addChild(this._newItemsNotification);
            this._windowManager.registerHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE), _local_13);
            var _local_14= Std.downcast(this._newItemsNotification.findChildByName("new_textfield") , ITextWindow);
            var _local_15= k.localization.getLocalizationRaw("toolbar.new_additions.notification");
            if (_local_15 != null)
            {
                _local_14.text = _local_15.value;
            }
            this._newItemsNotification.visible = false;
            this._newItemsNotification.x = ((_local_13.width - this._newItemsNotification.width) - _Str_3504);
            this._newItemsNotification.y = _Str_3504;
            this._newItemsNotificationEnabled = this.isNewItemsNotificationEnabled();
            this._Str_5532();
            k .context.addLinkEventTracker(this);
        }

        function _Str_22880(k:WindowMouseEvent, _arg_2:ASAny)
        {
            this._toolbar.toggleWindowVisibility("PANIC");
        }

        function _Str_16256(k:WindowEvent)
        {
            this._Str_5532();
        }

        function _Str_5532()
        {
            if (((!(this._window != null)) || (!(this._windowManager != null))))
            {
                return;
            }
            this._left_arrow.visible = (!this._collapsed);
            this._right_arrow.visible = this._collapsed;
            this._window.y = (this._window.desktop.height - this._window.height);
            this._window.width = (((_Str_16891 * this._Str_23943()) + _Str_16288) + 150);
            if (!this._collapsed)
            {
                if (this._memenu != null)
                {
                    this._memenu.reposition();
                }
            }
            this._window.invalidate();
        }

        public function dispose()
        {
            if (this._memenu != null)
            {
                this._memenu.dispose();
                this._memenu = null;
            }
            if (this._meMenuNormalBitmap != null)
            {
                this._meMenuNormalBitmap.dispose();
                this._meMenuNormalBitmap = null;
            }
            if (this._unseenItemCounters != null)
            {
                this._unseenItemCounters.dispose();
                this._unseenItemCounters = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._newItemsNotification != null)
            {
                this._newItemsNotification.dispose();
                this._newItemsNotification = null;
            }
            if (this._windowManager != null)
            {
                this._windowManager.unregisterHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.NAVIGATOR));
                this._windowManager.unregisterHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.MEMENU));
                this._windowManager.unregisterHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.INVENTORY));
                this._windowManager.unregisterHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.PROGRESSION));
                this._windowManager.unregisterHintWindow(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE));
            }
            if (this._toolbar != null)
            {
                this._toolbar .context.removeLinkEventTracker(this);
                this._toolbar = null;
            }
            this._windowManager = null;
            this._assets = null;
            this._disposed = true;
            if (this._events != null)
            {
                this._events = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

        function _Str_16413()
        {
            var k= Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE)) , IWindowContainer);
            k.blend = 0.5;
            k.disable();
        }

        public function onCatalogEvent(k:CatalogEvent)
        {
            var _local_2:IWindowContainer = null;
            var _local_3:String = null;
            switch (k.type)
            {
                case CatalogEvent.CATALOG_INITIALIZED:
                    _local_2 = Std.downcast(this._window.findChildByName(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE)) , IWindowContainer);
                    _local_2.blend = 1;
                    _local_2.enable();
                    _local_3 = this._toolbar.getProperty("open.catalog.page");
                    if (((_local_3.length > 0) && (this._toolbar.catalog != null)))
                    {
                        this._toolbar.catalog.openCatalogPage(CatalogPageName.HC_MEMBERSHIP);
                        this._toolbar.setProperty("open.catalog.page", "");
                    }
                    return;
                case CatalogEvent.CATALOG_NOT_READY:
                    this._Str_16413();
                    return;
                case CatalogEvent.CATALOG_NEW_ITEMS_SHOW:
                    if (((!(this._newItemsNotification == null)) && this._newItemsNotificationEnabled))
                    {
                        this._newItemsNotification.visible = true;
                    }
                    return;
                case CatalogEvent.CATALOG_NEW_ITEMS_HIDE:
                    if (this._newItemsNotification != null)
                    {
                        this._newItemsNotification.visible = false;
                    }
                    return;
            }
        }

        public function updateVisibility(k:String)
        {
            var _local_3:String = null;
            var _local_4:IWindow = null;
            var _local_5 = false;
            var _local_6:String = null;
            var _local_7 = false;
            if (k == HabboToolbarEnum.HTE_STATE_HIDDEN)
            {
                this._window.visible = false;
                return;
            }
            this._window.visible = true;
            if (k != HabboToolbarEnum.HTE_STATE_COLLAPSED)
            {
                this._previousState = k;
            }
            var _local_2:Array<ASAny> = [];
            this._window.groupChildrenWithTag("TOGGLE", _local_2, -1);
            switch (k)
            {
                case HabboToolbarEnum.HTE_STATE_GAME_CENTER_VIEW:
                    _local_3 = "VISIBLE_GAME_CENTER";
                    this._window.position = DEFAULT_LOCATION;
                    
                case HabboToolbarEnum.HTE_STATE_HOTEL_VIEW:
                    _local_3 = "VISIBLE_HOTEL";
                    this._window.position = _Str_7220;
                    
                case HabboToolbarEnum.HTE_STATE_NOOB_NOT_HOME:
                    _local_3 = "VISIBLE_NOOB";
                    this._window.position = DEFAULT_LOCATION;
                    
                case HabboToolbarEnum.HETE_STATE_NOOB_HOME:
                    _local_3 = "VISIBLE_ROOM";
                    this._window.position = DEFAULT_LOCATION;
                    
                case HabboToolbarEnum.HTE_STATE_ROOM_VIEW:
                    _local_3 = "VISIBLE_ROOM";
                    this._window.position = DEFAULT_LOCATION;
                    
                case HabboToolbarEnum.HTE_STATE_COLLAPSED:
                    _local_3 = "VISIBLE_COLLAPSED";
                    this._window.position = DEFAULT_LOCATION;
                    
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = _tmp_;
                if (_local_4 != null)
                {
                    _local_4.visible = (_local_4.tags.indexOf(_local_3) >= 0);
                    if (((_local_4.name == "QUESTS") && (!this._collapsed)))
                    {
                        _local_4.visible = (_local_4.visible && ((!this._toolbar.isNewIdentity()) || (!this._toolbar.getBoolean("new.identity.hide.quests"))));
                        _local_4.visible = (_local_4.visible && (!this._toolbar.getBoolean("toolbar.hide.quests")));
                    }
                    else
                    {
                        if (((_local_4.name == "STORIES") && (!this._collapsed)))
                        {
                            _local_4.visible = (_local_4.visible && this._toolbar.getBoolean("toolbar.stories.enabled"));
                        }
                        else
                        {
                            if (((_local_4.name == "BUILDER") && (!this._collapsed)))
                            {
                                _local_4.visible = (_local_4.visible && this._toolbar.getBoolean("builders.club.enabled"));
                            }
                            else
                            {
                                if (_local_4.name == "GAMES")
                                {
                                    _local_4.visible = (_local_4.visible && this._toolbar.getBoolean("game.center.enabled"));
                                }
                                else
                                {
                                    if (_local_4.name == "CAMERA")
                                    {
                                        _local_5 = ((((k == HabboToolbarEnum.HTE_STATE_ROOM_VIEW) || (k == HabboToolbarEnum.HETE_STATE_NOOB_HOME)) || (k == HabboToolbarEnum.HTE_STATE_NOOB_NOT_HOME)) || (this._collapsed && (((this._previousState == HabboToolbarEnum.HTE_STATE_ROOM_VIEW) || (this._previousState == HabboToolbarEnum.HETE_STATE_NOOB_HOME)) || (this._previousState == HabboToolbarEnum.HTE_STATE_NOOB_NOT_HOME))));
                                        _local_6 = this._toolbar.getProperty("camera.launch.ui.position");
                                        _local_7 = this._toolbar.sessionDataManager.isPerkAllowed(PerkEnum.CAMERA);
                                        _local_4.visible = ((_local_5 && (_local_6 == "bottom-icons")) && _local_7);
                                    }
									else
									{
										if (_local_4.name == "MODTOOL")
										{
											_local_4.visible = this._toolbar.sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR);
										}
									}
                                }
                            }
                        }
                    }
                }
            }
            this._Str_5532();
        }

        public function _Str_4600(k:String, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
            }
            this._Str_5532();
        }

        public function _Str_23943():Int
        {
            var _local_3:IWindow = null;
            var k:Array<ASAny> = [];
            var _local_2= 1;
            this._window.groupChildrenWithTag("TOGGLE", k, -1);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (((_local_3 != null) && _local_3.visible))
                {
                    _local_2++;
                }
            }
            return _local_2;
        }

        function _Str_10617(k:WindowMouseEvent)
        {
            var _local_2:Rectangle = null;
            if (this._toolbar.navigator == null)
            {
                return;
            }
            switch (k.type)
            {
                case WindowMouseEvent.OVER:
                    _local_2 = this.getIconLocation(HabboToolbarIconEnum.NAVIGATOR);
                    this._toolbar.navigator.showToolbarHover(new Point((_local_2.right + 15), _local_2.y));
                    return;
                case WindowMouseEvent.OUT:
                    this._toolbar.navigator.hideToolbarHover(true);
                    return;
            }
        }

        function _Str_16860(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.findChildByTag("ICON_BORDER") , IBorderWindow);
            var _local_4= ASCompat.reinterpretAs(_local_2.findChildByTag("ICON_BMP") , IBitmapDataContainer);
            Logger.log([k]);
            switch (k.type)
            {
                case WindowMouseEvent.OVER:
                    this._Str_6574(_local_4, _HOVER);
                    this._Str_9894(_local_3, _HOVER);
                    if (k.target.name == "NAVIGATOR")
                    {
                        this._Str_10617(k);
                    }
                    return;
                case WindowMouseEvent.OUT:
                    this._Str_6574(_local_4, _NORMAL);
                    this._Str_9894(_local_3, _NORMAL);
                    if (k.target.name == "NAVIGATOR")
                    {
                        this._Str_10617(k);
                    }
                    return;
            }
        }

        function _Str_6574(k:IBitmapDataContainer, _arg_2:String)
        {
            var _local_3:IStaticBitmapWrapperWindow = null;
            var _local_4:IBitmapWrapperWindow = null;
            if (Std.is(k , IStaticBitmapWrapperWindow))
            {
                _local_3 = Std.downcast(k , IStaticBitmapWrapperWindow);
                _local_3.assetUri = (_local_3.name + _arg_2);
            }
            else
            {
                if (Std.is(k , IBitmapWrapperWindow))
                {
                    _local_4 = ASCompat.reinterpretAs(k , IBitmapWrapperWindow);
                    if (_local_4.name == ICON_ME_MENU)
                    {
                        _local_4.bitmap = this._meMenuNormalBitmap;
                    }
                }
            }
        }

        function _Str_9894(k:IWindowContainer, _arg_2:String)
        {
            if (k == null)
            {
                return;
            }
            if (_arg_2 == _HOVER)
            {
                k.color = _Str_7111;
            }
            else
            {
                k.color = _Str_7665;
            }
        }

        function _Str_16033(k:WindowMouseEvent)
        {
            var _local_2= k.target.name;
            if (_local_2 == HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.PROGRESSION))
            {
                this._toolbar .context.createLinkEvent("reward_track/open/introduction");
                this._windowManager.hideMatchingHint(_local_2);
                return;
            }
            this._toolbar.toggleWindowVisibility(_local_2);
            this._windowManager.hideMatchingHint(_local_2);
        }

        public function setAssetUri(location:String, image:BitmapData)
        {
var counterParent:IWindowContainer  = null;            if (image == null)
            {
                return;
            }
            var iconName:String = null;
            switch (location)
            {
                case HabboToolbarIconEnum.MEMENU:
                    iconName = ICON_ME_MENU;
                    this._Str_17734(image);
                    
            }
            var icon= ASCompat.reinterpretAs(this._window.findChildByName(iconName) , IBitmapDataContainer);
            if (icon != null)
            {
                this._Str_6574(icon, _NORMAL);
            }
            var counter= ASCompat.dynamicAs(this._unseenItemCounters.getValue(HabboToolbarIconEnum.MEMENU) , IWindowContainer);
            if (counter != null)
            {
counterParent= Std.downcast(counter.parent , IWindowContainer);
                if (counterParent != null)
                {
                    counterParent.setChildIndex(counter, (counterParent.numChildren - 1));
                }
            }
        }

        function getIconName(k:String):String
        {
            var _local_2:String = null;
            switch (k)
            {
                case HabboToolbarIconEnum.CATALOGUE:
                    _local_2 = "icons_toolbar_catalogue";
                    
                case HabboToolbarIconEnum.INVENTORY:
                    _local_2 = "icons_toolbar_inventory";
                    
                case HabboToolbarIconEnum.MEMENU:
                    _local_2 = "MEMENU";
                    
                case HabboToolbarIconEnum.NAVIGATOR:
                    _local_2 = "icons_toolbar_navigator";
                    
                case HabboToolbarIconEnum.QUESTS:
                    _local_2 = "icons_toolbar_quests";
                    
                case HabboToolbarIconEnum.PROGRESSION:
                    _local_2 = "icons_toolbar_progression";
                    
                case HabboToolbarIconEnum.GAMES:
                    _local_2 = "icons_toolbar_games";
                    
                case HabboToolbarIconEnum.STORIES:
                    _local_2 = "icons_toolbar_stories";
                    
                case HabboToolbarIconEnum.RECEPTION:
                    _local_2 = "icons_toolbar_reception";
                    
                case HabboToolbarIconEnum.BUILDER:
                    _local_2 = "icons_toolbar_builder";
                    
                case HabboToolbarIconEnum.CAMERA:
                    _local_2 = "icons_toolbar_camera";
                    
				case HabboToolbarIconEnum.MODTOOL:
					_local_2 = "icons_toolbar_modtool";
					
            }
            return _local_2;
        }

        public function getIconLocation(k:String):Rectangle
        {
            var _local_3:IWindow = null;
            var _local_2= new Rectangle();
            var _local_4:String = null;
            _local_4 = this.getIconName(k);
            if (_local_4 != null)
            {
                _local_3 = this._window.findChildByName(_local_4);
            }
            if (((!(_local_3 == null)) && _local_3.visible))
            {
                _local_3.getGlobalRectangle(_local_2);
                return _local_2;
            }
            var _local_5= this._memenu._Str_23094(k);
            if (_local_5 != null)
            {
                return _local_5;
            }
            return null;
        }

        public function _Str_24110(k:String):IWindow
        {
            var _local_3:IWindow = null;
            var _local_2= this.getIconName(k);
            _local_3 = this._window.findChildByName(_local_2);
            if (_local_3 == null)
            {
                _local_3 = this._memenu._Str_6621(k);
            }
            return _local_3;
        }

        function _Str_17734(k:BitmapData)
        {
            if (this._meMenuNormalBitmap != null)
            {
                this._meMenuNormalBitmap.dispose();
            }
            if (k != null)
            {
                this._meMenuNormalBitmap = k.clone();
            }
            k.dispose();
        }

        public function _Str_4168(k:String, _arg_2:Int)
        {
            var _local_3= this._Str_7926(k);
            if (_local_3 == null)
            {
                return;
            }
            if (_arg_2 < 0)
            {
                _local_3.visible = true;
                _local_3.findChildByName("count").caption = " ";
            }
            else
            {
                if (_arg_2 > 0)
                {
                    _local_3.visible = true;
                    _local_3.findChildByName("count").caption = Std.string(_arg_2);
                }
                else
                {
                    _local_3.visible = false;
                }
            }
        }

        public function _Str_7926(k:String):IWindowContainer
        {
            var _local_4:IWindowContainer = null;
            var _local_2= HabboToolbarIconEnum.getIconName(k);
            if (!ASCompat.stringAsBool(_local_2))
            {
                Logger.log([("[Toolbar] Unknown icon type for unseen item counter for iconId: " + k)]);
            }
            var _local_3= ASCompat.dynamicAs(this._unseenItemCounters.getValue(k) , IWindowContainer);
            if (_local_3 == null)
            {
                _local_3 = this._windowManager.createUnseenItemCounter();
                _local_4 = Std.downcast(this._window.findChildByName(_local_2) , IWindowContainer);
                if (_local_4 != null)
                {
                    if (k == HabboToolbarIconEnum.MEMENU)
                    {
                        _local_3.setParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, false);
                    }
                    _local_4.addChild(_local_3);
                    _local_4.setChildIndex(_local_3, (_local_4.numChildren - 1));
                    _local_3.x = ((_local_4.width - _local_3.width) - _Str_3504);
                    _local_3.y = _Str_3504;
                    this._unseenItemCounters.add(k, _local_3);
                }
            }
            return _local_3;
        }

        public function isNewItemsNotificationEnabled():Bool
        {
            return this._toolbar.getBoolean("toolbar.new_additions.notification.enabled");
        }

        public function _Str_21423(k:String, _arg_2:BitmapData, _arg_3:Int, _arg_4:Int):Motion
        {
            var _local_9:IWindow = null;
            var _local_5= 20;
            var _local_6= ((_arg_2 != null) ? _arg_2.width : _local_5);
            var _local_7= ((_arg_2 != null) ? _arg_2.height : _local_5);
            var _local_8= Std.downcast(this._windowManager.create("ToolBarTransition", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, 0, 0, new Rectangle(_arg_3, _arg_4, _local_6, _local_7)) , IBitmapWrapperWindow);
            if (_arg_2 != null)
            {
                _local_8.bitmap = _arg_2;
                _local_8.disposesBitmap = true;
                _local_8.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 0xFF, BitmapFilterQuality.LOW, false, false)];
            }
            this._windowManager.getDesktop(2).addChild(_local_8);
            var _local_10:String = null;
            _local_10 = this.getIconName(k);
            if (_local_10 != null)
            {
                _local_9 = this._window.findChildByName(_local_10);
            }
            if (_local_9 == null)
            {
                _local_8.dispose();
                return null;
            }
            var _local_11= new Rectangle();
            _local_8.getGlobalRectangle(_local_11);
            var _local_12= new Rectangle();
            _local_9.getGlobalRectangle(_local_12);
            var _local_13= Std.int(_local_11.x - _local_12.x);
            var _local_14= Std.int(_local_11.y - _local_12.y);
            var _local_15= Math.sqrt(((_local_13 * _local_13) + (_local_14 * _local_14)));
            var _local_16= Std.int(500 - Math.abs(((((1 / _local_15) * 100) * 500) * 0.5)));
            var _local_17= 20;
            var _local_18:ASAny = (("ToolBarBouncing[ " + _local_10) + " ]");
            if (Motions._Str_19320(_local_18) == null)
            {
                Motions._Str_4598(new Queue([new Wait((_local_16 + 8)), new DropBounce(_local_9, 400, 12)])).tag = _local_18;
            }
            var _local_19:Motion = new Queue([new EaseOut(new JumpBy(_local_8, _local_16, Std.int((_local_12.x - _local_11.x) + _local_17), Std.int(_local_12.y - _local_11.y), 100, 1), 1), new Dispose(_local_8)]);
            return Motions._Str_4598(_local_19);
        }

        public var onDuty(never,set):Bool;
public function  set_onDuty(k:Bool):Bool        {
            var _local_2= this._window.findChildByName("guide_icon");
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
return k;
        }

        public var _Str_17961(never,set):Int;
public function  set__Str_17961(k:Int):Int        {
            return this._unseenAchievementCount = k;
        }

        public var _Str_16525(never,set):Int;
public function  set__Str_16525(k:Int):Int        {
            return this._unseenMiniMailMessageCount = k;
        }

        public var _Str_9691(never,set):Int;
public function  set__Str_9691(k:Int):Int        {
            return this._unseenForumsCount = k;
        }

        public var _Str_16152(get,never):Int;
public function  get__Str_16152():Int
        {
            return (this._unseenMiniMailMessageCount + this._unseenAchievementCount) + this._unseenForumsCount;
        }

        public var memenu(get,never):MeMenuNewController;
public function  get_memenu():MeMenuNewController
        {
            return this._memenu;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "toolbar/";
        }

        function _Str_21630(k:WindowMouseEvent)
        {
            this._collapsed = (!this._collapsed);
            if (this._collapsed)
            {
                this.updateVisibility(HabboToolbarEnum.HTE_STATE_COLLAPSED);
            }
            else
            {
                this.updateVisibility(this._previousState);
            }
            this._Str_5532();
            this._toolbar._Str_12052.triggerbottomBarResize();
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "memenu":
                    this.memenu.toggleVisibility();
                    return;
                case "highlight":
                    if (_local_2.length <= 2)
                    {
                        return;
                    }
                    switch (_local_2[2])
                    {
                        case "catalog":
                            this._windowManager.showHint(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.CATALOGUE));
                            
                        case "navigator":
                            this._windowManager.showHint(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.NAVIGATOR));
                            
                        case "memenu":
                            this._windowManager.showHint(HabboToolbarIconEnum.getIconName(HabboToolbarIconEnum.MEMENU));
                            
                    }
                    return;
                default:
                    Logger.log([("Toolbar unknown link-type received: " + _local_2[1])]);
            }
        }

        public function _Str_22465():Int
        {
            if (((!(this._verticalLine != null)) || (!(this._verticalLine.parent != null))))
            {
                return 0;
            }
            return this._collapsed ? COLLAPSED_MARGIN : (this._verticalLine.x + this._verticalLine.parent.x);
        }
    }

