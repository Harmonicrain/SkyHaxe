package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboGroupsManager extends IUnknown 
    {
        function showGroupBadgeInfo(_arg_1:Bool, _arg_2:Int):Void;
        function openGroupInfo(_arg_1:Int):Void;
        function updateVisibleExtendedProfile(_arg_1:Int):Void;
        function showExtendedProfile(_arg_1:Int):Void;
        var events(get,never):IEventDispatcher;
    }

