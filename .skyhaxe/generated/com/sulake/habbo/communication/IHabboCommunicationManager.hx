package com.sulake.habbo.communication
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.hurlant.math.BigInteger;
    import com.sulake.core.communication.handshake.IKeyExchange;

     interface IHabboCommunicationManager extends IUnknown 
    {
        var connection(get,never):IConnection;
                var mode(get,set):Int;
        var port(get,never):Int;
        function updateHostParameters():Void;
        function initConnection(_arg_1:String):Void;
        function renewSocket():Void;
        function addHabboConnectionMessageEvent(_arg_1:IMessageEvent):IMessageEvent;
        function removeHabboConnectionMessageEvent(_arg_1:IMessageEvent):Void;
        function habboWebLogin(_arg_1:String, _arg_2:String):IHabboWebLogin;
        function initializeEncryption():IEncryption;
        function initializeKeyExchange(_arg_1:BigInteger, _arg_2:BigInteger):IKeyExchange;
        function setMessageQueueErrorDebugData():Void;
    }

