package com.sulake.habbo.navigator
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;

     interface IHabboNavigator extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        function goToHomeRoom():Bool;
        function performTagSearch(_arg_1:String):Void;
        function performTextSearch(_arg_1:String):Void;
        function performGuildBaseSearch():Void;
        function performCompetitionRoomsSearch(_arg_1:Int, _arg_2:Int):Void;
        function showOwnRooms():Void;
        function goToPrivateRoom(_arg_1:Int):Void;
        function hasRoomRightsButIsNotOwner(_arg_1:Int):Bool;
        function removeRoomRights(_arg_1:Int):Void;
        function goToRoomNetwork(_arg_1:Int, _arg_2:Bool):Void;
        function startRoomCreation():Void;
        function openNavigator(_arg_1:Point=null):Void;
        function closeNavigator():Void;
        var homeRoomId(get,never):Int;
        var enteredGuestRoomData(get,never):GuestRoomData;
        function showToolbarHover(_arg_1:Point):Void;
        function hideToolbarHover(_arg_1:Bool):Void;
        function toggleRoomInfoVisibility():Void;
        function canRateRoom():Bool;
        function _Str_12281(_arg_1:Int):Bool;
        function _Str_8458(_arg_1:Int):Bool;
        var _Str_8075(get,never):Array<ASAny>;
    }

