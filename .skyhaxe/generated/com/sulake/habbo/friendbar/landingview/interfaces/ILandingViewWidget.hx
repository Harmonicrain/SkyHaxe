package com.sulake.habbo.friendbar.landingview.interfaces
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;

     interface ILandingViewWidget extends IDisposable 
    {
        function initialize():Void;
        function refresh():Void;
        var container(get,never):IWindow;
    }

