package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNodeListView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfig;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfigs;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonView;

     class ExpandedVariablePickerView implements IDisposable
    {
        var _picker:NewVariablePicker;
        var _window:IWindowContainer;
        var _tabButtonTemplate:IRegionWindow;
        var _overviewTemplate:IWindowContainer;
        var _tabButtons:Vector<TabButtonView> = new Vector();
        var _configs:TabButtonConfigs;
        var _selectedTab:TabButtonView;
        var _activeItemsView:VariableNodeListView;
        var _disposed:Bool = false;

        public function new(picker:NewVariablePicker, window:IWindowContainer)
        {
var config:TabButtonConfig  = null, view:TabButtonView  = null;            this._picker = picker;
            this._window = window;
            this._tabButtonTemplate = Std.downcast(this.buttonList.removeListItemAt(0) , IRegionWindow);
            this._overviewTemplate = Std.downcast(this.contentBox.removeChild(
                this.contentBox.getChildByName("variable_overview_template")) , IWindowContainer);
            var nodeTemplate= this.contentBox.getChildByName("node_template");
            if (nodeTemplate != null) { this.contentBox.removeChild(nodeTemplate); }
            this._configs = new TabButtonConfigs(picker);
            this.expandedWindow.width = picker.window.width;
            var baseWidth= Std.int((this.expandedWindow.width - 3) / this._configs.tabButtons.length);
            var remainder= (this.expandedWindow.width - 3) % this._configs.tabButtons.length;
            final _iter_ = this._configs.tabButtons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
config = _tmp_;
view= new TabButtonView(this, config, baseWidth + (remainder-- > 0 ? 1 : 0));
                this._tabButtons.push(view);
                this.buttonList.addListItem(view.window);
            }
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker) function onHide() { this.clearActiveItems(); }
        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker) function onVisible()
        {
            if (this._selectedTab != null) { this.loadTab(this._selectedTab.tabConfig); }
        }

        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._picker.roomEvents; }
        public var selectedTab(get,never):TabButtonView;
public function  get_selectedTab():TabButtonView { return this._selectedTab; }
        public var activeItemsView(get,never):VariableNodeListView;
public function  get_activeItemsView():VariableNodeListView { return this._activeItemsView; }
        public var tabButtonTemplate(get,never):IRegionWindow;
public function  get_tabButtonTemplate():IRegionWindow { return this._tabButtonTemplate; }
        public var overviewTemplate(get,never):IWindowContainer;
public function  get_overviewTemplate():IWindowContainer { return this._overviewTemplate; }
        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._window; }

        public function tabById(id:Int):TabButtonView
        {
var view:TabButtonView  = null;            final _iter_ = this._tabButtons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                if (view.tabConfig.tabId == id) { return view; }
            }
            return null;
        }

        public function selectTab(value:TabButtonView, force:Bool = false)
        {
            if (this._selectedTab == value)
            {
                if (force && value != null) { this.loadTab(value.tabConfig); }
                return;
            }
            if (this._selectedTab != null) { this._selectedTab.active = false; }
            this._selectedTab = value;
            if (value != null)
            {
                value.active = true;
                this.loadTab(value.tabConfig);
            }
            this._picker.inputField.focus();
        }

        public function loadTab(config:TabButtonConfig)
        {
            this.clearActiveItems();
            var root:VariableNode = config.filteredVariables();
            if (root.childrenCount == 0)
            {
                this.emptyContainer.visible = true;
                this.contentBox.height = this.emptyContainer.height;
                return;
            }
            this.emptyContainer.visible = false;
            this._activeItemsView = new VariableNodeListView(this._picker, root.children, this.contentBox.width, true);
            this.contentBox.addChild(this._activeItemsView.window);
            this.contentBox.height = this._activeItemsView.window.height;
        }

        function clearActiveItems()
        {
            if (this._activeItemsView == null) { return; }
            if ((this._activeItemsView.window.parent : ASAny) == (this.contentBox : ASAny))
            {
                this.contentBox.removeChild(this._activeItemsView.window);
            }
            this._activeItemsView.dispose();
            this._activeItemsView = null;
        }

        var buttonList(get,never):IItemListWindow;
function  get_buttonList():IItemListWindow { return Std.downcast(this._window.findChildByName("button_list") , IItemListWindow); }
        var expandedWindow(get,never):IWindowContainer;
function  get_expandedWindow():IWindowContainer { return Std.downcast(this._window.findChildByName("expanded_view") , IWindowContainer); }
        var contentBox(get,never):IWindowContainer;
function  get_contentBox():IWindowContainer { return Std.downcast(this._window.findChildByName("content_box") , IWindowContainer); }
        var emptyContainer(get,never):IWindowContainer;
function  get_emptyContainer():IWindowContainer { return Std.downcast(this._window.findChildByName("empty_container") , IWindowContainer); }

        public function dispose()
        {
var view:TabButtonView  = null;            if (this._disposed) { return; }
            this.clearActiveItems();
            this.buttonList.removeListItems();
            final _iter_ = this._tabButtons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { view = _tmp_;
view.dispose(); }
            this._tabButtons = null;
            this._picker = null;
            this._window = null;
            this._tabButtonTemplate = null;
            this._overviewTemplate = null;
            this._configs = null;
            this._selectedTab = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

