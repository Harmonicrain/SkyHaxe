package com.sulake.core.window.utils
;
     interface IChildEntityArray extends IChildEntityArrayReader 
    {
        function addChild(_arg_1:IChildEntity):IChildEntity;
        function addChildAt(_arg_1:IChildEntity, _arg_2:Int):IChildEntity;
        function removeChild(_arg_1:IChildEntity):IChildEntity;
        function removeChildAt(_arg_1:Int):IChildEntity;
        function setChildIndex(_arg_1:IChildEntity, _arg_2:Int):Void;
        function swapChildren(_arg_1:IChildEntity, _arg_2:IChildEntity):Void;
        function swapChildrenAt(_arg_1:Int, _arg_2:Int):Void;
    }

