package com.sulake.habbo.inventory.wired_trading
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.inventory.ItemPopupCtrl;
    import com.sulake.habbo.inventory.items.CreditTradingItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

     class WiredTradingView implements IInventoryView implements  IGetImageListener
    {
        var _model:WiredTradingModel;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _roomEngine:IRoomEngine;
        var _assets:IAssetLibrary;
        var _popup:ItemPopupCtrl;
        var _confirmTimer:Timer;
        var _secondsTimer:Timer;
        var _window:IWindowContainer;
        var _disposed:Bool = false;

        public function new(
            model:WiredTradingModel,
            windowManager:IHabboWindowManager,
            assets:IAssetLibrary,
            roomEngine:IRoomEngine,
            localization:IHabboLocalizationManager,
            soundManager:IHabboSoundManager)
        {
            this._model = model;
            this._windowManager = windowManager;
            this._assets = assets;
            this._roomEngine = roomEngine;
            this._localization = localization;

            var popupWindow= Std.downcast(windowManager.buildFromXML(
                (cast(assets.getAssetByName("item_popup_xml"), XmlAsset).content : com.sulake.core.utils.xml.XML) )
, IWindowContainer);
            popupWindow.visible = false;
            this._popup = new ItemPopupCtrl(
                popupWindow, assets, windowManager, model);
            this.createWindow();
        }

        function createWindow()
        {
            var xml= (cast(
                this._assets.getAssetByName("inventory_trading_wired_xml"), XmlAsset).content : com.sulake.core.utils.xml.XML)
;
            this._window = Std.downcast(this._windowManager.buildFromXML(xml)
, IWindowContainer);
            this.prepareGrid(this.yourItemGrid, this.ownThumbEventProc);
            this.prepareGrid(this.wiredItemGrid, this.wiredThumbEventProc);
            this.acceptButton.addEventListener(
                WindowMouseEvent.CLICK, this.onAcceptClick);
            this.cancelButton.addEventListener(
                WindowMouseEvent.CLICK, this.onCancelClick);
            this.secondsLeftText.visible = false;
        }

        function prepareGrid(grid:IItemGridWindow, handler:ASFunction)
        {
var             i = 0, item:IWindow  = null;            i= 0;while ((i : UInt) < grid.numGridItems)
            {
item= grid.getGridItemAt(i);
                item.id = i;
                item.procedure = handler;
                item.addEventListener(WindowMouseEvent.OVER, handler);
                item.addEventListener(WindowMouseEvent.OUT, handler);
i++;
            }
        }

        function onCancelClick(event:WindowMouseEvent)
        {
            this._model.requestCancelTrading();
        }

        function onAcceptClick(event:WindowMouseEvent)
        {
            if (this._model.state == WiredTradingModel.STATE_ADDING_ITEMS)
            {
                if (this._model.requestAccept())
                {
                    this.startConfirmCountdown();
                }
            }
            else if (this._model.state == WiredTradingModel.STATE_CONFIRMING)
            {
                this._model.requestConfirm();
            }
        }

        public function updateAllUI()
        {
            if (this._window == null)
            {
                return;
            }
            this.updateUI();
            this.updateItemsGrid(this.yourItemGrid, this._model.ownItems);
            this.updateItemsGrid(this.wiredItemGrid, this._model.wiredItems);
            this.updateStateUI();
            this.updateOfferInfoUI();
        }

        function updateUI()
        {
            if (this._model.canAccept)
            {
                this.acceptButton.enable();
            }
            else
            {
                this.acceptButton.disable();
            }
            var payment= this._model.isPayment();
            this.tradeTypeSplitter.assetUri = payment
                ? "inventory_trading_trading_arrow_icon"
                : "inventory_trading_trading_split_icon";
            if (payment && this._model.paymentLayoutType != null)
            {
                this.paymentLayoutImage.assetUri = "wired_chests_images_"
                    + this._model.paymentLayoutType + "_payments";
            }
            this.wiredOfferings.visible = !payment;
            this.wiredPaymentPlaceholder.visible = payment;
        }

        public function tradeStateUpdated()
        {
            if (this._window != null)
            {
                this.updateStateUI();
            }
        }

        function updateStateUI()
        {
            var type= this._model.tradeTypeLocalization.toLowerCase();
            this.lockIcon.assetUri =
                this._model.state == WiredTradingModel.STATE_READY
                || this._model.state == WiredTradingModel.STATE_ADDING_ITEMS
                    ? "inventory_trading_trading_unlocked_icon"
                    : "inventory_trading_trading_locked_icon";

            if (this._model.state == WiredTradingModel.STATE_READY
                || this._model.state == WiredTradingModel.STATE_ADDING_ITEMS)
            {
                this.infoText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.note.add_items", "",
                        ["type", type]);
                this.acceptButton.caption =
                    this._localization.getLocalization("inventory.trading.accept");
            }
            else if (this._model.state == WiredTradingModel.STATE_COUNTDOWN)
            {
                this.infoText.text = this._localization.getLocalization(
                    "inventory.wired_trading.note.countdown");
                this.acceptButton.caption = "${inventory.trading.countdown}";
                this.acceptButton.disable();
            }
            else
            {
                this.infoText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.note.verify", "",
                        ["type", type]);
                this.acceptButton.caption =
                    this._localization.getLocalization("inventory.trading.confirm");
                if (this._model.state == WiredTradingModel.STATE_CONFIRMED)
                {
                    this.acceptButton.disable();
                }
                else
                {
                    this.acceptButton.enable();
                }
            }
        }

        public function startConfirmCountdown()
        {
            if (this._confirmTimer == null)
            {
                this._confirmTimer = new Timer(1000, 3);
                this._confirmTimer.addEventListener(
                    TimerEvent.TIMER, (this.onConfirmTimer : ASAny));
            }
            this._confirmTimer.reset();
            this._confirmTimer.repeatCount = 3;
            this._confirmTimer.start();
            this._windowManager.registerLocalizationParameter(
                "inventory.trading.countdown", "counter", "3");
        }

        function onConfirmTimer(event:TimerEvent)
        {
            this._windowManager.registerLocalizationParameter(
                "inventory.trading.countdown", "counter",
                Std.string(3 - this._confirmTimer.currentCount));
            if (this._confirmTimer.currentCount == 3)
            {
                this._model.confirmCountdownReady();
                this._confirmTimer.reset();
                this.acceptButton.enable();
            }
        }

        public function stopConfirmCountdown()
        {
            if (this._confirmTimer != null)
            {
                this._confirmTimer.stop();
                this._confirmTimer.reset();
            }
        }

        public function startSecondsLeftTimer()
        {
            if (this._secondsTimer == null)
            {
                this._secondsTimer = new Timer(1000);
                this._secondsTimer.addEventListener(
                    TimerEvent.TIMER, (this.onSecondsTimer : ASAny));
            }
            this._secondsTimer.reset();
            this._secondsTimer.start();
            this.updateSecondsLeftUI();
        }

        public function stopSecondsLeftTimer()
        {
            if (this._secondsTimer != null)
            {
                this._secondsTimer.stop();
            }
        }

        function onSecondsTimer(event:TimerEvent)
        {
            this.updateSecondsLeftUI();
            if (this._model.secondsLeft <= 0)
            {
                this.stopSecondsLeftTimer();
            }
        }

        function updateSecondsLeftUI()
        {
var minutes = 0, seconds = 0;            var left= this._model.secondsLeft;
            if (left >= 0 && left < 120)
            {
                this.secondsLeftText.visible = true;
minutes= Std.int(left / 60);
seconds= left - minutes * 60;
                this.secondsLeftText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.seconds_left", "",
                        ["seconds", seconds < 10 ? "0" + Std.string(seconds) : Std.string(seconds),
                        "minutes", minutes]);
            }
            else
            {
                this.secondsLeftText.visible = false;
            }
        }

        function updateItemsGrid(grid:IItemGridWindow, items:Map)
        {
var group:GroupItem  = null;            var i= 0;
            var cell:IWindowContainer = null;
            if (items != null)
            {
                while ((i : UInt) < items.length && (i : UInt) < grid.numGridItems)
                {
group= ASCompat.dynamicAs(items.getWithIndex(i) , GroupItem);
                    cell =
                        Std.downcast(grid.getGridItemAt(i) , IWindowContainer);
                    this.clearCell(cell);
                    if (group != null)
                    {
                        cell.addChild(group.window);
                        group.window.id = i;
                        group._Str_24322();
                    }
                    i++;
                }
            }
            while ((i : UInt) < grid.numGridItems)
            {
                cell = Std.downcast(grid.getGridItemAt(i) , IWindowContainer);
                this.clearCell(cell);
                cell.invalidate();
                i++;
            }
        }

        function clearCell(cell:IWindowContainer)
        {
            if (cell == null)
            {
                return;
            }
            while (cell.numChildren > 0)
            {
                cell.removeChildAt(0);
            }
        }

        function updateOfferInfoUI()
        {
            this.yourItemCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.itemcount", "",
                    ["value", this._model.ownNumItems]);
            this.wiredItemCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.itemcount", "",
                    ["value", this._model.wiredNumItems]);
            this.yourCreditCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.creditvalue", "",
                    ["value", this._model.ownNumCredits]);
            this.wiredCreditCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.creditvalue", "",
                    ["value", this._model.wiredNumCredits]);
        }

        function ownThumbEventProc(
            event:WindowEvent, window:IWindow)
        {
            this.thumbEventProc(event, window, true);
        }

        function wiredThumbEventProc(
            event:WindowEvent, window:IWindow)
        {
            this.thumbEventProc(event, window, false);
        }

        function thumbEventProc(
            event:WindowEvent, window:IWindow, own:Bool)
        {
            if (own && event.type == WindowMouseEvent.CLICK)
            {
                this._model.requestRemoveItemFromTrading(window.id);
            }
            if (event.type == WindowMouseEvent.OUT)
            {
                this._popup._Str_14093();
                return;
            }
            if (event.type != WindowMouseEvent.OVER)
            {
                return;
            }
            var items= own ? this._model.ownItems : this._model.wiredItems;
            if (items == null || window.id < 0 || (window.id : UInt) >= items.length)
            {
                return;
            }
            var group= ASCompat.dynamicAs(items.getWithIndex(window.id) , GroupItem);
            if (group == null)
            {
                return;
            }
            var credits= Std.downcast(group , CreditTradingItem);
            if (credits != null)
            {
                this._popup.updateContent(
                    Std.downcast(window , IWindowContainer),
                    credits._Str_22574(), credits._Str_21010());
                this._popup.show();
                return;
            }
            var item= group._Str_3205();
            if (item == null)
            {
                return;
            }
            var title= item.isWallItem
                ? "${wallItem.name." + Std.string(item.type) + "}"
                : "${roomItem.name." + Std.string(item.type) + "}";
            if (item.category == 6)
            {
                title = "${poster_" + item.stuffData.getLegacyString() + "_name}";
            }
            this._popup.updateContent(
                Std.downcast(window , IWindowContainer), title,
                this.resolveItemThumbnail(group), item.stuffData);
            this._popup.show();
        }

        function resolveItemThumbnail(group:GroupItem):BitmapData
        {
            var bitmap= group.icon;
            if (bitmap != null)
            {
                return bitmap;
            }
            var result= group.isWallItem
                ? this._roomEngine.getWallItemIcon(
                    group.type, this, group.stuffData.getLegacyString())
                : this._roomEngine.getFurnitureIcon(
                    group.type, this, null, group.stuffData);
            if (result != null)
            {
                bitmap = result.data;
                group.icon = bitmap;
            }
            return bitmap;
        }

        public function imageReady(id:Int, bitmap:BitmapData)
        {
        }

        public function imageFailed(id:Int)
        {
        }

        public function alertTradeCancelled(reason:Int)
        {
            if (reason == WiredTradingModel.FAILURE_NONE)
            {
                return;
            }
            var title= this._localization.getLocalization(
                "wired_transactions.notification.fail.popup.title");
            var message=
                this._localization.getLocalizationWithParams(
                    "wired_transactions.notification.fail", "",
                    ["reason", this._localization.getLocalization(
                        "wired_transactions.notification.fail." + Std.string(reason))]);
            this._windowManager.alert(title, message, 0, null);
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._window;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.stopConfirmCountdown();
            if (this._confirmTimer != null)
            {
                this._confirmTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onConfirmTimer : ASAny));
                this._confirmTimer = null;
            }
            this.stopSecondsLeftTimer();
            if (this._secondsTimer != null)
            {
                this._secondsTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onSecondsTimer : ASAny));
                this._secondsTimer = null;
            }
            if (this._popup != null)
            {
                this._popup.dispose();
                this._popup = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._model = null;
            this._windowManager = null;
            this._localization = null;
            this._roomEngine = null;
            this._assets = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var infoText(get,never):ITextWindow;
function  get_infoText():ITextWindow
        { return Std.downcast(this._window.findChildByName("info_text") , ITextWindow); }
        var tradeTypeSplitter(get,never):IStaticBitmapWrapperWindow;
function  get_tradeTypeSplitter():IStaticBitmapWrapperWindow
        { return Std.downcast(this._window.findChildByName("trade_type_splitter") , IStaticBitmapWrapperWindow); }
        var lockIcon(get,never):IStaticBitmapWrapperWindow;
function  get_lockIcon():IStaticBitmapWrapperWindow
        { return Std.downcast(this._window.findChildByName("lock_0") , IStaticBitmapWrapperWindow); }
        var acceptButton(get,never):IButtonWindow;
function  get_acceptButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("button_accept") , IButtonWindow); }
        var cancelButton(get,never):IButtonWindow;
function  get_cancelButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("button_cancel") , IButtonWindow); }
        public var requirementsButton(get,never):com.sulake.core.window.components.IRegionWindow;
public function  get_requirementsButton():com.sulake.core.window.components.IRegionWindow
        { return Std.downcast(this._window.findChildByName("requirements_button") , com.sulake.core.window.components.IRegionWindow); }
        var yourItemGrid(get,never):IItemGridWindow;
function  get_yourItemGrid():IItemGridWindow
        { return Std.downcast(this._window.findChildByName("item_grid_0") , IItemGridWindow); }
        var wiredItemGrid(get,never):IItemGridWindow;
function  get_wiredItemGrid():IItemGridWindow
        { return Std.downcast(this._window.findChildByName("item_grid_1") , IItemGridWindow); }
        var yourItemCountText(get,never):ITextWindow;
function  get_yourItemCountText():ITextWindow
        { return Std.downcast(this._window.findChildByName("content_text_1_a") , ITextWindow); }
        var yourCreditCountText(get,never):ITextWindow;
function  get_yourCreditCountText():ITextWindow
        { return Std.downcast(this._window.findChildByName("content_text_1_b") , ITextWindow); }
        var wiredItemCountText(get,never):ITextWindow;
function  get_wiredItemCountText():ITextWindow
        { return Std.downcast(this._window.findChildByName("content_text_2_a") , ITextWindow); }
        var wiredCreditCountText(get,never):ITextWindow;
function  get_wiredCreditCountText():ITextWindow
        { return Std.downcast(this._window.findChildByName("content_text_2_b") , ITextWindow); }
        var wiredOfferings(get,never):IWindowContainer;
function  get_wiredOfferings():IWindowContainer
        { return Std.downcast(this._window.findChildByName("offers_1") , IWindowContainer); }
        var wiredPaymentPlaceholder(get,never):IWindowContainer;
function  get_wiredPaymentPlaceholder():IWindowContainer
        { return Std.downcast(this._window.findChildByName("offers_1_payment_placeholder") , IWindowContainer); }
        var paymentLayoutImage(get,never):IStaticBitmapWrapperWindow;
function  get_paymentLayoutImage():IStaticBitmapWrapperWindow
        { return Std.downcast(this._window.findChildByName("payment_layout_image") , IStaticBitmapWrapperWindow); }
        var secondsLeftText(get,never):ITextWindow;
function  get_secondsLeftText():ITextWindow
        { return Std.downcast(this._window.findChildByName("seconds_left_text") , ITextWindow); }
    }

