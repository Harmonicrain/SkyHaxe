package com.sulake.core.runtime
;

     interface IHabboConfigurationManager extends IUnknown 
    {
        function propertyExists(_arg_1:String):Bool;
        function getProperty(_arg_1:String, _arg_2:ASDictionary<ASAny,ASAny>=null):String;
        function setProperty(_arg_1:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false):Void;
        function getBoolean(_arg_1:String):Bool;
        function getInteger(_arg_1:String, _arg_2:Int):Int;
        function interpolate(_arg_1:String):String;
        function updateUrlProtocol(_arg_1:String):String;
    }

