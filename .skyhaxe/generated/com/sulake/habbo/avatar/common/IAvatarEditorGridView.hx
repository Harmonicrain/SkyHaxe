package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.IWindowContainer;

     interface IAvatarEditorGridView 
    {
        function dispose():Void;
        var window(get,never):IWindowContainer;
        function initFromList(_arg_1:IAvatarEditorCategoryModel, _arg_2:String):Void;
        function _Str_5614(_arg_1:Int):Void;
    }

