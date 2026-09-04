package com.sulake.core.window
;
    import com.sulake.core.window.utils.IIterable;
    import flash.geom.Point;

     interface IWindowContainer extends IWindow extends  IIterable 
    {
        var numChildren(get,never):Int;
        function addChild(_arg_1:IWindow):IWindow;
        function addChildAt(_arg_1:IWindow, _arg_2:Int):IWindow;
        function getChildAt(_arg_1:Int):IWindow;
        function getChildByID(_arg_1:Int):IWindow;
        function getChildByTag(_arg_1:String):IWindow;
        function getChildByName(_arg_1:String):IWindow;
        function getChildIndex(_arg_1:IWindow):Int;
        function findChildByTag(_arg_1:String):IWindow;
        function findChildByName(_arg_1:String):IWindow;
        function removeChild(_arg_1:IWindow):IWindow;
        function removeChildAt(_arg_1:Int):IWindow;
        function setChildIndex(_arg_1:IWindow, _arg_2:Int):Void;
        function swapChildren(_arg_1:IWindow, _arg_2:IWindow):Void;
        function swapChildrenAt(_arg_1:Int, _arg_2:Int):Void;
        function groupChildrenWithID(_arg_1:UInt, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
        function groupChildrenWithTag(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
        function getChildUnderPoint(_arg_1:Point):IWindow;
        function groupChildrenUnderPoint(_arg_1:Point, _arg_2:Array<ASAny>):Void;
    }

