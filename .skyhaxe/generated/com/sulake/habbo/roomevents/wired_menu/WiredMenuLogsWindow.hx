package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;

    /**
     * July-compatible Wired execution log browser. Packet transport stays in
     * WiredMenuController; this class owns only the dedicated window state.
     */
     final class WiredMenuLogsWindow implements IDisposable
    {
        static inline final PAGE_SIZE= 50;
        static inline final AUTO_REFRESH_MS= 2500;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _requestCallback:ASFunction;
        var _window:IFrameWindow;
        var _table:TableView;
        var _timer:Timer;
        var _page:Int = 1;
        var _total:Int = 0;
        var _disposed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                            requestCallback:ASFunction)
        {
            this._roomEvents = roomEvents;
            this._requestCallback = requestCallback;
            this._timer = new Timer(AUTO_REFRESH_MS);
            this._timer.addEventListener(TimerEvent.TIMER, (this.onAutoRefresh : ASAny));
        }

        public function show()
        {
            this.ensureWindow();
            if (this._window == null)
            {
                return;
            }
            this._window.visible = true;
            this._window.activate();
            this.requestPage(this._page);
        }

        public function applyPage(parser:ASObject)
        {
            if (parser == null)
            {
                return;
            }
            this.ensureWindow();
            this._total = Std.int(Math.max(0, ASCompat.toInt(parser.total)));
            this._page = Std.int(Math.max(1, ASCompat.toInt(parser.page)));
            var rows=
                new Vector<com.sulake.habbo.window.utils.tableview.ITableObject>();
            var entry:ASObject = null;
            var index = 0;
            final _iter_:ASAny = parser.entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                rows.push(new WiredMenuTableObject("log_" + entry.id + "_" + Std.string(index++), {
                    "time": entry.timestampText,
                    "level": this.loc("wiredmenu.logs_overview.log_level." + entry.level,
                        ASCompat.toString(entry.level)),
                    "source": this.loc("wiredmenu.logs_overview.log_source." + entry.source,
                        ASCompat.toString(entry.source)),
                    "message": entry.message
                }, entry));
            }
            if (this._table != null)
            {
                this._table.setObjects(rows, true);
            }
            this.updatePagination();
            this.applyResponseFilters(parser);
        }

        public function close()
        {
            this._timer.stop();
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, (this.onAutoRefresh : ASAny));
            if (this._table != null)
            {
                this._table.dispose();
                this._table = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._requestCallback = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function ensureWindow()
        {
            if (this._window != null || this._disposed)
            {
                return;
            }
            this._window = Std.downcast(this._roomEvents.getXmlWindow(
                "wired_menu_logs_overview") , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._window);
            this._window.center();
            var close= this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            }
            this.bindClick("first_page_btn", this.onFirstPage);
            this.bindClick("prev_page_btn", this.onPreviousPage);
            this.bindClick("next_page_btn", this.onNextPage);
            this.bindClick("last_page_btn", this.onLastPage);
            var input=
                Std.downcast(this._window.findChildByName("filter_input") , ITextFieldWindow);
            if (input != null)
            {
                input.maxChars = 64;
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onFilterKey);
            }
            var pageInput=
                Std.downcast(this._window.findChildByName("pagina_number_input") , ITextFieldWindow);
            if (pageInput != null)
            {
                pageInput.restrict = "0-9";
                pageInput.maxChars = 6;
                pageInput.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onPageKey);
            }
            var source=
                Std.downcast(this._window.findChildByName("log_source_menu") , IDropMenuWindow);
            var level=
                Std.downcast(this._window.findChildByName("log_level_menu") , IDropMenuWindow);
            if (source != null)
            {
                source.selection = 0;
                source.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onFilterChanged);
            }
            if (level != null)
            {
                level.selection = 0;
                level.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onFilterChanged);
            }
            var autoRefresh=
                Std.downcast(this._window.findChildByName("auto_refresh_cbx") , ICheckBoxWindow);
            if (autoRefresh != null)
            {
                autoRefresh.select();
                autoRefresh.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onAutoRefreshChanged);
                autoRefresh.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                    this.onAutoRefreshChanged);
                this._timer.start();
            }
            var tableParent=
                Std.downcast(this._window.findChildByName("table_view") , IWindowContainer);
            var tableAsset=
                Std.downcast(this._roomEvents.assets.getAssetByName("table_view_xml") , XmlAsset);
            if (tableParent != null && tableAsset != null)
            {
                this._table = new TableView(this._roomEvents.windowManager,
                    tableParent, true, false, tableAsset);
                this._table.initialize(Vector.ofArray([
                    new TableColumn("time", this.loc("wiredmenu.logs_overview.col.timestamp",
                        "Timestamp"), 0.20, "left"),
                    new TableColumn("level", this.loc("wiredmenu.logs_overview.col.level",
                        "Level"), 0.12, "left"),
                    new TableColumn("source", this.loc("wiredmenu.logs_overview.col.source",
                        "Source"), 0.16, "left"),
                    new TableColumn("message", this.loc("wiredmenu.logs_overview.col.message",
                        "Message"), 0.52, "left")
                ]), true, false);
            }
        }

        function bindClick(name:String, callback:ASFunction)
        {
            var window= this._window.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        function requestPage(page:Int)
        {
            if (this._requestCallback == null)
            {
                return;
            }
            var source=
                Std.downcast(this._window.findChildByName("log_source_menu") , IDropMenuWindow);
            var level=
                Std.downcast(this._window.findChildByName("log_level_menu") , IDropMenuWindow);
            var input=
                Std.downcast(this._window.findChildByName("filter_input") , ITextFieldWindow);
            this._requestCallback(Math.max(1, page), PAGE_SIZE,
                level == null ? -1 : level.selection - 1,
                source == null ? -1 : source.selection - 1,
                input == null ? "" : input.text.substr(0, 64));
        }

        function updatePagination()
        {
            if (this._window == null)
            {
                return;
            }
            var pageCount= Std.int(Math.max(1, Math.fceil(this._total / PAGE_SIZE)));
            this._page = Std.int(Math.min(Math.max(1, this._page), pageCount));
            var start=
                Std.downcast(this._window.findChildByName("pagina_text_start") , ITextWindow);
            var end=
                Std.downcast(this._window.findChildByName("pagina_text_end") , ITextWindow);
            var input=
                Std.downcast(this._window.findChildByName("pagina_number_input") , ITextFieldWindow);
            if (start != null)
            {
                start.text = Std.string(this._total) + " logs found. Showing page";
            }
            if (input != null)
            {
                input.text = Std.string(this._page);
            }
            if (end != null)
            {
                end.text = "of " + Std.string(pageCount);
            }
            this.setEnabled("first_page_btn", this._page > 1);
            this.setEnabled("prev_page_btn", this._page > 1);
            this.setEnabled("next_page_btn", this._page < pageCount);
            this.setEnabled("last_page_btn", this._page < pageCount);
        }

        function applyResponseFilters(parser:ASObject)
        {
var level:IDropMenuWindow  = null, source:IDropMenuWindow  = null, input:ITextFieldWindow  = null;            if (this._window == null)
            {
                return;
            }
            if (ASCompat.hasOwnProperty(parser, "levelFilter"))
            {
level=
                    Std.downcast(this._window.findChildByName("log_level_menu")
, IDropMenuWindow);
                if (level != null)
                {
                    level.selection = ASCompat.toInt(parser.levelFilter) + 1;
                }
            }
            if (ASCompat.hasOwnProperty(parser, "sourceFilter"))
            {
source=
                    Std.downcast(this._window.findChildByName("log_source_menu")
, IDropMenuWindow);
                if (source != null)
                {
                    source.selection = ASCompat.toInt(parser.sourceFilter) + 1;
                }
            }
            if (ASCompat.hasOwnProperty(parser, "query"))
            {
input=
                    Std.downcast(this._window.findChildByName("filter_input")
, ITextFieldWindow);
                if (input != null)
                {
                    input.text = ASCompat.toString(parser.query);
                }
            }
        }

        function setEnabled(name:String, enabled:Bool)
        {
            var window= this._window.findChildByName(name);
            if (window != null)
            {
                if (enabled) window.enable(); else window.disable();
            }
        }

        function loc(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(key, fallback);
        }

        function onClose(event:WindowMouseEvent) { this.close(); }
        function onFirstPage(event:WindowMouseEvent) { this.requestPage(1); }
        function onPreviousPage(event:WindowMouseEvent)
        {
            this.requestPage(Std.int(Math.max(1, this._page - 1)));
        }
        function onNextPage(event:WindowMouseEvent)
        {
            this.requestPage(this._page + 1);
        }
        function onLastPage(event:WindowMouseEvent)
        {
            this.requestPage(Std.int(Math.max(1, Math.fceil(this._total / PAGE_SIZE))));
        }
        function onFilterChanged(event:WindowEvent)
        {
            this.requestPage(1);
        }
        function onFilterKey(event:WindowKeyboardEvent)
        {
            if (event.charCode == Keyboard.ENTER)
            {
                this.requestPage(1);
            }
        }
        function onPageKey(event:WindowKeyboardEvent)
        {
            if (event.charCode != Keyboard.ENTER)
            {
                return;
            }
            var input= Std.downcast(event.window , ITextFieldWindow);
            this.requestPage(Std.int(Math.max(1, ASCompat.toInt(input.text))));
        }
        function onAutoRefreshChanged(event:WindowEvent)
        {
            var checkbox= Std.downcast(event.window , ICheckBoxWindow);
            if (checkbox != null && checkbox.Selected)
            {
                this._timer.start();
            }
            else
            {
                this._timer.stop();
            }
        }
        function onAutoRefresh(event:TimerEvent)
        {
            if (this._window != null && this._window.visible)
            {
                this.requestPage(this._page);
            }
        }
    }

