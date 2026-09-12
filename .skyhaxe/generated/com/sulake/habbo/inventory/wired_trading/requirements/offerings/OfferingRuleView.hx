package com.sulake.habbo.inventory.wired_trading.requirements.offerings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;

     class OfferingRuleView implements IDisposable
    {
        static inline final MAX_COLUMNS= 2;

        var _window:IWindowContainer;
        var _rowTemplate:IItemListWindow;
        var _nodeTemplate:IItemListWindow;
        var _rowX:Int = 0;
        var _nodes:Vector<OfferingNodeView>;
        var _disposed:Bool = false;

        public function new(template:IWindowContainer)
        {
            this._window = Std.downcast(template.clone() , IWindowContainer);
            this._rowTemplate =
                Std.downcast(this.rows.removeListItemAt(0) , IItemListWindow);
            this._nodeTemplate =
                Std.downcast(this._rowTemplate.removeListItemAt(0) , IItemListWindow);
            this._rowX = this.rows.x;
        }

        public function initialize(rule:TradeRequirementRule, index:Int)
        {
var node:TradeRequirementNode  = null, nodeView:OfferingNodeView  = null;            this.clearRows();
            this._nodes = new Vector<OfferingNodeView>();
            var row:IItemListWindow = null;
            var nodeIndex= 0;
            final _iter_ = rule.nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
                if (row == null || row.numListItems >= MAX_COLUMNS)
                {
                    row = Std.downcast(this._rowTemplate.clone() , IItemListWindow);
                    this.rows.addListItem(row);
                }
nodeView=
                    new OfferingNodeView(this._nodeTemplate);
                nodeView.initialize(node, nodeIndex);
                this._nodes.push(nodeView);
                row.addListItem(nodeView.window);
                nodeIndex++;
            }
            this.orText.visible = index > 0;
            this._window.height = this.rows.height;
        }

        public function center(width:Int)
        {
var             i = 0, row:IItemListWindow  = null;            var columnsWidth= 0;
            i= 0;while (i < this.rows.numListItems)
            {
row=
                    Std.downcast(this.rows.getListItemAt(i) , IItemListWindow);
                columnsWidth = Std.int(Math.max(columnsWidth, row.width));
i++;
            }
            this.rows.x = Std.int(width / 2 - columnsWidth / 2);
        }

        function clearRows()
        {
var row:IItemListWindow  = null, node:OfferingNodeView  = null;            this.rows.x = this._rowX;
            while (this.rows.numListItems > 0)
            {
row=
                    Std.downcast(this.rows.removeListItemAt(0) , IItemListWindow);
                row.removeListItems();
                row.dispose();
            }
            if (this._nodes != null)
            {
                final _iter_ = this._nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
node = _tmp_;
                    node.dispose();
                }
            }
            this._nodes = null;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._window; }

        public function dispose()
        {
            if (this._disposed) { return; }
            this.clearRows();
            this._rowTemplate.dispose();
            this._nodeTemplate.dispose();
            this._rowTemplate = null;
            this._nodeTemplate = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var orText(get,never):ITextWindow;
function  get_orText():ITextWindow
        { return Std.downcast(this._window.findChildByName("or_text") , ITextWindow); }
        var rows(get,never):IItemListWindow;
function  get_rows():IItemListWindow
        { return Std.downcast(this._window.findChildByName("rule_nodes_rows") , IItemListWindow); }
    }

