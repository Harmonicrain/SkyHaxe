package com.sulake.habbo.ui.widget.furniture.guildfurnicontextmenu
;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextInfoView;
    import com.sulake.habbo.groups.IHabboGroupsManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextMenuWidget;

     class GuildFurnitureContextMenuView extends FurnitureContextInfoView 
    {
        var _Str_17990:IHabboGroupsManager;
        var _windowManager:IHabboWindowManager;
        public var _guildId:Int = -1;
        public var _Str_8815:Int = -1;
        public var _Str_7536:Bool = false;
        public var _Str_9506:Bool = false;

        public function new(k:IContextMenuParentWidget, _arg_2:IHabboGroupsManager, _arg_3:IHabboWindowManager)
        {
            super(k);
            _Str_3403 = false;
            this._Str_17990 = _arg_2;
            this._windowManager = _arg_3;
        }

        override public function dispose()
        {
            this._Str_17990 = null;
            this._windowManager = null;
            super.dispose();
        }

        override function updateWindow()
        {
            var _local_1:IRegionWindow = null;
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
                if (_window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("guild_furni_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
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
                _buttons = Std.downcast(window.findChildByName("buttons") , IItemListWindow);
                _buttons.procedure = this.buttonEventProc;
                _local_1 = Std.downcast(window.findChildByName("profile_link") , IRegionWindow);
                if (_local_1 != null)
                {
                    _local_1.procedure = this.buttonEventProc;
                    _local_1.toolTipCaption = this.widget.localizations.getLocalization("infostand.profile.link.tooltip", "Click to view profile");
                    _local_1.toolTipDelay = 100;
                }
                _window.findChildByName("name").caption = _title;
                _window.visible = false;
                activeView = _window;
                this._Str_2771();
                isMouseOver = false;
            }
        }

        function _Str_2771()
        {
            if (((!(_window != null)) || (!(_buttons != null))))
            {
                return;
            }
            _buttons.autoArrangeItems = false;
            showButton("join", (!this._Str_7536), true);
            showButton("open_forum", this._Str_9506, true);
            _buttons.autoArrangeItems = true;
            _buttons.visible = true;
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:Component = null;
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
                    switch (_arg_2.parent.name)
                    {
                        case "join":
                            this.widget.handler._Str_24943(this._guildId);
                            showButton("join", (!this._Str_7536), false);
                            
                        case "home_room":
                            this.widget.handler._Str_24389(this._Str_8815);
                            
                        case "open_forum":
                            if (((!(this.widget == null)) && (!(this.widget.roomEngine == null))))
                            {
                                _local_4 = ASCompat.reinterpretAs(this.widget.roomEngine , Component);
                                if (_local_4.context != null)
                                {
                                    _local_4.context.createLinkEvent(("groupforum/" + Std.string(this._guildId)));
                                }
 else {}                            }
                    }
                }
                if (_arg_2.name == "profile_link")
                {
                    this._Str_17990.openGroupInfo(this._guildId);
                }
                _local_3 = true;
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

        var widget(get,never):FurnitureContextMenuWidget;
function  get_widget():FurnitureContextMenuWidget
        {
            return Std.downcast(_widget , FurnitureContextMenuWidget);
        }
    }

