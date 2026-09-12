package com.sulake.core.window.theme
;
     interface IThemeManager 
    {
        function getStyle(_arg_1:String, _arg_2:UInt, _arg_3:String):UInt;
        function getThemeAndIntent(_arg_1:UInt, _arg_2:UInt):ASObject;
        function getIntents(_arg_1:UInt, _arg_2:String, _arg_3:UInt):Array<ASAny>;
        function getPropertyDefaults(_arg_1:UInt):IPropertyMap;
        function getThemes():Array<ASAny>;
    }

