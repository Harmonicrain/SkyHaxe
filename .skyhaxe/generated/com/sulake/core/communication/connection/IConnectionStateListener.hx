package com.sulake.core.communication.connection
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     interface IConnectionStateListener 
    {
        function connectionInit(host:String, port:Int):Void;
        function messageReceived(_arg_1:String):Void;
        function messageSent(_arg_1:String):Void;
        function messageParseError(_arg_1:IMessageDataWrapper):Void;
    }

