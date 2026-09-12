package com.sulake.core.window.components
;
     interface ITextFieldWindow extends ITextWindow extends  IFocusWindow extends  IInteractiveWindow 
    {
                var editable(get,set):Bool;
                var selectable(get,set):Bool;
                var displayAsPassword(get,set):Bool;
                var _Str_16747(get,set):Bool;
        function setSelection(_arg_1:Int, _arg_2:Int):Void;
        var selectionBeginIndex(get,never):Int;
        var selectionEndIndex(get,never):Int;
                var restrict(get,set):String;
        function requestChangeEvent():Void;
        function getWordAt(_arg_1:Int, _arg_2:Int):String;
    }

