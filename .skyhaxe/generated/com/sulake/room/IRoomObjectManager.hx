package com.sulake.room
;
    import com.sulake.room.object.IRoomObjectController;

     interface IRoomObjectManager 
    {
        function dispose():Void;
        function createObject(_arg_1:Int, _arg_2:UInt, _arg_3:String):IRoomObjectController;
        function getObject(_arg_1:Int):IRoomObjectController;
        function getObjects():Array<ASAny>;
        function disposeObject(_arg_1:Int):Bool;
        function getObjectCount():Int;
        function getObjectWithIndex(_arg_1:Int):IRoomObjectController;
        function getObjectCountForType(_arg_1:String):Int;
        function getObjectWithIndexAndType(_arg_1:Int, _arg_2:String):IRoomObjectController;
        function reset():Void;
    }

