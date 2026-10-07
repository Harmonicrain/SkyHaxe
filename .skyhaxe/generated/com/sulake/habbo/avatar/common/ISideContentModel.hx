package com.sulake.habbo.avatar.common
;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.core.window.IWindowContainer;

     interface ISideContentModel 
    {
        function dispose():Void;
        function reset():Void;
        var controller(get,never):HabboAvatarEditor;
        function getWindowContainer():IWindowContainer;
    }

