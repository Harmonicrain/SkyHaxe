package com.sulake.habbo.window.utils.tableview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class TableRowView implements IDisposable
    {
        static inline final COLOR_SELECTED_FOCUSED:UInt = 0xFFB8E2FC;
        static inline final COLOR_SELECTED:UInt = 0xFFD1D1D1;
        static inline final COLOR_EVEN:UInt = 0xFFF2F2F2;
        static inline final COLOR_ODD:UInt = 0xFFF9F9F9;

        var _disposed:Bool = false;
        var _table:TableView;
        var _container:IItemListWindow;
        var _cellViews:Vector<TableCellView>;
        var _model:TableRowModel;

        public function new(table:TableView, model:TableRowModel)
        {
            var column:TableColumn = null;
            var cell:TableCell = null;
            var cellView:TableCellView = null;
            this._table = table;
            this._model = model;
            this._container = Std.downcast(table.rowTemplate.clone() , IItemListWindow);
            this._cellViews = new Vector<TableCellView>();
            this.updateWidth();
            final _iter_ = table.columns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
column  = _tmp_;
                cell = this.object.getTableCell(column.id);
                cellView = new TableCellView(table, this, column.id, cell);
                this._cellViews.push(cellView);
                this._container.addListItem(cellView.container);
            }
            this.updateColor();
            this._container.addEventListener(WindowMouseEvent.DOWN, this.onDown);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onHoverOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onHoverOut);
        }

        public static function windowIsChild(parent:IWindow, child:IWindow):Bool
        {
            var container:IWindowContainer = null;
            var i = 0;
            var selector:ISelectorWindow = null;
            if (parent == child)
            {
                return true;
            }
            if (Std.is(parent , ISelectorWindow))
            {
                selector = Std.downcast(parent , ISelectorWindow);
                i = 0;
                while ((i : UInt) < selector.numSelectables)
                {
                    if (windowIsChild(selector.getSelectableAt(i), child))
                    {
                        return true;
                    }
                    i++;
                }
            }
            else if (Std.is(parent , IWindowContainer) || Std.is(parent , IItemListWindow))
            {
                container = Std.downcast(parent , IWindowContainer);
                i = 0;
                while (i < container.numChildren)
                {
                    if (windowIsChild(container.getChildAt(i), child))
                    {
                        return true;
                    }
                    i++;
                }
            }
            return false;
        }

        public function indexUpdated()
        {
            this.updateColor();
        }

        public function objectUpdated(previous:ITableObject, current:ITableObject)
        {
            var column:TableColumn = null;
            var cell:TableCell = null;
            var cellView:TableCellView = null;
            var index = 0;
            final _iter_ = this._table.columns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
column  = _tmp_;
                if (current.isPropertyUpdated(column.id, previous))
                {
                    cell = current.getTableCell(column.id);
                    cellView = this._cellViews[index];
                    cellView.update(cell);
                }
                index++;
            }
        }

        public function reuse(model:TableRowModel)
        {
            var column:TableColumn = null;
            var cell:TableCell = null;
            var cellView:TableCellView = null;
            var index = 0;
            this._model = model;
            final _iter_ = this._table.columns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
column  = _tmp_;
                cell = this.object.getTableCell(column.id);
                cellView = this._cellViews[index];
                cellView.reuse(cell);
                index++;
            }
            this.updateColor();
        }

        public function updateWidth()
        {
            var cellView:TableCellView = null;
            if (this._container.width == this._table.rowWidth)
            {
                return;
            }
            this._container.width = this._table.rowWidth;
            final _iter_ = this._cellViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
cellView  = _tmp_;
                cellView.updateWidth();
            }
        }

        public function onDown(k:WindowMouseEvent)
        {
            if (this._model == null)
            {
                return;
            }
            this._model.hasFocus = true;
            this._table.trySelect(this.object, true);
            this.updateColor();
        }

        public function onHoverOver(k:WindowMouseEvent)
        {
            if (((this._model == null) || this._model.hovered))
            {
                return;
            }
            this._table.onHover(this.object);
        }

        public function onHoverOut(k:WindowMouseEvent)
        {
            if (((this._model == null) || (!this._model.hovered)))
            {
                return;
            }
            this._table.onHover(null);
        }

        public function selectedUpdated()
        {
            this.updateColor();
        }

        public function hoveredUpdated()
        {
        }

        public var object(get,never):ITableObject;
public function  get_object():ITableObject
        {
            return ((this._model != null) ? this._model.object : null);
        }

        public var container(get,never):IItemListWindow;
public function  get_container():IItemListWindow
        {
            return this._container;
        }

        public function recycle()
        {
            var cellView:TableCellView = null;
            final _iter_ = this._cellViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
cellView  = _tmp_;
                cellView.recycle();
            }
            this._model = null;
        }

        public function dispose()
        {
            var cellView:TableCellView = null;
            if (this._disposed)
            {
                return;
            }
            final _iter_ = this._cellViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
cellView  = _tmp_;
                cellView.dispose();
            }
            this._cellViews = null;
            if (this._container != null)
            {
                this._container.removeEventListener(WindowMouseEvent.DOWN, this.onDown);
                this._container.removeEventListener(WindowMouseEvent.OVER, this.onHoverOver);
                this._container.removeEventListener(WindowMouseEvent.OUT, this.onHoverOut);
                this._container.dispose();
                this._container = null;
            }
            this._table = null;
            this._model = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function updateColor()
        {
            var color:UInt = 0;
            if (this._model == null)
            {
                return;
            }
            if (this._model.selected)
            {
                color = (this._model.hasFocus ? COLOR_SELECTED_FOCUSED : COLOR_SELECTED);
            }
            else
            {
                color = (((this._model.i % 2) == 0) ? COLOR_EVEN : COLOR_ODD);
            }
            this._container.color = color;
        }
    }

