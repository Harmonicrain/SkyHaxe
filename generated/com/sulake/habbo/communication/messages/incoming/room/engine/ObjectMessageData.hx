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
function  get_id():Int
        {
            return this._id;
        }

        
        public var x(get,set):Float;
function  get_x():Float
        {
            return this._x;
        }
function  set_x(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._x = k;
            }
return k;
        }

        
        public var y(get,set):Float;
function  get_y():Float
        {
            return this._y;
        }
function  set_y(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._y = k;
            }
return k;
        }

        
        public var z(get,set):Float;
function  get_z():Float
        {
            return this._z;
        }
function  set_z(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._z = k;
            }
return k;
        }

        
        public var dir(get,set):Int;
function  get_dir():Int
        {
            return this._dir;
        }
function  set_dir(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._dir = k;
            }
return k;
        }

        
        public var sizeX(get,set):Int;
function  get_sizeX():Int
        {
            return this._sizeX;
        }
function  set_sizeX(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._sizeX = k;
            }
return k;
        }

        
        public var sizeY(get,set):Int;
function  get_sizeY():Int
        {
            return this._sizeY;
        }
function  set_sizeY(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._sizeY = k;
            }
return k;
        }

        
        public var sizeZ(get,set):Float;
function  get_sizeZ():Float
        {
            return this._sizeZ;
        }
function  set_sizeZ(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._sizeZ = k;
            }
return k;
        }

        
        public var type(get,set):Int;
function  get_type():Int
        {
            return this._type;
        }
function  set_type(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._type = k;
            }
return k;
        }

        
        public var state(get,set):Int;
function  get_state():Int
        {
            return this._state;
        }
function  set_state(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._state = k;
            }
return k;
        }

        
        public var data(get,set):IStuffData;
function  get_data():IStuffData
        {
            return this._data;
        }
function  set_data(k:IStuffData):IStuffData        {
            if (!this._isReadOnly)
            {
                this._data = k;
            }
return k;
        }

        
        public var staticClass(get,set):String;
function  get_staticClass():String
        {
            return this._staticClass;
        }
function  set_staticClass(k:String):String        {
            if (!this._isReadOnly)
            {
                this._staticClass = k;
            }
return k;
        }

        
        public var extra(get,set):Int;
function  get_extra():Int
        {
            return this._extra;
        }
function  set_extra(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._extra = k;
            }
return k;
        }

        
        public var expiryTime(get,set):Int;
function  get_expiryTime():Int
        {
            return this._expiryTime;
        }
function  set_expiryTime(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._expiryTime = k;
            }
return k;
        }

        
        public var usagePolicy(get,set):Int;
function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }
function  set_usagePolicy(k:Int):Int        {
            return this._usagePolicy = k;
        }

        
        public var ownerId(get,set):Int;
function  get_ownerId():Int
        {
            return this._ownerId;
        }
function  set_ownerId(k:Int):Int        {
            return this._ownerId = k;
        }

        
        public var ownerName(get,set):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }
function  set_ownerName(k:String):String        {
            return this._ownerName = k;
        }
    }

