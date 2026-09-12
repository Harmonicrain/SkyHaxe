package com.sulake.room
;
    import com.sulake.room.object.IRoomObject;

     interface IRoomInstanceContainer 
    {
        function createRoomObject(_arg_1:String, _arg_2:Int, _arg_3:String, _arg_4:Int):IRoomObject;
        function createRoomObjectManager():IRoomObjectManager;
    }

