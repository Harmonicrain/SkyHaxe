package com.sulake.room
;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.renderer.IRoomRendererBase;

     interface IRoomInstance 
    {
        function getNumber(_arg_1:String):Float;
        function setNumber(_arg_1:String, _arg_2:Float, _arg_3:Bool=false):Void;
        function getString(_arg_1:String):String;
        function setString(_arg_1:String, _arg_2:String, _arg_3:Bool=false):Void;
        function dispose():Void;
        function update():Void;
        function createRoomObject(_arg_1:Int, _arg_2:String, _arg_3:Int):IRoomObject;
        function getObject(_arg_1:Int, _arg_2:Int):IRoomObject;
        function getObjects(_arg_1:Int):Array<ASAny>;
        function disposeObject(_arg_1:Int, _arg_2:Int):Bool;
        function getObjectCount(_arg_1:Int):Int;
        function getObjectWithIndexAndType(_arg_1:Int, _arg_2:String, _arg_3:Int):IRoomObject;
        function getObjectCountForType(_arg_1:String, _arg_2:Int):Int;
        function getObjectWithIndex(_arg_1:Int, _arg_2:Int):IRoomObject;
        function disposeObjects(_arg_1:Int):Int;
        function setRenderer(_arg_1:IRoomRendererBase):Void;
        function getRenderer():IRoomRendererBase;
    }

