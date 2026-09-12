package com.sulake.habbo.friendbar.view
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.friendbar.view.tabs.ITab;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;

     interface IHabboFriendBarView extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
                var visible(get,set):Bool;
        function selectTab(_arg_1:ITab, _arg_2:Bool):Void;
        function deSelect(_arg_1:Bool):Void;
        function getAvatarFaceBitmap(_arg_1:String):BitmapData;
        function getGroupIconBitmap(_arg_1:String):BitmapData;
        function setMessengerIconNotify(_arg_1:Bool):Void;
        function setFriendListIconNotify(_arg_1:Bool):Void;
        function removeMessengerNotifications():Void;
        var friendBarWidth(get,never):Int;
        function getIconLocation(_arg_1:String):IWindowContainer;
    }

