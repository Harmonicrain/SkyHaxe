package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;

     interface ISelectorWindow extends IWindow 
    {
        var numSelectables(get,never):UInt;
        function getSelected():ISelectableWindow;
        function setSelected(_arg_1:ISelectableWindow):Void;
        function addSelectable(_arg_1:ISelectableWindow):ISelectableWindow;
        function addSelectableAt(_arg_1:ISelectableWindow, _arg_2:Int):ISelectableWindow;
        function getSelectableAt(_arg_1:Int):ISelectableWindow;
        function getSelectableByID(_arg_1:UInt):ISelectableWindow;
        function getSelectableByTag(_arg_1:String):ISelectableWindow;
        function getSelectableByName(_arg_1:String):ISelectableWindow;
        function getSelectableIndex(_arg_1:ISelectableWindow):Int;
        function removeSelectable(_arg_1:ISelectableWindow):ISelectableWindow;
    }

