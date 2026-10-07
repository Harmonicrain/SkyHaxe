package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.habbo.catalog.targetedoffers.data.HabboMallOffer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class MallOfferMinimizedView extends OfferView 
    {
        static inline final _Str_5155= "targetedoffers/offer_default_icon.png";

        var _mallOffer:HabboMallOffer;

        public function new(k:OfferController, _arg_2:HabboMallOffer)
        {
            super(k, null);
            this._mallOffer = _arg_2;
            _window = cast(_controller.catalog.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_controller.catalog.assets.getAssetByName("targeted_offer_minimized_xml").content)), IWindowContainer);
            var _local_3= cast(_window.findChildByName("txt_title"), ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = getLocalization(_arg_2.title);
            }
            var _local_4= _controller.catalog .getProperty("image.library.url");
            cast(_window.findChildByName("bmp_icon"), IStaticBitmapWrapperWindow).assetUri = (_local_4 + _Str_5155);
            _window.procedure = this.onInput;
            _controller.attachExtension(_window);
        }

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            if (_controller == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.DOWN)
            {
                _controller.maximizeMallOffer(this._mallOffer);
_arg_2.name;            }
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return _window;
        }
    }

