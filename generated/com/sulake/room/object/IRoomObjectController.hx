package com.sulake.room.object
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;

     interface IRoomObjectController extends IRoomObject 
    {
        function dispose():Void;
        function setInitialized(_arg_1:Bool):Void;
        function setLocation(_arg_1:IVector3d):Void;
        function setDirection(_arg_1:IVector3d):Void;
        function setVisualization(_arg_1:IRoomObjectVisualization):Void;
        function setState(_arg_1:Int, _arg_2:Int):Bool;
        function setEventHandler(_arg_1:IRoomObjectEventHandler):Void;
        function getEventHandler():IRoomObjectEventHandler;
        function getModelController():IRoomObjectModelController;
    }

