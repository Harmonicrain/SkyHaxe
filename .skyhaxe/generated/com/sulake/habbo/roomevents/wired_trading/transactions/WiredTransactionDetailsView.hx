package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /** Exact July transaction-details presentation adapted to clean windows. */
     final class WiredTransactionDetailsView implements IDisposable
    {
        var _controller:WiredTransactionDetailsController;
        var _window:IFrameWindow;
        var _extraBubble:IWindowContainer;
        var _withdrawals:TransactionOverviewView;
        var _deposits:TransactionOverviewView;
        var _disposed:Bool = false;

        public function new(
            controller:WiredTransactionDetailsController)
        {
            this._controller = controller;
            this._window = Std.downcast(controller.roomEvents.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(
                controller.roomEvents.assets.getAssetByName(
                    "transaction_details_xml").content), 1) , IFrameWindow);
            this.closeButton.addEventListener("WME_CLICK", this.onClose);
            this.extraButton.addEventListener("WME_CLICK", this.onExtra);
            this._withdrawals = new TransactionOverviewView(
                Std.downcast(this._window.findChildByName("withdrawals_container")
, IWindowContainer));
            this._deposits = new TransactionOverviewView(
                Std.downcast(this._window.findChildByName("deposits_container")
, IWindowContainer));
            this._extraBubble = Std.downcast(this._window.findChildByName("extra_info_bubble")
, IWindowContainer);
            this._window.desktop.addChild(this._extraBubble);
            this._extraBubble.visible = false;
            this._extraBubble.addEventListener("WE_DEACTIVATED",
                this.onBubbleDeactivated);
            this.hide();
        }

        public function updateUI()
        {
            var details= this._controller.details;
            if (details == null) { return; }
            this.value("transaction_type").text = this.loc(
                "wired_transactions.type." + Std.string(details.info.transactionType));
            this.value("timestamp").text = details.info.readableTimestamp;
            this.value("room_id").text = Std.string(details.info.roomId);
            this.value("chest_ids").text = details.chestIds.join(", ");
            this.value("username").text = details.info.username;
            this.value("extra").text = details.info.transactionDefinitionInfo == ""
                ? "-" : details.info.transactionDefinitionInfo;
            this._withdrawals.initialize(details.info.withdrawCoinsCount,
                details.withdrawnFurnis, details.info.withdrawFurniCount,
                details.incompleteData);
            this._deposits.initialize(details.info.depositCoinsCount,
                details.depositedFurnis, details.info.depositFurniCount,
                details.incompleteData);
            this._extraBubble.visible = false;
            this._window.activate();
        }
        public function show()
        {
            if (this._window.parent == null)
            {
                this._controller.roomEvents.windowManager.getDesktop(1)
                    .addChild(this._window);
                this._window.center();
            }
        }
        public function hide()
        {
            if (this._window.parent != null)
            {
                this._controller.roomEvents.windowManager.getDesktop(1)
                    .removeChild(this._window);
            }
            this._extraBubble.visible = false;
            this._withdrawals.clear();
            this._deposits.clear();
        }
        function onClose(event:WindowMouseEvent) { this.hide(); }
        function onBubbleDeactivated(event:WindowEvent)
        {
            this._extraBubble.visible = false;
        }
        function onExtra(event:WindowMouseEvent)
        {
            var rectangle= new Rectangle();
            this.extraButton.getGlobalRectangle(rectangle);
            this._extraBubble.position = new Point(
                rectangle.x + rectangle.width + 3,
                rectangle.y + rectangle.height / 2 - this._extraBubble.height / 2);
            this._extraBubble.visible = true;
            this._extraBubble.activate();
        }
        function value(name:String):ITextWindow
        {
            var pair= Std.downcast(this._window.findChildByName(name + "_pair")
, IItemListWindow);
            return Std.downcast(pair.getListItemAt(1) , ITextWindow);
        }
        function loc(key:String):String
        {
            return this._controller.roomEvents.localization.getLocalization(key, key);
        }
        var closeButton(get,never):IWindow;
function  get_closeButton():IWindow
        {
            return this._window.findChildByName("header_button_close");
        }
        var extraButton(get,never):IRegionWindow;
function  get_extraButton():IRegionWindow
        {
            return Std.downcast(this._window.findChildByName("extra_info_button")
, IRegionWindow);
        }
        public function dispose()
        {
            if (this._disposed) { return; }
            this._extraBubble.dispose();
            this._extraBubble = null;
            this._withdrawals.dispose();
            this._deposits.dispose();
            this._withdrawals = null;
            this._deposits = null;
            this._window.dispose();
            this._window = null;
            this._controller = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

