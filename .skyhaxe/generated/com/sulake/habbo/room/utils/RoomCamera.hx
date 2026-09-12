package com.sulake.habbo.room.utils
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class RoomCamera 
    {
        static inline final MOVE_SPEED_DENOMINATOR:Float = 12;

        var _targetId:Int = -1;
        var _targetCategory:Int = -2;
        var _targetLoc:Vector3d = null;
        var _moveDistance:Float = 0;
        var _previousMoveSpeed:Float = 0;
        var _maintainPreviousMoveSpeed:Bool = false;
        var _currentLoc:Vector3d = null;
        var _targetObjectLoc:Vector3d;
        var _limitedLocX:Bool = false;
        var _limitedLocY:Bool = false;
        var _centeredLocX:Bool = false;
        var _centeredLocY:Bool = false;
        var _screenWd:Int = 0;
        var _screenHt:Int = 0;
        var _scale:Int = 0;
        var _roomWd:Int = 0;
        var _roomHt:Int = 0;
        var _geometryUpdateId:Int = -1;
        var _scaleChanged:Bool = false;
        var _followDuration:Int = 0;

        public function new()
        {
            this._targetObjectLoc = new Vector3d();
        }

        public var location(get,never):IVector3d;
public function  get_location():IVector3d
        {
            return this._currentLoc;
        }

        
        public var _Str_10760(get,set):Int;
public function  get__Str_10760():Int
        {
            return this._targetId;
        }

        
        public var _Str_16562(get,set):Int;
public function  get__Str_16562():Int
        {
            return this._targetCategory;
        }

        
        public var _Str_16185(get,set):IVector3d;
public function  get__Str_16185():IVector3d
        {
            return this._targetObjectLoc;
        }

        
        public var _Str_10235(get,set):Bool;
public function  get__Str_10235():Bool
        {
            return this._limitedLocX;
        }

        
        public var _Str_10446(get,set):Bool;
public function  get__Str_10446():Bool
        {
            return this._limitedLocY;
        }

        
        public var _Str_8564(get,set):Bool;
public function  get__Str_8564():Bool
        {
            return this._centeredLocX;
        }

        
        public var _Str_8690(get,set):Bool;
public function  get__Str_8690():Bool
        {
            return this._centeredLocY;
        }

        
        public var _Str_7609(get,set):Int;
public function  get__Str_7609():Int
        {
            return this._screenWd;
        }

        
        public var _Str_7902(get,set):Int;
public function  get__Str_7902():Int
        {
            return this._screenHt;
        }

        
        public var scale(get,set):Int;
public function  get_scale():Int
        {
            return this._scale;
        }

        
        public var _Str_18975(get,set):Int;
public function  get__Str_18975():Int
        {
            return this._roomWd;
        }

        
        public var _Str_15953(get,set):Int;
public function  get__Str_15953():Int
        {
            return this._roomHt;
        }

        
        public var _Str_16377(get,set):Int;
public function  get__Str_16377():Int
        {
            return this._geometryUpdateId;
        }

        public var isMoving(get,never):Bool;
public function  get_isMoving():Bool
        {
            if (((!(this._targetLoc == null)) && (!(this._currentLoc == null))))
            {
                return true;
            }
            return false;
        }
public function  set__Str_10760(k:Int):Int        {
            return this._targetId = k;
        }
public function  set__Str_16185(k:IVector3d):IVector3d        {
            this._targetObjectLoc.assign(k);
return k;
        }
public function  set__Str_16562(k:Int):Int        {
            return this._targetCategory = k;
        }
public function  set__Str_10235(k:Bool):Bool        {
            return this._limitedLocX = k;
        }
public function  set__Str_10446(k:Bool):Bool        {
            return this._limitedLocY = k;
        }
public function  set__Str_8564(k:Bool):Bool        {
            return this._centeredLocX = k;
        }
public function  set__Str_8690(k:Bool):Bool        {
            return this._centeredLocY = k;
        }
public function  set__Str_7609(k:Int):Int        {
            return this._screenWd = k;
        }
public function  set__Str_7902(k:Int):Int        {
            return this._screenHt = k;
        }
public function  set_scale(k:Int):Int        {
            if (this._scale != k)
            {
                this._scale = k;
                this._scaleChanged = true;
            }
return k;
        }
public function  set__Str_18975(k:Int):Int        {
            return this._roomWd = k;
        }
public function  set__Str_15953(k:Int):Int        {
            return this._roomHt = k;
        }
public function  set__Str_16377(k:Int):Int        {
            return this._geometryUpdateId = k;
        }

        public var target(never,set):IVector3d;
public function  set_target(k:IVector3d):IVector3d        {
            var _local_2:Vector3d = null;
            if (this._targetLoc == null)
            {
                this._targetLoc = new Vector3d();
            }
            if ((((!(this._targetLoc.x == k.x)) || (!(this._targetLoc.y == k.y))) || (!(this._targetLoc.z == k.z))))
            {
                this._targetLoc.assign(k);
                _local_2 = Vector3d.dif(this._targetLoc, this._currentLoc);
                this._moveDistance = _local_2.length;
                this._maintainPreviousMoveSpeed = true;
            }
return k;
        }

        public function dispose()
        {
            this._targetLoc = null;
            this._currentLoc = null;
        }

        public function initializeLocation(k:IVector3d)
        {
            if (this._currentLoc != null)
            {
                return;
            }
            this._currentLoc = new Vector3d();
            this._currentLoc.assign(k);
        }

        public function resetLocation(k:IVector3d)
        {
            if (this._currentLoc == null)
            {
                this._currentLoc = new Vector3d();
            }
            this._currentLoc.assign(k);
        }

        public function update(k:UInt, _arg_2:Float)
        {
            var _local_3:Vector3d = null;
            var _local_4 = Math.NaN;
            var _local_5 = Math.NaN;
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            if ((((this._followDuration > 0) && (!(this._targetLoc == null))) && (!(this._currentLoc == null))))
            {
                if (this._scaleChanged)
                {
                    this._scaleChanged = false;
                    this._currentLoc = this._targetLoc;
                    this._targetLoc = null;
                    return;
                }
                _local_3 = Vector3d.dif(this._targetLoc, this._currentLoc);
                if (_local_3.length > this._moveDistance)
                {
                    this._moveDistance = _local_3.length;
                }
                if (_local_3.length <= _arg_2)
                {
                    this._currentLoc = this._targetLoc;
                    this._targetLoc = null;
                    this._previousMoveSpeed = 0;
                }
                else
                {
                    _local_4 = Math.sin(((Math.PI * _local_3.length) / this._moveDistance));
                    _local_5 = (_arg_2 * 0.5);
                    _local_6 = (this._moveDistance / MOVE_SPEED_DENOMINATOR);
                    _local_7 = (_local_5 + ((_local_6 - _local_5) * _local_4));
                    if (this._maintainPreviousMoveSpeed)
                    {
                        if (_local_7 < this._previousMoveSpeed)
                        {
                            _local_7 = this._previousMoveSpeed;
                            if (_local_7 > _local_3.length)
                            {
                                _local_7 = _local_3.length;
                            }
                        }
                        else
                        {
                            this._maintainPreviousMoveSpeed = false;
                        }
                    }
                    this._previousMoveSpeed = _local_7;
                    _local_3.div(_local_3.length);
                    _local_3.mul(_local_7);
                    this._currentLoc = Vector3d.sum(this._currentLoc, _local_3);
                }
            }
        }

        public function reset()
        {
            this._geometryUpdateId = -1;
        }

        public function activateFollowing(k:Int)
        {
            this._followDuration = k;
        }
    }

