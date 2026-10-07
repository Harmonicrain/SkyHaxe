package com.sulake.habbo.friendbar.data
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboFriendBarData extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        var numFriends(get,never):Int;
        function getFriendAt(_arg_1:Int):IFriendEntity;
        function getFriendByID(_arg_1:Int):IFriendEntity;
        function getFriendByName(_arg_1:String):IFriendEntity;
        var numFriendRequests(get,never):Int;
        function getFriendRequestAt(_arg_1:Int):IFriendRequest;
        function getFriendRequestByID(_arg_1:Int):IFriendRequest;
        function getFriendRequestByName(_arg_1:String):IFriendRequest;
        function getFriendRequestList():Array<ASAny>;
        function acceptFriendRequest(_arg_1:Int):Void;
        function acceptAllFriendRequests():Void;
        function declineFriendRequest(_arg_1:Int):Void;
        function declineAllFriendRequests():Void;
        function followToRoom(_arg_1:Int):Void;
        function startConversation(_arg_1:Int):Void;
        function findNewFriends():Void;
        function openUserTextSearch():Void;
        function toggleFriendList():Void;
        function toggleMessenger():Void;
        function showProfile(_arg_1:Int):Void;
        function showProfileByName(_arg_1:String):Void;
    }

