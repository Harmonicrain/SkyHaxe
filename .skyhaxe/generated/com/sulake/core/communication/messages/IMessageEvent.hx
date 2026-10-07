package com.sulake.core.communication.messages
;
    import com.sulake.core.communication.connection.IConnection;

     interface IMessageEvent 
    {
        var callback(get,never):ASFunction;
                var connection(get,set):IConnection;
        var parserClass(get,never):Class<Dynamic>;
                var parser(get,set):IMessageParser;
        function dispose():Void;
    }

