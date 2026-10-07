package com.sulake.habbo.friendlist
;
    import flash.geom.Point;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.friendlist.events._Str_3797;
    import com.sulake.core.window.IWindow;

     class FriendListView
    {
        static final DEFAULT_LOCATION:Point = new Point(110, 50);
        static inline final MIN_LEFT_MARGIN= 110;
        static inline final WINDOW_LAYER_INDEX= 1;

        var _habboFriendList:HabboFriendList;
        var _tabsView:FriendListTabsView;
        var _mainWindow:IFrameWindow;
        var _tabContent:IWindowContainer;
        var _footer:IWindowContainer;
        var _infoText:ITextWindow;
        var _lastWindowHeight:Int = -1;
        var _lastWindowWidth:Int = -1;
        var _ignoreResizeEvents:Bool = false;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
            this._tabsView = new FriendListTabsView(this._habboFriendList);
        }

        public function openFriendList()
        {
            if (this._mainWindow == null)
            {
                this.prepare();
                this._mainWindow.position = DEFAULT_LOCATION;
            }
            else
            {
                this._mainWindow.visible = true;
                this._mainWindow.activate();
            }
        }

        public function showInfo(k:WindowEvent, _arg_2:String)
        {
            var _local_3= Std.downcast(k , WindowMouseEvent);
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3.type == WindowMouseEvent.OUT)
            {
                this._infoText.text = "";
            }
            else
            {
                if (_local_3.type == WindowMouseEvent.OVER)
                {
                    this._infoText.text = _arg_2;
                }
            }
        }

        public function refresh(k:String)
        {
            if (this._mainWindow == null)
            {
                return;
            }
            this._tabsView.refresh(k);
            this.refreshWindowSize();
        }

        public function close()
        {
            if (this._mainWindow != null)
            {
                this._mainWindow.visible = false;
            }
        }

        public function isOpen():Bool
        {
            return (this._mainWindow != null) && this._mainWindow.visible;
        }

        function prepare()
        {
            this._mainWindow = cast(this._habboFriendList.getXmlWindow("main_window"), IFrameWindow);
            this._mainWindow.findChildByTag("close").procedure = this.onWindowClose;
            this._tabContent = cast(this._mainWindow.content.findChildByName("main_content"), IWindowContainer);
            this._footer = cast(this._mainWindow.content.findChildByName("footer"), IWindowContainer);
            this._tabsView.prepare(this._tabContent);
            this._mainWindow.procedure = this.onWindow;
            this._mainWindow.content.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER, false);
            this._mainWindow.content.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_FIXED, true);
            this._mainWindow.header.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER, false);
            this._mainWindow.header.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED, true);
            this._mainWindow.content.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER, false);
            this._mainWindow.content.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED, true);
            var k= this._habboFriendList.getBoolean("friendship.category.management.enabled");
            if ((k && (!(this._habboFriendList.getInteger("spaweb", 0) == 1))))
            {
                this._mainWindow.findChildByName("open_edit_ctgs_but").procedure = this.onEditCategoriesButtonClick;
            }
            else
            {
                this._mainWindow.findChildByName("open_edit_ctgs_but").visible = false;
            }
            this._infoText = cast(this._mainWindow.findChildByName("info_text"), ITextWindow);
            this._infoText.text = "";
            this._habboFriendList.refreshButton(this._mainWindow, "open_edit_ctgs", true, null, 0);
            this.refresh("prepare");
            this._mainWindow.height = 350;
            this._mainWindow.width = 230;
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Close window"]);
            this._mainWindow.visible = false;
            this._habboFriendList._Str_9727(_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_CLOSED);
            this._habboFriendList.categories.view._Str_18123();
        }

        function onWindow(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowEvent.WINDOW_EVENT_RELOCATE) || (k.type == WindowEvent.WINDOW_EVENT_RESIZED)))
            {
                this._habboFriendList.categories.view._Str_18123();
            }
            if (((!(k.type == WindowEvent.WINDOW_EVENT_RESIZED)) || (!((_arg_2 : ASAny) == (this._mainWindow : ASAny)))))
            {
                return;
            }
            if (this._ignoreResizeEvents)
            {
                return;
            }
            var _local_3= ((this._lastWindowHeight == -1) ? 0 : (this._mainWindow.height - this._lastWindowHeight));
            var _local_4= ((this._lastWindowWidth == -1) ? 0 : (this._mainWindow.width - this._lastWindowWidth));
            this._habboFriendList.tabs._Str_12266 = Std.int(Math.max(100, (this._habboFriendList.tabs._Str_12266 + _local_3)));
            this._habboFriendList.tabs._Str_4971 = Std.int(Math.max(147, (this._habboFriendList.tabs._Str_4971 + _local_4)));
            this.refresh(("resize: " + Std.string(_local_3)));
        }

        function refreshWindowSize()
        {
            this._ignoreResizeEvents = true;
            this._footer.visible = false;
            this._footer.y = Util.getLowestPoint(this._mainWindow.content);
            this._footer.width = this._habboFriendList.tabs._Str_4971;
            this._footer.visible = true;
            this._mainWindow.content.height = Util.getLowestPoint(this._mainWindow.content);
            this._mainWindow.content.width = (this._habboFriendList.tabs._Str_4971 - 10);
            this._mainWindow.header.width = (this._habboFriendList.tabs._Str_4971 - 10);
            this._mainWindow.height = (this._mainWindow.content.height + 30);
            this._mainWindow.width = this._habboFriendList.tabs._Str_4971;
            this._ignoreResizeEvents = false;
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TRIGGER, false);
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TRIGGER, (!(this._habboFriendList.tabs._Str_14015() == null)));
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER, false);
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER, false);
            this._mainWindow.scaler.x = (this._mainWindow.width - this._mainWindow.scaler.width);
            this._mainWindow.scaler.y = (this._mainWindow.height - this._mainWindow.scaler.height);
            this._lastWindowHeight = this._mainWindow.height;
            this._lastWindowWidth = this._mainWindow.width;
            Logger.log([("RESIZED: " + Std.string(this._habboFriendList.tabs._Str_4971))]);
        }

        function onEditCategoriesButtonClick(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${friendlist.tip.preferences}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Edit categories clicked"]);
            var _local_3= Std.downcast(k , WindowMouseEvent);
            this._habboFriendList.openHabboWebPage("link.format.friendlist.pref", new ASDictionary<ASAny,ASAny>(), Std.int(_local_3.stageX), Std.int(_local_3.stageY));
        }

        public var mainWindow(get,never):IWindowContainer;
public function  get_mainWindow():IWindowContainer
        {
            return this._mainWindow;
        }

        public function alignBottomLeftTo(k:Point)
        {
            var _local_2= k.clone();
            _local_2.y = (_local_2.y - this._mainWindow.height);
            var _local_3= this._habboFriendList.windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().width;
            _local_2.x = Math.min((_local_3 - this._mainWindow.width), _local_2.x);
            _local_2.x = Math.max(MIN_LEFT_MARGIN, _local_2.x);
            this._mainWindow.position = _local_2;
        }
    }

