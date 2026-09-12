package com.sulake.habbo.navigator.mainview
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.navigator.TextSearchInputs;
    import flash.geom.Point;

     interface ITransitionalMainViewCtrl 
    {
        var disposed(get,never):Bool;
        function _Str_18392():Void;
        function dispose():Void;
        function open():Void;
        function isOpen():Bool;
        function close():Void;
        var mainWindow(get,never):IFrameWindow;
        function refresh():Void;
        function reloadRoomList(_arg_1:Int):Bool;
        function startSearch(_arg_1:Int, _arg_2:Int, _arg_3:String="-1", _arg_4:Int=1):Void;
        function update(_arg_1:UInt):Void;
        var searchInput(get,never):TextSearchInputs;
        function openAtPosition(_arg_1:Point):Void;
        var isPhaseOneNavigator(get,never):Bool;
    }

