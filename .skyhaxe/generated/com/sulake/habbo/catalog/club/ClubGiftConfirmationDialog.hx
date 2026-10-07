package com.sulake.habbo.catalog.club
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;

     class ClubGiftConfirmationDialog 
    {
        var _offer:IPurchasableOffer;
        var _controller:ClubGiftController;
        var _view:IFrameWindow;

        public function new(k:ClubGiftController, _arg_2:IPurchasableOffer)
        {
            this._offer = _arg_2;
            this._controller = k;
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
            this._view = Std.downcast(this.createWindow("club_gift_confirmation") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            this._view.procedure = this._Str_3545;
            this._view.center();
            var k= Std.downcast(this._view.findChildByName("item_name") , ITextWindow);
            if (k != null)
            {
                k.text = this._Str_25688();
            }
            var _local_2= Std.downcast(this._view.findChildByName("image_border") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            if (this._offer.productContainer == null)
            {
                return;
            }
            this._offer.productContainer.view = _local_2;
            this._offer.productContainer.initProductIcon(this._controller.roomEngine);
        }

        function _Str_25688():String
        {
            var k:IProductData = null;
            if (((this._offer != null) && (this._offer.product != null)))
            {
                k = this._offer.product.productData;
                if (k != null)
                {
                    return k.name;
                }
            }
            return "";
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            if (((((!(k != null)) || (!(_arg_2 != null))) || (!(this._controller != null))) || (!(this._offer != null))))
            {
                return;
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "select_button":
                    this._controller._Str_11237(this._offer.localizationId);
                    return;
                case "header_button_close"
                   | "cancel_button":
                    this._controller._Str_4504();
                    return;
            }
        }

        function createWindow(k:String):IWindow
        {
            if ((((!(this._controller != null)) || (!(this._controller.assets != null))) || (!(this._controller.windowManager != null))))
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






