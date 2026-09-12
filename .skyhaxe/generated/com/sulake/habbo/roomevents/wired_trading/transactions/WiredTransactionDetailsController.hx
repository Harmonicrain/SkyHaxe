package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetails;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetailsMessageEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /** Owns July's retained transaction-details response and window. */
     final class WiredTransactionDetailsController implements IDisposable
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Vector<IMessageEvent>;
        var _details:WiredTransactionDetails;
        var _view:WiredTransactionDetailsView;
        var _disposed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector<IMessageEvent>();
            var event:IMessageEvent =
                new WiredTransactionDetailsMessageEvent(this.onDetails);
            this._messageEvents.push(event);
            roomEvents.communication.addHabboConnectionMessageEvent(event);
        }

        function onDetails(event:WiredTransactionDetailsMessageEvent)
        {
            this._details = event.getParser().details;
            if (this._details == null) { return; }
            if (this._view == null)
            {
                this._view = new WiredTransactionDetailsView(this);
            }
            this._view.updateUI();
            this._view.show();
        }

        public function resetRoom()
        {
            this._details = null;
            if (this._view != null) { this._view.hide(); }
        }

        public var details(get,never):WiredTransactionDetails;
public function  get_details():WiredTransactionDetails { return this._details; }
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
            this._details = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

