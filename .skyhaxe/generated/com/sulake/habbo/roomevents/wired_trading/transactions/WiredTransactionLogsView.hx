package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.utils.LoadingIcon;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;

    /** Exact July full transaction-list interaction adapted to clean TableView. */
     final class WiredTransactionLogsView implements IDisposable
    {
        static inline final REQUEST_PAGE_RATE_LIMIT:UInt = 280;
        static inline final SAME_PAGE_TIMEOUT:UInt = 2000;

        var _controller:WiredTransactionLogsController;
        var _window:IFrameWindow;
        var _table:TableView;
        var _loading:LoadingIcon;
        var _pendingPage:Int = -1;
        var _lastRequest:Int = 0;
        var _disposed:Bool = false;

        public function new(
            controller:WiredTransactionLogsController)
        {
            this._controller = controller;
            this._window = Std.downcast(controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(
                controller.roomEvents.assets.getAssetByName(
                    "transaction_overview_xml").content), 1) , IFrameWindow);
            this._loading = new LoadingIcon();
            this.pageInput.restrict = "0-9";
            var tableAsset= Std.downcast(controller.roomEvents.assets
                .getAssetByName("table_view_xml") , XmlAsset);
            this._table = new TableView(controller.windowManager,
                this.tableContainer, true, true, tableAsset);
            this._table.initialize(Vector.ofArray([
                new TableColumn("type", this.loc("wiredchests.logs.col.type"), 0.17),
                new TableColumn("timestamp",
                    this.loc("wiredchests.logs.col.timestamp"), 0.15),
                new TableColumn("username",
                    this.loc("wiredchests.logs.col.username"), 0.14),
                new TableColumn("withdraws",
                    this.loc("wiredchests.logs.col.withdraws"), 0.14),
                new TableColumn("deposits",
                    this.loc("wiredchests.logs.col.deposits"), 0.14),
                new TableColumn("chests",
                    this.loc("wiredchests.logs.col.chests"), 0.12),
                new TableColumn("details",
                    this.loc("wiredchests.logs.col.details"), 0.14)
            ]), true, true);
            this.firstButton.addEventListener("WME_CLICK", this.onFirst);
            this.previousButton.addEventListener("WME_CLICK", this.onPrevious);
            this.nextButton.addEventListener("WME_CLICK", this.onNext);
            this.lastButton.addEventListener("WME_CLICK", this.onLast);
            this.refreshButton.addEventListener("WME_CLICK", this.onRefresh);
            this.pageInput.addEventListener("WKE_KEY_DOWN", this.onPageKeyDown);
            this.pageInput.addEventListener("WME_CLICK_AWAY", this.onPageClickAway);
            this.closeButton.addEventListener("WME_CLICK", this.onClose);
            this.hide();
        }

        public function displayNewPage()
        {
var info:WiredTransactionInfo  = null;            var page= this._controller.page;
            if (page == null) { return; }
            this._loading.setVisible(this.loadingIcon, false);
            if (page.currentPage == this._pendingPage) { this._pendingPage = -1; }
            this.listTypeValue.text = this.loc(
                "wiredchests.logs.type." + Std.string(page.listType));
            this.idKey.text = this.loc(page.listType == WiredTransactionLogPage.LIST_CHEST
                ? "wiredchests.logs.chest_id" : "wiredchests.logs.room_id");
            this.idValue.text = Std.string(page.listId);
            var last= this.lastPage;
            Util.disableSection(this.firstButton, page.currentPage <= 1);
            Util.disableSection(this.previousButton, page.currentPage <= 1);
            Util.disableSection(this.nextButton, page.currentPage >= last);
            Util.disableSection(this.lastButton, page.currentPage >= last);
            var parts:Array<ASAny> = (cast this.loc("wiredchests.logs.bottom_text").split("%page%"));
            if (parts.length == 2)
            {
                this.pageTextStart.text = ASCompat.stringReplace(
ASCompat.toString(parts[0]),                     "%transaction_count%", page.totalLogs);
                this.pageTextEnd.text = ASCompat.stringReplace(
ASCompat.toString(parts[1]),                     "%page_count%", last);
                this.pageInput.text = Std.string(page.currentPage);
            }
            var rows= new Vector<ITableObject>();
            final _iter_ = page.logs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
info = _tmp_;
                rows.push(new TransactionTableObject(this._controller, info));
            }
            this._table.setObjects(rows, true);
            this._window.activate();
        }

        public function show()
        {
            if (this._window.parent == null)
            {
                this._controller.windowManager.getDesktop(1).addChild(this._window);
                this._window.center();
            }
        }

        public function hide()
        {
            if (this._window.parent != null)
            {
                this._controller.windowManager.getDesktop(1).removeChild(this._window);
            }
        }

        function onClose(event:WindowMouseEvent) { this.hide(); }
        function onFirst(event:WindowMouseEvent) { this.requestPage(1); }
        function onPrevious(event:WindowMouseEvent)
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage - 1);
            }
        }
        function onNext(event:WindowMouseEvent)
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage + 1);
            }
        }
        function onLast(event:WindowMouseEvent)
        {
            this.requestPage(this.lastPage);
        }
        function onRefresh(event:WindowMouseEvent)
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage);
            }
        }
        function onPageClickAway(event:WindowMouseEvent)
        {
            this.navigateToInputPage();
        }
        function onPageKeyDown(event:WindowKeyboardEvent)
        {
            if (event.keyCode == 13) { this.navigateToInputPage(); }
        }
        function navigateToInputPage()
        {
            if (this._controller.page == null) { return; }
            var page= Std.int(Math.max(1, Math.min(this.lastPage, ASCompat.toInt(this.pageInput.text))));
            this.pageInput.text = Std.string(page);
            if (page != this._controller.page.currentPage)
            {
                this.requestPage(page);
            }
        }
        function requestPage(page:Int)
        {
            if (this._controller.page == null || page < 1 || page > this.lastPage)
            {
                return;
            }
            var now= flash.Lib.getTimer();
            if ((this._lastRequest : UInt) > now - REQUEST_PAGE_RATE_LIMIT
                || (page == this._pendingPage
                    && (this._lastRequest : UInt) > now - SAME_PAGE_TIMEOUT))
            {
                return;
            }
            this._pendingPage = page;
            this._lastRequest = now;
            this._controller.requestPage(page);
            this._loading.setVisible(this.loadingIcon, true);
        }
        var lastPage(get,never):Int;
function  get_lastPage():Int
        {
            var total= this._controller.page == null
                ? 0 : this._controller.page.totalLogs;
            return Std.int(Math.max(1, Std.int(Math.max(total - 1, 0)
                / TransactionConfig.PAGE_SIZE) + 1));
        }
        function loc(key:String):String
        {
            return this._controller.localization.getLocalization(key, key);
        }

        var closeButton(get,never):IWindow;
function  get_closeButton():IWindow
        {
            return this._window.findChildByName("header_button_close");
        }
        var listTypeValue(get,never):ITextWindow;
function  get_listTypeValue():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("list_type_value") , ITextWindow);
        }
        var idKey(get,never):ITextWindow;
function  get_idKey():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("id_key") , ITextWindow);
        }
        var idValue(get,never):ITextWindow;
function  get_idValue():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("id_value") , ITextWindow);
        }
        var refreshButton(get,never):IButtonWindow;
function  get_refreshButton():IButtonWindow
        {
            return Std.downcast(this._window.findChildByName("refresh_btn") , IButtonWindow);
        }
        var loadingIcon(get,never):IIconWindow;
function  get_loadingIcon():IIconWindow
        {
            return Std.downcast(this._window.findChildByName("searching_icon") , IIconWindow);
        }
        var tableContainer(get,never):IWindowContainer;
function  get_tableContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("table_view") , IWindowContainer);
        }
        var firstButton(get,never):IWindow;
function  get_firstButton():IWindow
        {
            return this._window.findChildByName("first_page_btn");
        }
        var previousButton(get,never):IWindow;
function  get_previousButton():IWindow
        {
            return this._window.findChildByName("prev_page_btn");
        }
        var nextButton(get,never):IWindow;
function  get_nextButton():IWindow
        {
            return this._window.findChildByName("next_page_btn");
        }
        var lastButton(get,never):IWindow;
function  get_lastButton():IWindow
        {
            return this._window.findChildByName("last_page_btn");
        }
        var pageTextStart(get,never):ITextWindow;
function  get_pageTextStart():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("pagina_text_start") , ITextWindow);
        }
        var pageInput(get,never):ITextFieldWindow;
function  get_pageInput():ITextFieldWindow
        {
            return Std.downcast(this._window.findChildByName("pagina_number_input")
, ITextFieldWindow);
        }
        var pageTextEnd(get,never):ITextWindow;
function  get_pageTextEnd():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("pagina_text_end") , ITextWindow);
        }

        public function dispose()
        {
            if (this._disposed) { return; }
            this._loading.dispose();
            this._loading = null;
            this._table.dispose();
            this._table = null;
            this._window.dispose();
            this._window = null;
            this._controller = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

