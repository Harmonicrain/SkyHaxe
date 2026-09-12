package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;

     interface IInteractiveWindow extends IWindow 
    {
                var toolTipCaption(get,set):String;
                var toolTipDelay(get,set):UInt;
                var _Str_4074(get,set):Bool;
        function showToolTip(_arg_1:IToolTipWindow):Void;
        function hideToolTip():Void;
        function setMouseCursorForState(_arg_1:UInt, _arg_2:UInt):UInt;
        function getMouseCursorByState(_arg_1:UInt):UInt;
    }

