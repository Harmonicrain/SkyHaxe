package com.sulake.habbo.moderation
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;

     class IssueBrowser 
    {
        static inline final _Str_23545= "my_issues";
        static inline final _Str_25166= "open_issues";
        static inline final _Str_23557= "picked_issues";
        static inline final _Str_26068= "closed_issues";

        var _issueManager:IssueManager;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _window:IFrameWindow;
        var _tabContext:ITabContextWindow;
        var _selectedView:IIssueBrowserView;
        var _myIssuesView:IIssueBrowserView;
        var _openIssuesView:IIssueBrowserView;
        var _pickedIssuesView:PickedIssuesView;

        public function new(k:IssueManager, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._issueManager = k;
            this._windowManager = _arg_2;
            this._assets = _arg_3;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._assets;
        }

        public var _Str_2880(get,never):IssueManager;
public function  get__Str_2880():IssueManager
        {
            return this._issueManager;
        }

        public function show()
        {
            if (this._window == null)
            {
                this._Str_25703();
            }
            this._window.visible = true;
            this._window.activate();
            this.update();
        }

        public function isOpen():Bool
        {
            return (!(this._window == null)) && this._window.visible;
        }

        function _Str_25703()
        {
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            var _local_4:IWindow = null;
            var _local_5:ITabButtonWindow = null;
            var _local_6 = 0;
            if (this._window == null)
            {
                this._window = Std.downcast(this.createWindow("issue_browser_xml") , IFrameWindow);
                if (this._window == null)
                {
                    return;
                }
                _local_2 = this._window.desktop;
                this._window.x = Std.int((_local_2.width / 2) - (this._window.width / 2));
                this._window.y = Std.int((_local_2.height / 2) - (this._window.height / 2));
                _local_3 = this._window.findChildByTag("close");
                if (_local_3 != null)
                {
                    _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
                }
                _local_4 = this._window.findChildByName("auto_pick");
                if (_local_4 != null)
                {
                    _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_25081);
                }
                this._tabContext = Std.downcast(this._window.findChildByName("tab_context") , ITabContextWindow);
                _local_6 = 0;
                while ((_local_6 : UInt) < this._tabContext.numTabs)
                {
                    _local_5 = this._tabContext.getTabButtonAt(_local_6);
                    _local_5.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onTabSelected);
                    _local_6++;
                }
                this._myIssuesView = new MyIssuesView(this._Str_2880, this, Std.downcast(this._window.findChildByName("my_issues_prototype") , IWindowContainer));
                this._openIssuesView = new OpenIssuesView(this._Str_2880, this, Std.downcast(this._window.findChildByName("open_issues_prototype") , IWindowContainer));
                this._pickedIssuesView = new PickedIssuesView(this._Str_2880, this, Std.downcast(this._window.findChildByName("picked_issues_prototype") , IWindowContainer));
            }
            this._tabContext = Std.downcast(this._window.findChildByName("tab_context") , ITabContextWindow);
            if (((this._tabContext == null) || (this._tabContext.container == null)))
            {
                return;
            }
            var k= this._tabContext.selector.getSelectableByName("open_issues");
            this._tabContext.selector.setSelected(k);
        }

        function _Str_3734(k:String)
        {
            var _local_2= this._Str_9043(k);
            if (this._selectedView == _local_2)
            {
                return;
            }
            if (this._selectedView != null)
            {
                this._selectedView.visible = false;
            }
            this._selectedView = _local_2;
            if (this._selectedView == null)
            {
                return;
            }
            this._selectedView.view.width = this._tabContext.container.width;
            this._selectedView.view.height = this._tabContext.container.height;
            this._selectedView.visible = true;
            this._selectedView.update();
        }

        function _Str_9043(k:String):IIssueBrowserView
        {
            switch (k)
            {
                case IssueBrowser._Str_23545:
                    return this._myIssuesView;
                case IssueBrowser._Str_25166:
                    return this._openIssuesView;
                case IssueBrowser._Str_23557:
                    return this._pickedIssuesView;
                default:
                    return null;
            }
        }

        function onTabSelected(k:WindowEvent)
        {
            if (((k == null) || (k.window == null)))
            {
                return;
            }
            this._Str_3734(k.window.name);
        }

        public function update()
        {
            if (((this._window == null) || (!this._window.visible)))
            {
                return;
            }
            if (this._selectedView == null)
            {
                return;
            }
            this._selectedView.update();
        }

        public function createWindow(k:String):IWindow
        {
            if (((this._windowManager == null) || (this._assets == null)))
            {
                return null;
            }
            var _local_2= Std.downcast(this._assets.getAssetByName(k) , XmlAsset);
            if (((_local_2 == null) || (_local_2.content == null)))
            {
                return null;
            }
            return this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ));
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._window.visible = false;
        }

        function _Str_25081(k:WindowMouseEvent)
        {
            if (this._issueManager != null)
            {
                this._issueManager.autoPick("issue browser pick next");
            }
        }
    }

