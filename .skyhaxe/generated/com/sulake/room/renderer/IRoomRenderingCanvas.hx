package com.sulake.room.renderer
;
    import flash.display.DisplayObject;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.data.RoomObjectSpriteData;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import com.sulake.room.object.IRoomObject;

     interface IRoomRenderingCanvas 
    {
        var useMask(never,set):Bool;
        function initialize(_arg_1:Int, _arg_2:Int):Void;
        var width(get,never):Int;
        var height(get,never):Int;
                var screenOffsetX(get,set):Int;
                var screenOffsetY(get,set):Int;
        function render(_arg_1:Int, _arg_2:Bool=false):Void;
        var displayObject(get,never):DisplayObject;
        var geometry(get,never):IRoomGeometry;
        var mouseListener(never,set):IRoomRenderingCanvasMouseListener;
        function handleMouseEvent(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool):Bool;
        function getRoomObjectAt(_arg_1:Int, _arg_2:Int):IRoomObject;
        function getSortableSpriteList():Vector<RoomObjectSpriteData>;
        function getPlaneSortableSprites():Array<ASAny>;
        function setScale(_arg_1:Float, _arg_2:Point=null, _arg_3:Point=null, _arg_4:Bool=false):Void;
        var scale(get,never):Float;
        function takeScreenShot():BitmapData;
        function skipSpriteVisibilityChecking():Void;
        function resumeSpriteVisibilityChecking():Void;
        function getId():Int;
    }

