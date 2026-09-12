package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.catalog.targetedoffers.data.TargetedOffer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class TargetedOfferMinimizedView extends OfferView 
    {
        static inline final _Str_5155= "targetedoffers/offer_default_icon.png";

        public function new(k:OfferController, _arg_2:TargetedOffer)
        {
            var _local_6:IItemListWindow = null;
            super(k, _arg_2);
            _window = cast(_controller.catalog.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_controller.catalog.assets.getAssetByName("targeted_offer_minimized_xml").content)), IWindowContainer);
            var _local_3= cast(_window.findChildByName("txt_title"), ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = getLocalization(_arg_2.title);
            }
            var _local_4= _controller.catalog .getProperty("image.library.url");
            var _local_5= ((ASCompat.stringAsBool(_arg_2._Str_13452) && (_arg_2._Str_13452.length > 0)) ? _arg_2._Str_13452 : _Str_5155);
            cast(_window.findChildByName("bmp_icon"), IStaticBitmapWrapperWindow).assetUri = (_local_4 + _local_5);
            _Str_5181 = getLocalization("targeted.offer.minimized.timeleft", "");
            if (_offer.expirationTime == 0)
            {
                _local_6 = Std.downcast(_window.findChildByName("itemlist") , IItemListWindow);
                if (_local_6 != null)
                {
                    _local_6.removeListItem(_window.findChildByName("cnt_time_left"));
                }
            }
            else
            {
                _Str_13550();
            }
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
                _controller.maximizeOffer(_offer);
_arg_2.name;            }
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return _window;
        }
    }

