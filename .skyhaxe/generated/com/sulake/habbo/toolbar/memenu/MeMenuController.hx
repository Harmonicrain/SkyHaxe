package com.sulake.habbo.toolbar.memenu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.ToolbarView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;

     class MeMenuController implements IDisposable
    {
        public static inline final USE_GUIDE_TOOL= "USE_GUIDE_TOOL";

        var _habboToolbar:HabboToolbar;
        var _toolbarView:ToolbarView;
        var _window:IWindowContainer;
        var _meMenuIconLoader:MeMenuNewIconLoader;
        var _newUiEnabled:Bool = false;
        var _settingsMenuView:MeMenuSettingsMenuView;
        var _unseenItemCounters:Map;

        public function new(k:HabboToolbar, _arg_2:ToolbarView)
        {
            this._unseenItemCounters = new Map();
            this._habboToolbar = k;
            this._toolbarView = _arg_2;
            this._habboToolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
            var _local_3= Std.downcast(this._habboToolbar.assets.getAssetByName("me_menu_view_xml") , XmlAsset);
            this._window = Std.downcast(this._habboToolbar.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) ), 2) , IWindowContainer);
            this._meMenuIconLoader = new MeMenuNewIconLoader(this._habboToolbar);
            this._window.visible = false;
            this._window.procedure = this.windowProcedure;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IRegionWindow = null;
            var _local_4:IStaticBitmapWrapperWindow = null;
            var _local_5:IHabboNavigator = null;
            var _local_6:String = null;
            if (Std.is(_arg_2 , IRegionWindow))
            {
                _local_3 = Std.downcast(_arg_2 , IRegionWindow);
                switch (k.type)
                {
                    case WindowMouseEvent.OVER:
                        _local_4 = Std.downcast(_local_3.findChildByName((_arg_2.name + "_icon")) , IStaticBitmapWrapperWindow);
                        if (_local_4 != null)
                        {
                            _local_4.assetUri = (("toolbar_memenu_" + _arg_2.name) + "_color");
                        }
                        return;
                    case WindowMouseEvent.OUT:
                        _local_4 = Std.downcast(_local_3.findChildByName((_arg_2.name + "_icon")) , IStaticBitmapWrapperWindow);
                        if (_local_4 != null)
                        {
                            _local_4.assetUri = (("toolbar_memenu_" + _arg_2.name) + "_white");
                        }
                        return;
                    case WindowMouseEvent.CLICK:
                        this._window.visible = false;
                        switch (_arg_2.name)
                        {
                            case "profile":
                                this._habboToolbar.connection.send(new GetExtendedProfileMessageComposer(this._habboToolbar.sessionDataManager.userId));
                                
                            case "minimail":
                                HabboWebTools.openMinimail("#mail/inbox/");
                                
                            case "rooms":
                                _local_5 = this._habboToolbar.navigator;
                                if (_local_5 != null)
                                {
                                    _local_5.showOwnRooms();
                                }
                                
                            case "talents":
                                _local_6 = this._habboToolbar.sessionDataManager.currentTalentTrack;
                                this._habboToolbar.connection.send(new GetTalentTrackMessageComposer(_local_6));
                                
                            case "settings":
                                this._settingsMenuView = new MeMenuSettingsMenuView();
                                this._settingsMenuView.init(this, this._toolbarView);
                                
                            case "achievements":
                                this._habboToolbar.questEngine.showAchievements();
                                
                            case "guide":
                                this._habboToolbar.toggleWindowVisibility("GUIDE");
                                
                            case "clothes":
                                this._habboToolbar.context.createLinkEvent("avatareditor/open");
                                
                        }
                        return;
                }
            }
        }

        function onToolbarClick(k:HabboToolbarEvent)
        {
            if (this._newUiEnabled)
            {
                return;
            }
            if (k.iconId == HabboToolbarIconEnum.MEMENU)
            {
                this.toggleVisibility();
            }
            else
            {
                this._window.visible = false;
                if (this._settingsMenuView != null)
                {
                    this._settingsMenuView.dispose();
                    this._settingsMenuView = null;
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
            if (this._settingsMenuView != null)
            {
                this._settingsMenuView.dispose();
                this._settingsMenuView = null;
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
            if (this._settingsMenuView != null)
            {
                this._settingsMenuView.dispose();
                this._settingsMenuView = null;
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
            this._window.x = (this._toolbarView.window.width + 10);
            this._window.y = (this._toolbarView.window.bottom - this._window.height);
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

        public var _Str_25935(never,set):Int;
public function  set__Str_25935(k:Int):Int        {
            this._Str_4168("achievements", k);
return k;
        }

        public var _Str_26372(never,set):Int;
public function  set__Str_26372(k:Int):Int        {
            this._Str_4168("minimail", k);
return k;
        }

        public var _Str_22759(never,set):Bool;
public function  set__Str_22759(k:Bool):Bool        {
            return this._newUiEnabled = k;
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

