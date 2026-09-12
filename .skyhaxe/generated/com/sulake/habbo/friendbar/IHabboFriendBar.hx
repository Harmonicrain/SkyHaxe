package com.sulake.habbo.friendbar
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboFriendBar extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        var visible(never,set):Bool;
    }

