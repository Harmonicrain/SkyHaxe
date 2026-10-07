package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;

     interface IBoxSizerWindow extends IWindowContainer 
    {
        function setHorizontalPadding(_arg_1:Int):Void;
        function setVerticalPadding(_arg_1:Int):Void;
        function setSpacing(_arg_1:Int):Void;
        function setVertical(_arg_1:Bool):Void;
        function setAutoRearrange(_arg_1:Bool):Void;
        function getAutoRearrange():Bool;
    }

