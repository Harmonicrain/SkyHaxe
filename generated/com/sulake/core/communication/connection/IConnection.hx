package com.sulake.core.communication.connection
;
    import flash.events.IEventDispatcher;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.sulake.core.communication.messages.IMessageConfiguration;
    import com.sulake.core.communication.messages.IMessageEvent;

     interface IConnection extends IEventDispatcher 
    {
        function dispose():Void;
        var disposed(get,never):Bool;
        function init(_arg_1:String, _arg_2:UInt=0):Bool;
        var timeout(never,set):Int;
        function send(_arg_1:IMessageComposer):Bool;
        function sendUnencrypted(_arg_1:IMessageComposer):Bool;
        function setEncryption(outgoing:IEncryption, incoming:IEncryption):Void;
        function getServerToClientEncryption():IEncryption;
        function registerMessageClasses(_arg_1:IMessageConfiguration):Void;
        function addMessageEvent(_arg_1:IMessageEvent):Void;
        function removeMessageEvent(_arg_1:IMessageEvent):Void;
        function processReceivedData():Void;
        var connected(get,never):Bool;
        function close():Void;
        function isAuthenticated():Void;
        function isConfigured():Void;
        function createSocket():Void;
    }

