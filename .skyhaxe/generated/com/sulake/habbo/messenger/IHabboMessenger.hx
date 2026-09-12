package com.sulake.habbo.messenger
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboMessenger extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        function isOpen():Bool;
        function toggleMessenger():Void;
        function startConversation(_arg_1:Int):Void;
        function closeConversation(_arg_1:Int):Void;
        function setFollowingAllowed(_arg_1:Int, _arg_2:Bool):Void;
        function setOnlineStatus(_arg_1:Int, _arg_2:Bool):Void;
        function getUnseenMiniMailMessageCount():Int;
        function getRoomInvitesIgnored():Bool;
        function setRoomInvitesIgnored(_arg_1:Bool):Void;
        var hasfriendsListInitialized(get,never):Bool;
    }

