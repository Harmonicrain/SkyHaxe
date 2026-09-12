package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNodeListView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfigs;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;

     class NewVariablePicker implements IDisposable
    {
        public static final UNSPECIFIED_TYPE:Int = ASCompat.MAX_INT;

        var _disposed:Bool = false;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _container:IWindowContainer;
        var _expandedWindowWrapper:IWindowContainer;
        var _inputFieldRegion:IRegionWindow;
        var _isExpanded:Bool = false;
        var _variableFilter:ASFunction;
        var _onSelected:ASFunction;
        var _showFilteredVariables:Bool = true;
        var _allVariables:AllVariablesInRoom;
        var _filteredVariables:Vector<WiredVariable> = new Vector();
        var _selected:WiredVariable;
        var _variableTarget:Int = 0;
        var _selectionCache:ASDictionary<ASAny,ASAny> = new ASDictionary();
        var _originalSelectedId:String;
        var _queryDirty:Bool = false;
        var _expandedView:ExpandedVariablePickerView;

        public function new(roomEvents:HabboUserDefinedRoomEvents, container:IWindowContainer,
                                          filter:ASFunction = null, onSelected:ASFunction = null,
                                          style:WiredStyle = null)
        {
            this._roomEvents = roomEvents;
            this._container = container;
            this._variableFilter = filter;
            this._onSelected = onSelected;
            this._selectionCache = new ASDictionary<ASAny,ASAny>();
            this._inputFieldRegion = Std.downcast(container.findChildByName("input_field_region") , IRegionWindow);
            this._expandedWindowWrapper = Std.downcast(container.findChildByName("expanded_view_wrapper") , IWindowContainer);
            this._expandedWindowWrapper.desktop.addChild(this._expandedWindowWrapper);
            this._expandedWindowWrapper.visible = false;
            if (style != null && style.name == "illumina")
            {
                this.collapsedView.style = 105;
                this._expandedWindowWrapper.findChildByName("expanded_view").style = 105;
            }
            this._inputFieldRegion.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClick);
            this.inputField.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClick);
            this.cancelSearchButton.addEventListener(WindowMouseEvent.CLICK, this.onCancelSearch);
            this.inputField.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onChangeQuery);
            this.inputField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onKeyUp);
            this.inputPlaceholderText.visible = true;
            this._expandedWindowWrapper.setParamFlag(16, false);
            this._expandedWindowWrapper.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
            this.collapseView(true);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, target:Int)
        {
            this._allVariables = variables;
            this._variableTarget = target;
            this._originalSelectedId = selectedId;
            this._queryDirty = false;
            this._selectionCache = new ASDictionary<ASAny,ASAny>();
            this._filteredVariables = this.filterAllVariables();
            this.select(this.findVariableById(selectedId), true);
            if (this._expandedView != null)
            {
                this._expandedView.selectTab(this._expandedView.tabById(this.determineInitialTab()));
            }
        }

                public var variableTarget(get,set):Int;
public function  set_variableTarget(value:Int):Int        {
            if (value == this._variableTarget) { return value; }
            this.collapseView();
            this.updateSelected();
            this._variableTarget = value;
            this._filteredVariables = this.filterAllVariables();
            this.select(this._selectionCache.exists(value ) ? ASCompat.dynamicAs(this._selectionCache[value] , WiredVariable) : null);
return value;
        }
public function  get_variableTarget():Int { return this._variableTarget; }
        public var filteredVariables(get,never):Vector<WiredVariable>;
public function  get_filteredVariables():Vector<WiredVariable> { return this._filteredVariables; }
        public var variableFilter(get,never):ASFunction;
public function  get_variableFilter():ASFunction { return this._variableFilter; }
        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        public var expandedView(get,never):ExpandedVariablePickerView;
public function  get_expandedView():ExpandedVariablePickerView { return this._expandedView; }
        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._container; }

        public function filteredVariableById(id:String):WiredVariable { return this.findVariableById(id); }

        function findVariableById(id:String):WiredVariable
        {
var variable:WiredVariable  = null;            final _iter_ = this._filteredVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
                if (variable.variableId == id) { return variable; }
            }
            return null;
        }

        function filterAllVariables():Vector<WiredVariable>
        {
var variable:WiredVariable  = null, filterVisible = false, targetVisible = false, privateVisible = false;            var output= new Vector<WiredVariable>();
            if (this._allVariables == null || this._allVariables.variables == null) { return output; }
            final _iter_ = this._allVariables.variables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
filterVisible= this._variableFilter == null || this._showFilteredVariables || ASCompat.toBool(this._variableFilter(variable));
targetVisible= variable.variableTarget == this._variableTarget || this._variableTarget == UNSPECIFIED_TYPE;
privateVisible= !variable.isInvisible || this._originalSelectedId == variable.variableId;
                if (filterVisible && targetVisible && privateVisible && variable.variableName.length > 0) { output.push(variable); }
            }
            return output;
        }

        public function select(value:WiredVariable, initializing:Bool = false)
        {
            this.collapseView();
            this._selectionCache[this._variableTarget] = value;
            this._selected = value;
            this.inputField.text = value == null ? "" : value.variableName;
            this.updatePlaceholder();
            if (!initializing && this._onSelected != null) { this._onSelected(value); }
            this._queryDirty = false;
        }

        function updateSelected()
        {
            var value= this.filteredVariableByDisplayName(this.inputField.text);
            if (value != null && value != this._selected) { this.select(value); }
            if (this.inputField.text.length == 0 && this._selected != null) { this.select(null); }
        }

        public var selected(get,never):WiredVariable;
public function  get_selected():WiredVariable { this.updateSelected(); return this._selected; }
        public function finalize()
        {
            this.updateSelected();
            if (this._selected != null) { this._roomEvents.variablePickerHelper.addToHistory(this._selected); }
        }

        function collapseView(force:Bool = false)
        {
            if (!this._isExpanded && !force) { return; }
            this._isExpanded = false;
            this.collapsedView.visible = true;
            this._expandedWindowWrapper.visible = false;
            this._expandedWindowWrapper.deactivate();
            this.moveInputField(this.searchWrapperCollapsed);
            if (this._expandedView != null) { this._expandedView.onHide(); }
        }

        function expandView()
        {
            if (this._isExpanded) { return; }
            this._isExpanded = true;
            this.collapsedView.visible = false;
            var position= new Point();
            this._container.getGlobalPosition(position);
            position.y -= this.searchWrapperExpanded.y;
            this._expandedWindowWrapper.setGlobalPosition(position);
            this._expandedWindowWrapper.visible = true;
            this._expandedWindowWrapper.activate();
            this.moveInputField(this.searchWrapperExpanded);
            this.inputField.focus();
            if (this._expandedView == null)
            {
                this._expandedView = new ExpandedVariablePickerView(this, this._expandedWindowWrapper);
                this._expandedView.selectTab(this._expandedView.tabById(this.determineInitialTab()));
            }
            else { this._expandedView.onVisible(); }
            this._queryDirty = false;
        }

        function determineInitialTab():Int
        {
            if (this._selected == null) { return TabButtonConfigs.USER_CREATED_TAB_ID; }
            if (this._selected.variableType == WiredVariableTypes.DYNAMIC) { return TabButtonConfigs.DYNAMIC_TAB_ID; }
            if (this._selected.variableType == WiredVariableTypes.INTERNAL) { return TabButtonConfigs.INTERNAL_TAB_ID; }
            return TabButtonConfigs.USER_CREATED_TAB_ID;
        }

        function moveInputField(parent:IWindowContainer)
        {
            cast(this._inputFieldRegion.parent, IWindowContainer).removeChild(this._inputFieldRegion);
            parent.addChild(this._inputFieldRegion);
            this._inputFieldRegion.width = parent.width;
            this._inputFieldRegion.height = parent.height;
        }

        function onDeactivate(event:WindowEvent)
        {
var value:WiredVariable  = null;            if (this._queryDirty)
            {
value= this.filteredVariableByDisplayName(this.inputField.text);
                this.select(value != null ? value : this._selected);
            }
            this._queryDirty = false;
            this.collapseView();
        }

        function filteredVariableByDisplayName(name:String):WiredVariable
        {
var variable:WiredVariable  = null;            final _iter_ = this._filteredVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
                if (this._variableFilter != null && !this._variableFilter(variable)) { continue; }
                if (variable.variableName.toLowerCase() == name.toLowerCase()) { return variable; }
            }
            return null;
        }

        function onKeyUp(event:WindowKeyboardEvent)
        {
var tab:TabButtonView  = null, list:VariableNodeListView  = null, node:VariableNode  = null;            if (event.keyCode == 27) { this.collapseView(); return; }
            if (event.keyCode != 13) { return; }
            var value= this.filteredVariableByDisplayName(this.inputField.text);
            if (value != null) { this.select(value); return; }
            if (this.inputField.text.length == 0) { this.select(null); return; }
            if (this._expandedView != null && this._isExpanded)
            {
tab= this._expandedView.selectedTab;
list= this._expandedView.activeItemsView;
                if (tab != null && tab.tabConfig.tabId == TabButtonConfigs.SEARCH_TAB_ID
                    && list != null && list.childNodes.length > 0)
                {
node= list.childNodes[0].variableNode;
                    if (node.variable != null && node.canBeSelected(this)) { this.select(node.variable); }
                }
            }
        }

        function onChangeQuery(event:WindowEvent)
        {
            if (this._isExpanded && this._expandedView != null)
            {
                this._expandedView.selectTab(this._expandedView.tabById(TabButtonConfigs.SEARCH_TAB_ID), true);
            }
            this.updatePlaceholder();
            this._queryDirty = true;
        }
        function updatePlaceholder()
        {
            this.cancelSearchButton.visible = this.inputField.text.length > 0;
            this.inputPlaceholderText.visible = this.inputField.text.length == 0;
        }
        function onTextRegionClick(event:WindowMouseEvent) { this.inputField.focus(); this.expandView(); }
        function onCancelSearch(event:WindowMouseEvent)
        {
            this.inputField.text = "";
            this.select(null);
            this.inputField.focus();
            this.expandView();
        }

        public var width(never,set):Int;
public function  set_width(value:Int):Int{ return this._container.width = value; }
        public var inputField(get,never):ITextFieldWindow;
public function  get_inputField():ITextFieldWindow { return Std.downcast(this._inputFieldRegion.findChildByName("input_field") , ITextFieldWindow); }
        var collapsedView(get,never):IBorderWindow;
function  get_collapsedView():IBorderWindow { return Std.downcast(this._container.findChildByName("collapsed_view") , IBorderWindow); }
        var inputPlaceholderText(get,never):ITextWindow;
function  get_inputPlaceholderText():ITextWindow { return Std.downcast(this._inputFieldRegion.findChildByName("input_placeholder_text") , ITextWindow); }
        var searchWrapperCollapsed(get,never):IWindowContainer;
function  get_searchWrapperCollapsed():IWindowContainer { return Std.downcast(this._container.findChildByName("search_wrapper_collapsed") , IWindowContainer); }
        var searchWrapperExpanded(get,never):IWindowContainer;
function  get_searchWrapperExpanded():IWindowContainer { return Std.downcast(this._expandedWindowWrapper.findChildByName("search_wrapper_expanded") , IWindowContainer); }
        var cancelSearchButton(get,never):IRegionWindow;
function  get_cancelSearchButton():IRegionWindow { return Std.downcast(this._expandedWindowWrapper.findChildByName("cancel_search") , IRegionWindow); }

        public function dispose()
        {
            if (this._disposed) { return; }
            if (this._expandedView != null)
            {
                this._expandedView.dispose();
                this._expandedView = null;
            }
            if (this._expandedWindowWrapper != null)
            {
                this._expandedWindowWrapper.removeEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
                if (this._expandedWindowWrapper.parent != null)
                {
                    cast(this._expandedWindowWrapper.parent, IWindowContainer).removeChild(this._expandedWindowWrapper);
                }
                this._expandedWindowWrapper.dispose();
            }
            this._container = null;
            this._expandedWindowWrapper = null;
            this._inputFieldRegion = null;
            this._roomEvents = null;
            this._allVariables = null;
            this._filteredVariables = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

