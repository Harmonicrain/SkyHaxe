package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class RewardBadgeElementHandler implements IElementHandler 
    {


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            var _local_5:String = _arg_3[2];
            var _local_6= cast(_arg_2, IWindowContainer);
            _local_6.findChildByName("badge_desc").caption = (("${" + _local_5) + "}");
            var _local_7= cast(_local_6.findChildByName("badge_image"), IStaticBitmapWrapperWindow);
            var _local_8:ASAny = (("${image.library.url}album1584/" + _arg_3[1]) + ".gif");
            Logger.log([("IMAGE: " + _local_8)]);
            _local_7.assetUri = _local_8;
        }

        public function refresh()
        {
        }
public function new(){}
    }

