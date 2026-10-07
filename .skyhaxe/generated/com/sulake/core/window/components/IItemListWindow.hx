package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.IIterable;

     interface IItemListWindow extends IWindow extends  IScrollableWindow extends  IIterable 
    {
                var spacing(get,set):Int;
                var scaleToFitItems(get,set):Bool;
                var autoArrangeItems(get,set):Bool;
                var resizeOnItemUpdate(get,set):Bool;
        var numListItems(get,never):Int;
        function addListItem(_arg_1:IWindow):IWindow;
        function addListItemAt(_arg_1:IWindow, _arg_2:UInt):IWindow;
        function getListItemAt(_arg_1:UInt):IWindow;
        function getListItemByID(_arg_1:UInt):IWindow;
        function getListItemByName(_arg_1:String):IWindow;
        function getListItemByTag(_arg_1:String):IWindow;
        function getListItemIndex(_arg_1:IWindow):Int;
        function removeListItem(_arg_1:IWindow):IWindow;
        function removeListItemAt(_arg_1:Int):IWindow;
        function setListItemIndex(_arg_1:IWindow, _arg_2:Int):Void;
        function swapListItems(_arg_1:IWindow, _arg_2:IWindow):Void;
        function groupListItemsWithID(_arg_1:UInt, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
        function groupListItemsWithTag(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
        function swapListItemsAt(_arg_1:Int, _arg_2:Int):Void;
        function removeListItems():Void;
        function destroyListItems():Void;
        function arrangeListItems():Void;
        function populate(_arg_1:Array<ASAny>):Void;
        function scrollWithWheel(_arg_1:Float, _arg_2:Bool):Bool;
        function stopDragging():Void;
        var disableAutodrag(never,set):Bool;
                var isPartOfGridWindow(get,set):Bool;
        var scrollableWindow(get,never):IWindow;
    }

