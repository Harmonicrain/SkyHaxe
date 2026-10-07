package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class ImageElementHandler implements IElementHandler 
    {


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            var _local_5= cast(_arg_2, IStaticBitmapWrapperWindow);
            var _local_6= ("${image.library.url}" + _arg_3[1]);
            _local_5.assetUri = _local_6;
            _local_5.x = ASCompat.toInt(_arg_3[2]);
        }

        public function refresh()
        {
        }
public function new(){}
    }

