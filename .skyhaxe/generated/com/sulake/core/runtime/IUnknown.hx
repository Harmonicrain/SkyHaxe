package com.sulake.core.runtime
;
     interface IUnknown extends IDisposable 
    {
        function queueInterface(_arg_1:IID, _arg_2:ASFunction=null):IUnknown;
        function release(_arg_1:IID):UInt;
    }

