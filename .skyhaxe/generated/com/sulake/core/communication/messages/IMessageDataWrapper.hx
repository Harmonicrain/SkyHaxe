package com.sulake.core.communication.messages
;
     interface IMessageDataWrapper 
    {
        function getID():Int;
        function readString():String;
        function readInteger():Int;
        function readBoolean():Bool;
        function readShort():Int;
        function readByte():Int;
        function readFloat():Float;
        function readDouble():Float;
        function readLong():Float;
        var bytesAvailable(get,never):UInt;
    }

