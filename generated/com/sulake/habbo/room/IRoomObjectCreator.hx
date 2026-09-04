package com.sulake.habbo.room
;
    import com.sulake.room.utils.IVector3d;

     interface IRoomObjectCreator 
    {
        function addObjectFurniture(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:IStuffData, _arg_8:Float=null, _arg_9:Int=-1, _arg_10:Int=0, _arg_11:Int=0, _arg_12:String="", _arg_13:Bool=true, _arg_14:Bool=true, _arg_15:Float=-1):Bool;
        function addObjectFurnitureByName(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:IStuffData, _arg_8:Float=null):Bool;
        function updateObjectFurniture(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Int, _arg_6:IStuffData, _arg_7:Float=null):Bool;
        function updateObjectFurnitureHeight(_arg_1:Int, _arg_2:Int, _arg_3:Float):Bool;
        function updateObjectFurnitureLocation(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:IVector3d=null, _arg_6:Float=null, _arg_7:Float=null, _arg_8:Float=null):Bool;
        function updateObjectFurnitureExpiryTime(_arg_1:Int, _arg_2:Int, _arg_3:Int):Bool;
        function disposeObjectFurniture(_arg_1:Int, _arg_2:Int, _arg_3:Int=-1, _arg_4:Bool=false):Void;
        function addObjectWallItem(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:String, _arg_8:Int=0, _arg_9:Int=0, _arg_10:String="", _arg_11:Int=-1, _arg_12:Bool=true):Bool;
        function updateObjectWallItem(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Int, _arg_6:String):Bool;
        function updateObjectWallItemData(_arg_1:Int, _arg_2:Int, _arg_3:String):Bool;
        function updateObjectWallItemLocation(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d=null, _arg_5:Float=null):Bool;
        function updateObjectWallItemExpiryTime(_arg_1:Int, _arg_2:Int, _arg_3:Int):Bool;
        function disposeObjectWallItem(_arg_1:Int, _arg_2:Int, _arg_3:Int=-1):Void;
        function addObjectUser(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Float, _arg_6:Int, _arg_7:String=null):Bool;
        function updateObjectUser(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Bool=false, _arg_6:Float=0, _arg_7:IVector3d=null, _arg_8:Float=null, _arg_9:Float=null, _arg_10:Bool=false, _arg_11:Float=null):Bool;
        function updateObjectUserDir(_arg_1:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:Float):Bool;
        function updateObjectUserFlatControl(_arg_1:Int, _arg_2:Int, _arg_3:String):Bool;
        function updateObjectUserOwnUserAvatar(_arg_1:Int, _arg_2:Int):Bool;
        function updateObjectUserFigure(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:String=null, _arg_5:String=null, _arg_6:Bool=false):Bool;
        function updateObjectUserAction(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:String=null):Bool;
        function updateObjectUserPosture(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:String=""):Bool;
        function updateObjectUserGesture(_arg_1:Int, _arg_2:Int, _arg_3:Int):Bool;
        function updateObjectPetGesture(_arg_1:Int, _arg_2:Int, _arg_3:String):Bool;
        function updateObjectUserEffect(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int=0):Bool;
        function disposeObjectUser(_arg_1:Int, _arg_2:Int):Void;
        function updateObjectRoom(_arg_1:Int, _arg_2:String=null, _arg_3:String=null, _arg_4:String=null, _arg_5:Bool=false):Bool;
        function updateObjectRoomColor(_arg_1:Int, _arg_2:UInt, _arg_3:Int, _arg_4:Bool):Bool;
        function updateObjectRoomBackgroundColor(_arg_1:Int, _arg_2:Bool, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool;
        function updateObjectRoomVisibilities(_arg_1:Int, _arg_2:Bool, _arg_3:Bool=true):Bool;
        function updateObjectRoomPlaneThicknesses(_arg_1:Int, _arg_2:Float, _arg_3:Float):Bool;
        function setRoomObjectAlias(_arg_1:String, _arg_2:String):Void;
        function getPetTypeId(_arg_1:String):Int;
    }

