package com.sulake.core.communication.handshake
;
     interface IKeyExchange 
    {
        function init(_arg_1:String, _arg_2:UInt=16):Bool;
        function generateSharedKey(_arg_1:String, _arg_2:UInt=16):String;
        function getSharedKey(_arg_1:UInt=16):String;
        function getPublicKey(_arg_1:UInt=16):String;
        function isValidServerPublicKey():Bool;
        function isValidSharedKey():Bool;
    }

