package com.sulake.habbo.window.utils.tableview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;

     class TableCellView implements IDisposable
    {
        var _disposed:Bool = false;
        var _table:TableView;
        var _row:TableRowView;
        var _columnId:String;
        var _cell:TableCell;
        var _container:IRegionWindow;
        var _transitionTimer:Timer;
        var _highlightBorder:IBorderWindow;

        public function new(table:TableView, row:TableRowView, columnId:String, cell:TableCell)
        {
            this._table = table;
            this._row = row;
            this._columnId = columnId;
            this._cell = cell;
            this._container = this.template.clone();
            this.updateWidth();
            this.initializeView();
            this._container.addEventListener(WindowMouseEvent.DOUBLE_CLICK, this.onDoubleClick);
            this._container.addEventListener(WindowMouseEvent.DOWN, this._row.onDown);
            this._container.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
            this._container.mouseThreshold = 0;
        }

        public function reuse(cell:TableCell)
        {
            this._cell = cell;
            this.initializeView();
            this.updateWidth();
        }

        public function update(cell:TableCell)
        {
            this._cell = cell;
            var input= this.getInputElement(false);
            if (input != null && input.visible)
            {
                this.updateContents();
            }
            else
            {
                this.initializeView();
                if (cell.highlightOnChange)
                {
                    this.highlight();
                }
            }
            this.updateWidth();
        }

        public function updateWidth()
        {
            var text:ITextWindow = null;
            var input:ITextFieldWindow = null;
            var linkRegion:IRegionWindow = null;
            var linkText:ITextWindow = null;
            var width= this._table.getCellWidth(this._columnId);
            this._container.width = width;
            text = this.getTextElement(false);
            if (text != null)
            {
                text.width = width;
            }
            input = this.getInputElement(false);
            if (input != null)
            {
                input.width = width;
            }
            linkRegion = this.getLinkRegion(false);
            if (linkRegion != null)
            {
                linkRegion.width = width;
                linkText = this.getLinkElement(false);
                if (linkText != null)
                {
                    linkText.width = width;
                }
            }
        }

        public var container(get,never):IRegionWindow;
public function  get_container():IRegionWindow
        {
            return this._container;
        }

        public function recycle()
        {
            this._cell = null;
        }

        public function dispose()
        {
            var input:ITextFieldWindow = null;
            var linkRegion:IRegionWindow = null;
            var extraRegion:IRegionWindow = null;
            if (this._disposed)
            {
                return;
            }
            if (this._transitionTimer != null)
            {
                this._transitionTimer.stop();
                this._transitionTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onHighlightTimer : ASAny));
                this._transitionTimer.removeEventListener(
                    TimerEvent.TIMER_COMPLETE, (this.onHighlightComplete : ASAny));
                this._transitionTimer = null;
            }
            this._highlightBorder = null;
            if (this._container != null)
            {
                this._container.removeEventListener(WindowMouseEvent.DOUBLE_CLICK, this.onDoubleClick);
                this._container.removeEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                this._container.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                this._container.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                input = this.getInputElement(false);
                if (input != null)
                {
                    input.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.onInputEdit);
                    input.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onInputEdit);
                    input.removeEventListener(WindowEvent.WINDOW_EVENT_UNFOCUS, this.onInputFocusOut);
                }
                linkRegion = this.getLinkRegion(false);
                if (linkRegion != null)
                {
                    linkRegion.removeEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                    linkRegion.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                    linkRegion.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                    linkRegion.removeEventListener(WindowMouseEvent.CLICK, this.onLinkClick);
                }
                extraRegion = this.getExtraButtonRegion(false);
                if (extraRegion != null)
                {
                    extraRegion.removeEventListener(WindowMouseEvent.CLICK, this.onExtraButtonClick);
                    extraRegion.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                    extraRegion.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                }
                this._container.dispose();
                this._container = null;
            }
            this._row = null;
            this._table = null;
            this._cell = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function initializeView()
        {
            this.setAllInvisible();
            if (this._cell == null)
            {
                return;
            }
            if (this._cell.type == TableCell.TYPE_LINK)
            {
                this.getLinkRegion(true).visible = true;
            }
            else
            {
                this.getTextElement(true).visible = true;
            }
            this.updateContents();
            this.updateWidth();
        }

        function updateContents()
        {
            var text:ITextWindow = null;
            var tooltip:String = null;
            var extraRegion:IRegionWindow = null;
            if (this._cell.type == TableCell.TYPE_LINK)
            {
                this.getLinkElement(true).text = ASCompat.asString(this._cell.contents );
            }
            else
            {
                text = this.getTextElement(true);
                if (text != null)
                {
                    if (this._cell.textColor != 0)
                    {
                        text.textColor = this._cell.textColor;
                    }
                    text.autoSize = this.column.alignment;
                    text.text = ASCompat.asString(this._cell.contents );
                }
            }

            tooltip = "";
            if (this._cell.tooltipText != null)
            {
                tooltip = this._cell.tooltipText;
            }
            this._container.toolTipCaption = tooltip;

            extraRegion = this.getExtraButtonRegion(false);
            if (this._cell.extraBtn != null)
            {
                extraRegion = this.getExtraButtonRegion(true);
                extraRegion.visible = true;
                this.getExtraButton(true).assetUri = this._cell.extraBtn;
            }
            else if (extraRegion != null)
            {
                extraRegion.visible = false;
            }
        }

        function setAllInvisible()
        {
            this.turnInvisible(this.getTextElement(false));
            this.turnInvisible(this.getInputElement(false));
            this.turnInvisible(this.getLinkRegion(false));
            this.turnInvisible(this.getExtraButtonRegion(false));
        }

        function turnInvisible(window:IWindow)
        {
            if (window != null)
            {
                window.visible = false;
            }
        }

        function onLinkClick(k:WindowMouseEvent)
        {
            if (((this._cell != null) && (!(this._cell.linkClickCallback == null))))
            {
                this._cell.linkClickCallback();
            }
        }

        function onExtraButtonClick(k:WindowMouseEvent)
        {
            if (((this._cell != null) && (!(this._cell.extraBtnCallback == null))))
            {
                this._cell.extraBtnCallback();
            }
        }

        function onDoubleClick(k:WindowMouseEvent)
        {
            var input:ITextFieldWindow = null;
            if (((this._cell == null) || ((!this._cell.isInspectable) && (!this._cell.isEditable))))
            {
                return;
            }
            this.setAllInvisible();
            input = this.getInputElement(true);
            input.visible = true;
            input.text = this._cell.textFieldValue;
            input.editable = this._cell.isEditable;
            input.focus();
        }

        function onInputEdit(k:WindowKeyboardEvent)
        {
            var input:ITextFieldWindow = null;
            if (this._cell == null)
            {
                return;
            }
            input = this.getInputElement(false);
            if (((k.keyCode == Keyboard.ENTER) && this._cell.isEditable))
            {
                this._table.onEnterNewCellValue(input.text, this._row.object, this._columnId);
                this.initializeView();
            }
            else if (k.keyCode == Keyboard.ESCAPE)
            {
                this.initializeView();
            }
        }

        function onInputFocusOut(k:WindowEvent)
        {
            this.initializeView();
        }

        var column(get,never):TableColumn;
function  get_column():TableColumn
        {
            return this._table.getColumnById(this._columnId);
        }

        function getTextElement(create:Bool):ITextWindow
        {
            var text= Std.downcast(this._container.findChildByName("element_text") , ITextWindow);
            if (((text == null) && create))
            {
                text = this.template.createElementText(this._container);
            }
            return text;
        }

        function getInputElement(create:Bool):ITextFieldWindow
        {
            var input:ITextFieldWindow = null;
            input = Std.downcast(this._container.findChildByName("element_input") , ITextFieldWindow);
            if (((input == null) && create))
            {
                input = this.template.createElementInput(this._container);
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.onInputEdit);
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onInputEdit);
                input.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUS, this.onInputFocusOut);
            }
            return input;
        }

        function getLinkRegion(create:Bool):IRegionWindow
        {
            var region:IRegionWindow = null;
            region = Std.downcast(this._container.findChildByName("link_container") , IRegionWindow);
            if (((region == null) && create))
            {
                region = this.template.createLinkContainer(this._container);
                region.addEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                region.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                region.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                region.addEventListener(WindowMouseEvent.CLICK, this.onLinkClick);
                region.mouseThreshold = 0;
            }
            return region;
        }

        function getLinkElement(create:Bool):ITextWindow
        {
            var region= this.getLinkRegion(create);
            if (region == null)
            {
                return null;
            }
            return Std.downcast(region.findChildByName("element_link") , ITextWindow);
        }

        function getExtraButtonRegion(create:Bool):IRegionWindow
        {
            var region:IRegionWindow = null;
            region = Std.downcast(this._container.findChildByName("extra_button") , IRegionWindow);
            if (((region == null) && create))
            {
                region = this.template.createExtraButton(this._container);
                region.addEventListener(WindowMouseEvent.CLICK, this.onExtraButtonClick);
                region.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                region.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
            }
            return region;
        }

        function getExtraButton(create:Bool):IStaticBitmapWrapperWindow
        {
            var region= this.getExtraButtonRegion(create);
            if (region == null)
            {
                return null;
            }
            return Std.downcast(region.findChildByName("extra_button_bitmap") , IStaticBitmapWrapperWindow);
        }

        function getHighlightBorder(create:Bool):IBorderWindow
        {
            var border=
                Std.downcast(this._container.findChildByName("highlight_border")
, IBorderWindow);
            if (border == null && create)
            {
                border = this.template.createHighlightBorder(
                    this._container );
            }
            return border;
        }

        function highlight()
        {
            if (this._transitionTimer != null
                && this._transitionTimer.running)
            {
                return;
            }
            this._highlightBorder = this.getHighlightBorder(true);
            if (this._highlightBorder == null)
            {
                return;
            }
            this._highlightBorder.visible = true;
            this._highlightBorder.blend = 0;
            if (this._transitionTimer == null)
            {
                this._transitionTimer = new Timer(16, 31);
                this._transitionTimer.addEventListener(
                    TimerEvent.TIMER, (this.onHighlightTimer : ASAny));
                this._transitionTimer.addEventListener(
                    TimerEvent.TIMER_COMPLETE, (this.onHighlightComplete : ASAny));
            }
            else
            {
                this._transitionTimer.reset();
            }
            this._transitionTimer.start();
        }

        function onHighlightTimer(event:TimerEvent)
        {
            if (this._highlightBorder == null
                || this._transitionTimer == null)
            {
                return;
            }
            var progress=
                this._transitionTimer.currentCount
                / this._transitionTimer.repeatCount;
            var curve= -(progress * 1.75 - 0.7)
                * (progress * 1.75 - 0.7) + 1;
            this._highlightBorder.blend = 0.35 * curve;
        }

        function onHighlightComplete(event:TimerEvent)
        {
            if (this._highlightBorder != null)
            {
                this._highlightBorder.visible = false;
            }
        }

        var template(get,never):CellTemplate;
function  get_template():CellTemplate
        {
            return this._table.cellTemplate;
        }
    }

