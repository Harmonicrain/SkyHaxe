package com.sulake.room
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import flash.events.IEventDispatcher;

     interface IRoomObjectFactory extends IUnknown 
    {
        function addObjectEventListener(_arg_1:ASFunction):Void;
        function removeObjectEventListener(_arg_1:ASFunction):Void;
        function createRoomObjectLogic(_arg_1:String):IRoomObjectEventHandler;
        function createRoomObjectManager():IRoomObjectManager;
        var events(get,never):IEventDispatcher;
    }

