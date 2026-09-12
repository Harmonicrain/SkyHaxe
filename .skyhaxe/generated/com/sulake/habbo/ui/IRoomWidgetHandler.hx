package com.sulake.habbo.ui
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     interface IRoomWidgetHandler extends IDisposable 
    {
        var type(get,never):String;
        var container(never,set):IRoomWidgetHandlerContainer;
        function getWidgetMessages():Array<ASAny>;
        function processWidgetMessage(_arg_1:RoomWidgetMessage):RoomWidgetUpdateEvent;
        function getProcessedEvents():Array<ASAny>;
        function processEvent(_arg_1:Event):Void;
        function update():Void;
    }

