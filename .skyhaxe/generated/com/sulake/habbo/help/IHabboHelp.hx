package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboHelp extends IUnknown 
    {
        function requestGuide():Void;
        var events(get,never):IEventDispatcher;
        function reportBully(_arg_1:Int):Void;
        function startPhotoReportingInNewCfhFlow(_arg_1:Int, _arg_2:String, _arg_3:String, _arg_4:Int):Void;
        function reportUser(_arg_1:Int, _arg_2:Int, _arg_3:String):Void;
        function reportUserName(_arg_1:Int, _arg_2:String):Void;
        function reportUserFromIM(_arg_1:Int):Void;
        function reportRoom(_arg_1:Int, _arg_2:String, _arg_3:String):Void;
        function reportThread(_arg_1:Int, _arg_2:Int):Void;
        function reportMessage(_arg_1:Int, _arg_2:Int, _arg_3:Int):Void;
        function reportSelfie(_arg_1:String, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool;
        function reportPhoto(_arg_1:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool;
        function startNameChange():Void;
        function showWelcomeScreen(_arg_1:String, _arg_2:String, _arg_3:Int, _arg_4:String=null):Void;
        var outsideRoom(never,set):Bool;
        function showHabboWay():Void;
        function showSafetyBooklet():Void;
        function showTourPopup():Void;
    }

