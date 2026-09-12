package com.sulake.habbo.ui.widget
;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.IWindow;

     interface IRoomWidget 
    {
        var state(get,never):Int;
        function initialize(_arg_1:Int=0):Void;
        function dispose():Void;
        var messageListener(never,set):IRoomWidgetMessageListener;
        function registerUpdateEvents(_arg_1:IEventDispatcher):Void;
        function unregisterUpdateEvents(_arg_1:IEventDispatcher):Void;
        var mainWindow(get,never):IWindow;
    }

