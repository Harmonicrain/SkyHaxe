package com.sulake.core.window.components
;

     interface IDropMenuWindow extends IInteractiveWindow 
    {
                var selection(get,set):Int;
        var numMenuItems(get,never):Int;
        function populate(_arg_1:Array<ASAny>):Void;
        function _Str_24893(_arg_1:Vector<String>):Void;
        function items():Array<ASAny>;
        function openMenu():Void;
    }

