package com.sulake.core.communication.encryption
;
    import flash.utils.ByteArray;

     interface IEncryption 
    {
        function init(_arg_1:com.sulake.core.utils.ByteArray):Void;
        function encipher(_arg_1:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray;
        function decipher(_arg_1:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray;
        function mark():Void;
        function reset():Void;
    }

