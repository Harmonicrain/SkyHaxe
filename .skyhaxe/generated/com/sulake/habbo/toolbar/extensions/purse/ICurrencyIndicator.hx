package com.sulake.habbo.toolbar.extensions.purse
;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.IEventDispatcher;

     interface ICurrencyIndicator 
    {
        function dispose():Void;
        var window(get,never):IWindowContainer;
        function registerUpdateEvents(_arg_1:IEventDispatcher):Void;
    }

