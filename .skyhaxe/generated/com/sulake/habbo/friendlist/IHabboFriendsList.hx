package com.sulake.habbo.friendlist
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;

     interface IHabboFriendsList extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        function canBeAskedForAFriend(_arg_1:Int):Bool;
        function askForAFriend(_arg_1:Int, _arg_2:String):Bool;
        function getFriend(_arg_1:Int):IFriend;
        function openFriendList():Void;
        function openFriendRequests():Void;
        function openFriendSearch():Void;
        function close():Void;
        function alignBottomLeftTo(_arg_1:Point):Void;
        function isOpen():Bool;
        function currentTabId():Int;
        function getFriendCount(_arg_1:Bool, _arg_2:Bool):Int;
        function openHabboWebPage(_arg_1:String, _arg_2:ASDictionary<ASAny,ASAny>, _arg_3:Int, _arg_4:Int):Void;
        function getFriendNames():Array<ASAny>;
        function acceptFriendRequest(_arg_1:Int):Void;
        function acceptAllFriendRequests():Void;
        function declineFriendRequest(_arg_1:Int):Void;
        function declineAllFriendRequests():Void;
        var mainWindow(get,never):IWindowContainer;
        function getRelationshipStatus(_arg_1:Int):Int;
        function setRelationshipStatus(_arg_1:Int, _arg_2:Int):Void;
        var hasfriendsListInitialized(get,never):Bool;
    }

