package com.sulake.habbo.inventory
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

     interface IInventoryModel extends IDisposable 
    {
        function getWindowContainer():IWindowContainer;
        function onInventoryOpen():Void;
        function initCategory(_arg_1:String):Void;
        function onCategorySwitch(_arg_1:String):Void;
        function onInventoryClose():Void;
        function updateView():Void;
        function onSubcategorySwitch(_arg_1:String):Void;
    }

