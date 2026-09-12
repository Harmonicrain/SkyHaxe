package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class VariableNodeView implements IDisposable
    {
        static inline final HOVER_BG:UInt = 0xFFE0E0E0;
        static inline final EVEN_BG:UInt = 0xFFEFEFEF;
        static inline final ODD_BG:UInt = 0xFFFAFAFA;

        var _variableNode:VariableNode;
        var _picker:NewVariablePicker;
        var _window:IRegionWindow;
        var _style:WiredStyle;
        var _index:Int = 0;
        var _hover:Bool = false;
        var _selectable:Bool = false;
        var _disabled:Bool = false;
        var _parent:VariableNodeListView;
        var _sublist:VariableNodeListView;
        var _disposed:Bool = false;

        public function new(node:VariableNode, picker:NewVariablePicker,
                                         parent:VariableNodeListView, index:Int)
        {
            this._variableNode = node;
            this._picker = picker;
            this._parent = parent;
            this._index = index;
            this._style = picker.roomEvents.wiredCtrl.wiredStyle;
            this._window = picker.roomEvents.variablePickerHelper.acquireNodeView(this._style);
            this._selectable = node.canBeSelected(picker);
            this._disabled = node.isDisabled(picker);
            this.icon.visible = node.childrenCount > 0;
            this.nodeName.text = node.name;
            this.nodeName.blend = this._disabled ? 0.55 : 1;
            this.icon.blend = this._disabled ? 0.55 : 1;
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.addEventListener(WindowMouseEvent.OVER, this.onOver);
            if (this._disabled)
            {
                this._window.toolTipCaption = picker.roomEvents.localization.getLocalization(
                    "wiredfurni.variable_picker.tooltip_disabled", "wiredfurni.variable_picker.tooltip_disabled");
            }
            else if (!this._selectable)
            {
                this._window.toolTipCaption = picker.roomEvents.localization.getLocalization(
                    "wiredfurni.variable_picker.tooltip_not_selectable", "wiredfurni.variable_picker.tooltip_not_selectable");
            }
            else
            {
                this._window.toolTipCaption = "";
            }
            this.updateColoring();
        }

        function onClick(event:WindowMouseEvent)
        {
            if (this._selectable) { this._picker.select(this._variableNode.variable); }
        }
        function onOver(event:WindowMouseEvent) { this._parent.setHover(this); }

        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview) var hover(never,set):Bool;
function  set_hover(value:Bool):Bool        {
            if (this._hover == value) { return value; }
            this._hover = value;
            this.updateColoring();
            if (this._variableNode.childrenCount > 0)
            {
                if (value) { this.initSublist(); } else { this.removeSublist(); }
            }
return value;
        }

        function updateColoring()
        {
            this._window.color = this._hover ? HOVER_BG : (this._index % 2 == 0 ? EVEN_BG : ODD_BG);
        }

        function initSublist()
        {
            if (this._sublist != null) { return; }
            this._sublist = new VariableNodeListView(this._picker, this._variableNode.children, this._window.width);
            var child= this._sublist.window;
            var host= this._picker.expandedView.window;
            host.addChild(child);
            var nodeGlobal= new Point();
            var hostGlobal= new Point();
            this._window.getGlobalPosition(nodeGlobal);
            host.getGlobalPosition(hostGlobal);
            child.x = Std.int(nodeGlobal.x - hostGlobal.x + this._window.width + this._parent.scrollbarWidth);
            child.y = Std.int(nodeGlobal.y - hostGlobal.y);
            var bounds= new Rectangle();
            child.getGlobalRectangle(bounds);
            if (bounds.bottom > child.desktop.bottom)
            {
                child.offset(0, child.desktop.bottom - bounds.bottom);
                if (child.y < 0) { child.y = 0; }
            }
        }

        function removeSublist()
        {
            if (this._sublist == null) { return; }
            if (this._sublist.window.parent != null)
            {
                cast(this._sublist.window.parent, IWindowContainer).removeChild(this._sublist.window);
            }
            this._sublist.dispose();
            this._sublist = null;
        }

        public var variableNode(get,never):VariableNode;
public function  get_variableNode():VariableNode { return this._variableNode; }
        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }

        var icon(get,never):IIconWindow;
function  get_icon():IIconWindow { return Std.downcast(this._window.findChildByName("right_triangle_icon") , IIconWindow); }
        var nodeName(get,never):ITextWindow;
function  get_nodeName():ITextWindow { return Std.downcast(this._window.findChildByName("node_name") , ITextWindow); }

        public function dispose()
        {
            if (this._disposed) { return; }
            this.removeSublist();
            this._window.removeEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.removeEventListener(WindowMouseEvent.OVER, this.onOver);
            this._picker.roomEvents.variablePickerHelper.releaseNodeView(this._style, this._window);
            this._picker = null;
            this._window = null;
            this._style = null;
            this._variableNode = null;
            this._parent = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

