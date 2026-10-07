package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.targetedoffers.data.TargetedOffer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowEvent;

     class TargetedOfferPurchaseConfirmationView extends OfferView 
    {
        var _quantity:Int = 0;

        public function new(k:OfferController, _arg_2:TargetedOffer, _arg_3:Int)
        {
            super(k, _arg_2);
            this._quantity = _arg_3;
            _window = cast(_controller.catalog.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_controller.catalog.assets.getAssetByName("targeted_offer_purchase_confirmation_xml").content)), IWindowContainer);
            var _local_4= _controller.catalog ;
            if (_local_4.getBoolean("disclaimer.credit_spending.enabled"))
            {
                this._Str_3515(false);
            }
            else
            {
                _window.findChildByName("disclaimer").dispose();
                this._Str_3515(true);
            }
            cast(_window.findChildByName("product_name"), ITextWindow).text = getLocalization(_arg_2.title);
            var _local_5= Std.downcast(_window.findChildByName("purchase_cost_box") , IWindowContainer);
            _local_4.utils._Str_6455(_local_5, _arg_2, _arg_3);
            var _local_6= Std.downcast(_window.findChildByName("quantity") , ITextWindow);
            if (_local_6 != null)
            {
                if ((k.catalog.multiplePurchaseEnabled && (this._quantity > 1)))
                {
                    _local_6.text = ("X " + Std.string(this._quantity));
                }
            }
            _window.procedure = this.onInput;
            _window.center();
        }

        function _Str_3515(k:Bool)
        {
            if (_window == null)
            {
                return;
            }
            var _local_2= _window.findChildByName("select_button");
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

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            if (_controller == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.DOWN)
            {
                switch (_arg_2.name)
                {
                    case "spending_disclaimer":
                        this._Str_3515(cast(_arg_2, ICheckBoxWindow).Selected);
                        return;
                    case "header_button_close"
                       | "cancel_button":
                        _controller.maximizeOffer(_offer);
                        return;
                    case "buy_button":
                        _controller.purchaseTargetedOffer(_offer, this._quantity);
                        return;
                }
            }
        }
    }




