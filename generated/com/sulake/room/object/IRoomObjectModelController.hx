package com.sulake.room.object
;
    import com.sulake.core.utils.Map;

     interface IRoomObjectModelController extends IRoomObjectModel 
    {
        function setNumber(_arg_1:String, _arg_2:Float, _arg_3:Bool=false):Void;
        function setString(_arg_1:String, _arg_2:String, _arg_3:Bool=false):Void;
        function setNumberArray(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Bool=false):Void;
        function setStringArray(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Bool=false):Void;
        function setStringToStringMap(_arg_1:String, _arg_2:Map, _arg_3:Bool=false):Void;
    }

