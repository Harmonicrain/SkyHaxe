package com.hurlant.crypto.symmetric
;
    import flash.utils.ByteArray;

     interface ICipher 
    {
        function getBlockSize():UInt;
        function encrypt(src:com.sulake.core.utils.ByteArray):Void;
		function decrypt(src:com.sulake.core.utils.ByteArray):Void;
		function dispose():Void;
		function toString():String;
    }

