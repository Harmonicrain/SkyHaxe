package com.sulake.habbo.session
;
    import flash.events.IEventDispatcher;

     interface IRoomHandlerListener 
    {
        function sessionUpdate(_arg_1:Int, _arg_2:String):Void;
        function sessionReinitialize(_arg_1:Int, _arg_2:Int):Void;
        function getSession(_arg_1:Int):IRoomSession;
        var events(get,never):IEventDispatcher;
    }

