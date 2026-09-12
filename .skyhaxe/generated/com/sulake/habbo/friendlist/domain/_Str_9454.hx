package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist._Str_6567;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.notifications.IHabboNotifications;

     interface _Str_9454 
    {
        var view(get,never):_Str_6567;
        var messenger(get,never):IHabboMessenger;
        var notifications(get,never):IHabboNotifications;
    }

