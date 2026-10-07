package com.sulake.room.object
;
    import com.sulake.core.utils.Map;

     interface IRoomObjectModel 
    {
        function hasNumber(_arg_1:String):Bool;
        function hasNumberArray(_arg_1:String):Bool;
        function hasString(_arg_1:String):Bool;
        function hasStringArray(_arg_1:String):Bool;
        function getNumber(_arg_1:String):Float;
        function getString(_arg_1:String):String;
        function getNumberArray(_arg_1:String):Array<ASAny>;
        function getStringArray(_arg_1:String):Array<ASAny>;
        function getUpdateID():Int;
        function getStringToStringMap(_arg_1:String):Map;
    }

