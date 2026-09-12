package com.sulake.habbo.roomevents.wired_trading.chests.upgrade_confirmation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestUpgradeResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.UpgradeChestMessageComposer;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;

     class WiredChestUpgradeConfirmationView implements IDisposable implements  IGetImageListener
    {
        var _disposed:Bool = false;
        var _window:IWindowContainer;
        var _controller:WiredChestController;
        var _windowManager:IHabboWindowManager;
        var _resultEvent:ChestUpgradeResultMessageEvent;
        var _chestId:Int = 0;
        var _chestType:Int = 0;
        var _chestItemType:Int = 0;
        var _capacityLevel:Int = 0;

        public function new(controller:WiredChestController)
        {
            this._controller = controller;
            this._windowManager = controller.windowManager;
            this._window = Std.downcast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(
                controller.assets.getAssetByName("chest_upgrade_xml").content), 1)
, IWindowContainer);
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.cancelButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.buyButton.addEventListener("WME_CLICK", this.onBuyClicked);
            this.amountSelection.addEventListener("WE_SELECTED", this.onAmountSelected);
            this._resultEvent = new ChestUpgradeResultMessageEvent(this.onUpgradeResult);
            controller.addMessageEvent(this._resultEvent);
        }
        function onUpgradeResult(event:ChestUpgradeResultMessageEvent)
        {
var reason:String  = null;            if (event.getParser().chestId != this._chestId) { return; }
            var code= event.getParser().resultCode;
            if (code == 0)
            {
                this._controller.roomEvents.notifications.addItem(
                    "${wiredchests.upgrade.result.success}", "info");
            }
            else
            {
reason= this._controller.localization.getLocalization(
                    "wiredchests.upgrade.result.error." + Std.string(code));
                this._controller.roomEvents.notifications.addItem(
                    this._controller.localization.getLocalizationWithParams(
                        "wiredchests.upgrade.result.error", "", ["reason", reason]), "info");
            }
            this.hide();
        }
        function onBuyClicked(event:WindowMouseEvent)
        {
            this.buyButton.disable();
            this._controller.send(new UpgradeChestMessageComposer(
                this._chestId, this.amountSelection.selection + 1));
        }
        public function initialize(chestId:Int, chestType:Int, chestItemType:Int,
            capacityLevel:Int)
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._capacityLevel = capacityLevel;
            this.initializeDropMenu();
            this.updateUI();
        }
        function initializeDropMenu()
        {
            var kind= this._chestType == ChestType.COINS ? "coins" : "furni";
            var maxUpgrades= this._controller.getInteger(
                "wired." + kind + "_chest.max_upgrades", 0);
            var values:Array<ASAny> = ["1"];
            var levels= 2;
            var nextLevel= this._capacityLevel + 2;
            while (nextLevel <= maxUpgrades)
            {
                values.push(Std.string(levels++));
                nextLevel++;
            }
            this.amountSelection.populate(values);
            this.amountSelection.selection = 0;
            Util.disableSection(this.amountSelection, this._capacityLevel >= maxUpgrades);
        }
        function onAmountSelected(event:WindowEvent) { this.updateUI(); }
        function updateUI()
        {
            var levels= this.amountSelection.selection + 1;
            this.buyButton.enable();
            this.cancelButton.enable();
            var image= this._controller.roomEngine.getFurnitureImage(
                this._chestItemType, new Vector3d(90, 0, 0), 64, this);
            if (image.data != null) { this.showChestPreview(image.data); }
            var kind= this._chestType == ChestType.COINS ? "coins" : "furni";
            var initial= this._controller.getInteger(
                "wired." + kind + "_chest.initial_capacity", 0);
            var increment= this._controller.getInteger(
                "wired." + kind + "_chest.upgrade_capacity", 0);
            var maxUpgrades= this._controller.getInteger(
                "wired." + kind + "_chest.max_upgrades", 0);
            var creditCost= this._controller.getInteger(
                "wired.chests.upgrade_cost_credits", 999);
            var diamondCost= this._controller.getInteger(
                "wired.chests.upgrade_cost_diamonds", 999);
            var errorKey:String = null;
            var purse:IPurse = this._controller.catalog == null
                ? null : this._controller.catalog.getPurse();
            if (this._capacityLevel >= maxUpgrades)
            {
                errorKey = "wiredchests.upgrade.error.reason.at_capacity";
            }
            else if (purse != null && (purse.credits < creditCost * levels
                || purse.getActivityPointsForType(5) < diamondCost * levels))
            {
                errorKey = "wiredchests.upgrade.error.reason.not_enough_currency";
            }
            var current= initial + this._capacityLevel * increment;
            var extra= increment * levels;
            this.productNameText.text = this._controller.localization.getLocalizationWithParams(
                "wiredchests.upgrade.capacity.extra", "", ["purchase_capacity", extra]);
            this.currentCapacityText.text =
                this._controller.localization.getLocalizationWithParams(
                    "wiredchests.upgrade.capacity.current", "", ["current_capacity", current]);
            this.newCapacityText.text = this._controller.localization.getLocalizationWithParams(
                "wiredchests.upgrade.capacity.new", "", ["new_capacity", current + extra]);
            this.priceCreditsText.text = Std.string(creditCost * levels);
            this.priceDiamondsText.text = Std.string(diamondCost * levels);
            this.priceCreditsText.visible = creditCost != 0;
            this.priceDiamondsText.visible = diamondCost != 0;
            this.pricePlusText.visible = creditCost != 0 && diamondCost != 0;
            this.errorText.visible = errorKey != null;
            if (errorKey != null)
            {
                this.buyButton.disable();
                this.errorText.text = this._controller.localization.getLocalizationWithParams(
                    "wiredchests.upgrade.error", "", ["reason",
                    this._controller.localization.getLocalization(errorKey)]);
            }
        }
        function showChestPreview(bitmap:BitmapData)
        {
            this.productImage.bitmap = bitmap;
        }
        public function show()
        {
var desktop:IDesktopWindow  = null;            if (this._window.parent == null)
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._window); }
            }
            this._window.center();
            this._window.activate();
        }
        function hide()
        {
var desktop:IDesktopWindow  = null;            if (this._window != null && this._window.parent != null)
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._window); }
            }
        }
        function onWindowClose(event:WindowEvent)
        {
            if (event.type == "WME_CLICK") { this.hide(); }
        }
        public function imageReady(id:Int, bitmap:BitmapData) { this.showChestPreview(bitmap); }
        public function imageFailed(id:Int) { this.showChestPreview(null); }
        public function dispose()
        {
            if (this._disposed) { return; }
            if (!this._controller.disposed)
            {
                this._controller.removeMessageEvent(this._resultEvent);
            }
            this._resultEvent.dispose();
            this.hide();
            this._window.dispose();
            this._window = null;
            this._windowManager = null;
            this._controller = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var closeButton(get,never):IWindow;
function  get_closeButton():IWindow
        { return this._window.findChildByName("header_button_close"); }
        var productImage(get,never):IBitmapWrapperWindow;
function  get_productImage():IBitmapWrapperWindow
        { return Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow); }
        var productNameText(get,never):ITextWindow;
function  get_productNameText():ITextWindow
        { return Std.downcast(this._window.findChildByName("product_name") , ITextWindow); }
        var currentCapacityText(get,never):ITextWindow;
function  get_currentCapacityText():ITextWindow
        { return Std.downcast(this._window.findChildByName("current_capacity") , ITextWindow); }
        var newCapacityText(get,never):ITextWindow;
function  get_newCapacityText():ITextWindow
        { return Std.downcast(this._window.findChildByName("new_capacity") , ITextWindow); }
        var amountSelection(get,never):IDropMenuWindow;
function  get_amountSelection():IDropMenuWindow
        { return Std.downcast(this._window.findChildByName("amount_selection_dropmenu") , IDropMenuWindow); }
        var priceCreditsText(get,never):ITextWindow;
function  get_priceCreditsText():ITextWindow
        { return Std.downcast(this._window.findChildByName("price_credits") , ITextWindow); }
        var pricePlusText(get,never):ITextWindow;
function  get_pricePlusText():ITextWindow
        { return Std.downcast(this._window.findChildByName("plus") , ITextWindow); }
        var priceDiamondsText(get,never):ITextWindow;
function  get_priceDiamondsText():ITextWindow
        { return Std.downcast(this._window.findChildByName("price_diamonds") , ITextWindow); }
        var errorText(get,never):ITextWindow;
function  get_errorText():ITextWindow
        { return Std.downcast(this._window.findChildByName("error_text") , ITextWindow); }
        var cancelButton(get,never):IButtonWindow;
function  get_cancelButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("cancel_button") , IButtonWindow); }
        var buyButton(get,never):IButtonWindow;
function  get_buyButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("buy_button") , IButtonWindow); }
    }

