package com.sulake.room
;
    import com.sulake.core.runtime.IUnknown;

     interface IRoomManager extends IUnknown 
    {
        function initialize(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:IRoomManagerListener):Bool;
        function update(_arg_1:UInt):Void;
        function setContentLoader(_arg_1:IRoomContentLoader):Void;
        function addObjectUpdateCategory(_arg_1:Int):Void;
        function removeObjectUpdateCategory(_arg_1:Int):Void;
        function createRoom(_arg_1:String, _arg_2:com.sulake.core.utils.xml.XML):IRoomInstance;
        function disposeRoom(_arg_1:String):Bool;
        function getRoom(_arg_1:String):IRoomInstance;
        function getRoomWithIndex(_arg_1:Int):IRoomInstance;
        function getRoomCount():Int;
        function isContentAvailable(_arg_1:String):Bool;
        function resetObjectContentToPlaceHolder(_arg_1:String):Bool;
        function loadObjectContent(_arg_1:String):Bool;
    }

