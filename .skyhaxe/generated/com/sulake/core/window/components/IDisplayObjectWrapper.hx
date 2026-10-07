package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import flash.display.DisplayObject;

     interface IDisplayObjectWrapper extends IWindow 
    {
        function setDisplayObject(_arg_1:DisplayObject):Void;
        function getDisplayObject():DisplayObject;
    }

