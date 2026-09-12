package com.sulake.habbo.session
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IRoomSessionManager extends IUnknown 
    {
        function gotoRoom(_arg_1:Int, _arg_2:String="", _arg_3:String=""):Bool;
        function gotoRoomNetwork(_arg_1:Int, _arg_2:Int):Bool;
        function startSession(_arg_1:IRoomSession):Bool;
        function getSession(_arg_1:Int):IRoomSession;
        var events(get,never):IEventDispatcher;
        var sessionStarting(get,never):Bool;
        function startGameSession():Void;
        function disposeGameSession():Void;
        function disposeSession(_arg_1:Int, _arg_2:Bool=true):Void;
    }

