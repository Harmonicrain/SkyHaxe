package com.sulake.habbo.roomevents.wired_trading.chests.settings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;

    /** July's dedicated confirmation window for enabling Wired on a chest. */
     final class WiredChestWiredUpdateConfirmationView
        implements IDisposable implements  IGetImageListener
    {
        var _disposed:Bool = false;
        var _window:IWindowContainer;
        var _settings:ChestSettingsUI;
        var _windowManager:IHabboWindowManager;
        var _chestId:Int = 0;
        var _chestType:Int = 0;
        var _chestItemType:Int = 0;
        var _starterChest:Bool = false;

        public function new(
            settings:ChestSettingsUI)
        {
            this._settings = settings;
            this._windowManager = settings.chestController.windowManager;
            var controller= settings.chestController;
            this._window = Std.downcast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(
                controller.assets.getAssetByName(
                    "chest_wired_upgrade_xml").content), 1)
, IWindowContainer);
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.cancelButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.buyButton.addEventListener("WME_CLICK", this.onBuyClicked);
            this.hide();
        }

        public function initialize(chestId:Int, chestType:Int,
            chestItemType:Int, starterChest:Bool)
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._starterChest = starterChest;
            this.updateUI();
        }

        function updateUI()
        {
            this.buyButton.enable();
            this.cancelButton.enable();
            var controller= this._settings.chestController;
            var image= controller.roomEngine.getFurnitureImage(
                this._chestItemType, new Vector3d(90, 0, 0), 64, this);
            if (image.data != null)
            {
                this.showChestPreview(image.data);
            }
            var reason= this._starterChest
                ? "wiredchests.upgrade.wired.error.reason.rookie_chest"
                : null;
            this.errorText.visible = reason != null;
            if (reason != null)
            {
                this.buyButton.disable();
                this.errorText.text =
                    controller.localization.getLocalizationWithParams(
                        "wiredchests.upgrade.wired.error", "", ["reason",
                        controller.localization.getLocalization(reason)]);
            }
        }

        function onBuyClicked(event:WindowMouseEvent)
        {
            this.buyButton.disable();
            this._settings.confirmUpgrade();
        }

        public function show()
        {
var desktop:IDesktopWindow  = null;            if (this._windowManager != null && this._window != null
                && this._window.parent == null)
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null)
                {
                    desktop.addChild(this._window);
                }
            }
            this._window.center();
            this._window.activate();
        }

        public function hide()
        {
var desktop:IDesktopWindow  = null;            if (this._windowManager != null && this._window != null
                && this._window.parent != null)
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null)
                {
                    desktop.removeChild(this._window);
                }
            }
        }

        function onWindowClose(event:WindowEvent)
        {
            if (event.type == "WME_CLICK")
            {
                this.hide();
            }
        }

        function showChestPreview(bitmap:BitmapData)
        {
            this.productImage.bitmap = bitmap;
        }

        public function imageReady(id:Int, bitmap:BitmapData)
        {
            this.showChestPreview(bitmap);
        }

        public function imageFailed(id:Int)
        {
            this.showChestPreview(null);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.hide();
            this._window.dispose();
            this._window = null;
            this._windowManager = null;
            this._settings = null;
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

