package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.core.window.IWindowContainer;

     interface ITabPageDecorator 
    {
        function refreshCustomContent(_arg_1:IWindowContainer):Void;
        function tabSelected():Void;
        function navigatorOpenedWhileInTab():Void;
        function refreshFooter(_arg_1:IWindowContainer):Void;
        var filterCategory(get,never):String;
        function setSubSelection(_arg_1:Int):Void;
        function processSearchParam(_arg_1:String):String;
    }

