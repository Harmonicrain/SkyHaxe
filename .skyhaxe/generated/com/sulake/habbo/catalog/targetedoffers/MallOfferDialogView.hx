package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.targetedoffers.data.HabboMallOffer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class MallOfferDialogView 
    {
        var _controller:OfferController;
        var _window:IWindowContainer;
        var _offer:HabboMallOffer;

        public function new(k:OfferController, _arg_2:HabboMallOffer)
        {
            var _local_3:String = null;
            this._controller = k;
            this._offer = _arg_2;
            this._window = cast(this._controller.catalog.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._controller.catalog.assets.getAssetByName("targeted_offer_habbomall_xml").content)), IWindowContainer);
            cast(this._window, IFrameWindow).title.text = this.getLocalization(this._offer.title);
            cast(this._window.findChildByName("txt_title"), ITextWindow).text = this.getLocalization(this._offer.title);
            if ((ASCompat.stringAsBool(_arg_2.imageUrl) && (_arg_2.imageUrl.length > 0)))
            {
                _local_3 = this._controller.catalog .getProperty("image.library.url");
                cast(this._window.findChildByName("bmp_illustration"), IStaticBitmapWrapperWindow).assetUri = (_local_3 + _arg_2.imageUrl);
            }
            this._window.procedure = this.onInput;
            this._window.center();
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(this._controller != null)) || (!(this._offer != null))))
            {
                return;
            }
            if (k.type == WindowMouseEvent.DOWN)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close":
                        this._controller.onHabboMallOfferClosed(this._offer);
                        return;
                    case "btn_buy":
                        this._controller.onHabboMallOfferOpened(this._offer);
                        return;
                }
            }
        }

        function getLocalization(k:String, _arg_2:String=null):String
        {
            return this._controller.catalog.localization.getLocalization(k, (if (ASCompat.stringAsBool(_arg_2)) _arg_2; else k));
        }
    }

