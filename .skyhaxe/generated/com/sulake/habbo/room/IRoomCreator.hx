package com.sulake.habbo.room
;
    import com.sulake.room.IRoomInstance;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.habbo.room.utils.FurniStackingHeightMap;
    import com.sulake.habbo.room.utils.LegacyWallGeometry;
    import com.sulake.habbo.room.utils.TileObjectMap;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.room.utils.IVector3d;

     interface IRoomCreator extends IRoomObjectCreator 
    {
        function initializeRoom(_arg_1:Int, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:IVector3d=null, _arg_4:Vector<IAreaHideInfo>=null):Void;
        function getRoom(_arg_1:Int):IRoomInstance;
        function disposeRoom(_arg_1:Int):Void;
        function setOwnUserId(_arg_1:Int, _arg_2:Int):Void;
        function setWorldType(_arg_1:Int, _arg_2:String, _arg_3:Bool=false):Void;
        function updatePublicRoomParkBusDoor(_arg_1:Int, _arg_2:Bool):Void;
        function getWorldType(_arg_1:Int):String;
        function getPublicRoomContentType(_arg_1:String):String;
        function getObjectRoom(_arg_1:Int):IRoomObjectController;
        function setFurniStackingHeightMap(_arg_1:Int, _arg_2:FurniStackingHeightMap):Void;
        function getFurniStackingHeightMap(_arg_1:Int):FurniStackingHeightMap;
        function getLegacyGeometry(_arg_1:Int):LegacyWallGeometry;
        function getTileObjectMap(_arg_1:Int):TileObjectMap;
        function getRoomNumberValue(_arg_1:Int, _arg_2:String):Float;
        function getRoomStringValue(_arg_1:Int, _arg_2:String):String;
        function isRoomObjectContentAvailable(_arg_1:String):Bool;
        function setIsPlayingGame(_arg_1:Int, _arg_2:Bool):Void;
        function setHanditemControlBlocked(_arg_1:Int, _arg_2:Bool):Void;
        function setChooserDisabled(_arg_1:Int, _arg_2:Bool):Void;
        function setFreeFurniMovementsMode(_arg_1:Int, _arg_2:Bool):Void;
        function setInvisibleFurni(_arg_1:Int, _arg_2:Bool):Void;
        function refreshTileObjectMap(_arg_1:Int, _arg_2:String):Void;
        function updateAreaHide(_arg_1:Int, _arg_2:Int, _arg_3:Bool, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Bool):Void;
        var configuration(get,never):IHabboConfigurationManager;
        var roomSessionManager(get,never):IRoomSessionManager;
        var sessionDataManager(get,never):ISessionDataManager;
    }

