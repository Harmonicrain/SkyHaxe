package com.sulake.habbo.room.utils
;
    import com.sulake.habbo.room.ISelectedRoomObjectData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.room.utils.IVector3d;

     class SelectedRoomObjectData implements ISelectedRoomObjectData 
    {
        var _id:Int = 0;
        var _category:Int = 0;
        var _operation:String = "";
        var _loc:Vector3d = null;
        var _dir:Vector3d = null;
        var _typeId:Int = 0;
        var _instanceData:String = null;
        var _stuffData:IStuffData = null;
        var _state:Int = -1;
        var _animFrame:Int = -1;
        var _posture:String = null;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int=0, _arg_7:String=null, _arg_8:IStuffData=null, _arg_9:Int=-1, _arg_10:Int=-1, _arg_11:String=null)
        {
            this._id = k;
            this._category = _arg_2;
            this._operation = _arg_3;
            this._loc = new Vector3d();
            this._loc.assign(_arg_4);
            this._dir = new Vector3d();
            this._dir.assign(_arg_5);
            this._typeId = _arg_6;
            this._instanceData = _arg_7;
            this._stuffData = _arg_8;
            this._state = _arg_9;
            this._animFrame = _arg_10;
            this._posture = _arg_11;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var operation(get,never):String;
public function  get_operation():String
        {
            return this._operation;
        }

        public var loc(get,never):Vector3d;
public function  get_loc():Vector3d
        {
            return this._loc;
        }

        public var dir(get,never):Vector3d;
public function  get_dir():Vector3d
        {
            return this._dir;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }

        public var _Str_4766(get,never):String;
public function  get__Str_4766():String
        {
            return this._instanceData;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var _Str_15896(get,never):Int;
public function  get__Str_15896():Int
        {
            return this._animFrame;
        }

        public var posture(get,never):String;
public function  get_posture():String
        {
            return this._posture;
        }

        public function dispose()
        {
            this._loc = null;
            this._dir = null;
        }
    }

