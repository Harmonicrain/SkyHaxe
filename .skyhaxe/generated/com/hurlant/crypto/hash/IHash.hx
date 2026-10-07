package com.hurlant.crypto.hash
;
    import flash.utils.ByteArray;

     interface IHash 
    {
        function getInputSize():UInt;
        function getHashSize():UInt;
        function hash(_arg_1:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray;
        function toString():String;
        function getPadSize():Int;
    }

