package com.sulake.habbo.notifications
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.utils.Map;

     interface IHabboNotifications extends IUnknown 
    {
        function addItem(message:String, style:String, iconAssetName:String=null, internalLink:String=null, extraData:ASObject=null):Void;
        function removeNotificationById(id:String):Void;
        function showNotification(_arg_1:String, _arg_2:Map=null):Void;
        function addSongPlayingNotification(_arg_1:String, _arg_2:String):Void;
    }

