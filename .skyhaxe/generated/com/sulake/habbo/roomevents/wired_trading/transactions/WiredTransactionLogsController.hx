package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogsMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestChestTransactionLogsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestRoomTransactionLogsMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;

    /** Owns July's full 25-row transaction-log window. */
     final class WiredTransactionLogsController implements IDisposable
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Vector<IMessageEvent>;
        var _page:WiredTransactionLogPage;
        var _view:WiredTransactionLogsView;
        var _disposed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector<IMessageEvent>();
            this.addMessageEvent(new WiredTransactionLogsMessageEvent(this.onLogs));
        }

        function onLogs(event:WiredTransactionLogsMessageEvent)
        {
            var page= event.getParser().page;
            if (page == null || page.amount != TransactionConfig.PAGE_SIZE)
            {
                return;
            }
            this._page = page;
            if (this._view == null)
            {
                this._view = new WiredTransactionLogsView(this);
            }
            this._view.displayNewPage();
            this._view.show();
        }

        public function openRoomLogs()
        {
            this.send(new RequestRoomTransactionLogsMessageComposer(
                TransactionConfig.PAGE_SIZE, TransactionConfig.FIRST_PAGE));
        }

        public function openChestLogs(chestId:Int)
        {
            if (chestId > 0)
            {
                this.send(new RequestChestTransactionLogsMessageComposer(
                    chestId, TransactionConfig.PAGE_SIZE,
                    TransactionConfig.FIRST_PAGE));
            }
        }

        public function requestPage(page:Int)
        {
            if (this._page == null) { return; }
            if (this._page.listType == WiredTransactionLogPage.LIST_CHEST)
            {
                this.send(new RequestChestTransactionLogsMessageComposer(
                    Std.int(this._page.listId), TransactionConfig.PAGE_SIZE, page));
            }
            else
            {
                this.send(new RequestRoomTransactionLogsMessageComposer(
                    TransactionConfig.PAGE_SIZE, page));
            }
        }

        public function send(composer:IMessageComposer)
        {
            this._roomEvents.send(composer);
        }

        function addMessageEvent(event:IMessageEvent)
        {
            this._messageEvents.push(event);
            this._roomEvents.communication.addHabboConnectionMessageEvent(event);
        }

        public function resetRoom()
        {
            this._page = null;
            if (this._view != null) { this._view.hide(); }
        }

        public var page(get,never):WiredTransactionLogPage;
public function  get_page():WiredTransactionLogPage { return this._page; }
        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }
        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._roomEvents.windowManager;
        }
        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._roomEvents.sessionDataManager;
        }
        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed) { return; }
            if (this._view != null) { this._view.dispose(); this._view = null; }
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
event = _tmp_;
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            }
            this._messageEvents = null;
            this._page = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

