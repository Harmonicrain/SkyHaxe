package com.sulake.habbo.inventory.trading
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.inventory.ItemPopupCtrl;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOpenFailedEvent;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.CreditTradingItem;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.inventory.items.IFurnitureItem;

     class TradingView implements IInventoryView implements  IGetImageListener 
    {
        static inline final _Str_20030:UInt = 0xFF60C560;
        static inline final _Str_20416:UInt = 2577770;
        public static inline final _Str_15142= 0;
        public static inline final _Str_15599= 1;
        public static inline final _Str_14838= 2;

        var _tradingModel:TradingModel;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _roomEngine:IRoomEngine;
        var _assetLibrary:IAssetLibrary;
        var _popupCtrl:ItemPopupCtrl;
        var _soundManager:IHabboSoundManager;
        var _disposed:Bool = false;
        var _visible:Bool = false;
        var _windowFull:IWindowContainer;
        var _windowMin:IWindowContainer;
        var _timer:Timer;
        var _selection:GroupItem;
        var _isMinimized:Bool = false;
        var _waitingSongInfo:Array<ASAny>;

        public function new(k:TradingModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IRoomEngine, _arg_5:IHabboLocalizationManager, _arg_6:IHabboSoundManager)
        {
            this._waitingSongInfo = new Array<ASAny>();
            this._tradingModel = k;
            this._windowManager = _arg_2;
            this._localization = _arg_5;
            this._assetLibrary = _arg_3;
            this._roomEngine = _arg_4;
            this._soundManager = _arg_6;
            this._visible = false;
            var _local_7= this._assetLibrary.getAssetByName("item_popup_xml");
            var _local_8= cast(_local_7, XmlAsset);
            var _local_9= Std.downcast(this._windowManager.buildFromXML(((_local_8.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            _local_9.visible = false;
            this._popupCtrl = new ItemPopupCtrl(_local_9, this._assetLibrary, this._windowManager, this._tradingModel);
            this._soundManager.events.addEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._windowFull != null) && (!this._windowFull.disposed)))
                {
                    this._windowFull.dispose();
                    this._windowFull = null;
                }
                if (this._timer != null)
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, (this._Str_916 : ASAny));
                    this._timer.stop();
                    this._timer = null;
                }
                if (this._popupCtrl != null)
                {
                    this._popupCtrl.dispose();
                    this._popupCtrl = null;
                }
                if (this._soundManager != null)
                {
                    if (this._soundManager.events != null)
                    {
                        this._soundManager.events.removeEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
                    }
                    this._soundManager = null;
                }
                this._waitingSongInfo = null;
                this._tradingModel = null;
                this._windowManager = null;
                this._roomEngine = null;
                this._localization = null;
                this._assetLibrary = null;
                this._selection = null;
                this._visible = false;
                this._disposed = true;
            }
        }

        public function setup(k:Int, _arg_2:Bool, _arg_3:Int, _arg_4:Bool)
        {
            this._Str_5129(false);
            this._Str_25386();
            this._Str_24229();
            if (((!_arg_2) && (!_arg_4)))
            {
                this._Str_9274("${inventory.trading.warning.both_accounts_disabled}");
                this._Str_16518("");
                this._Str_16189("");
            }
            else
            {
                if (!_arg_2)
                {
                    this._Str_16518("${inventory.trading.warning.own_account_disabled}");
                }
                if (!_arg_4)
                {
                    this._Str_16189("${inventory.trading.warning.others_account_disabled}");
                }
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            if (this._windowFull == null)
            {
                this._windowFull = this.createNormalWindow();
                this._Str_17273(null);
            }
            if (this._windowMin == null)
            {
                this._windowMin = this.createMinimizedWindow();
            }
            if (!this._isMinimized)
            {
                return this._windowFull;
            }
            return this._windowMin;
        }

        public function _Str_5129(k:Bool=false)
        {
            this._isMinimized = k;
        }

        public function _Str_9059(k:Int)
        {
            var _local_3:GroupItem = null;
            var _local_4:IWindowContainer = null;
            var _local_5:IBitmapWrapperWindow = null;
            var _local_6:ITextWindow = null;
            var _local_7:BitmapData = null;
            var _local_8:BitmapData = null;
            if (this._windowFull == null)
            {
                return;
            }
            var _local_2:UInt = 0;
            var _local_9:ASAny = (k == this._tradingModel._Str_21380);
            var _local_10= (_local_9 ? this._tradingModel._Str_5629 : this._tradingModel._Str_5319);
            var _local_11= (_local_9 ? this.getOtherUsersItemGrid() : this.getOwnUsersItemGrid());
            while (_local_2 < _local_10.length)
            {
                _local_3 = ASCompat.dynamicAs(_local_10.getWithIndex(ASCompat.toInt(_local_2)) , GroupItem);
                _local_4 = Std.downcast(_local_11.getGridItemAt(_local_2) , IWindowContainer);
                if (_local_4 != null)
                {
                    _local_4.id = ASCompat.toInt(_local_2);
                    while (_local_4.numChildren > 0)
                    {
                        _local_4.removeChildAt(0);
                    }
                    _local_4.addChild(_local_3.window);
                    _local_3.window.id = ASCompat.toInt(_local_2);
                    _local_3._Str_24322();
                }
                _local_2++;
            }
            while (_local_2 < _local_11.numGridItems)
            {
                _local_4 = Std.downcast(_local_11.getGridItemAt(_local_2) , IWindowContainer);
                if (_local_4 != null)
                {
                    _local_4.id = ASCompat.toInt(_local_2);
                    _local_4.removeChildAt(0);
                    _local_4.invalidate();
                }
                _local_2++;
            }
            this._Str_19826();
        }

        public function _Str_24697()
        {
            var k:IItemGridWindow = null;
            var _local_2:IWindowContainer = null;
            var _local_3:UInt = 0;
            k = this.getOwnUsersItemGrid();
            _local_3 = 0;
            while (_local_3 < k.numGridItems)
            {
                _local_2 = Std.downcast(k.getGridItemAt(_local_3) , IWindowContainer);
                if (_local_2 != null)
                {
                    _local_2.id = ASCompat.toInt(_local_3);
                    _local_2.removeChildAt(0);
                }
                _local_3++;
            }
            k = this.getOtherUsersItemGrid();
            _local_3 = 0;
            while (_local_3 < k.numGridItems)
            {
                _local_2 = Std.downcast(k.getGridItemAt(_local_3) , IWindowContainer);
                if (_local_2 != null)
                {
                    _local_2.id = ASCompat.toInt(_local_3);
                    _local_2.removeChildAt(0);
                }
                _local_3++;
            }
        }

        public function _Str_11244()
        {
            var k:IWindow = null;
            var _local_2:ITextWindow = null;
            var _local_3:IStaticBitmapWrapperWindow = null;
            if (this._windowFull != null)
            {
                this._Str_19826();
                _local_2 = Std.downcast(this._windowFull.findChildByTag("OTHER_USER_NAME") , ITextWindow);
                if (_local_2 != null)
                {
                    _local_2.text = this._tradingModel._Str_17035;
                }
                this._windowFull.findChildByTag("OWN_USER_ACCEPTED").visible = this._tradingModel._Str_11659;
                _local_3 = Std.downcast(this._windowFull.findChildByTag("OWN_USER_LOCK") , IStaticBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    _local_3.assetUri = (this._tradingModel._Str_11659 ? "talent_locked_achievement" : "inventory_trading_trading_unlocked_icon");
                }
                this._windowFull.findChildByTag("OTHER_USER_ACCEPTED").visible = this._tradingModel._Str_21829;
                _local_3 = Std.downcast(this._windowFull.findChildByTag("OTHER_USER_LOCK") , IStaticBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    _local_3.assetUri = (this._tradingModel._Str_21829 ? "talent_locked_achievement" : "inventory_trading_trading_unlocked_icon");
                }
            }
        }

        public function _Str_19826()
        {
            var k:IWindow = null;
            if (this._windowFull != null)
            {
                k = this._windowFull.findChildByName("button_accept");
                if (k == null)
                {
                    return;
                }
                if (this._tradingModel.getInventory().getBoolean("trading.warning.enabled"))
                {
                    if (this._tradingModel._Str_24618())
                    {
                        this._Str_17273(this._localization.getLocalization("inventory.trading.warning.credits", "inventory.trading.warning.credits"));
                    }
                    else
                    {
                        this._Str_17273(null);
                    }
                }
                this._Str_25501(this._tradingModel._Str_24153, this._tradingModel._Str_25441);
                this._Str_25640(this._tradingModel._Str_24984, this._tradingModel._Str_23259);
                switch (this._tradingModel.state)
                {
                    case TradingModel.TRADING_STATE_READY:
                        if (((this._tradingModel._Str_5629.length > 0) || (this._tradingModel._Str_5319.length > 0)))
                        {
                            k.enable();
                        }
                        else
                        {
                            k.disable();
                        }
                        k.caption = "${inventory.trading.accept}";
                        return;
                    case TradingModel.TRADING_STATE_RUNNING:
                        if (((this._tradingModel._Str_5629.length > 0) || (this._tradingModel._Str_5319.length > 0)))
                        {
                            k.enable();
                        }
                        else
                        {
                            k.disable();
                        }
                        k.caption = (this._tradingModel._Str_11659 ? "${inventory.trading.modify}" : "${inventory.trading.accept}");
                        this._Str_9274("${inventory.trading.info.add}");
                        return;
                    case TradingModel.TRADING_STATE_COUNTDOWN:
                        k.disable();
                        k.caption = "${inventory.trading.countdown}";
                        this._Str_9274("${inventory.trading.info.confirm}");
                        return;
                    case TradingModel.TRADING_STATE_CONFIRMING:
                        k.enable();
                        k.caption = "${inventory.trading.confirm}";
                        this._Str_9274("${inventory.trading.info.confirm}");
                        return;
                    case TradingModel.TRADING_STATE_CONFIRMED:
                        k.disable();
                        this._Str_9274("${inventory.trading.info.waiting}");
                        return;
                    case TradingModel.TRADING_STATE_COMPLETED:
                        k.disable();
                        k.caption = "${inventory.trading.accept}";
                        this._Str_9274("${inventory.trading.info.confirm}");
                        return;
                    case TradingModel.TRADING_STATE_CANCELLED:
                        return;
                    default:
                        throw new ASError((('Unknown trading progress state: "' + Std.string(this._tradingModel.state)) + '"'));
                }
            }
        }

        public function _Str_9274(k:String)
        {
            var _local_2= Std.downcast(this._windowFull.findChildByName("help_text") , ITextWindow);
            _local_2.text = k;
            _local_2.visible = true;
        }

        function _Str_17273(k:String)
        {
            if (this._windowFull == null)
            {
                return;
            }
            var _local_2= this._windowFull.findChildByName("info_border_highlighted");
            if (_local_2 != null)
            {
                _local_2.visible = (!(k == null));
            }
            var _local_3= Std.downcast(this._windowFull.findChildByName("info_text_highlighted") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.visible = (!(k == null));
                if (ASCompat.stringAsBool(k))
                {
                    _local_3.text = k;
                }
            }
        }

        function _Str_25501(k:Int, _arg_2:Int)
        {
            this._Str_20764("content_text_1_a", k, "content_text_1_b", _arg_2, true);
        }

        function _Str_25640(k:Int, _arg_2:Int)
        {
            this._Str_20764("content_text_2_a", k, "content_text_2_b", _arg_2, false);
        }

        function _Str_20764(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Bool)
        {
            var _local_6:ITextWindow = null;
            if (!this._tradingModel.getInventory().getBoolean("trading.warning.enabled"))
            {
                return;
            }
            _local_6 = Std.downcast(this._windowFull.findChildByName(k) , ITextWindow);
            if (_local_6 != null)
            {
                this._localization.registerParameter("inventory.trading.info.itemcount", "value", Std.string(_arg_2));
                _local_6.text = this._localization.getLocalization("inventory.trading.info.itemcount");
            }
            _local_6 = Std.downcast(this._windowFull.findChildByName(_arg_3) , ITextWindow);
            if (_local_6 != null)
            {
                if (_arg_5)
                {
                    this._localization.registerParameter("inventory.trading.info.creditvalue.own", "value", Std.string(_arg_4));
                    _local_6.text = this._localization.getLocalization("inventory.trading.info.creditvalue.own");
                }
                else
                {
                    this._localization.registerParameter("inventory.trading.info.creditvalue", "value", Std.string(_arg_4));
                    _local_6.text = this._localization.getLocalization("inventory.trading.info.creditvalue");
                }
            }
        }

        public function _Str_16518(k:String)
        {
            var _local_2= Std.downcast(this._windowFull.findChildByName("info_text_0") , ITextWindow);
            _local_2.text = k;
            _local_2.visible = true;
            var _local_3= Std.downcast(this._windowFull.findChildByName("item_grid_0") , IItemGridWindow);
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
        }

        public function _Str_25386()
        {
            var k= Std.downcast(this._windowFull.findChildByName("info_text_0") , ITextWindow);
            k.visible = false;
            var _local_2= Std.downcast(this._windowFull.findChildByName("item_grid_0") , IItemGridWindow);
            if (_local_2 != null)
            {
                _local_2.visible = true;
            }
        }

        public function _Str_16189(k:String)
        {
            var _local_2= Std.downcast(this._windowFull.findChildByName("info_text_1") , ITextWindow);
            _local_2.text = k;
            _local_2.visible = true;
            var _local_3= Std.downcast(this._windowFull.findChildByName("item_grid_1") , IItemGridWindow);
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
        }

        public function _Str_24229()
        {
            var k= Std.downcast(this._windowFull.findChildByName("info_text_1") , ITextWindow);
            k.visible = false;
            var _local_2= Std.downcast(this._windowFull.findChildByName("item_grid_1") , IItemGridWindow);
            if (_local_2 != null)
            {
                _local_2.visible = true;
            }
        }

        public function _Str_24174(k:TradingOpenFailedEvent)
        {
            var _local_2= ("inventory.trading.openfail." + Std.string(k.getParser().reason));
            this._windowManager.registerLocalizationParameter(_local_2, "otherusername", k.getParser()._Str_17035);
            this._windowManager.simpleAlert("${inventory.trading.openfail.title}", "${inventory.trading.openfail.caption}", (("${" + _local_2) + "}"));
        }

        public function _Str_17682(k:Int)
        {
            switch (k)
            {
                case _Str_15142:
                    this._windowManager.alert("${inventory.trading.notification.title}", "${inventory.trading.warning.other_not_offering}", 0, this._Str_16452);
                    return;
                case _Str_15599:
                    this._windowManager.alert("${inventory.trading.notification.title}", "${inventory.trading.info.closed}", 0, this._Str_16452);
                    return;
                case _Str_14838:
                    this._windowManager.alert("${inventory.trading.notification.title}", "${inventory.trading.info.already_open}", 0, this._Str_16452);
                    return;
            }
        }

        public function _Str_26089(title:String, description:String, callback:ASFunction)
        {
            this._windowManager.alert(title, description, 0, ((callback != null) ? callback : function (k:IAlertDialog, _arg_2:WindowEvent)
{
    k.dispose();
}));
        }

        public function _Str_17610()
        {
            if (this._timer == null)
            {
                this._timer = new Timer(1000, 3);
                this._timer.addEventListener(TimerEvent.TIMER, (this._Str_916 : ASAny));
            }
            this._timer.reset();
            this._timer.repeatCount = 3;
            this._timer.start();
            this._windowManager.registerLocalizationParameter("inventory.trading.countdown", "counter", "3");
            this._Str_11244();
        }

        public function _Str_18651()
        {
            if (this._timer != null)
            {
                this._timer.reset();
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3:UInt = 0;
            var _local_4:GroupItem = null;
            var _local_5:Map = null;
            var _local_6 = false;
            _local_5 = this._tradingModel._Str_5319;
            _local_6 = false;
            _local_3 = 0;
            while (_local_3 < _local_5.length)
            {
                _local_4 = ASCompat.dynamicAs(_local_5.getWithIndex(ASCompat.toInt(_local_3)) , GroupItem);
                if (_local_4._Str_15216 == k)
                {
                    _local_4.icon = _arg_2;
                    _local_6 = true;
                }
                _local_3++;
            }
            if (_local_6)
            {
                this._Str_9059(this._tradingModel._Str_6240);
            }
            _local_5 = this._tradingModel._Str_5629;
            _local_6 = false;
            _local_3 = 0;
            while (_local_3 < _local_5.length)
            {
                _local_4 = ASCompat.dynamicAs(_local_5.getValue(_local_3), GroupItem);
                if (_local_4._Str_15216 == k)
                {
                    _local_4.icon = _arg_2;
                    _local_6 = true;
                }
                _local_3++;
            }
            if (_local_6)
            {
                this._Str_9059(this._tradingModel._Str_21380);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        public function setSelection(k:GroupItem)
        {
            this._Str_25509();
            if (k != null)
            {
                this._selection = k;
                this._selection.Selected = true;
            }
        }

        public function _Str_25509()
        {
            if (this._selection != null)
            {
                this._selection.Selected = false;
                this._selection = null;
            }
        }

        public function _Str_23654(k:Int, _arg_2:BitmapData)
        {
        }

        public function _Str_16452(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                k.dispose();
            }
        }

        function getOwnUsersItemGrid():IItemGridWindow
        {
            return Std.downcast(this._windowFull.findChildByTag("OWN_USER_GRID") , IItemGridWindow);
        }

        function getOtherUsersItemGrid():IItemGridWindow
        {
            return Std.downcast(this._windowFull.findChildByTag("OTHER_USER_GRID") , IItemGridWindow);
        }

        function resolveItemThumbnail(k:GroupItem):BitmapData
        {
            var _local_3:ImageResult = null;
            var _local_2= k.icon;
            if (_local_2 == null)
            {
                if (k.isWallItem)
                {
                    _local_3 = this._roomEngine.getWallItemIcon(k.type, this, k.stuffData.getLegacyString());
                }
                else
                {
                    _local_3 = this._roomEngine.getFurnitureIcon(k.type, this, null, k.stuffData);
                }
                if (_local_3.id > 0)
                {
                    k._Str_15216 = _local_3.id;
                }
                _local_2 = _local_3.data;
                k.icon = _local_2;
            }
            return _local_2;
        }

        function createThumbnailContainer():IWindowContainer
        {
            var k= ((cast(this._assetLibrary.getAssetByName("inventory_thumb_xml"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
            return Std.downcast(this._windowManager.buildFromXML(k) , IWindowContainer);
        }

        function selectOwnTradeItem(k:UInt)
        {
            var _local_2:GroupItem = null;
            if (((this._tradingModel == null) || (this._tradingModel._Str_5319 == null)))
            {
                return;
            }
            if (k < this._tradingModel._Str_5319.length)
            {
                _local_2 = ASCompat.dynamicAs(this._tradingModel._Str_5319.getWithIndex(ASCompat.toInt(k)) , GroupItem);
                this.setSelection(_local_2);
                if (_local_2 != null)
                {
                    this._tradingModel._Str_19254()._Str_12834(_local_2);
                }
            }
        }

        function selectOthersTradeItem(k:UInt)
        {
            var _local_2:GroupItem = null;
            if (((this._tradingModel == null) || (this._tradingModel._Str_5629 == null)))
            {
                return;
            }
            if (k < this._tradingModel._Str_5629.length)
            {
                _local_2 = ASCompat.dynamicAs(this._tradingModel._Str_5629.getWithIndex(ASCompat.toInt(k)) , GroupItem);
                this.setSelection(_local_2);
                if (_local_2 != null)
                {
                    this._tradingModel._Str_19254()._Str_12834(_local_2);
                }
            }
        }

        function createNormalWindow():IWindowContainer
        {
            var _local_3:IItemGridWindow = null;
            var _local_4:IWindow = null;
            var _local_5:IWindowContainer = null;
            var _local_6:UInt = 0;
            var k= ((cast(this._assetLibrary.getAssetByName("inventory_trading_xml"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
            var _local_2= Std.downcast(this._windowManager.buildFromXML(k) , IWindowContainer);
            _local_3 = Std.downcast(_local_2.findChildByTag("OWN_USER_GRID") , IItemGridWindow);
            _local_6 = 0;
            while (_local_6 < _local_3.numGridItems)
            {
                _local_4 = _local_3.getGridItemAt(_local_6);
                _local_4.id = ASCompat.toInt(_local_6);
                _local_4.procedure = this.ownThumbEventProc;
                _local_4.addEventListener(WindowMouseEvent.OVER, this.ownThumbEventProc);
                _local_4.addEventListener(WindowMouseEvent.OUT, this.ownThumbEventProc);
                _local_6++;
            }
            _local_3 = Std.downcast(_local_2.findChildByTag("OTHER_USER_GRID") , IItemGridWindow);
            _local_6 = 0;
            while (_local_6 < _local_3.numGridItems)
            {
                _local_4 = _local_3.getGridItemAt(_local_6);
                _local_4.id = ASCompat.toInt(_local_6);
                _local_4.procedure = this.othersThumbEventProc;
                _local_4.addEventListener(WindowMouseEvent.OVER, this.othersThumbEventProc);
                _local_4.addEventListener(WindowMouseEvent.OUT, this.othersThumbEventProc);
                _local_6++;
            }
            _local_2.procedure = this.windowEventProc;
            return _local_2;
        }

        function createMinimizedWindow():IWindowContainer
        {
            var k= ((cast(this._assetLibrary.getAssetByName("inventory_trading_minimized_xml"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
            var _local_2= Std.downcast(this._windowManager.buildFromXML(k) , IWindowContainer);
            _local_2.procedure = this.windowMininizedEventProc;
            return _local_2;
        }

        function windowMininizedEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "button_continue":
                        this._tradingModel._Str_24199();
                        return;
                    case "button_cancel":
                        this._tradingModel.requestCancelTrading();
                        return;
                }
            }
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "button_accept":
                        switch (this._tradingModel.state)
                        {
                            case TradingModel.TRADING_STATE_RUNNING:
                                if (((this._tradingModel._Str_5629.length == 0) && (!this._tradingModel._Str_11659)))
                                {
                                    this._Str_17682(_Str_15142);
                                }
                                if (this._tradingModel._Str_11659)
                                {
                                    this._tradingModel.requestUnacceptTrading();
                                }
                                else
                                {
                                    this._tradingModel.requestAcceptTrading();
                                }
                                
                            case TradingModel.TRADING_STATE_CONFIRMING:
                                _arg_2.disable();
                                this._tradingModel.requestConfirmAcceptTrading();
                                
                        }
                        return;
                    case "button_cancel":
                        switch (this._tradingModel.state)
                        {
                            case TradingModel.TRADING_STATE_RUNNING:
                                this._tradingModel.requestCancelTrading();
                                
                            case TradingModel.TRADING_STATE_CONFIRMING:
                                this._tradingModel.requestConfirmDeclineTrading();
                                
                        }
                        return;
                }
            }
        }

        function ownThumbEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            this.thumbEventProc(k, _arg_2, true);
        }

        function othersThumbEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            this.thumbEventProc(k, _arg_2, false);
        }

        function thumbEventProc(k:WindowEvent, _arg_2:IWindow, _arg_3:Bool)
        {
            var _local_4:GroupItem = null;
            var _local_5:FurnitureItem = null;
            var _local_6:CreditTradingItem = null;
            var _local_7:BitmapData = null;
            var _local_8:String = null;
            var _local_9:FurnitureItem = null;
            var _local_10:Date = null;
            if ((_arg_3 && (k.type == WindowMouseEvent.CLICK)))
            {
                this._tradingModel.requestRemoveItemFromTrading(_arg_2.id);
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                if (_arg_3)
                {
                    _local_4 = this._tradingModel._Str_5319.getWithIndex(_arg_2.id);
                }
                else
                {
                    _local_4 = this._tradingModel._Str_5629.getWithIndex(_arg_2.id);
                }
                if (_local_4 == null)
                {
                    return;
                }
                _local_6 = Std.downcast(_local_4 , CreditTradingItem);
                if (((!(_local_6 == null)) && (!_arg_3)))
                {
                    this._popupCtrl.updateContent(Std.downcast(_arg_2 , IWindowContainer), _local_6._Str_22574(), _local_6._Str_21010(), null, ItemPopupCtrl._Str_9535, false);
                    this._popupCtrl.show();
                    return;
                }
                _local_5 = _local_4._Str_3205();
                if (_local_5 == null)
                {
                    return;
                }
                _local_7 = this._tradingModel._Str_9836(_local_5);
                if (!_local_5.isWallItem)
                {
                    _local_8 = ((("$" + "{roomItem.name.") + Std.string(_local_5.type)) + "}");
                }
                else
                {
                    _local_8 = ((("$" + "{wallItem.name.") + Std.string(_local_5.type)) + "}");
                }
                if (_local_5.category == FurniCategory.POSTER)
                {
                    _local_8 = (("${poster_" + _local_5.stuffData.getLegacyString()) + "_name}");
                }
                if (_local_5.category == FurniCategory.ECOTRON_BOX)
                {
                    _local_9 = _local_5 ;
                    _local_10 = ASCompat.newDateWithMilliseconds(_local_9.creationYear, (_local_9.creationMonth - 1), _local_9.creationDay);
                    _local_8 = ((this._localization.getLocalization(("roomItem.name." + Std.string(_local_5.type))) + " ") + ASCompat.dateToLocaleDateString(_local_10));
                }
                if (_local_5.category == FurniCategory.TRAX_SONG)
                {
                    _local_8 = this.getTraxSongFurniName(_local_4, _local_8, true, _arg_2.id, _arg_3);
                }
                this._popupCtrl.updateContent(Std.downcast(_arg_2 , IWindowContainer), _local_8, _local_7, _local_4._Str_3205().stuffData, ItemPopupCtrl._Str_9535, this.isExternalImagetype(_local_5));
                this._popupCtrl.show();
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    this._popupCtrl._Str_14093();
                }
            }
        }

        function isExternalImagetype(k:FurnitureItem):Bool
        {
            if (this._tradingModel.getInventory() == null)
            {
                return false;
            }
            var _local_2= this._tradingModel.getInventory().getFurnitureData(k.type, ProductTypeEnum.WALL);
            return (_local_2 != null) && _local_2.isExternalImageType;
        }

        function getTraxSongFurniName(k:GroupItem, _arg_2:String, _arg_3:Bool, _arg_4:Int=-1, _arg_5:Bool=false):String
        {
            var _local_6:IFurnitureItem = k._Str_3205();
            var _local_7= this._soundManager.musicController.getSongInfo(Std.int(_local_6.extra));
            if (_local_7 != null)
            {
                this._localization.registerParameter("songdisc.info", "name", _local_7.name);
                this._localization.registerParameter("songdisc.info", "author", _local_7.creator);
                _arg_2 = this._localization.getLocalization("songdisc.info");
            }
            else
            {
                if (_arg_3)
                {
                    if (this._waitingSongInfo.length > 0)
                    {
                        this._waitingSongInfo.pop();
                        this._waitingSongInfo.pop();
                        this._waitingSongInfo.pop();
                    }
                    this._waitingSongInfo.push(_arg_4);
                    this._waitingSongInfo.push(k);
                    this._waitingSongInfo.push(_arg_5);
                    this._soundManager.musicController.requestSongInfoWithoutSamples(Std.int(_local_6.extra));
                }
            }
            return _arg_2;
        }

        function _Str_916(k:TimerEvent)
        {
            this._windowManager.registerLocalizationParameter("inventory.trading.countdown", "counter", Std.string((3 - this._timer.currentCount)));
            if (this._timer.currentCount == 3)
            {
                this._tradingModel._Str_24577();
                this._timer.reset();
            }
        }

        function onSongInfoReceivedEvent(k:SongInfoReceivedEvent)
        {
            var _local_2 = false;
            var _local_3:GroupItem = null;
            var _local_4:UInt = 0;
            var _local_5:FurnitureItem = null;
            var _local_6:String = null;
            var _local_7:BitmapData = null;
            var _local_8:IWindow = null;
            if (this._waitingSongInfo.length > 0)
            {
                _local_2 = this._waitingSongInfo.pop();
                _local_3 = this._waitingSongInfo.pop();
                _local_4 = ASCompat.toUInt(this._waitingSongInfo.pop());
                _local_5 = _local_3._Str_3205();
                if (_local_5.extra == k.id)
                {
                    if (((_local_2 && (this._tradingModel._Str_5319.getWithIndex(ASCompat.toInt(_local_4)) == _local_3)) || ((!_local_2) && (this._tradingModel._Str_5629.getWithIndex(ASCompat.toInt(_local_4)) == _local_3))))
                    {
                        _local_6 = this.getTraxSongFurniName(_local_3, "", false);
                        _local_7 = this._tradingModel._Str_9836(_local_5);
                        _local_8 = (_local_2 ? this.getOwnUsersItemGrid().getGridItemAt(_local_4) : this.getOtherUsersItemGrid().getGridItemAt(_local_4));
                        this._popupCtrl.updateContent(Std.downcast(_local_8 , IWindowContainer), _local_6, _local_7);
                    }
                }
                else
                {
                    this._waitingSongInfo.push(_local_4);
                    this._waitingSongInfo.push(_local_3);
                    this._waitingSongInfo.push(_local_2);
                }
            }
        }
    }

