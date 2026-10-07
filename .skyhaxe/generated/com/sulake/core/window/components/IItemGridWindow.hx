package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.IIterable;

     interface IItemGridWindow extends IWindow extends  IScrollableWindow extends  IIterable 
    {
                var spacing(get,set):Int;
        var verticalSpacing(never,set):Int;
                var scaleToFitItems(get,set):Bool;
                var autoArrangeItems(get,set):Bool;
                var resizeOnItemUpdate(get,set):Bool;
        var numColumns(get,never):UInt;
        var numRows(get,never):UInt;
        var numGridItems(get,never):UInt;
        function addGridItem(_arg_1:IWindow):IWindow;
        function addGridItemAt(_arg_1:IWindow, _arg_2:UInt):IWindow;
        function getGridItemAt(_arg_1:UInt):IWindow;
        function getGridItemByID(_arg_1:UInt):IWindow;
        function getGridItemByName(_arg_1:String):IWindow;
        function getGridItemByTag(_arg_1:String):IWindow;
        function getGridItemIndex(_arg_1:IWindow):Int;
        function removeGridItem(_arg_1:IWindow):IWindow;
        function removeGridItemAt(_arg_1:Int):IWindow;
        function setGridItemIndex(_arg_1:IWindow, _arg_2:Int):Void;
        function swapGridItems(_arg_1:IWindow, _arg_2:IWindow):Void;
        function swapGridItemsAt(_arg_1:Int, _arg_2:Int):Void;
        function removeGridItems():Void;
        function destroyGridItems():Void;
                var shouldRebuildGridOnResize(get,set):Bool;
        function rebuildGridStructure():Void;
                var containerResizeToColumns(get,set):Bool;
        function populate(_arg_1:Array<ASAny>):Void;
    }

