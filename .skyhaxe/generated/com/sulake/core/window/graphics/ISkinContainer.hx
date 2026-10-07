package com.sulake.core.window.graphics
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import com.sulake.core.window.utils.DefaultAttStruct;

     interface ISkinContainer extends IDisposable 
    {
        function _Str_18054(_arg_1:UInt, _arg_2:UInt):ISkinRenderer;
        function _Str_21732(_arg_1:UInt, _arg_2:UInt):DefaultAttStruct;
        function _Str_15965(_arg_1:UInt, _arg_2:UInt, _arg_3:UInt):UInt;
    }

