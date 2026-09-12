package com.sulake.habbo.battleball
;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.utils.HabboWebTools;

    /**
     * The ticket shop: the original two bundles, optional gifting, and the purchase result.
     *
     * It draws through its own shell instance, so moving the dialog never changes the lobby or final
     * standings position. The authoritative balance and cost live in BattleBallViewState -- this reads
     * them, it never writes them.
     */
     class BattleBallTicketRenderer
    {
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;

        var _ticketBundle:Int = 1;
        var _ticketRecipient:String = "";
        var _ticketMessage:String = "";
        var _ticketMessageSuccess:Bool = false;
        var _ticketPurchasePending:Bool = false;

        public function new(shell:BattleBallLobbyWindow, state:BattleBallViewState,
                                                 services:BattleBallViewServices)
        {
            this._shell = shell;
            this._state = state;
            this._services = services;
        }

        public function dispose()
        {
            this._ticketPurchasePending = false;
            this._shell = null; this._state = null; this._services = null;
        }

        public var purchasePending(get,never):Bool;
public function  get_purchasePending():Bool
        {
            return this._ticketPurchasePending;
        }

        public function open(data:ASObject=null)
        {
            this._ticketPurchasePending = false;
            this._ticketMessage = "";
            this._ticketMessageSuccess = false;
            // Centre only when the shop is first opened. Subsequent bundle selections and purchase
            // responses rebuild the contents in place and must retain the player's chosen position.
            this._shell.centerNext = true;
            this._shell.moved = false;
            try
            {
                this.render();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                HabboWebTools.airDebug("[BattleBall UI] ticket window failed to open: " + error.message);
                return;
            }
 }        }
        /** The authored native ticket window, using the original two bundles and optional gifting. */
        public function render()
        {
            this._shell.clearBindings();
            this._shell.bindText("ticket_title", this._services.text("bb_ticket_title"));
            this._shell.bindText("ticket_balance", this._services.text("bb_ticket_balance")
                .replace("%count%", this._state.ticketBalance));
            this._shell.bindText("ticket_choose", this._services.text("bb_ticket_choose_bundle"));
            this._shell.bindText("ticket_bundle_1_title", this._services.text("bb_ticket_bundle_small"));
            this._shell.bindText("ticket_bundle_1_price", this._services.text("bb_ticket_bundle_small_price"));
            this._shell.bindText("ticket_bundle_2_title", this._services.text("bb_ticket_bundle_large"));
            this._shell.bindText("ticket_bundle_2_price", this._services.text("bb_ticket_bundle_large_price"));
            this._shell.bindAction("ticket_bundle_1", this.selectTicketBundle, 1);
            this._shell.bindAction("ticket_bundle_2", this.selectTicketBundle, 2);
            this._shell.bindText("ticket_gift_prompt", this._services.text("bb_ticket_gift_prompt"));
            this._shell.bindInput("ticket_recipient", this._ticketRecipient, this.onTicketRecipientChange);
            this._shell.bindText("ticket_message", this._ticketMessage);
            this._shell.bindText("ticket_buy", this._services.text("generic.buy"));
            this._shell.bindAction("ticket_buy", this.submitTicketPurchase);
            this._shell.bindText("ticket_cancel", this._services.text("gs_button_cancel"));
            this._shell.bindAction("ticket_cancel", this.closeTicketPurchase);
            if (!this._shell.renderXmlWindow("bb_tickets_xml", true)) return;

            this.formatTicketBundle(1, this._ticketBundle == 1);
            this.formatTicketBundle(2, this._ticketBundle == 2);
            var message= Std.downcast(this._shell.xmlWindow("ticket_message") , ITextWindow);
            if (message != null)
                this._shell.chrome.formatText(message, this._ticketMessage,
                    this._ticketMessageSuccess ? 0x1F6B2C : 0xA32620, true, "left");
            this._shell.window.visible = true; this._shell.window.activate();
        }

        /** Keeps an open shop in sync with a balance push without rebuilding its input controls. */
        public function refreshTicketBalance()
        {
            if (this._shell == null || this._state == null || this._services == null) return;
            var balance= Std.downcast(this._shell.xmlWindow("ticket_balance") , ITextWindow);
            if (balance != null)
                balance.caption = this._services.text("bb_ticket_balance")
                    .replace("%count%", this._state.ticketBalance);
        }

        function formatTicketBundle(bundleId:Int, selected:Bool)
        {
            var prefix= "ticket_bundle_" + Std.string(bundleId);
            this._shell.chrome.assignBitmap(Std.downcast(this._shell.xmlWindow(prefix + "_bg") , IBitmapWrapperWindow),
                selected ? "bb_clr_px" : "bb_bg_px");
            this._shell.chrome.assignBitmap(Std.downcast(this._shell.xmlWindow(prefix + "_radio") , IBitmapWrapperWindow),
                selected ? "button_radio_on" : "button_radio_off");
            this._shell.chrome.formatText(Std.downcast(this._shell.xmlWindow(prefix + "_title") , ITextWindow),
                this._services.text(bundleId == 1 ? "bb_ticket_bundle_small" : "bb_ticket_bundle_large"),
                selected ? 0xD3D3D3 : 0x1E2A2B, true, "left");
            this._shell.chrome.formatText(Std.downcast(this._shell.xmlWindow(prefix + "_price") , ITextWindow),
                this._services.text(bundleId == 1 ? "bb_ticket_bundle_small_price" : "bb_ticket_bundle_large_price"),
                selected ? 0xBFC9CA : 0x53656A, false, "right");
        }
        function onTicketRecipientChange(event:WindowEvent)
        {
            var input:ITextFieldWindow = event == null ? null : Std.downcast(event.window , ITextFieldWindow);
            if (input != null) this._ticketRecipient = input.text;
        }
        function selectTicketBundle(value:ASObject)
        {
            this._ticketBundle = ASCompat.toInt(value) == 2 ? 2 : 1;
            this.render();
        }
        function submitTicketPurchase(data:ASObject=null)
        {
            if (this._ticketPurchasePending) return;
            this._ticketPurchasePending = true;
            this._ticketMessage = this._services.text("bb_ticket_purchasing");
            this._ticketMessageSuccess = false;
            this.render();
            var buy= this._shell.xmlWindow("ticket_buy");
            var cancel= this._shell.xmlWindow("ticket_cancel");
            if (buy != null) buy.disable();
            if (cancel != null) cancel.disable();
            this._services.emit(BattleBallViewEvent.BUY_TICKETS,
                {bundleId:this._ticketBundle, recipient:this._ticketRecipient});
        }
        function closeTicketPurchase(data:ASObject=null)
        {
            this._ticketPurchasePending = false;
            this._shell.hide();
            this._ticketMessage = "";
            this._ticketMessageSuccess = false;
            this._services.emit(BattleBallViewEvent.REDRAW);
        }
        /** Shockwave displays the lobby balance as a fixed-width, three-digit counter (for example 002). */
        public function showError(message:String)
        {
            this.completePurchase();
            this._ticketMessage = message;
            this._ticketMessageSuccess = false;
            this.render();
        }
        public function finish(recipient:String, ticketsAdded:Int)
        {
            this.completePurchase();
            this._ticketMessage = this._services.text("bb_ticket_purchase_success")
                .replace("%count%", ticketsAdded).replace("%recipient%", recipient);
            this._ticketMessageSuccess = true;
            this.render();
        }

        function completePurchase()
        {
            this._ticketPurchasePending = false;
        }

    }

