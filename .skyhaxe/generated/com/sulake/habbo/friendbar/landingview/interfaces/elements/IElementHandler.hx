package com.sulake.habbo.friendbar.landingview.interfaces.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     interface IElementHandler 
    {
        function initialize(_arg_1:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget):Void;
        function refresh():Void;
    }

