package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TradeRuleEditorPreset extends WiredUIPreset
    {
        static inline final NODE_VIEW_POOL_MAX_SIZE= 50;
        public static inline final MAX_NODES_IN_RULE= 5;
        static final NODE_VIEW_POOL:Map = new Map();

        var _container:IBorderWindow;
        var _nodeTemplate:IRegionWindow;
        var _nodeViews:Vector<TradeRuleNodeView>;
        var _onEdit:ASFunction;
        var _onAdd:ASFunction;
        var _onRemove:ASFunction;
        var _onChange:ASFunction;
        var _hovered:Bool = false;
        var _closeHovered:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, title:String,
            onEdit:ASFunction, onAdd:ASFunction, onRemove:ASFunction = null,
            onChange:ASFunction = null)
        {
            super(roomEvents, presetManager, style);
            this._container = style.createTradeRequirementRule();
            this._nodeViews = new Vector<TradeRuleNodeView>();
            this._onEdit = onEdit;
            this._onAdd = onAdd;
            this._onRemove = onRemove;
            this._onChange = onChange;
            this.updateTitle(title);
            this._nodeTemplate = Std.downcast(this.itemGrid.removeGridItemAt(0) , IRegionWindow);
            this.addMoreButton.addEventListener(WindowMouseEvent.CLICK, this.onAddMoreClicked);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.OVER, this.onCloseHover);
            this.closeRegion.addEventListener(WindowMouseEvent.OUT, this.onCloseHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.CLICK, this.onCloseClick);
            if (this.isOneLineMode) this.itemGrid.setParamFlag(8388608, false);
            this.updateCloseButtonVisibility();
        }

        var isOneLineMode(get,never):Bool;
function  get_isOneLineMode():Bool { return true; }
        var showNodeCloseButton(get,never):Bool;
function  get_showNodeCloseButton():Bool { return true; }

        public var rule(never,set):TradeRequirementRule;
public function  set_rule(value:TradeRequirementRule):TradeRequirementRule        {
var node:TradeRequirementNode  = null;            this.removeAllNodes();
            final _iter_ = value.nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {node = _tmp_;
this.addNode(node);
};
return value;
        }

        function onAddMoreClicked(event:WindowMouseEvent)
        {
            if (this._onAdd != null) this._onAdd(this);
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts) function editNode(view:TradeRuleNodeView)
        {
            if (this.itemGrid.getGridItemIndex(view.window) == -1) return;
            if (this._onEdit != null)
                this._onEdit(this, view.uniqueID, view.node);
        }

        public function updateTitle(value:String) { this.titleWindow.text = value; }
        function fireOnChange() { if (this._onChange != null) this._onChange(); }

        public function addNode(node:TradeRequirementNode)
        {
            if (disposed || this._nodeViews.length >= MAX_NODES_IN_RULE) return;
            var view= this.createNodeView(node.deepCopy(),
                this.showNodeCloseButton);
            this.itemGrid.addGridItemAt(view.window, this.itemGrid.numGridItems - 1);
            this._nodeViews.push(view);
            this.onNodeCountChange();
        }

        function createNodeView(node:TradeRequirementNode,
            showClose:Bool = true):TradeRuleNodeView
        {
            var pool:Vector<TradeRuleNodeView> = null;
            if (!NODE_VIEW_POOL.hasKey(this._style.name))
                NODE_VIEW_POOL.add(this._style.name, new Vector<TradeRuleNodeView>());
            pool = ASCompat.asVector(NODE_VIEW_POOL.getValue(this._style.name) , (_ : TradeRuleNodeView));
            var view= pool.length > 0
                ? pool.pop() : new TradeRuleNodeView(this._nodeTemplate);
            view.initialize(this, node, showClose);
            return view;
        }

        function releaseNodeView(view:TradeRuleNodeView)
        {
            if (!NODE_VIEW_POOL.hasKey(this._style.name))
                NODE_VIEW_POOL.add(this._style.name, new Vector<TradeRuleNodeView>());
            var pool=
                ASCompat.asVector(NODE_VIEW_POOL.getValue(this._style.name) , (_ : TradeRuleNodeView));
            if (pool.length >= NODE_VIEW_POOL_MAX_SIZE) view.dispose();
            else { view.release(); pool.push(view); }
        }

        public function updateNode(uniqueId:UInt, node:TradeRequirementNode)
        {
            if (disposed) return;
            var view= this.getNodeViewByUniqueId(uniqueId);
            if (view == null) return;
            view.node = node;
            this.fireOnChange();
        }

        public function finalizeRule():TradeRequirementRule
        {
var view:TradeRuleNodeView  = null;            var nodes= new Vector<TradeRequirementNode>();
            final _iter_ = this._nodeViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{view = _tmp_;
                nodes.push(view.node);
};
            return new TradeRequirementRule(nodes);
        }

        function getNodeViewByUniqueId(uniqueId:UInt):TradeRuleNodeView
        {
var view:TradeRuleNodeView  = null;            final _iter_ = this._nodeViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{view = _tmp_;
                if (view.uniqueID == uniqueId) return view;
};
            return null;
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts) function removeNode(view:TradeRuleNodeView)
        {
            var index= this._nodeViews.indexOf(view);
            if (index == -1) return;
            this._nodeViews.splice(index, 1);
            this.itemGrid.removeGridItem(view.window);
            this.releaseNodeView(view);
            this.onNodeCountChange();
        }

        function removeAllNodes()
        {
var view:TradeRuleNodeView  = null;            if (this._container == null) return;
            while (this.itemGrid.numGridItems > 1) this.itemGrid.removeGridItemAt(0);
            final _iter_ = this._nodeViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{view = _tmp_;
                this.releaseNodeView(view);
};
            this._nodeViews = new Vector<TradeRuleNodeView>();
            this.onNodeCountChange();
        }

        function onNodeCountChange()
        {
            this.itemGrid.rebuildGridStructure();
            if (this.addMoreButton != null)
            {
                if (this.isOneLineMode)
                    this.addMoreButton.visible = this._nodeViews.length < MAX_NODES_IN_RULE;
                else
                    Util.disableSection(this.addMoreButton,
                        this._nodeViews.length >= MAX_NODES_IN_RULE);
            }
            this.fireOnChange();
        }

        function onCloseClick(event:WindowMouseEvent)
        {
            if (this._onRemove != null) this._onRemove(this);
        }
        function onHoverEnd(event:WindowMouseEvent) { this._hovered = false; this.updateCloseButtonVisibility(); }
        function onHover(event:WindowMouseEvent) { this._hovered = true; this.updateCloseButtonVisibility(); }
        function onCloseHoverEnd(event:WindowMouseEvent) { this._closeHovered = false; this.updateCloseButtonVisibility(); }
        function onCloseHover(event:WindowMouseEvent) { this._closeHovered = true; this.updateCloseButtonVisibility(); }

        function updateCloseButtonVisibility()
        {
            this.closeRegion.visible =
                (this._hovered || this._closeHovered) && this._onRemove != null;
        }

        override public function  get_window():IWindow { return this._container; }
        override public function resizeToWidth(width:Int)
        {
            super.resizeToWidth(width);
            this._container.width = width;
        }
        override function  get_childPresets():Array<ASAny> { return []; }

        override public function dispose()
        {
            if (disposed) return;
            this.removeAllNodes();
            super.dispose();
            this._nodeViews = null;
            this._onEdit = null;
            this._onAdd = null;
            this._onRemove = null;
            this._onChange = null;
            this._nodeTemplate.dispose();
            this._nodeTemplate = null;
            this._container.dispose();
            this._container = null;
        }

        var itemGrid(get,never):IItemGridWindow;
function  get_itemGrid():IItemGridWindow { return Std.downcast(this._container.findChildByName("grid") , IItemGridWindow); }
        var titleWindow(get,never):ITextWindow;
function  get_titleWindow():ITextWindow { return Std.downcast(this._container.findChildByName("title") , ITextWindow); }
        var addMoreButton(get,never):IWindow;
function  get_addMoreButton():IWindow { return this._container.findChildByName("add_more"); }
        var closeRegion(get,never):IRegionWindow;
function  get_closeRegion():IRegionWindow { return Std.downcast(this._container.findChildByName("close_rule_region") , IRegionWindow); }
    }

