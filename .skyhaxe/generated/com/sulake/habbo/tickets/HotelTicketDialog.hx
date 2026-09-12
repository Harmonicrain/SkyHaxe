package com.sulake.habbo.tickets
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.battleball.BattleBallAssets;
    import com.sulake.habbo.battleball.BattleBallLobbyWindow;
    import com.sulake.habbo.battleball.BattleBallTicketRenderer;
    import com.sulake.habbo.battleball.BattleBallViewEvent;
    import com.sulake.habbo.battleball.BattleBallViewServices;
    import com.sulake.habbo.battleball.BattleBallViewState;
    import com.sulake.habbo.battleball.BattleBallWindowHost;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.tickets.TicketBalanceEvent;
    import com.sulake.habbo.communication.messages.incoming.tickets.TicketMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.tickets.TicketPurchaseResultEvent;
    import com.sulake.habbo.communication.messages.outgoing.tickets.BuyTicketsComposer;
    import com.sulake.habbo.communication.messages.tickets.TicketProtocol;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    /** Neutral owner for the classic hotel-ticket shop shared by windowed games. */
     final class HotelTicketDialog extends EventDispatcher
    {
        var _communication:IHabboCommunicationManager;
        var _localization:IHabboLocalizationManager;
        var _assets:BattleBallAssets;
        var _host:BattleBallWindowHost;
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;
        var _renderer:BattleBallTicketRenderer;
        var _events:Array<ASAny> = [];
        var _ready:Bool = false;
        var _openPending:Bool = false;

        public function new(communication:IHabboCommunicationManager,
                                          windows:IHabboWindowManager,
                                          roomUI:IRoomUI,
                                          localization:IHabboLocalizationManager,
                                          assetBaseUrl:String,
                                          componentAssets:IAssetLibrary)
        {
            super();
            this._communication = communication;
            this._localization = localization;
            this._assets = new BattleBallAssets();
            this._assets.addEventListener(BattleBallAssets.READY, (this.onAssetsReady : ASAny));
            this._assets.load(assetBaseUrl);
            this._host = new BattleBallWindowHost(windows, roomUI);
            this._shell = new BattleBallLobbyWindow(windows, this._assets, componentAssets,
                this._host, this.text, this.noop, this.noop, this.arenaAbsent, this.noop);
            this._state = new BattleBallViewState();
            this._services = new BattleBallViewServices();
            this._services.emit = this.emit;
            this._services.text = this.text;
            this._renderer = new BattleBallTicketRenderer(this._shell, this._state, this._services);
            this.add(new TicketBalanceEvent(this.onTicketMessage));
            this.add(new TicketPurchaseResultEvent(this.onTicketMessage));
        }

        public function open(data:ASObject=null)
        {
            if (!this._ready) { this._openPending = true; return; }
            if (this._renderer != null) this._renderer.open();
        }

        function onAssetsReady(event:Event)
        {
            this._ready = true;
            if (this._openPending)
            {
                this._openPending = false;
                this.open();
            }
        }

        public function setBalance(value:Int)
        {
            if (this._state == null) return;
            var changed= this._state.ticketBalance != value;
            this._state.ticketBalance = value;
            if (this._renderer != null) this._renderer.refreshTicketBalance();
            if (changed) this.dispatchEvent(new Event(Event.CHANGE));
        }

        public var balance(get,never):Int;
public function  get_balance():Int
        {
            return this._state == null ? 0 : this._state.ticketBalance;
        }

        function onTicketMessage(event:IMessageEvent)
        {
            var parser= cast(event, TicketMessageEvent).getParser();
            var data:ASObject = parser.data;
            if (parser.header == TicketProtocol.BALANCE)
                this.setBalance(ASCompat.toInt(data.ticketBalance));
            else if (parser.header == TicketProtocol.PURCHASE_RESULT && this._renderer != null
                && this._renderer.purchasePending)
            {
                if (ASCompat.toInt(data.status) == 0)
                    this._renderer.finish(ASCompat.toString(data.recipient), ASCompat.toInt(data.ticketsAdded));
                else
                    this._renderer.showError(this.purchaseFailureText(ASCompat.toInt(data.status)));
            }
        }

        function emit(type:String, data:ASObject=null)
        {
            if (type != BattleBallViewEvent.BUY_TICKETS || data == null) return;
            this.send(new BuyTicketsComposer(ASCompat.toInt(data.bundleId), ASCompat.toString(data.recipient)));
        }

        function send(composer:IMessageComposer)
        {
            if (this._communication != null && this._communication.connection != null && composer != null)
                this._communication.connection.send(composer);
        }

        function purchaseFailureText(status:Int):String
        {
            if (status == 1) return this.text("bb_ticket_purchase_error_credits");
            if (status == 2) return this.text("bb_ticket_purchase_error_recipient");
            if (status == 3) return this.text("bb_ticket_purchase_error_bundle");
            return this.text("bb_ticket_purchase_error_generic");
        }

        function text(key:String):String
        {
            if (this._localization == null) return key;
            var value= this._localization.getLocalization(key);
            return value == null || value == "" ? key : value;
        }

        function add(event:IMessageEvent)
        {
            this._events.push(this._communication.addHabboConnectionMessageEvent(event));
        }

        function noop(args:Array<ASAny> = null) {if (args == null) args = [];
}
        function arenaAbsent():Bool { return false; }

        public function dispose()
        {
var event:IMessageEvent  = null;            final _iter_ = this._events; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                this._communication.removeHabboConnectionMessageEvent(event);
};
            this._events = [];
            if (this._renderer != null) { this._renderer.dispose(); this._renderer = null; }
            if (this._shell != null) { this._shell.dispose(); this._shell = null; }
            if (this._host != null) { this._host.dispose(); this._host = null; }
            if (this._assets != null)
            {
                this._assets.removeEventListener(BattleBallAssets.READY, (this.onAssetsReady : ASAny));
                this._assets.dispose(); this._assets = null;
            }
            this._services = null; this._state = null;
            this._communication = null; this._localization = null;
        }
    }

