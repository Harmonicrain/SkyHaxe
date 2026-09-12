package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.habbo.catalog.IVideoOfferLauncher;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.catalog._enum.VideoOfferTypeEnum;

     class VideoOfferExtension implements IVideoOfferLauncher 
    {
        static inline final VIDEO_OFFER= "video_offer";
        static inline final _Str_4086:UInt = 0xFFFFFF;
        static inline final _Str_4030:UInt = 12247545;
        static inline final _Str_16248:UInt = 0x666666;
        static inline final _Str_17848:UInt = 0xCCCCCC;

        var _toolbar:HabboToolbar;
        var _view:IWindowContainer;
        var _textRegion:IRegionWindow;
        var _closeButton:IIconWindow;
        var _promoClosed:Bool = false;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._view;
        }

        public function _Str_5219(k:HabboInventoryHabboClubEvent)
        {
            if (((this._toolbar.inventory.clubIsExpiring && (!(this._view != null))) && this._Str_20377()))
            {
                this._toolbar.extensionView.detachExtension(VIDEO_OFFER);
                this.destroyWindow();
                return;
            }
            if (((!this._promoClosed) && (!(this._view != null))))
            {
                this._toolbar.catalog.videoOffers.load(this);
            }
        }

        function _Str_20377():Bool
        {
            return (this._toolbar.inventory.clubLevel == HabboClubLevelEnum.VIP) && this._toolbar.getBoolean("club.membership.extend.vip.promotion.enabled");
        }

        public function offersAvailable(k:Int)
        {
            if (this._toolbar == null)
            {
                return;
            }
            if ((((k <= 0) || this._promoClosed) || (this._toolbar.inventory.clubIsExpiring && this._Str_20377())))
            {
                if (this._view != null)
                {
                    this.destroyWindow();
                }
                return;
            }
            if (this._view == null)
            {
                this._view = this.createWindow();
            }
        }

        function createWindow():IWindowContainer
        {
            var _local_3:String = null;
            var _local_4:ITextWindow = null;
            var _local_5:ITextWindow = null;
            var _local_6:BitmapDataAsset = null;
            var _local_7:BitmapData = null;
            var _local_8:IBitmapWrapperWindow = null;
            var k:IWindowContainer = null;
            var _local_2= Std.downcast(this._toolbar.assets.getAssetByName("video_offer_promotion_xml") , XmlAsset);
            if (_local_2 != null)
            {
                k = Std.downcast(this._toolbar.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ), 1) , IWindowContainer);
                if (k != null)
                {
                    _local_3 = this._toolbar.localization.getLocalization("supersaverads.video.promo.offer", "Watch a video and earn a credit!");
                    _local_4 = Std.downcast(k.findChildByName("promo_text") , ITextWindow);
                    _local_5 = Std.downcast(k.findChildByName("promo_text_shadow") , ITextWindow);
                    if (_local_4 != null)
                    {
                        _local_4.text = _local_3;
                    }
                    if (_local_5 != null)
                    {
                        _local_5.text = _local_3;
                    }
                    _local_6 = Std.downcast(this._toolbar.assets.getAssetByName("offer_icon_png") , BitmapDataAsset);
                    if (_local_6 != null)
                    {
                        _local_7 = ASCompat.dynamicAs(_local_6.content , BitmapData);
                        _local_8 = Std.downcast(k.findChildByName("promo_icon") , IBitmapWrapperWindow);
                        if (((!(_local_7 == null)) && (!(_local_8 == null))))
                        {
                            _local_8.bitmap = new BitmapData(_local_8.width, _local_8.height, true, 0);
                            _local_8.bitmap.copyPixels(_local_7, _local_7.rect, new Point(0, 0));
                        }
                    }
                    this._textRegion = Std.downcast(k.findChildByName("text_region") , IRegionWindow);
                    if (this._textRegion != null)
                    {
                        this._textRegion.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClicked);
                        this._textRegion.addEventListener(WindowMouseEvent.OVER, this._Str_14217);
                        this._textRegion.addEventListener(WindowMouseEvent.OUT, this._Str_13749);
                    }
                    this._closeButton = Std.downcast(k.findChildByName("promo_close_icon") , IIconWindow);
                    if (this._closeButton != null)
                    {
                        this._closeButton.addEventListener(WindowMouseEvent.CLICK, this._Str_14359);
                        this._closeButton.addEventListener(WindowMouseEvent.OVER, this._Str_19522);
                        this._closeButton.addEventListener(WindowMouseEvent.OUT, this._Str_21414);
                    }
                    this._toolbar.extensionView.attachExtension(VIDEO_OFFER, k, ExtensionFixedSlotsEnum._Str_8642);
                }
            }
            return k;
        }

        function destroyWindow()
        {
            if (this._view != null)
            {
                if (this._textRegion != null)
                {
                    this._textRegion.removeEventListener(WindowMouseEvent.CLICK, this.onTextRegionClicked);
                    this._textRegion.removeEventListener(WindowMouseEvent.OVER, this._Str_14217);
                    this._textRegion.removeEventListener(WindowMouseEvent.OUT, this._Str_13749);
                    this._textRegion = null;
                }
                if (this._closeButton != null)
                {
                    this._closeButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_14359);
                    this._closeButton.removeEventListener(WindowMouseEvent.OVER, this._Str_19522);
                    this._closeButton.removeEventListener(WindowMouseEvent.OUT, this._Str_21414);
                    this._closeButton = null;
                }
                this._view.dispose();
                this._view = null;
            }
        }

        public function dispose()
        {
            if (this._toolbar == null)
            {
                return;
            }
            this._toolbar.extensionView.detachExtension(VIDEO_OFFER);
            this.destroyWindow();
            this._toolbar = null;
        }

        function _Str_14359(k:WindowMouseEvent)
        {
            this._promoClosed = true;
            this.destroyWindow();
            this._toolbar.connection.send(new EventLogMessageComposer("SuperSaverAds", "client_action", "supersaverads.video.promo.close_clicked"));
        }

        function _Str_19522(k:WindowMouseEvent)
        {
            if (this._closeButton != null)
            {
                this._closeButton.color = _Str_17848;
            }
        }

        function _Str_21414(k:WindowMouseEvent)
        {
            if (this._closeButton != null)
            {
                this._closeButton.color = _Str_16248;
            }
        }

        function onTextRegionClicked(k:WindowMouseEvent)
        {
            if (!this._toolbar.catalog.videoOffers.launch(VideoOfferTypeEnum.CREDIT))
            {
                this.destroyWindow();
            }
        }

        function _Str_14217(k:WindowMouseEvent)
        {
            var _local_2:ITextWindow = null;
            if (this._view != null)
            {
                _local_2 = Std.downcast(this._view.findChildByName("promo_text") , ITextWindow);
                _local_2.textColor = _Str_4030;
            }
        }

        function _Str_13749(k:WindowMouseEvent)
        {
            var _local_2:ITextWindow = null;
            if (this._view != null)
            {
                _local_2 = Std.downcast(this._view.findChildByName("promo_text") , ITextWindow);
                _local_2.textColor = _Str_4086;
            }
        }
    }

