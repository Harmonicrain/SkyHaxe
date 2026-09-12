package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestCoinBalanceMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawChestCoinsMessageComposer;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;

     class CoinChestSubController extends AbstractChestSubController
    {
        public static final DARK_THEME_CHEST_NAMES:Array<ASAny> = ["wf_storage_coins1"];
        var _view:IWindowContainer;
        var _coins:Int = 0;
        var _chestState:String = "zero";
        var _theme:String = "light";
        var _classNameCache:String;

        public function new(parent:WiredChestController)
        {
            super(parent);
            this._view = Std.downcast(roomEvents.getXmlWindow("coins_chest_contents") , IWindowContainer);
            if (this._view != null && this._view.parent != null)
            {
                this._view.parent = null;
            }
            this.addMessageEvent(new ChestCoinBalanceMessageEvent(this.onCoinsMessage));
            this.withdrawInput.restrict = "0-9";
            this.withdrawButton.addEventListener("WME_CLICK", this.onWithdrawClick);
        }
        function onWithdrawClick(event:WindowMouseEvent)
        {
            var amount:Float = ASCompat.parseInt(this.withdrawInput.text);
            if (!Math.isNaN(amount) && amount > 0)
            {
                parentController.send(new WithdrawChestCoinsMessageComposer(
                    viewingChestId, Std.int(amount)));
            }
        }
        function onCoinsMessage(event:ChestCoinBalanceMessageEvent)
        {
            var parser= event.getParser();
            if (parser.isUpdate)
            {
                if (parentController.activeChestId != parser.chestId) { return; }
            }
            else
            {
                if (parentController.requestedChestId != parser.chestId) { return; }
                this._classNameCache = null;
                parentController.setOpenStatus(parser.chestId, this);
            }
            this._coins = Std.int(Math.max(0, parser.coins));
            this.coinAmountText.text = Std.string(this._coins);
            this.balanceContainer.x = Std.int((this.balanceContainer.parent.width
                - this.balanceContainer.width) / 2);
            this._chestState = this._coins >= 100 ? "high"
                : this._coins >= 20 ? "medium" : this._coins >= 1 ? "low" : "zero";
            this.backgroundImage.assetUri = "wired_chests_images_" + this._theme
                + "_coins_chest_balance_" + this._chestState;
            wrapperView.updateUI();
        }
        override public function  get_type():Int { return ChestType.COINS; }
        override public function  get_title():String { return localize("wiredchests.coin_chest"); }
        override public function  get_view():IWindowContainer { return this._view; }
        override public function  get_isEmpty():Bool { return this._coins <= 0; }
        override public function  get_itemCount():Int { return this._coins; }
        override public function clear() { this._coins = 0; }
        override public function updateUI()
        {
            Util.disableSection(this.withdrawButton, !canWithdraw || isEmpty);
            this._theme = DARK_THEME_CHEST_NAMES.indexOf(this.className) >= 0 ? "dark" : "light";
            this.backgroundImage.assetUri = "wired_chests_images_" + this._theme
                + "_coins_chest_balance_" + this._chestState;
        }
        public var className(get,never):String;
public function  get_className():String
        {
            if (this._classNameCache != null) { return this._classNameCache; }
            if (wrapperView.viewingChestFurni == null) { return ""; }
            var typeId= Std.int(wrapperView.viewingChestFurni.getModel()
                .getNumber("furniture_type_id"));
            var data= parentController.sessionDataManager
                .getFloorItemData(typeId);
            this._classNameCache = data == null ? "" : data.className;
            return this._classNameCache;
        }
        override public function  get_allowResizing():Bool { return false; }
        override public function dispose()
        {
            if (disposed) { return; }
            if (this._view != null) { this._view.dispose(); }
            this._view = null;
            super.dispose();
        }
        var coinAmountText(get,never):ITextWindow;
function  get_coinAmountText():ITextWindow
        {
            return Std.downcast(this._view.findChildByName("coins_amount_txt") , ITextWindow);
        }
        var balanceContainer(get,never):IItemListWindow;
function  get_balanceContainer():IItemListWindow
        {
            return Std.downcast(this._view.findChildByName("balance_container") , IItemListWindow);
        }
        var backgroundImage(get,never):IStaticBitmapWrapperWindow;
function  get_backgroundImage():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._view.findChildByName("bg_img") , IStaticBitmapWrapperWindow);
        }
        var withdrawInput(get,never):ITextFieldWindow;
function  get_withdrawInput():ITextFieldWindow
        {
            return Std.downcast(this._view.findChildByName("withdraw_input") , ITextFieldWindow);
        }
        var withdrawButton(get,never):IButtonWindow;
function  get_withdrawButton():IButtonWindow
        {
            return Std.downcast(this._view.findChildByName("withdraw_btn") , IButtonWindow);
        }
    }

