package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.components.IBorderWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.toolbar.IExtensionView;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetHabboClubExtendOfferMessageComposer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;

     class CitizenshipVipDiscountPromoExtension 
    {
        var _toolbar:HabboToolbar;
        var _view:IBorderWindow;
        var _expanded:Bool = true;
        var _originalHeight:Int = 216;
        var _expirationTimer:Timer;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
        }

        function createWindow():IBorderWindow
        {
            var k:IBorderWindow = null;
            var _local_2= this._toolbar.assets.getAssetByName("vip_discount_promotion_v2_xml");
            if (_local_2 != null)
            {
                k = Std.downcast(this._toolbar.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ), 1) , IBorderWindow);
                if (k != null)
                {
                    cast(k.findChildByName("extend_button"), IButtonWindow).addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                    cast(k.findChildByName("minimize_region"), IRegionWindow).addEventListener(WindowMouseEvent.CLICK, this._Str_12174);
                    cast(k.findChildByName("maximize_region"), IRegionWindow).addEventListener(WindowMouseEvent.CLICK, this._Str_12174);
                    this._originalHeight = k.height;
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
            }
            this.destroyExpirationTimer();
        }

        var extensionView(get,never):IExtensionView;
function  get_extensionView():IExtensionView
        {
            return this._toolbar.extensionView;
        }

        public function dispose()
        {
            if (this._toolbar == null)
            {
                return;
            }
            if (this.extensionView != null)
            {
                this.extensionView.detachExtension(ToolbarDisplayExtensionIds.CLUB_PROMO);
            }
            this.destroyWindow();
            this._toolbar = null;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            if (this._toolbar.inventory.clubLevel == HabboClubLevelEnum.VIP)
            {
                this._toolbar.connection.send(new EventLogMessageComposer("DiscountPromo", "citizenshipdiscount", "client.club.extend.discount.clicked"));
                this._toolbar.connection.send(new GetHabboClubExtendOfferMessageComposer());
            }
        }

        function _Str_6881()
        {
            this._view.findChildByName("content_itemlist").visible = this._expanded;
            this._view.findChildByName("promo_img").visible = this._expanded;
            this._view.height = (this._expanded ? this._originalHeight : 33);
        }

        public function _Str_5219(k:HabboInventoryHabboClubEvent)
        {
            if (((this._toolbar.inventory.citizenshipVipIsExpiring && (this._view == null)) && this._Str_17305()))
            {
                this._view = this.createWindow();
                if (this._expirationTimer != null)
                {
                    this.destroyExpirationTimer();
                }
                if (((this._toolbar.inventory.clubMinutesUntilExpiration < 1440) && (this._toolbar.inventory.clubMinutesUntilExpiration > 0)))
                {
                    this._expirationTimer = new Timer(((this._toolbar.inventory.clubMinutesUntilExpiration * 60) * 1000), 1);
                    this._expirationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                    this._expirationTimer.start();
                }
                this._Str_6881();
                if (!this._toolbar.extensionView.hasExtension(ToolbarDisplayExtensionIds.VIP_QUESTS))
                {
                    this._toolbar.extensionView.attachExtension(ToolbarDisplayExtensionIds.CLUB_PROMO, this._view, ExtensionFixedSlotsEnum._Str_8642);
                }
            }
            else
            {
                this._toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.VIP_QUESTS);
                this.destroyWindow();
            }
        }

        function destroyExpirationTimer()
        {
            if (this._expirationTimer != null)
            {
                this._expirationTimer.stop();
                this._expirationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._expirationTimer = null;
            }
        }

        function onTimerComplete(k:TimerEvent)
        {
            this._toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.CLUB_PROMO);
            this.destroyWindow();
        }

        function _Str_17305():Bool
        {
            return (this._toolbar.inventory.clubLevel == HabboClubLevelEnum.VIP) && this._toolbar.getBoolean("club.membership.extend.vip.promotion.enabled");
        }

        function _Str_12174(k:WindowMouseEvent)
        {
            this._expanded = (!this._expanded);
            this._Str_6881();
        }
    }





