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
public function  get_id():Int
        {
            return this._id;
        }

        public var isOldFormat(get,never):Bool;
public function  get_isOldFormat():Bool
        {
            return this._isOldFormat;
        }

        
        public var wallX(get,set):Float;
public function  get_wallX():Float
        {
            return this._wallX;
        }
public function  set_wallX(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._wallX = Std.int(k);
            }
return k;
        }

        
        public var wallY(get,set):Float;
public function  get_wallY():Float
        {
            return this._wallY;
        }
public function  set_wallY(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._wallY = Std.int(k);
            }
return k;
        }

        
        public var localX(get,set):Float;
public function  get_localX():Float
        {
            return this._localX;
        }
public function  set_localX(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._localX = Std.int(k);
            }
return k;
        }

        
        public var localY(get,set):Float;
public function  get_localY():Float
        {
            return this._localY;
        }
public function  set_localY(k:Float):Float        {
            if (!this._isReadOnly)
            {
                this._localY = Std.int(k);
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

        
        public var dir(get,set):String;
public function  get_dir():String
        {
            return this._dir;
        }
public function  set_dir(k:String):String        {
            if (!this._isReadOnly)
            {
                this._dir = k;
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

        
        public var data(get,set):String;
public function  get_data():String
        {
            return this._data;
        }
public function  set_data(k:String):String        {
            if (!this._isReadOnly)
            {
                this._data = k;
            }
return k;
        }

        
        public var usagePolicy(get,set):Int;
public function  get_usagePolicy():Int
        {
            return this._usagePolicy;
        }
public function  set_usagePolicy(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._usagePolicy = k;
            }
return k;
        }

        
        public var ownerId(get,set):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }
public function  set_ownerId(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._ownerId = k;
            }
return k;
        }

        
        public var ownerName(get,set):String;
public function  get_ownerName():String
        {
            return this._ownerName;
        }
public function  set_ownerName(k:String):String        {
            if (!this._isReadOnly)
            {
                this._ownerName = k;
            }
return k;
        }

        
        public var secondsToExpiration(get,set):Int;
public function  get_secondsToExpiration():Int
        {
            return this._secondsToExpiration;
        }
public function  set_secondsToExpiration(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._secondsToExpiration = k;
            }
return k;
        }
    }

