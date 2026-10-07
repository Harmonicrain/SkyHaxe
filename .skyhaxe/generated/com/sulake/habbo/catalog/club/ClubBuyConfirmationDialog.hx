package com.sulake.habbo.catalog.club
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowEvent;

     class ClubBuyConfirmationDialog 
    {
        var _offer:ClubBuyOfferData;
        var _controller:ClubOfferHandler;
        var _view:IFrameWindow;
        var _pageId:Int = 0;

        public function new(k:ClubOfferHandler, _arg_2:ClubBuyOfferData, _arg_3:Int)
        {
            this._offer = _arg_2;
            this._controller = k;
            this._pageId = _arg_3;
            this.showConfirmation();
        }

        public function dispose()
        {
            this._controller = null;
            this._offer = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        public function showConfirmation()
        {
            if (((!(this._offer != null)) || (!(this._controller != null))))
            {
                return;
            }
            this._view = Std.downcast(this._controller.catalog.utils.createWindow("club_buy_confirmation") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            this._view.procedure = this._Str_3545;
            this._view.center();
            if (this._controller.catalog.getBoolean("disclaimer.credit_spending.enabled"))
            {
                this._Str_3515(false);
            }
            else
            {
                this._view.findChildByName("disclaimer").dispose();
                this._Str_3515(true);
            }
            var k= this._controller.localization;
            var _local_2= this._controller.getPurse();
            var _local_3= ((_local_2.hasClubLeft && _local_2.isVIP) ? "extension." : "subscription.");
            var _local_4= ((this._offer.months == 0) ? "days" : "months");
            var _local_5= (("catalog.vip.buy.confirm." + _local_3) + _local_4);
            k.registerParameter(_local_5, ("num_" + _local_4), Std.string(((this._offer.months == 0) ? this._offer._Str_15178 : this._offer.months)));
            this._view.findChildByName("subscription_name").caption = k.getLocalization(_local_5);
            k.registerParameter("catalog.vip.buy.confirm.end_date", "day", Std.string(this._offer.day));
            k.registerParameter("catalog.vip.buy.confirm.end_date", "month", Std.string(this._offer.month));
            k.registerParameter("catalog.vip.buy.confirm.end_date", "year", Std.string(this._offer.year));
            this._controller.catalog.utils._Str_6455(Std.downcast(this._view.findChildByName("purchase_cost_box") , IWindowContainer), this._offer);
        }

        function _Str_3515(k:Bool)
        {
            if (this._view == null)
            {
                return;
            }
            var _local_2= this._view.findChildByName("select_button");
            if (_local_2 == null)
            {
                return;
            }
            if (k)
            {
                _local_2.enable();
            }
            else
            {
                _local_2.disable();
            }
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            if (((((!(k != null)) || (!(_arg_2 != null))) || (!(this._controller != null))) || (!(this._offer != null))))
            {
                return;
            }
            if (((!(k.type == WindowMouseEvent.CLICK)) && (!(k.type == WindowMouseEvent.DOUBLE_CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "spending_disclaimer":
                    this._Str_3515(cast(_arg_2, ICheckBoxWindow).Selected);
                    return;
                case "select_button":
                    this._controller.catalog.doNotCloseAfterVipPurchase();
                    this._controller._Str_11237(this._offer, this._pageId);
                    return;
                case "header_button_close"
                   | "cancel_button":
                    this._controller.catalog.forgetPageDuringVipPurchase();
                    this._controller._Str_4504();
                    return;
            }
        }
    }

