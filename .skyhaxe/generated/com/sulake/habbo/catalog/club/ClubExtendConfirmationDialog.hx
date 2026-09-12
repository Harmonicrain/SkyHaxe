package com.sulake.habbo.catalog.club
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubOfferExtendData;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.utils.Timer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.window._enum._Str_8057;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.assets.XmlAsset;

     class ClubExtendConfirmationDialog 
    {
        static inline final _Str_7770= 7;
        static inline final YOUR_PRICE_ICON_LEFT= "your_price_icon_left";
        static inline final _Str_17882= "${image.library.catalogue.url}catalogue/vip_extend_tsr.png";
        static inline final _Str_17088= "image/png";
        static inline final _Str_17359= 2000;
        static inline final _Str_17942= 75;
        static inline final _Str_17537:UInt = 0;
        static inline final _Str_16843:UInt = 9552639;

        var _controller:ClubExtendController;
        var _view:IFrameWindow;
        var _offer:ClubOfferExtendData;
        var _maybeLaterRegion:IRegionWindow;
        var _maybeLaterLink:ITextWindow;
        var _creditImageElement:IBitmapWrapperWindow;
        var _creditImages:Vector<BitmapData>;
        var _animationTriggerTimer:Timer;
        var _animationFrameTimer:Timer;
        var _animationFrame:Int = 0;
        var _animationLoop:Int = 0;
        var _disposed:Bool = false;
        var _localizationKey:String = "catalog.club.extend.";

        public function new(k:ClubExtendController, _arg_2:ClubOfferExtendData)
        {
            this._controller = k;
            this._offer = _arg_2;
            this._creditImages = new Vector<BitmapData>(_Str_7770);
        }

        public function dispose()
        {
            var k = 0;
            if (this._disposed)
            {
                return;
            }
            this._offer = null;
            this._controller = null;
            this._Str_9128();
            if (this._maybeLaterRegion != null)
            {
                this._maybeLaterRegion.removeEventListener(WindowMouseEvent.OUT, this._Str_21389);
                this._maybeLaterRegion.removeEventListener(WindowMouseEvent.OVER, this._Str_21154);
                this._maybeLaterRegion = null;
            }
            if (this._maybeLaterLink != null)
            {
                this._maybeLaterLink = null;
            }
            if (this._creditImageElement != null)
            {
                this._creditImageElement = null;
            }
            if (this._creditImages != null)
            {
                while (k < _Str_7770)
                {
                    this._creditImages[k].dispose();
                    this._creditImages[k] = null;
                    k++;
                }
                this._creditImages = null;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._disposed = true;
        }

        public function showConfirmation()
        {
            var _local_2:String = null;
            var _local_10:IIconWindow = null;
            var _local_11:BitmapDataAsset = null;
            var _local_12:BitmapData = null;
            if ((((!(this._offer != null)) || (!(this._controller != null))) || this._disposed))
            {
                return;
            }
            this._view = Std.downcast(this.createWindow("club_extend_confirmation") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            this._view.procedure = this._Str_3545;
            this._view.center();
            if (!this._offer.vip)
            {
                this._localizationKey = (this._localizationKey + "basic.");
                _local_10 = Std.downcast(this._view.findChildByName("club_level_icon") , IIconWindow);
                if (_local_10 != null)
                {
                    _local_10.style = _Str_8057._Str_18852;
                    _local_10.x = (_local_10.x + 15);
                }
            }
            var k= this._controller.localization;
            this._view.findChildByName("normal_price_price_left").caption = Std.string(this._offer._Str_23477);
            this._view.findChildByName("normal_price_price_right").caption = Std.string(this._offer._Str_21585);
            this._view.findChildByName("you_save_price_left").caption = Std.string(this._offer._Str_24050);
            this._view.findChildByName("you_save_price_right").caption = Std.string(this._offer._Str_22280);
            this._view.findChildByName("your_price_price_left").caption = Std.string(this._offer.priceCredits);
            this._view.findChildByName("your_price_price_right").caption = Std.string(this._offer.priceActivityPoints);
            this._view.title.caption = k.getLocalization((this._localizationKey + "confirm.caption"));
            this._view.findChildByName("extend_title").caption = k.getLocalization((this._localizationKey + "confirm.title"));
            this._view.findChildByName("normal_price_label").caption = k.getLocalization((this._localizationKey + "normal.label"));
            this._view.findChildByName("you_save_label").caption = k.getLocalization((this._localizationKey + "save.label"));
            this._view.findChildByName("your_price_label").caption = k.getLocalization((this._localizationKey + "price.label"));
            this._view.findChildByName("buy_now_button").caption = k.getLocalization((this._localizationKey + "buy.button"));
            this._view.findChildByName("maybe_later_link").caption = k.getLocalization((this._localizationKey + "later.link"));
            if (this._offer._Str_21229 > 1)
            {
                k.registerParameter((this._localizationKey + "expiration_days_left"), "day", Std.string(this._offer._Str_21229));
                k.registerParameter((this._localizationKey + "expiration_days_left"), "duration", Std.string((31 * this._offer.months)));
                _local_2 = k.getLocalization((this._localizationKey + "expiration_days_left"));
            }
            else
            {
                _local_2 = k.getLocalization((this._localizationKey + "expires_today"));
            }
            this._view.findChildByName("offer_expiration").caption = _local_2;
            this._maybeLaterRegion = Std.downcast(this._view.findChildByName("maybe_later_region") , IRegionWindow);
            this._maybeLaterLink = Std.downcast(this._view.findChildByName("maybe_later_link") , ITextWindow);
            if (((!(this._maybeLaterRegion != null)) || (!(this._maybeLaterLink != null))))
            {
                return;
            }
            this._maybeLaterRegion.addEventListener(WindowMouseEvent.OUT, this._Str_21389);
            this._maybeLaterRegion.addEventListener(WindowMouseEvent.OVER, this._Str_21154);
            var _local_3= this._Str_16777("icon_credit_0");
            this._Str_14412("normal_price_icon_left", _local_3);
            this._Str_14412("you_save_icon_left", _local_3);
            this._Str_9646("normal_price_icon_right");
            this._Str_9646("you_save_icon_right");
            this._Str_9646("your_price_icon_right");
            var _local_4= Std.downcast(this._view.findChildByName("club_teaser") , IBitmapWrapperWindow);
            _local_4.x = 1;
            _local_4.y = (this._view.height - 144);
            _local_4.height = 144;
            _local_4.width = 133;
            var _local_5= this._controller.config.interpolate(_Str_17882);
            if (this._controller.config != null)
            {
                _local_5 = this._controller.config.updateUrlProtocol(_local_5);
            }
            this._Str_22657("club_teaser", "club_teaser", _local_5, _Str_17088, this._Str_25165);
            var _local_6= Std.downcast(this._view.findChildByName("itemlist_vertical") , IItemListWindow);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= Std.downcast(this._view.findChildByName("total_amount_line") , IWindowContainer);
            if (_local_7 == null)
            {
                return;
            }
            var _local_8= Std.downcast(this._view.findChildByName("background_container") , IWindowContainer);
            if (_local_8 == null)
            {
                return;
            }
            _local_8.height = ((_local_6.y + _local_7.height) + _local_7.y);
            this._creditImageElement = Std.downcast(this._view.findChildByName(YOUR_PRICE_ICON_LEFT) , IBitmapWrapperWindow);
            if (this._creditImageElement == null)
            {
                return;
            }
            var _local_9 = 0;
            while (_local_9 < _Str_7770)
            {
                _local_11 = Std.downcast(this._controller.assets.getAssetByName(("icon_credit_" + Std.string(_local_9))) , BitmapDataAsset);
                _local_12 = ASCompat.dynamicAs(_local_11.content , BitmapData);
                this._creditImages[_local_9] = _local_12.clone();
                _local_9++;
            }
            this._Str_1480();
        }

        function _Str_9646(k:String)
        {
            var _local_2= this._view.findChildByName(k);
            _local_2.style = ActivityPointTypeEnum.getIconStyleFor(this._offer._Str_22469, this._controller.config, true);
        }

        function _Str_21389(k:WindowMouseEvent)
        {
            if (this._maybeLaterLink != null)
            {
                this._maybeLaterLink.textColor = _Str_17537;
            }
        }

        function _Str_21154(k:WindowMouseEvent)
        {
            if (this._maybeLaterLink != null)
            {
                this._maybeLaterLink.textColor = _Str_16843;
            }
        }

        function _Str_1480()
        {
            if (this._animationTriggerTimer != null)
            {
                this._Str_9128();
            }
            this._Str_9300();
            this._animationTriggerTimer = new Timer(_Str_17359);
            this._animationTriggerTimer.addEventListener(TimerEvent.TIMER, (this._Str_24007 : ASAny));
            this._animationTriggerTimer.start();
        }

        function _Str_9128()
        {
            this._animationFrame = 0;
            this._animationLoop = 0;
            if (this._animationFrameTimer != null)
            {
                this._animationFrameTimer.stop();
                this._animationFrameTimer = null;
            }
            if (this._animationTriggerTimer != null)
            {
                this._animationTriggerTimer.stop();
                this._animationTriggerTimer = null;
            }
        }

        function _Str_9300()
        {
            if (this._creditImageElement == null)
            {
                return;
            }
            if (this._creditImageElement.bitmap != null)
            {
                this._creditImageElement.bitmap.dispose();
            }
            if (this._animationFrame < _Str_7770)
            {
                this._creditImageElement.bitmap = new BitmapData(this._creditImageElement.width, this._creditImageElement.height, true, 0);
                this._creditImageElement.bitmap.copyPixels(this._creditImages[this._animationFrame], this._creditImages[this._animationFrame].rect, new Point(0, 0));
            }
            else
            {
                Logger.log([("Animation frame " + Std.string(this._animationFrame))]);
            }
        }

        function _Str_21014()
        {
            this._animationFrameTimer = new Timer(_Str_17942, (_Str_7770 - 1));
            this._animationFrameTimer.addEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
            this._animationFrameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
            this._animationFrameTimer.start();
        }

        function _Str_24007(k:TimerEvent)
        {
            this._Str_21014();
        }

        function onTimer(k:TimerEvent)
        {
            this._animationFrame = (this._animationFrame + 1);
            this._Str_9300();
        }

        function onTimerComplete(k:TimerEvent)
        {
            if (this._animationFrameTimer != null)
            {
                this._animationFrameTimer.stop();
                this._animationFrameTimer = null;
            }
            this._animationFrame = 0;
            this._Str_9300();
            if (this._animationLoop == 0)
            {
                this._animationLoop = 1;
                this._Str_21014();
            }
            else
            {
                this._animationLoop = 0;
            }
        }

        function _Str_16777(k:String):BitmapData
        {
            var _local_2= Std.downcast(this._controller.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData);
            }
            return null;
        }

        function _Str_14412(k:String, _arg_2:BitmapData)
        {
            var _local_3= Std.downcast(this._view.findChildByName(k) , IBitmapWrapperWindow);
            if (_local_3.bitmap != null)
            {
                _local_3.bitmap.dispose();
            }
            if (((!(_arg_2 == null)) && (!(_local_3 == null))))
            {
                if (_local_3.width != _arg_2.width)
                {
                    _local_3.width = _arg_2.width;
                }
                if (_local_3.height != _arg_2.height)
                {
                    _local_3.height = _arg_2.height;
                }
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0);
                _local_3.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(0, 0));
            }
        }

        function _Str_22657(k:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:ASFunction):Bool
        {
            var _local_6= this._Str_16777(_arg_2);
            if (_local_6 != null)
            {
                this._Str_14412(k, _local_6);
                return true;
            }
            var _local_7= new URLRequest(_arg_3);
            var _local_8= this._controller.assets.loadAssetFromFile(_arg_2, _local_7, _arg_4);
            if (_local_8 == null)
            {
                return false;
            }
            _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, _arg_5);
            return true;
        }

        function _Str_25165(k:AssetLoaderEvent)
        {
            var _local_2:AssetLoaderStruct = null;
            var _local_3:BitmapData = null;
            if (!this._disposed)
            {
                _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
                if (_local_2 != null)
                {
                    _local_3 = this._Str_16777(_local_2.assetName);
                    this._Str_14412("club_teaser", _local_3);
                }
            }
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((((!(k != null)) || (!(_arg_2 != null))) || (!(this._controller != null))) || (!(this._offer != null))) || this._disposed))
            {
                return;
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "buy_now_button":
                    this._controller._Str_11237();
                    return;
                case "header_button_close"
                   | "maybe_later_region":
                    this._controller._Str_4504();
                    return;
            }
        }

        function createWindow(k:String):IWindow
        {
            if (((((!(this._controller != null)) || (!(this._controller.assets != null))) || (!(this._controller.windowManager != null))) || this._disposed))
            {
                return null;
            }
            var _local_2= Std.downcast(this._controller.assets.getAssetByName(k) , XmlAsset);
            if (((!(_local_2 != null)) || (!_local_2.content)))
            {
                return null;
            }
            var _local_3= ((_local_2.content : com.sulake.core.utils.xml.XML) );
            if (_local_3 == null)
            {
                return null;
            }
            return this._controller.windowManager.buildFromXML(_local_3);
        }
    }

