package com.sulake.habbo.room.utils
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.room.utils.IVector3d;

     class FurnitureData 
    {
        var _id:Int = 0;
        var _typeId:Int = 0;
        var _type:String = null;
        var _loc:Vector3d;
        var _dir:Vector3d;
        var _state:Int = 0;
        var _data:IStuffData = null;
        var _extra:Float = Math.NaN;
        var _expiryTime:Int = -1;
        var _usagePolicy:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _synchronized:Bool = true;
        var _realRoomObject:Bool = true;
        var _sizeZ:Float = Math.NaN;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:IStuffData, _arg_8:Float=null, _arg_9:Int=-1, _arg_10:Int=0, _arg_11:Int=0, _arg_12:String="", _arg_13:Bool=true, _arg_14:Bool=true, _arg_15:Float=-1)
{
            if (_arg_8 == null) _arg_8 = Math.NaN;
            this._loc = new Vector3d();
            this._dir = new Vector3d();
            this._id = k;
            this._typeId = _arg_2;
            this._type = _arg_3;
            this._loc.assign(_arg_4);
            this._dir.assign(_arg_5);
            this._state = _arg_6;
            this._data = _arg_7;
            this._extra = _arg_8;
            this._expiryTime = _arg_9;
            this._usagePolicy = _arg_10;
            this._ownerId = _arg_11;
            this._ownerName = _arg_12;
            this._synchronized = _arg_13;
            this._realRoomObject = _arg_14;
            this._sizeZ = _arg_15;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var loc(get,never):IVector3d;
public function  get_loc():IVector3d
        {
            return this._loc;
        }

        public var dir(get,never):IVector3d;
public function  get_dir():IVector3d
        {
            return this._dir;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var data(get,never):IStuffData;
public function  get_data():IStuffData
        {
            return this._data;
        }

        public var extra(get,never):Float;
public function  get_extra():Float
        {
            return this._extra;
        }

        public var expiryTime(get,never):Int;
public function  get_expiryTime():Int
        {
            return this._expiryTime;
        }

        public var usagePolicy(get,never):Int;
public function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }

        public var ownerId(get,never):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        public var ownerName(get,never):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }

        public var synchronized(get,never):Bool;
public function  get_synchronized():Bool
        {
            return this._synchronized;
        }

        public var realRoomObject(get,never):Bool;
public function  get_realRoomObject():Bool
        {
            return this._realRoomObject;
        }

        public var sizeZ(get,never):Float;
public function  get_sizeZ():Float
        {
            return this._sizeZ;
        }
    }

