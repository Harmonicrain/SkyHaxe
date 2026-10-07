package com.sulake.core.window.utils
;
    import flash.events.Event;

     interface IEventQueue 
    {
        var length(get,never):UInt;
        function begin():Void;
        function next():Event;
        function remove():Void;
        function end():Void;
        function flush():Void;
    }

