package com.hurlant.crypto.prng
;
    import flash.utils.ByteArray;

     interface IPRNG 
    {
        function getPoolSize():UInt;
        function init(_arg_1:com.sulake.core.utils.ByteArray):Void;
        function next():UInt;
        function dispose():Void;
        function toString():String;
    }

