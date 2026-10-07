package com.sulake.core.communication.wireformat
;
    import flash.utils.ByteArray;
    import com.sulake.core.communication.connection.IConnection;

     interface IWireFormat 
    {
        function dispose():Void;
        function encode(header:Int, messageBuffer:Array<ASAny>):com.sulake.core.utils.ByteArray;
        function decode(buffer:com.sulake.core.utils.ByteArray, socket:IConnection):Array<ASAny>;
    }

