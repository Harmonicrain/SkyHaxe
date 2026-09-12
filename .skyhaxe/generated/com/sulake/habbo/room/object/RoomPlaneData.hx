package com.sulake.habbo.room.object
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class RoomPlaneData 
    {
        public static inline final PLANE_UNDEFINED= 0;
        public static inline final PLANE_FLOOR= 1;
        public static inline final PLANE_WALL= 2;
        public static inline final PLANE_LANDSCAPE= 3;
        public static inline final PLANE_BILLBOARD= 4;

        var _type:Int = 0;
        var _loc:Vector3d = null;
        var _leftSide:Vector3d = null;
        var _rightSide:Vector3d = null;
        var _normal:Vector3d = null;
        var _normalDirection:Vector3d = null;
        var _secondaryNormals:Array<ASAny>;
        var _masks:Array<ASAny>;

        public function new(k:Int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Array<ASAny>)
        {
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            var _local_11 = 0;
            var _local_12:IVector3d = null;
            var _local_13:Vector3d = null;
            this._secondaryNormals = [];
            this._masks = [];
            this._loc = new Vector3d();
            this._loc.assign(_arg_2);
            this._leftSide = new Vector3d();
            this._leftSide.assign(_arg_3);
            this._rightSide = new Vector3d();
            this._rightSide.assign(_arg_4);
            this._type = k;
            if (((!(_arg_3 == null)) && (!(_arg_4 == null))))
            {
                this._normal = Vector3d.crossProduct(_arg_3, _arg_4);
                _local_6 = 0;
                _local_7 = 0;
                _local_8 = 0;
                _local_9 = 0;
                _local_10 = 0;
                if (((!(this.normal.x == 0)) || (!(this.normal.y == 0))))
                {
                    _local_9 = this.normal.x;
                    _local_10 = this.normal.y;
                    _local_6 = (360 + ((Math.atan2(_local_10, _local_9) / Math.PI) * 180));
                    if (_local_6 >= 360)
                    {
                        _local_6 = (_local_6 - 360);
                    }
                    _local_9 = Math.sqrt(((this.normal.x * this.normal.x) + (this.normal.y * this.normal.y)));
                    _local_10 = this.normal.z;
                    _local_7 = (360 + ((Math.atan2(_local_10, _local_9) / Math.PI) * 180));
                    if (_local_7 >= 360)
                    {
                        _local_7 = (_local_7 - 360);
                    }
                }
                else
                {
                    if (this.normal.z < 0)
                    {
                        _local_7 = 90;
                    }
                    else
                    {
                        _local_7 = 270;
                    }
                }
                this._normalDirection = new Vector3d(_local_6, _local_7, _local_8);
            }
            if (((!(_arg_5 == null)) && (_arg_5.length > 0)))
            {
                _local_11 = 0;
                while (_local_11 < _arg_5.length)
                {
                    _local_12 = _arg_5[_local_11];
                    if (((!(_local_12 == null)) && (_local_12.length > 0)))
                    {
                        _local_13 = new Vector3d();
                        _local_13.assign(_local_12);
                        _local_13.mul((1 / _local_13.length));
                        this._secondaryNormals.push(_local_13);
                    }
                    _local_11++;
                }
            }
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var loc(get,never):IVector3d;
public function  get_loc():IVector3d
        {
            return this._loc;
        }

        public var leftSide(get,never):IVector3d;
public function  get_leftSide():IVector3d
        {
            return this._leftSide;
        }

        public var rightSide(get,never):IVector3d;
public function  get_rightSide():IVector3d
        {
            return this._rightSide;
        }

        public var normal(get,never):IVector3d;
public function  get_normal():IVector3d
        {
            return this._normal;
        }

        public var normalDirection(get,never):IVector3d;
public function  get_normalDirection():IVector3d
        {
            return this._normalDirection;
        }

        public var secondaryNormalCount(get,never):Int;
public function  get_secondaryNormalCount():Int
        {
            return this._secondaryNormals.length;
        }

        public var maskCount(get,never):Int;
public function  get_maskCount():Int
        {
            return this._masks.length;
        }

        public function getSecondaryNormal(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this.secondaryNormalCount)))
            {
                return null;
            }
            var _local_2= new Vector3d();
            _local_2.assign(ASCompat.dynamicAs(this._secondaryNormals[k] , IVector3d));
            return _local_2;
        }

        public function addMask(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float)
        {
            var _local_5= new RoomPlaneMaskData(k, _arg_2, _arg_3, _arg_4);
            this._masks.push(_local_5);
        }

        function getMask(k:Int):RoomPlaneMaskData
        {
            if (((k < 0) || (k >= this.maskCount)))
            {
                return null;
            }
            return this._masks[k];
        }

        public function getMaskLeftSideLoc(k:Int):Float
        {
            var _local_2= this.getMask(k);
            if (_local_2 != null)
            {
                return _local_2._Str_5120;
            }
            return -1;
        }

        public function getMaskRightSideLoc(k:Int):Float
        {
            var _local_2= this.getMask(k);
            if (_local_2 != null)
            {
                return _local_2._Str_4659;
            }
            return -1;
        }

        public function getMaskLeftSideLength(k:Int):Float
        {
            var _local_2= this.getMask(k);
            if (_local_2 != null)
            {
                return _local_2._Str_9124;
            }
            return -1;
        }

        public function getMaskRightSideLength(k:Int):Float
        {
            var _local_2= this.getMask(k);
            if (_local_2 != null)
            {
                return _local_2._Str_12156;
            }
            return -1;
        }
    }

