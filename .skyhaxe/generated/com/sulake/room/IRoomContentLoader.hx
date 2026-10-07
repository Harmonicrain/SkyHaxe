package com.sulake.room
;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.object.IRoomObject;

     interface IRoomContentLoader 
    {
        function dispose():Void;
        function getPlaceHolderType(_arg_1:String):String;
        function getPlaceHolderTypes():Array<ASAny>;
        function getContentType(_arg_1:String):String;
        function hasInternalContent(_arg_1:String):Bool;
        function loadObjectContent(_arg_1:String, _arg_2:IEventDispatcher):Bool;
        function insertObjectContent(_arg_1:Int, _arg_2:Int, _arg_3:IAssetLibrary):Bool;
        function getPublicRoomContentType(_arg_1:String):String;
        function getPublicRoomWorldHeightScale(_arg_1:String):Float;
        function getPublicRoomWorldSize(_arg_1:String):Int;
        function isPublicRoomWorldType(_arg_1:String):Bool;
        function getVisualizationType(_arg_1:String):String;
        function getLogicType(_arg_1:String):String;
        function hasVisualizationXML(_arg_1:String):Bool;
        function getVisualizationXML(_arg_1:String):com.sulake.core.utils.xml.XML;
        function hasAssetXML(_arg_1:String):Bool;
        function getAssetXML(_arg_1:String):com.sulake.core.utils.xml.XML;
        function hasLogicXML(_arg_1:String):Bool;
        function getLogicXML(_arg_1:String):com.sulake.core.utils.xml.XML;
        function getGraphicAssetCollection(_arg_1:String):IGraphicAssetCollection;
        function roomObjectCreated(_arg_1:IRoomObject, _arg_2:String):Void;
    }

