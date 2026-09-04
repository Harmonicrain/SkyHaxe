package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class ItemMessageData
    {
        var _id:Int = 0;
        var _isOldFormat:Bool = false;
        var _wallX:Int = 0;
        var _wallY:Int = 0;
        var _localX:Int = 0;
        var _localY:Int = 0;
        var _y:Float = 0;
        var _z:Float = 0;
        var _dir:String = "";
        var _type:Int = 0;
        var _state:Int = 0;
        var _data:String = "";
        var _isReadOnly:Bool = false;
        var _usagePolicy:Int = 0;
        var _ownerId:Int = 0;
        var _ownerName:String = "";
        var _secondsToExpiration:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            this._id = k;
            this._type = _arg_2;
            this._isOldFormat = _arg_3;
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

        public var isOldFormat(get,never):Bool;
function  get_isOldFormat():Bool
        {
            return this._isOldFormat;
        }

        
        public var wallX(get,set):Float;
function  get_wallX():Float
        {
            return this._wallX;
        }
function  set_wallX(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._wallX = Std.int(k);
            }
return k;
        }

        
        public var wallY(get,set):Float;
function  get_wallY():Float
        {
            return this._wallY;
        }
function  set_wallY(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._wallY = Std.int(k);
            }
return k;
        }

        
        public var localX(get,set):Float;
function  get_localX():Float
        {
            return this._localX;
        }
function  set_localX(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._localX = Std.int(k);
            }
return k;
        }

        
        public var localY(get,set):Float;
function  get_localY():Float
        {
            return this._localY;
        }
function  set_localY(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._localY = Std.int(k);
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

        
        public var dir(get,set):String;
function  get_dir():String
        {
            return this._dir;
        }
function  set_dir(k:String):String        {
            if (!this._isReadOnly)
            {
                this._dir = k;
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

        
        public var data(get,set):String;
function  get_data():String
        {
            return this._data;
        }
function  set_data(k:String):String        {
            if (!this._isReadOnly)
            {
                this._data = k;
            }
return k;
        }

        
        public var usagePolicy(get,set):Int;
function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }
function  set_usagePolicy(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._usagePolicy = k;
            }
return k;
        }

        
        public var ownerId(get,set):Int;
function  get_ownerId():Int
        {
            return this._ownerId;
        }
function  set_ownerId(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._ownerId = k;
            }
return k;
        }

        
        public var ownerName(get,set):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }
function  set_ownerName(k:String):String        {
            if (!this._isReadOnly)
            {
                this._ownerName = k;
            }
return k;
        }

        
        public var secondsToExpiration(get,set):Int;
function  get_secondsToExpiration():Int
        {
            return this._secondsToExpiration;
        }
function  set_secondsToExpiration(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._secondsToExpiration = k;
            }
return k;
        }
    }

