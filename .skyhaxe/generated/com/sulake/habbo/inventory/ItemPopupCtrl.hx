package com.sulake.habbo.inventory
;
    import flash.utils.Timer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.inventory.trading.ITradingModel;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.events.TimerEvent;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.window.widgets.ILimitedItemPreviewOverlayWidget;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import org.openvideoads.util.StringUtils;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.room.IStuffData;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import adobe.serialization.json.JSONDecoder;
    import com.sulake.core.assets.loaders.BitmapFileLoader;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import com.sulake.core.window.components.*;

     class ItemPopupCtrl 
    {
        public static inline final _Str_13336= 1;
        public static inline final _Str_9535= 2;
        static inline final _Str_13845= -5;
        static inline final _Str_18361= 250;
        static inline final _Str_16920= 100;
        static inline final _Str_11047= 180;
        static inline final _Str_13158= 200;

        var _openDelayTimer:Timer;
        var _hideDelayTimer:Timer;
        var _assets:IAssetLibrary;
        var _popupWindow:IWindowContainer;
        var _parent:IWindowContainer;
        var _preferredLocation:Int = 2;
        var _arrowImgLeft:BitmapData;
        var _arrowImgRight:BitmapData;
        var _tradingModel:ITradingModel;
        var _windowManager:IHabboWindowManager;
        var _expectingExtImage:Bool = false;

        public function new(k:IWindowContainer, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager, _arg_4:ITradingModel)
        {
            this._openDelayTimer = new Timer(_Str_18361, 1);
            this._hideDelayTimer = new Timer(_Str_16920, 1);
            if (((k == null) || (_arg_2 == null)))
            {
                throw new ASError("Null pointers passed as argument!");
            }
            this._popupWindow = k;
            this._popupWindow.visible = false;
            this._assets = _arg_2;
            this._windowManager = _arg_3;
            this._openDelayTimer.addEventListener(TimerEvent.TIMER, (this._Str_10545 : ASAny));
            this._hideDelayTimer.addEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
            this._tradingModel = _arg_4;
            var _local_5= Std.downcast(this._assets.getAssetByName("popup_arrow_right_png") , BitmapDataAsset);
            if (((!(_local_5 == null)) && (!(_local_5.content == null))))
            {
                this._arrowImgRight = ASCompat.dynamicAs(_local_5.content , BitmapData);
            }
            _local_5 = Std.downcast(this._assets.getAssetByName("popup_arrow_left_png") , BitmapDataAsset);
            if (((!(_local_5 == null)) && (!(_local_5.content == null))))
            {
                this._arrowImgLeft = ASCompat.dynamicAs(_local_5.content , BitmapData);
            }
        }

        public function dispose()
        {
            if (this._openDelayTimer != null)
            {
                this._openDelayTimer.removeEventListener(TimerEvent.TIMER, (this._Str_10545 : ASAny));
                this._openDelayTimer.stop();
                this._openDelayTimer = null;
            }
            if (this._hideDelayTimer != null)
            {
                this._hideDelayTimer.removeEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
                this._hideDelayTimer.stop();
                this._hideDelayTimer = null;
            }
            this._assets = null;
            this._popupWindow = null;
            this._parent = null;
            this._arrowImgLeft = null;
            this._arrowImgRight = null;
        }

        public function updateContent(k:IWindowContainer, _arg_2:String, _arg_3:BitmapData, _arg_4:IStuffData=null, _arg_5:Int=2, _arg_6:Bool=false)
        {
            var _local_10:BitmapData = null;
            var _local_11:String = null;
            var _local_12:String = null;
            var _local_13:String = null;
            var _local_14:ILimitedItemPreviewOverlayWidget = null;
            if (this._popupWindow == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (_arg_3 == null)
            {
                _arg_3 = new BitmapData(1, 1, true, 0xFFFFFF);
            }
            if (this._parent != null)
            {
                this._parent.removeChild(this._popupWindow);
            }
            this._parent = k;
            this._preferredLocation = _arg_5;
            this._expectingExtImage = false;
            var _local_7= cast(this._popupWindow.findChildByName("item_name_text"), ITextWindow);
            if (_local_7 != null)
            {
                _local_7.text = _arg_2;
            }
            var _local_8= cast(this._popupWindow.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
            var _local_9= Std.downcast(this._popupWindow.findChildByName("item_image") , IBitmapWrapperWindow);
            if (_local_9 != null)
            {
                if ((_arg_6 && (this._tradingModel != null)))
                {
                    _local_8.visible = false;
                    _local_9.bitmap = new BitmapData(1, 1, true, 0xFFFFFF);
                    if (_arg_4 != null)
                    {
                        this._expectingExtImage = true;
                        _local_11 = _arg_4.getJSONValue("id");
                        if (!StringUtils.isEmpty(_local_11))
                        {
                            this.loadExtraData(_local_11);
                        }
                        else
                        {
                            _local_12 = _arg_4.getJSONValue("w");
                            if (!StringUtils.isEmpty(_local_12))
                            {
                                _local_13 = (this._tradingModel.getInventory().getProperty("stories.image_url_base") + _local_12);
                                this.loadImage(_local_13);
                            }
                        }
                    }
                    return;
                }
                _local_10 = new BitmapData(Std.int(Math.min(_Str_11047, _arg_3.width)), Std.int(Math.min(_Str_13158, _arg_3.height)), true, 0xFFFFFF);
                _local_10.copyPixels(_arg_3, new Rectangle(0, 0, _local_10.width, _local_10.height), new Point(0, 0), null, null, true);
                _local_9.bitmap = _local_10;
                _local_9.width = _local_9.bitmap.width;
                _local_9.height = _local_9.bitmap.height;
                _local_9.x = Std.int((this._popupWindow.width - _local_9.width) / 2);
                this._popupWindow.height = (_local_9.bottom + 10);
            }
            if (((!(_arg_4 == null)) && (_arg_4.uniqueSerialNumber > 0)))
            {
                _local_14 = cast(_local_8.widget, ILimitedItemPreviewOverlayWidget);
                _local_14.serialNumber = _arg_4.uniqueSerialNumber;
                _local_14.seriesSize = _arg_4.uniqueSeriesSize;
            }
            else
            {
                _local_8.visible = false;
            }
        }

        function loadExtraData(k:String)
        {
            var _local_2= (this._tradingModel.getInventory().getProperty("extra_data_service_url") + k);
            var _local_3= new URLLoader(new URLRequest(_local_2));
            _local_3.addEventListener(Event.COMPLETE, (this.onExtraDataLoaded : ASAny));
        }

        function onExtraDataLoaded(k:Event)
        {
            var _local_3:ASObject = null;
            var _local_2:String = cast(k.target, URLLoader).data;
            if ((this._expectingExtImage && (!StringUtils.isEmpty(_local_2))))
            {
                try
                {
                    _local_3 = new JSONDecoder(_local_2, false).getValue();
                    this.loadImage(_local_3.url);
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        function loadImage(k:String)
        {
            var _local_2:BitmapFileLoader = null;
            if (!StringUtils.isEmpty(k))
            {
                _local_2 = new BitmapFileLoader("image/png", new URLRequest(k));
                _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onExtImageLoaded);
            }
        }

        function onExtImageLoaded(k:AssetLoaderEvent)
        {
            if (((!(this._popupWindow != null)) || (!this._expectingExtImage)))
            {
                return;
            }
            var _local_2= Std.downcast(this._popupWindow.findChildByName("item_image") , IBitmapWrapperWindow);
            if (((!(_local_2 != null)) || (this._assets == null)))
            {
                return;
            }
            var _local_3= ASCompat.dynamicAs(cast(k.target, BitmapFileLoader).content , DisplayObject);
            var _local_4= new BitmapData(Std.int(Math.min(_Str_11047, _local_3.width)), Std.int(Math.min(_Str_13158, _local_3.height)), true, 0xFFFFFF);
            var _local_5= (_Str_11047 / _local_3.width);
            var _local_6= new Matrix();
            _local_6.scale(_local_5, _local_5);
            _local_4.draw(_local_3, _local_6);
            _local_2.bitmap = _local_4;
            _local_2.width = _local_2.bitmap.width;
            _local_2.height = _local_2.bitmap.height;
            _local_2.x = Std.int((this._popupWindow.width - _local_2.width) / 2);
            this._popupWindow.height = (_local_2.bottom + 10);
        }

        public function show()
        {
            this._hideDelayTimer.reset();
            this._openDelayTimer.reset();
            if (this._parent == null)
            {
                return;
            }
            this._popupWindow.visible = true;
            this._parent.addChild(this._popupWindow);
            this._Str_22732(this._preferredLocation);
            switch (this._preferredLocation)
            {
                case _Str_13336:
                    this._popupWindow.x = ((-1 * this._popupWindow.width) - _Str_13845);
                    
                case _Str_9535:
                    this._popupWindow.x = (this._parent.width + _Str_13845);
                    
            }
            this._popupWindow.y = Std.int((this._parent.height - this._popupWindow.height) / 2);
        }

        public function hide()
        {
            this._popupWindow.visible = false;
            this._hideDelayTimer.reset();
            this._openDelayTimer.reset();
            if (this._parent != null)
            {
                this._parent.removeChild(this._popupWindow);
            }
        }

        public function _Str_26396()
        {
            this._hideDelayTimer.reset();
            this._openDelayTimer.reset();
            this._openDelayTimer.start();
        }

        public function _Str_14093()
        {
            this._hideDelayTimer.reset();
            this._openDelayTimer.reset();
            this._hideDelayTimer.start();
        }

        function _Str_22732(k:Int=2)
        {
            if (((this._popupWindow == null) || this._popupWindow.disposed))
            {
                return;
            }
            var _local_2= cast(this._popupWindow.findChildByName("arrow_pointer"), IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            switch (k)
            {
                case _Str_13336:
                    _local_2.bitmap = this._arrowImgRight.clone();
                    _local_2.width = this._arrowImgRight.width;
                    _local_2.height = this._arrowImgRight.height;
                    _local_2.y = Std.int((this._popupWindow.height - this._arrowImgRight.height) / 2);
                    _local_2.x = (this._popupWindow.width - 1);
                    
                case _Str_9535:
                    _local_2.bitmap = this._arrowImgLeft.clone();
                    _local_2.width = this._arrowImgLeft.width;
                    _local_2.height = this._arrowImgLeft.height;
                    _local_2.y = Std.int((this._popupWindow.height - this._arrowImgLeft.height) / 2);
                    _local_2.x = ((-1 * this._arrowImgLeft.width) + 1);
                    
            }
            _local_2.invalidate();
        }

        function _Str_10545(k:TimerEvent)
        {
            this.show();
        }

        function _Str_6823(k:TimerEvent)
        {
            this.hide();
        }
    }

