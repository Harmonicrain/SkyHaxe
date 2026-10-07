package com.sulake.habbo.ui.widget.contextmenu
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.ui.widget.IRoomWidgetMessageListener;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.friendlist.IHabboFriendsList;

     interface IContextMenuParentWidget 
    {
        var assets(get,never):IAssetLibrary;
        var windowManager(get,never):IHabboWindowManager;
        var messageListener(get,never):IRoomWidgetMessageListener;
        var catalog(get,never):IHabboCatalog;
        var friendList(get,never):IHabboFriendsList;
        function removeView(_arg_1:ContextInfoView, _arg_2:Bool):Void;
    }

