package com.sulake.room.object.logic
;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.IEventDispatcher;

     interface IRoomObjectEventHandler extends IRoomObjectMouseHandler 
    {
                var object(get,set):IRoomObjectController;
        function dispose():Void;
        function initialize(_arg_1:com.sulake.core.utils.xml.XML):Void;
        function tearDown():Void;
        function update(_arg_1:Int):Void;
        function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):Void;
        function useObject():Void;
                var eventDispatcher(get,set):IEventDispatcher;
        function getEventTypes():Array<ASAny>;
        var widget(get,never):String;
        var contextMenu(get,never):String;
    }

