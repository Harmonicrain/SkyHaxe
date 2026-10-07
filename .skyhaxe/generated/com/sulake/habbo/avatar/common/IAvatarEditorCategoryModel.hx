package com.sulake.habbo.avatar.common
;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.inventory.IHabboInventory;

     interface IAvatarEditorCategoryModel 
    {
        function dispose():Void;
        function reset():Void;
        var controller(get,never):HabboAvatarEditor;
        function getWindowContainer():IWindow;
        function switchCategory(_arg_1:String=""):Void;
        function getCategoryData(_arg_1:String):CategoryData;
        function selectPart(_arg_1:String, _arg_2:Int):Void;
        function selectColor(_arg_1:String, _arg_2:Int, _arg_3:Int):Void;
        function _Str_20411(_arg_1:Int):Bool;
        function _Str_7960(_arg_1:IHabboInventory):Bool;
        function _Str_15298(_arg_1:Int):Bool;
        function _Str_8360():Bool;
    }

