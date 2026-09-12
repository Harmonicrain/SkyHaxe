package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.object.data.LegacyStuffData;

     class ObjectMessageData
    {
        var _id:Int = 0;
        var _x:Float = 0;
        var _y:Float = 0;
        var _z:Float = 0;
        var _dir:Int = 0;
        var _sizeX:Int = 0;
        var _sizeY:Int = 0;
        var _sizeZ:Float = 0;
        var _type:Int = 0;
        var _extra:Int = -1;
        var _state:Int = 0;
        var _data:IStuffData;
        var _expiryTime:Int = 0;
        var _usagePolicy:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _staticClass:String = null;
        var _isReadOnly:Bool = false;

        public function new(k:Int)
        {
            this._data = new LegacyStuffData();
            this._id = k;
        }

        public function setReadOnly()
        {
            this._isReadOnly = true;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var x(get,set):Float;
public function  get_x():Float
        {
            return this._x;
        }
public function  set_x(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._x = k;
            }
return k;
        }

        
        public var y(get,set):Float;
public function  get_y():Float
        {
            return this._y;
        }
public function  set_y(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._y = k;
            }
return k;
        }

        
        public var z(get,set):Float;
public function  get_z():Float
        {
            return this._z;
        }
public function  set_z(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._z = k;
            }
return k;
        }

        
        public var dir(get,set):Int;
public function  get_dir():Int
        {
            return this._dir;
        }
public function  set_dir(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._dir = k;
            }
return k;
        }

        
        public var sizeX(get,set):Int;
public function  get_sizeX():Int
        {
            return this._sizeX;
        }
public function  set_sizeX(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._sizeX = k;
            }
return k;
        }

        
        public var sizeY(get,set):Int;
public function  get_sizeY():Int
        {
            return this._sizeY;
        }
public function  set_sizeY(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._sizeY = k;
            }
return k;
        }

        
        public var sizeZ(get,set):Float;
public function  get_sizeZ():Float
        {
            return this._sizeZ;
        }
public function  set_sizeZ(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._sizeZ = k;
            }
return k;
        }

        
        public var type(get,set):Int;
public function  get_type():Int
        {
            return this._type;
        }
public function  set_type(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._type = k;
            }
return k;
        }

        
        public var state(get,set):Int;
public function  get_state():Int
        {
            return this._state;
        }
public function  set_state(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._state = k;
            }
return k;
        }

        
        public var data(get,set):IStuffData;
public function  get_data():IStuffData
        {
            return this._data;
        }
public function  set_data(k:IStuffData):IStuffData        {
            if (!this._isReadOnly)
            {
                this._data = k;
            }
return k;
        }

        
        public var staticClass(get,set):String;
public function  get_staticClass():String
        {
            return this._staticClass;
        }
public function  set_staticClass(k:String):String        {
            if (!this._isReadOnly)
            {
                this._staticClass = k;
            }
return k;
        }

        
        public var extra(get,set):Int;
public function  get_extra():Int
        {
            return this._extra;
        }
public function  set_extra(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._extra = k;
            }
return k;
        }

        
        public var expiryTime(get,set):Int;
public function  get_expiryTime():Int
        {
            return this._expiryTime;
        }
public function  set_expiryTime(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._expiryTime = k;
            }
return k;
        }

        
        public var usagePolicy(get,set):Int;
public function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }
public function  set_usagePolicy(k:Int):Int        {
            return this._usagePolicy = k;
        }

        
        public var ownerId(get,set):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }
public function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }

        
        public var ownerName(get,set):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }
public function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
    }

