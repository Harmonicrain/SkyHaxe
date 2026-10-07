package com.sulake.habbo.toolbar.memenu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.BottomBarLeft;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import flash.geom.Rectangle;

     class MeMenuNewController implements IDisposable
    {
        public static inline final USE_GUIDE_TOOL= "USE_GUIDE_TOOL";

        var _habboToolbar:HabboToolbar;
        var _toolbarView:BottomBarLeft;
        var _window:IWindowContainer;
        var _meMenuIconLoader:MeMenuNewIconLoader;
        var _meMenuSettings:MeMenuSettingsMenuView;
        var _unseenItemCounters:Map;

        public function new(k:HabboToolbar, _arg_2:BottomBarLeft)
        {
            this._unseenItemCounters = new Map();
            this._habboToolbar = k;
            this._toolbarView = _arg_2;
            this._habboToolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
            var _local_3= Std.downcast(this._habboToolbar.assets.getAssetByName("me_menu_new_view_xml") , XmlAsset);
            this._window = Std.downcast(this._habboToolbar.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) ), 2) , IWindowContainer);
            this._meMenuIconLoader = new MeMenuNewIconLoader(this._habboToolbar);
            this._window.visible = false;
            this._window.procedure = this.windowProcedure;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IRegionWindow = null;
            var _local_4:IStaticBitmapWrapperWindow = null;
            var _local_5:IStaticBitmapWrapperWindow = null;
            var _local_6:ITextWindow = null;
            var _local_7:IHabboNavigator = null;
            var _local_8:String = null;
            if (Std.is(_arg_2 , IRegionWindow))
            {
                _local_3 = Std.downcast(_arg_2 , IRegionWindow);
            }
            else
            {
                if (((_arg_2.parent != null) && Std.is(_arg_2.parent , IRegionWindow)))
                {
                    _local_3 = Std.downcast(_arg_2.parent , IRegionWindow);
                }
            }
            if (_local_3 != null)
            {
                _local_4 = Std.downcast(_local_3.findChildByName((_local_3.name + "_icon_color")) , IStaticBitmapWrapperWindow);
                _local_5 = Std.downcast(_local_3.findChildByName((_local_3.name + "_icon_grey")) , IStaticBitmapWrapperWindow);
                _local_6 = Std.downcast(_local_3.findChildByName("field_text") , ITextWindow);
                switch (k.type)
                {
                    case WindowMouseEvent.OVER:
                        if (((!(_local_4 == null)) && (!(_local_5 == null))))
                        {
                            _local_4.visible = true;
                            _local_5.visible = false;
                            if (_local_6 != null)
                            {
                                _local_6.textColor = 2215924;
                            }
                        }
                        return;
                    case WindowMouseEvent.OUT:
                        if (((!(_local_4 == null)) && (!(_local_5 == null))))
                        {
                            _local_4.visible = false;
                            _local_5.visible = true;
                            if (_local_6 != null)
                            {
                                _local_6.textColor = 0xFFFFFF;
                            }
                        }
                        return;
                    case WindowMouseEvent.CLICK:
                        this._window.visible = false;
                        if (this._habboToolbar != null)
                        {
                            switch (_local_3.name)
                            {
                                case "profile":
                                    this._habboToolbar.connection.send(new GetExtendedProfileMessageComposer(this._habboToolbar.sessionDataManager.userId));
                                    
                                case "minimail":
                                    HabboWebTools.openMinimail("#mail/inbox/");
                                    
                                case "rooms":
                                    _local_7 = this._habboToolbar.navigator;
                                    if (_local_7 != null)
                                    {
                                        _local_7.showOwnRooms();
                                    }
                                    
                                case "talents":
                                    _local_8 = this._habboToolbar.sessionDataManager.currentTalentTrack;
                                    this._habboToolbar.connection.send(new GetTalentTrackMessageComposer(_local_8));
                                    
                                case "settings":
                                    
                                case "achievements":
                                    this._habboToolbar.questEngine.showAchievements();
                                    
                                case "guide":
                                    this._habboToolbar.toggleWindowVisibility("GUIDE");
                                    
                                case "clothes":
                                    this._habboToolbar.context.createLinkEvent("avatareditor/open");
                                    
                                case "forums":
                                    this._habboToolbar.context.createLinkEvent("groupforum/list/my");
                                    
                                case "progression":
                                    if (this._habboToolbar.questEngine != null)
                                    {
                                        this._habboToolbar.questEngine.openRewardTrack("introduction");
                                    }
                                    
                            }
                            return;
                        }
                }
            }
        }

        function onToolbarClick(k:HabboToolbarEvent)
        {
            if (k.iconId == HabboToolbarIconEnum.MEMENU)
            {
                this.toggleVisibility();
            }
            else
            {
                this._window.visible = false;
                if (this._meMenuSettings != null)
                {
                    this._meMenuSettings.dispose();
                    this._meMenuSettings = null;
                }
            }
        }

        function _Str_8899(k:Bool)
        {
            this._window.findChildByName("guide").visible = k;
            this._window.height = (k ? (this._window.findChildByName("guide").bottom + 5) : (this._window.findChildByName("achievements").bottom + 5));
        }

        public function toggleVisibility()
        {
            var k = false;
            if (this._meMenuSettings != null)
            {
                this._meMenuSettings.dispose();
                this._meMenuSettings = null;
            }
            this._window.visible = (!this._window.visible);
            if (this._window.visible)
            {
                if (!this.toolbar.getBoolean("talent.track.enabled"))
                {
                    this._window.findChildByName("guide").rectangle = this._window.findChildByName("talents").rectangle;
                    this._window.findChildByName("talents").visible = false;
                }
                if (this._habboToolbar.getBoolean("guides.enabled"))
                {
                    k = this._habboToolbar.sessionDataManager.isPerkAllowed(USE_GUIDE_TOOL);
                    this._Str_8899(k);
                }
            }
            this.reposition();
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._meMenuSettings != null)
            {
                this._meMenuSettings.dispose();
                this._meMenuSettings = null;
            }
            this._meMenuIconLoader.dispose();
            this._meMenuIconLoader = null;
            this._habboToolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
            this._toolbarView = null;
            this._habboToolbar = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._habboToolbar == null;
        }

        public var toolbar(get,never):HabboToolbar;
public function  get_toolbar():HabboToolbar
        {
            return this._habboToolbar;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function reposition()
        {
            this._window.x = 3;
            this._window.y = (this._toolbarView.window.top - this._window.height);
        }

        public function _Str_23094(k:String):Rectangle
        {
            var _local_2:Rectangle = null;
            var _local_3= this._window.findChildByName(k);
            if (_local_3 != null)
            {
                _local_2 = _local_3.rectangle;
                _local_2.x = (_local_2.x + (this._window.x + (_local_3.width / 2)));
                _local_2.y = (_local_2.y + (this._window.y + (_local_3.height / 2)));
                this._window.visible = true;
            }
            return _local_2;
        }

        public function _Str_6621(k:String):IWindow
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                this._window.visible = true;
            }
            return _local_2;
        }

        public function _Str_7926(k:String):IWindowContainer
        {
            var _local_4:IWindowContainer = null;
            var _local_2= k;
            if (!ASCompat.stringAsBool(_local_2))
            {
                Logger.log([("[Toolbar] Unknown icon type for unseen item counter for iconId: " + k)]);
            }
            var _local_3= ASCompat.dynamicAs(this._unseenItemCounters.getValue(k) , IWindowContainer);
            if (_local_3 == null)
            {
                _local_3 = this._habboToolbar.windowManager.createUnseenItemCounter();
                _local_4 = Std.downcast(this._window.findChildByName(_local_2) , IWindowContainer);
                if (_local_4 != null)
                {
                    _local_4.addChild(_local_3);
                    _local_3.x = ((_local_4.width - _local_3.width) - 5);
                    _local_3.y = 5;
                    this._unseenItemCounters.add(k, _local_3);
                }
            }
            return _local_3;
        }

        public var _Str_23581(never,set):Int;
public function  set__Str_23581(k:Int):Int        {
            this._Str_4168("achievements", k);
return k;
        }

        public var _Str_25841(never,set):Int;
public function  set__Str_25841(k:Int):Int        {
            this._Str_4168("minimail", k);
return k;
        }

        public var _Str_9691(never,set):Int;
public function  set__Str_9691(k:Int):Int        {
            this._Str_4168("forums", k);
return k;
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
    }

