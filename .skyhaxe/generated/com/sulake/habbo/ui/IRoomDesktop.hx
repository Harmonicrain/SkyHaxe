package com.sulake.habbo.ui
;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.IRoomWidget;
    import flash.geom.Rectangle;

     interface IRoomDesktop 
    {
        var events(get,never):IEventDispatcher;
        function processEvent(_arg_1:Event):Void;
        var roomSession(get,never):IRoomSession;
        function processWidgetMessage(_arg_1:RoomWidgetMessage):RoomWidgetUpdateEvent;
        function getWidget(_arg_1:String):IRoomWidget;
        function createWidget(_arg_1:String):Void;
        function disposeWidget(_arg_1:String):Void;
        function getFirstCanvasId():Int;
        function getRoomViewRect():Rectangle;
        function getCurrentRoomCanvasZoomScale():Float;
        function canZoomRoomCanvas(_arg_1:Int):Bool;
        function zoomRoomCanvas(_arg_1:Int):Void;
    }

