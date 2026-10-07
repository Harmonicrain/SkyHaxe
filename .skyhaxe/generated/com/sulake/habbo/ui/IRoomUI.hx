package com.sulake.habbo.ui
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.IWindow;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

     interface IRoomUI extends IUnknown 
    {
        function createDesktop(_arg_1:IRoomSession):IRoomDesktop;
        var chatContainer(get,never):IDisplayObjectWrapper;
        function disposeDesktop(_arg_1:String):Void;
        function getDesktop(_arg_1:String):IRoomDesktop;
        function getActiveCanvasId(_arg_1:Int):Int;
        var visible(never,set):Bool;
        function hideWidget(_arg_1:String):Void;
        function showGamePlayerName(_arg_1:Int, _arg_2:String, _arg_3:UInt, _arg_4:Int):Void;
        function hideAvatarInfo():Void;
        function createSpectatorModeVisualization():IWindow;
        function getRoomViewRect():Rectangle;
        function mouseEventPositionHasContextMenu(_arg_1:MouseEvent):Bool;
        function triggerbottomBarResize():Void;
    }

