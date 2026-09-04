package com.sulake.core.communication.messages
;
     interface IMessageParser 
    {
        function flush():Bool;
        function parse(data:IMessageDataWrapper):Bool;
    }

