package com.sulake.habbo.window.utils.tableview
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.IHabboWindowManager;

     class TableView implements IDisposable
    {
        static inline final SCROLLBAR_OFFSET= 21;

        var _disposed:Bool = false;
        var _initialized:Bool = false;

        var _windowManager:IHabboWindowManager;
        var _parent:IWindowContainer;
        var _container:IWindowContainer;

        var _tableTitleRow:IItemListWindow;
        var _splitter:IWindow;
        var _titleTemplate:ITextWindow;
        var _tableItems:IScrollableListWindow;
        var _rowTemplate:IItemListWindow;
        var _cellTemplate:CellTemplate;

        var _columns:Vector<TableColumn>;
        var _rowModels:Vector<TableRowModel>;
        var _rowViews:Vector<TableRowView>;
        var _rowByIdentifier:ASDictionary<ASAny,ASAny>;

        var _selected:TableRowModel;
        var _hovered:TableRowModel;
        var _canSelect:Bool = false;
        var _showHeader:Bool = false;

        var _onRowClickedCallback:ASFunction;
        var _onRowSelectedCallback:ASFunction;
        var _onRowHoverCallback:ASFunction;
        var _onCellEditCallback:ASFunction;

        public function new(windowManager:IHabboWindowManager, parent:IWindowContainer, clip:Bool=false, minimalResourcesMode:Bool=false, layoutAsset:XmlAsset=null)
        {
            var xml:com.sulake.core.utils.xml.XML = null;
            this._windowManager = windowManager;
            this._parent = parent;
            this._columns = new Vector<TableColumn>();
            this._rowModels = new Vector<TableRowModel>();
            this._rowViews = new Vector<TableRowView>();
            this._rowByIdentifier = new ASDictionary<ASAny,ASAny>();
            if (layoutAsset != null)
            {
                xml = ((layoutAsset.content : com.sulake.core.utils.xml.XML) );
            }
            else
            {
                if (((windowManager.assets == null) || (windowManager.assets.getAssetByName("table_view_xml") == null)))
                {
                    return;
                }
                xml = ((windowManager.assets.getAssetByName("table_view_xml").content : com.sulake.core.utils.xml.XML) );
            }
            this._container = Std.downcast(windowManager.buildFromXML(xml) , IWindowContainer);
            if (this._container == null)
            {
                return;
            }
            parent.addChild(this._container);

            this._tableTitleRow = Std.downcast(this._container.findChildByName("table_titlerow") , IItemListWindow);
            this._splitter = this._container.findChildByName("splitter");
            this.tableContents.removeListItem(this._tableTitleRow);
            this.tableContents.removeListItem(this._splitter);

            this._titleTemplate = Std.downcast(this._tableTitleRow.removeListItemAt(0) , ITextWindow);

            this._tableItems = Std.downcast(this._container.findChildByName("table_items") , IScrollableListWindow);
            this._rowTemplate = Std.downcast(this._tableItems.removeListItemAt(1) , IItemListWindow);
            this._cellTemplate = new CellTemplate(Std.downcast(this._rowTemplate.removeListItemAt(0) , IRegionWindow));

            this._container.width = parent.width;
            this._container.height = parent.height;
            this.updateTableItemsHeight();
            this.resizeHorizontally();
            this.updateEmptyText();

            if (clip)
            {
                this._container.setParamFlag(2048, true);
            }

            this.tableContents.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResized);
            this._tableItems.addEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrolled);
        }

        public function initialize(columns:Vector<TableColumn>, showHeader:Bool=true, canSelect:Bool=true)
        {
            if (this._initialized)
            {
                return;
            }
            this._canSelect = canSelect;
            this._columns = columns;
            this._rowModels = new Vector<TableRowModel>();
            this._rowViews = new Vector<TableRowView>();
            this._rowByIdentifier = new ASDictionary<ASAny,ASAny>();
            this._showHeader = showHeader;

            if (showHeader)
            {
                this.tableContents.addListItemAt(this._tableTitleRow, 0);
                this.tableContents.addListItemAt(this._splitter, 1);
            }
            else
            {
                this.updateTableItemsHeight();
                this.updateEmptyText();
            }

            this.initializeColumns(columns);
            this._initialized = true;
        }

        public function setObjects(objects:Vector<ITableObject>, resetScroll:Bool=false)
        {
            var obj:ITableObject = null;
            var model:TableRowModel = null;
            var index = 0;
            if (!this._initialized)
            {
                return;
            }

            var sameStructure=
                objects.length == this._rowModels.length;
            if (sameStructure)
            {
                index = 0;
                while (index < objects.length)
                {
                    if (this._rowModels[index].object.identifier
                        != objects[index].identifier)
                    {
                        sameStructure = false;
                        break;
                    }
                    index++;
                }
            }
            if (sameStructure)
            {
                index = 0;
                while (index < objects.length)
                {
                    this._rowModels[index].update(objects[index]);
                    index++;
                }
                if (resetScroll)
                {
                    this._tableItems.scrollV = 0;
                }
                this.updateEmptyText();
                this.onScrollBarVisibilityMayHaveChanged();
                return;
            }

            this.clear(false);
            if (objects.length == 0)
            {
                this.updateEmptyText();
                return;
            }

            index = 0;
            if (checkNullIteratee(objects)) for (_tmp_ in objects)
            {
obj  = _tmp_;
                model = new TableRowModel(obj, index);
                this._rowModels.push(model);
                this._rowByIdentifier[obj.identifier] = model;
                index++;
            }

            this.rebuildRowViews();
            this.updateEmptyText();
            this.onScrollBarVisibilityMayHaveChanged();

            if (resetScroll)
            {
                this._tableItems.scrollV = 0;
            }
        }

        public function clear(disposeModels:Bool=true)
        {
            var view:TableRowView = null;
            var model:TableRowModel = null;
            if (!this._initialized)
            {
                return;
            }

            final _iter_ = this._rowViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view  = _tmp_;
                view.dispose();
            }
            this._rowViews = new Vector<TableRowView>();
            this._tableItems.removeListItems();

            if (disposeModels && (this._rowModels != null))
            {
                final _iter_ = this._rowModels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
model  = _tmp_;
                    model.dispose();
                }
            }
            this._rowModels = new Vector<TableRowModel>();
            this._rowByIdentifier = new ASDictionary<ASAny,ASAny>();

            if (this._selected != null)
            {
                this._selected = null;
                if (this._onRowSelectedCallback != null)
                {
                    this._onRowSelectedCallback(null);
                }
            }
            if (this._hovered != null)
            {
                this._hovered = null;
                if (this._onRowHoverCallback != null)
                {
                    this._onRowHoverCallback(null);
                }
            }
        }

        public function trySelect(obj:ITableObject, fireClick:Bool=false)
        {
            var model:TableRowModel = null;
            if ((this._onRowClickedCallback != null) && fireClick)
            {
                this._onRowClickedCallback(obj);
            }
            if (!this._canSelect)
            {
                return;
            }
            if (((this._selected != null) && (obj != null)) && (this._selected.object == obj))
            {
                return;
            }
            if (this._selected != null)
            {
                this._selected.selected = false;
                this._selected = null;
            }
            if (obj != null)
            {
                model = this.getRowForObject(obj);
                if (model != null)
                {
                    model.selected = true;
                    this._selected = model;
                }
            }
            if (this._onRowSelectedCallback != null)
            {
                this._onRowSelectedCallback(((this._selected != null) ? this._selected.object : null));
            }
        }

        public function onHover(obj:ITableObject)
        {
            var model:TableRowModel = null;
            if (((this._hovered != null) && (obj != null)) && (this._hovered.object == obj))
            {
                return;
            }
            if (this._hovered != null)
            {
                this._hovered.hovered = false;
                this._hovered = null;
            }
            if (obj != null)
            {
                model = this.getRowForObject(obj);
                if (model != null)
                {
                    model.hovered = true;
                    this._hovered = model;
                }
            }
            if (this._onRowHoverCallback != null)
            {
                this._onRowHoverCallback(((this._hovered != null) ? this._hovered.object : null));
            }
        }

        public function resizeHorizontally()
        {
            var i = 0;
            var header:ITextWindow = null;
            var model:TableRowModel = null;
            if ((this._disposed || (this._container == null)) || (this._tableTitleRow == null))
            {
                return;
            }
            this._container.width = this._parent.width;
            this._tableTitleRow.width = this.rowWidth;
            this._splitter.width = this.rowWidth;

            i = 0;
            while (i < this._tableTitleRow.numListItems)
            {
                header = Std.downcast(this._tableTitleRow.getListItemAt(i) , ITextWindow);
                header.width = this.getCellWidth(this._columns[i].id);
                i++;
            }

            final _iter_ = this._rowModels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
model  = _tmp_;
                if (model.view != null)
                {
                    model.view.updateWidth();
                }
            }
        }

        public function getColumnById(id:String):TableColumn
        {
            var column:TableColumn = null;
            final _iter_ = this._columns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
column  = _tmp_;
                if (column.id == id)
                {
                    return column;
                }
            }
            return null;
        }

        public function getCellWidth(columnId:String):Int
        {
            var column= this.getColumnById(columnId);
            return Std.int((column != null) ? Std.int(this.rowWidth * column.widthFactor) : 0);
        }

        public function onEnterNewCellValue(value:String, obj:ITableObject, columnId:String)
        {
            if (this._onCellEditCallback != null)
            {
                this._onCellEditCallback(obj, columnId, value);
            }
        }

        public var rowWidth(get,never):Int;
public function  get_rowWidth():Int
        {
            var scrollbarVisible = false;
            scrollbarVisible = (this._tableItems.maxScrollV > 0);
            return (this.tableContents.width - (scrollbarVisible ? SCROLLBAR_OFFSET : 0));
        }

        public var columns(get,never):Vector<TableColumn>;
public function  get_columns():Vector<TableColumn>
        {
            return this._columns;
        }

        public var rowTemplate(get,never):IItemListWindow;
public function  get_rowTemplate():IItemListWindow
        {
            return this._rowTemplate;
        }

        public var cellTemplate(get,never):CellTemplate;
public function  get_cellTemplate():CellTemplate
        {
            return this._cellTemplate;
        }

        public var onRowSelectedCallback(never,set):ASFunction;
public function  set_onRowSelectedCallback(value:ASFunction):ASFunction        {
            return this._onRowSelectedCallback = value;
        }

        public var onRowClickedCallback(never,set):ASFunction;
public function  set_onRowClickedCallback(value:ASFunction):ASFunction        {
            return this._onRowClickedCallback = value;
        }

        public var onRowHoveredCallback(never,set):ASFunction;
public function  set_onRowHoveredCallback(value:ASFunction):ASFunction        {
            return this._onRowHoverCallback = value;
        }

        public var onCellEditCallback(never,set):ASFunction;
public function  set_onCellEditCallback(value:ASFunction):ASFunction        {
            return this._onCellEditCallback = value;
        }

        public var rowCount(get,never):Int;
public function  get_rowCount():Int
        {
            return ((this._rowModels != null) ? this._rowModels.length : 0);
        }

        public function dispose()
        {
            var model:TableRowModel = null;
            if (this._disposed)
            {
                return;
            }
            if (this.tableContents != null)
            {
                this.tableContents.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResized);
            }
            if (this._tableItems != null)
            {
                this._tableItems.removeEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrolled);
            }
            this.clear();
            final _iter_ = this._rowModels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
model  = _tmp_;
                model.dispose();
            }
            this._rowModels = null;
            this._rowByIdentifier = null;
            this._columns = null;
            this._onRowHoverCallback = null;
            this._onRowSelectedCallback = null;
            this._onRowClickedCallback = null;
            this._onCellEditCallback = null;
            if (this._container != null)
            {
                this._container.dispose();
                this._container = null;
            }
            this._tableTitleRow = null;
            this._splitter = null;
            this._titleTemplate = null;
            this._tableItems = null;
            this._rowTemplate = null;
            this._cellTemplate = null;
            this._windowManager = null;
            this._parent = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function initializeColumns(columns:Vector<TableColumn>)
        {
            var column:TableColumn = null;
            var header:ITextWindow = null;
            var width = 0;
            if (checkNullIteratee(columns)) for (_tmp_ in columns)
            {
column  = _tmp_;
                header = Std.downcast(this._titleTemplate.clone() , ITextWindow);
                header.text = column.columnName;
                width = this.getCellWidth(column.id);
                header.width = width;
                header.autoSize = column.alignment;
                this._tableTitleRow.addListItem(header);
            }
        }

        function rebuildRowViews()
        {
            var model:TableRowModel = null;
            var rowView:TableRowView = null;
            final _iter_ = this._rowModels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
model  = _tmp_;
                rowView = new TableRowView(this, model);
                model.view = rowView;
                this._rowViews.push(rowView);
                this._tableItems.addListItem(rowView.container);
            }
            this.onScrollBarVisibilityMayHaveChanged();
            this.resizeHorizontally();
        }

        function getRowForObject(obj:ITableObject):TableRowModel
        {
            return ((obj != null) ? this._rowByIdentifier[obj.identifier] : null);
        }

        function updateTableItemsHeight()
        {
            if (((this._tableItems == null) || (this.tableContents == null)) || this._disposed)
            {
                return;
            }
            this._tableItems.height = (this.tableContents.height - (this._showHeader ? (this._tableTitleRow.height + this._splitter.height) : 0));
            this.onScrollBarVisibilityMayHaveChanged();
        }

        function updateEmptyText()
        {
            if ((this._disposed || (this.emptyTextContainer == null)) || (this.tableContents == null))
            {
                return;
            }
            if (this._showHeader)
            {
                this.emptyTextContainer.y = (this._tableTitleRow.height + this._splitter.height);
                this.emptyTextContainer.height = (this.tableContents.height - this.emptyTextContainer.y);
            }
            else
            {
                this.emptyTextContainer.y = 0;
                this.emptyTextContainer.height = this.tableContents.height;
            }
            this.emptyTextContainer.visible = ((this._rowModels == null) || (this._rowModels.length == 0));
        }

        function onResized(k:WindowEvent)
        {
            if (this._disposed)
            {
                return;
            }
            this.updateTableItemsHeight();
            this.resizeHorizontally();
        }

        function onScrolled(k:WindowEvent)
        {
            if (this._disposed)
            {
                return;
            }
            this.onScrollBarVisibilityMayHaveChanged();
        }

        function onScrollBarVisibilityMayHaveChanged()
        {
            this.resizeHorizontally();
        }

        var tableContents(get,never):IItemListWindow;
function  get_tableContents():IItemListWindow
        {
            return Std.downcast(this._container.findChildByName("table_contents") , IItemListWindow);
        }

        var emptyTextContainer(get,never):IWindowContainer;
function  get_emptyTextContainer():IWindowContainer
        {
            return Std.downcast(this._container.findChildByName("empty_container") , IWindowContainer);
        }
    }

