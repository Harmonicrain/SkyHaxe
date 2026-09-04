package com.sulake.room.object
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.room.object.logic.IRoomObjectMouseHandler;

     interface IRoomObject 
    {
        function getId():Int;
        function getInstanceId():Int;
        function getType():String;
        function isInitialized():Bool;
        function getLocation():IVector3d;
        function getDirection():IVector3d;
        function getModel():IRoomObjectModel;
        function getVisualization():IRoomObjectVisualization;
        function getMouseHandler():IRoomObjectMouseHandler;
        function getState(_arg_1:Int):Int;
        function getUpdateID():Int;
        function tearDown():Void;
    }

