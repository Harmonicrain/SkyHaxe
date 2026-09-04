package com.sulake.habbo.room.utils
;
    import com.sulake.habbo.room.IAreaHideInfo;
    import com.sulake.room.utils.IVector3d;

     class RoomData 
    {
        var _roomId:Int = 0;
        var _data:com.sulake.core.utils.xml.XML;
        var _floorType:String = null;
        var _wallType:String = null;
        var _landscapeType:String = null;
        var _cameraInitPosition:IVector3d;
        var _areaHideData:Vector<IAreaHideInfo>;

        public function new(k:Int, data:com.sulake.core.utils.xml.XML)
        {
            this._roomId = k;
            this._data = data;
        }

        public var roomId(get,never):Int;
function  get_roomId():Int
        {
            return this._roomId;
        }

        public var data(get,never):com.sulake.core.utils.xml.XML;
function  get_data():com.sulake.core.utils.xml.XML
        {
            return this._data;
        }

        
        public var floorType(get,set):String;
function  get_floorType():String
        {
            return this._floorType;
        }
function  set_floorType(k:String):String        {
            return this._floorType = k;
        }

        
        public var wallType(get,set):String;
function  get_wallType():String
        {
            return this._wallType;
        }
function  set_wallType(k:String):String        {
            return this._wallType = k;
        }

        
        public var landscapeType(get,set):String;
function  get_landscapeType():String
        {
            return this._landscapeType;
        }
function  set_landscapeType(k:String):String        {
            return this._landscapeType = k;
        }

        
        public var cameraInitPosition(get,set):IVector3d;
function  get_cameraInitPosition():IVector3d
        {
            return this._cameraInitPosition;
        }
function  set_cameraInitPosition(k:IVector3d):IVector3d        {
            return this._cameraInitPosition = k;
        }

        
        public var areaHideData(get,set):Vector<IAreaHideInfo>;
function  get_areaHideData():Vector<IAreaHideInfo>
        {
            return this._areaHideData;
        }
function  set_areaHideData(k:Vector<IAreaHideInfo>):Vector<IAreaHideInfo>        {
            return this._areaHideData = k;
        }
    }

