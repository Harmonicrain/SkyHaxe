package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.IWindowContainer;

     interface IAvatarEditorCategoryView 
    {
        function dispose():Void;
        function init():Void;
        function reset():Void;
        function getWindowContainer():IWindowContainer;
        function switchCategory(_arg_1:String):Void;
        function _Str_5614(_arg_1:String, _arg_2:Int):Void;
    }

