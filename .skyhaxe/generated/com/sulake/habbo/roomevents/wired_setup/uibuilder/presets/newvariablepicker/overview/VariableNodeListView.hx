package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;

     class VariableNodeListView implements IDisposable
    {
        static inline final MAX_HEIGHT= 300;
        static inline final SCROLLBAR_WIDTH= 9;

        var _window:IWindowContainer;
        var _picker:NewVariablePicker;
        var _childNodes:Vector<VariableNodeView> = new Vector();
        var _currentHoveredNode:VariableNodeView;
        var _disposed:Bool = false;

        public function new(picker:NewVariablePicker, nodes:Vector<VariableNode>, width:Int,
                                             root:Bool = false)
        {
var                 index = 0, view:VariableNodeView  = null, childWidth = 0;            this._picker = picker;
            this._window = Std.downcast(picker.expandedView.overviewTemplate.clone() , IWindowContainer);
            if (!root) { this._window.style = 12; }
            this._window.width = width;
            if (nodes != null && nodes.length > 0)
            {
                index= 0;while (index < nodes.length)
                {
view= new VariableNodeView(nodes[index], picker, this, index);
                    this.nodesList.addListItem(view.window);
                    this._childNodes.push(view);
index++;
                }
                this.nodesList.height = Std.int(Math.min(this._childNodes[0].window.height * nodes.length, MAX_HEIGHT));
childWidth= width - this.scrollbarWidth - (root ? 0 : 3);
                final _iter_ = this._childNodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
view  = _tmp_;
                    view.window.width = childWidth;
                    if (!root) { view.window.x = 1; }
                }
            }
            else
            {
                this.nodesList.height = 10;
            }
        }

        public var scrollbarWidth(get,never):Int;
public function  get_scrollbarWidth():Int { return this.nodesList.isScrollBarVisible ? SCROLLBAR_WIDTH : 0; }
        public var childNodes(get,never):Vector<VariableNodeView>;
public function  get_childNodes():Vector<VariableNodeView> { return this._childNodes; }
        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._window; }

        public function setHover(value:VariableNodeView)
        {
            if (value == this._currentHoveredNode) { return; }
            if (this._currentHoveredNode != null) { this._currentHoveredNode.hover = false; }
            this._currentHoveredNode = value;
            if (value != null) { value.hover = true; }
        }

        var nodesList(get,never):IScrollableListWindow;
function  get_nodesList():IScrollableListWindow
        {
            return Std.downcast(this._window.findChildByName("nodes_list") , IScrollableListWindow);
        }

        public function dispose()
        {
var view:VariableNodeView  = null;            if (this._disposed) { return; }
            final _iter_ = this._childNodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { view = _tmp_;
view.dispose(); }
            this.nodesList.removeListItems();
            this._childNodes = null;
            this._picker = null;
            this._currentHoveredNode = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

