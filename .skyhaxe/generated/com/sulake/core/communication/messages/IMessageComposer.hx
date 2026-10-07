package com.sulake.core.communication.messages
;
     interface IMessageComposer 
    {
        function getMessageArray():Array<ASAny>;
        function dispose():Void;
    }

