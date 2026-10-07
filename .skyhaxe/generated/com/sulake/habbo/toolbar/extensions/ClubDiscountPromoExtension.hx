package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetHabboClubExtendOfferMessageComposer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.core.window.components.IIconWindow;

     class ClubDiscountPromoExtension 
    {
        static inline final CLUB_PROMO= "club_promo";
        static inline final _Str_3830= 14;
        static inline final _Str_4086:UInt = 0xFFFFFF;
        static inline final _Str_4030:UInt = 12247545;

        var _toolbar:HabboToolbar;
        var _view:IWindowContainer;
        var _disposed:Bool = false;
        var _animElement:IBitmapWrapperWindow;
        var _animTimer:Timer;
        var _animTickCount:Int = 0;
        var _animBlockMoveAmount:Int = 0;
        var _triggerTimer:Timer;
        var _animBitmap:BitmapData;
        var _expirationTimer:Timer;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
        }

        function createWindow():IWindowContainer
        {
            var _local_3:IRegionWindow = null;
            var _local_4:IAsset = null;
            var k:IWindowContainer = null;
            var _local_2= Std.downcast(this._toolbar.assets.getAssetByName("club_discount_promotion_xml") , XmlAsset);
            if (_local_2 != null)
            {
                k = Std.downcast(this._toolbar.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ), 1) , IWindowContainer);
                if (k != null)
                {
                    this._animElement = Std.downcast(k.findChildByName("flashing_animation") , IBitmapWrapperWindow);
                    if (this._animElement != null)
                    {
                        _local_4 = this._toolbar.assets.getAssetByName("extend_hilite_png") ;
                        if (_local_4 != null)
                        {
                            this._animBitmap = ASCompat.dynamicAs(_local_4.content , BitmapData);
                            if (this._animBitmap != null)
                            {
                                this._animElement.bitmap = this._animBitmap.clone();
                            }
                        }
                        this._animElement.visible = false;
                    }
                    _local_3 = Std.downcast(k.findChildByName("text_region") , IRegionWindow);
                    if (_local_3 != null)
                    {
                        _local_3.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClicked);
                        _local_3.addEventListener(WindowMouseEvent.OVER, this._Str_14217);
                        _local_3.addEventListener(WindowMouseEvent.OUT, this._Str_13749);
                    }
                    this._Str_6881();
                }
            }
            return k;
        }

        function destroyWindow()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
                this._animElement = null;
            }
            this.animate(false);
            this.destroyExpirationTimer();
        }

        public function dispose()
        {
            if ((this._disposed || (!(this._toolbar != null))))
            {
                return;
            }
            if (this._toolbar.extensionView != null)
            {
                this._toolbar.extensionView.detachExtension(CLUB_PROMO);
            }
            this._Str_9128();
            this.destroyWindow();
            this._toolbar = null;
            this._disposed = true;
        }

        function onTextRegionClicked(k:WindowMouseEvent)
        {
            if (this._toolbar.inventory.clubLevel == HabboClubLevelEnum.VIP)
            {
                this._toolbar.connection.send(new EventLogMessageComposer("DiscountPromo", "discount", "client.club.extend.discount.clicked"));
                this._toolbar.connection.send(new GetHabboClubExtendOfferMessageComposer());
            }
        }

        function _Str_6881()
        {
            switch (this._toolbar.inventory.clubLevel)
            {
                case HabboClubLevelEnum.NO_CLUB:
                    this.setText("${discount.bar.no.club.promo}");
                    this._Str_5997(_Str_3830);
                    
                case HabboClubLevelEnum.VIP:
                    this.setText("${discount.bar.vip.expiring}");
                    this._Str_5997(_Str_3830);
                    
            }
            this.animate(true);
        }

        public function _Str_5219(k:HabboInventoryHabboClubEvent)
        {
            if (((this._toolbar.inventory.clubIsExpiring && (!(this._view != null))) && this._Str_17305()))
            {
                this._view = this.createWindow();
                if (this._expirationTimer != null)
                {
                    this.destroyExpirationTimer();
                }
                if (((this._toolbar.inventory.clubMinutesUntilExpiration < 1440) && (this._toolbar.inventory.clubMinutesUntilExpiration > 0)))
                {
                    this._expirationTimer = new Timer(((this._toolbar.inventory.clubMinutesUntilExpiration * 60) * 1000), 1);
                    this._expirationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_12398 : ASAny));
                    this._expirationTimer.start();
                }
                this._Str_6881();
                this._toolbar.extensionView.attachExtension(CLUB_PROMO, this._view, ExtensionFixedSlotsEnum._Str_8642);
            }
            else
            {
                this._toolbar.extensionView.detachExtension(CLUB_PROMO);
                this.destroyWindow();
            }
        }

        function destroyExpirationTimer()
        {
            if (this._expirationTimer != null)
            {
                this._expirationTimer.stop();
                this._expirationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_12398 : ASAny));
                this._expirationTimer = null;
            }
        }

        function _Str_12398(k:TimerEvent)
        {
            this._toolbar.extensionView.detachExtension(CLUB_PROMO);
            this.destroyWindow();
        }

        function _Str_17305():Bool
        {
            if (((this._toolbar.inventory.clubLevel == HabboClubLevelEnum.VIP) && this._toolbar.getBoolean("club.membership.extend.vip.promotion.enabled")))
            {
                return true;
            }
            return false;
        }

        function setText(k:String)
        {
            var _local_2:ITextWindow = null;
            var _local_3:ITextWindow = null;
            if (this._view != null)
            {
                _local_2 = Std.downcast(this._view.findChildByName("promo_text") , ITextWindow);
                _local_3 = Std.downcast(this._view.findChildByName("promo_text_shadow") , ITextWindow);
                if (_local_2 != null)
                {
                    _local_2.text = k;
                }
                if (_local_3 != null)
                {
                    _local_3.text = k;
                }
            }
        }

        function animate(k:Bool)
        {
            if (k)
            {
                Logger.log(["Animate window"]);
                if (this._triggerTimer != null)
                {
                    this._triggerTimer.stop();
                }
                this._triggerTimer = new Timer(15000);
                this._triggerTimer.addEventListener(TimerEvent.TIMER, (this._Str_23307 : ASAny));
                this._triggerTimer.start();
            }
            else
            {
                if (this._triggerTimer != null)
                {
                    this._triggerTimer.stop();
                    this._triggerTimer = null;
                }
                this._Str_9128();
            }
        }

        function _Str_9128()
        {
            if (this._animElement != null)
            {
                this._animElement.visible = false;
                this._animElement.bitmap = null;
                this._animElement = null;
                this._view.invalidate();
                if (this._animTimer != null)
                {
                    this._animTimer.stop();
                    this._animTimer = null;
                }
            }
        }

        function _Str_23307(k:TimerEvent)
        {
            if (this._animElement != null)
            {
                if (this._animElement.context != null)
                {
                    this._animElement.visible = true;
                    this._Str_22649();
                    this._Str_25483();
                }
            }
        }

        function _Str_22649()
        {
            this._animElement.x = 3;
            this._animElement.y = 3;
            this._animElement.bitmap = this._animBitmap.clone();
            this._animElement.height = (this._view.height - 6);
            this._animElement.width = this._animElement.bitmap.width;
            this._animElement.invalidate();
            this._animBlockMoveAmount = ((this._view.width - 7) - this._animElement.bitmap.width);
            this._animTickCount = 0;
        }

        function _Str_25483()
        {
            this._animTimer = new Timer(25, 26);
            this._animTimer.addEventListener(TimerEvent.TIMER, (this._Str_14894 : ASAny));
            this._animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_17342 : ASAny));
            this._animTimer.start();
        }

        function _Str_14894(k:TimerEvent)
        {
            var _local_2 = 0;
            var _local_3:BitmapData = null;
            this._animElement.x = Std.int(3 + ((this._animTickCount / 20) * this._animBlockMoveAmount));
            if (this._animElement.x > this._animBlockMoveAmount)
            {
                _local_2 = ((this._view.width - 4) - this._animElement.x);
                _local_3 = new BitmapData(_local_2, this._animBitmap.height);
                _local_3.copyPixels(this._animBitmap, new Rectangle(0, 0, _local_2, this._animBitmap.height), new Point(0, 0));
                this._animElement.bitmap = _local_3;
                this._animElement.width = _local_2;
            }
            this._animElement.invalidate();
            this._animTickCount++;
        }

        function _Str_17342(k:TimerEvent)
        {
            this._Str_9128();
        }

        function _Str_5997(k:Int)
        {
            var _local_2:IIconWindow = null;
            if (this._view != null)
            {
                _local_2 = Std.downcast(this._view.findChildByName("club_icon") , IIconWindow);
                if (_local_2 != null)
                {
                    _local_2.style = k;
                    _local_2.invalidate();
                }
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







