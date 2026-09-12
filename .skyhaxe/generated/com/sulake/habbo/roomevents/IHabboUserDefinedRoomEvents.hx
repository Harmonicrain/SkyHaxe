package com.sulake.habbo.roomevents
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboUserDefinedRoomEvents extends IUnknown 
    {
        function _Str_15677(_arg_1:Int, _arg_2:String):Void;
        function userSelected(_arg_1:Int):Void;
        function furnitureSelected(_arg_1:Int):Void;
        function showInspectButton():Bool;
        function showToolbarMenuButton():Bool;
        function inspectObject(_arg_1:Int, _arg_2:Int):Void;
        function openWiredMenu(tab:String = "monitor"):Void;
        function hasClickUserWired():Bool;
        var isGameMode(get,never):Bool;
        function isWiredFeatureEnabled(_arg_1:Int):Bool;
        var events(get,never):IEventDispatcher;
    }

