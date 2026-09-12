package com.sulake.core.window.utils
;
     interface IChildEntityArrayReader 
    {
        var numChildren(get,never):Int;
        function getChildAt(_arg_1:Int):IChildEntity;
        function getChildByID(_arg_1:Int):IChildEntity;
        function getChildByName(_arg_1:String):IChildEntity;
        function getChildIndex(_arg_1:IChildEntity):Int;
        function groupChildrenWithID(_arg_1:UInt, _arg_2:Array<ASAny>):UInt;
    }

