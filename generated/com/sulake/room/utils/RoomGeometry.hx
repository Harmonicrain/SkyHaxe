package com.sulake.room.utils
;
    import com.sulake.core.utils.Map;
    import flash.geom.Point;

     class RoomGeometry implements IRoomGeometry 
    {
        public static inline final SCALE_ZOOMED_IN:Float = 64;
        public static inline final SCALE_ZOOMED_OUT:Float = 32;

        var _updateId:Int = 0;
        var _x:Vector3d;
        var _y:Vector3d;
        var _z:Vector3d;
        var _directionAxis:Vector3d;
        var _location:Vector3d;
        var _direction:Vector3d;
        var _depth:Vector3d;
        var _scale:Float = 1;
        var _x_scale:Float = 1;
        var _y_scale:Float = 1;
        var _z_scale:Float = 1;
        var _x_scale_internal:Float = 1;
        var _y_scale_internal:Float = 1;
        var _z_scale_internal:Float = 1;
        var _loc:Vector3d;
        var _dir:Vector3d;
        var _clipNear:Float = -500;
        var _clipFar:Float = 500;
        var _displacements:Map = null;

        public function new(k:Float, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d=null)
        {
            this.scale = k;
            this._x = new Vector3d();
            this._y = new Vector3d();
            this._z = new Vector3d();
            this._directionAxis = new Vector3d();
            this._location = new Vector3d();
            this._direction = new Vector3d();
            this._depth = new Vector3d();
            this._x_scale_internal = 1;
            this._y_scale_internal = 1;
            this.x_scale = 1;
            this.y_scale = 1;
            this._z_scale_internal = (Math.sqrt((1 / 2)) / Math.sqrt((3 / 4)));
            this.z_scale = 1;
            this.location = new Vector3d(_arg_3.x, _arg_3.y, _arg_3.z);
            this.direction = new Vector3d(_arg_2.x, _arg_2.y, _arg_2.z);
            if (_arg_4 != null)
            {
                this.setDepthVector(_arg_4);
            }
            else
            {
                this.setDepthVector(_arg_2);
            }
            this._displacements = new Map();
        }

        public static function getIntersectionVector(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d):IVector3d
        {
            var _local_5= Vector3d.dotProduct(_arg_2, _arg_4);
            if (Math.abs(_local_5) < 1E-5)
            {
                return null;
            }
            var _local_6= Vector3d.dif(k, _arg_3);
            var _local_7= (-Vector3d.dotProduct(_arg_4, _local_6) / _local_5);
            var _local_8= Vector3d.sum(k, Vector3d.product(_arg_2, _local_7));
            return _local_8;
        }


        public var updateId(get,never):Int;
function  get_updateId():Int
        {
            return this._updateId;
        }

        
        public var scale(get,set):Float;
function  get_scale():Float
        {
            return this._scale / Math.sqrt(0.5);
        }

        public var directionAxis(get,never):IVector3d;
function  get_directionAxis():IVector3d
        {
            return this._directionAxis;
        }

        
        public var location(get,set):IVector3d;
function  get_location():IVector3d
        {
            this._location.assign(this._loc);
            this._location.x = (this._location.x * this._x_scale);
            this._location.y = (this._location.y * this._y_scale);
            this._location.z = (this._location.z * this._z_scale);
            return this._location;
        }

        
        public var direction(get,set):IVector3d;
function  get_direction():IVector3d
        {
            return this._direction;
        }

        public var x_scale(never,set):Float;
function  set_x_scale(k:Float):Float        {
            if (this._x_scale != (k * this._x_scale_internal))
            {
                this._x_scale = (k * this._x_scale_internal);
                this._updateId++;
            }
return k;
        }

        public var y_scale(never,set):Float;
function  set_y_scale(k:Float):Float        {
            if (this._y_scale != (k * this._y_scale_internal))
            {
                this._y_scale = (k * this._y_scale_internal);
                this._updateId++;
            }
return k;
        }

        public var z_scale(never,set):Float;
function  set_z_scale(k:Float):Float        {
            if (this._z_scale != (k * this._z_scale_internal))
            {
                this._z_scale = (k * this._z_scale_internal);
                this._updateId++;
            }
return k;
        }
function  set_scale(k:Float):Float        {
            if (k <= 1)
            {
                k = 1;
            }
            k = (k * Math.sqrt(0.5));
            if (k != this._scale)
            {
                this._scale = k;
                this._updateId++;
            }
return k;
        }
function  set_location(k:IVector3d):IVector3d        {
            if (k == null)
            {
                return k;
            }
            if (this._loc == null)
            {
                this._loc = new Vector3d();
            }
            var _local_2= this._loc.x;
            var _local_3= this._loc.y;
            var _local_4= this._loc.z;
            this._loc.assign(k);
            this._loc.x = (this._loc.x / this._x_scale);
            this._loc.y = (this._loc.y / this._y_scale);
            this._loc.z = (this._loc.z / this._z_scale);
            if ((((!(this._loc.x == _local_2)) || (!(this._loc.y == _local_3))) || (!(this._loc.z == _local_4))))
            {
                this._updateId++;
            }
return k;
        }
function  set_direction(k:IVector3d):IVector3d        {
            var _local_21:Float;
            var _local_22:Float;
            var _local_23:Vector3d;
            var _local_24:Vector3d;
            var _local_25:Vector3d;
            if (k == null)
            {
                return k;
            }
            if (this._dir == null)
            {
                this._dir = new Vector3d();
            }
            var _local_2= this._dir.x;
            var _local_3= this._dir.y;
            var _local_4= this._dir.z;
            this._dir.assign(k);
            this._direction.assign(k);
            if ((((!(this._dir.x == _local_2)) || (!(this._dir.y == _local_3))) || (!(this._dir.z == _local_4))))
            {
                this._updateId++;
            }
            var _local_5= new Vector3d(0, 1, 0);
            var _local_6= new Vector3d(0, 0, 1);
            var _local_7= new Vector3d(1, 0, 0);
            var _local_8= ((k.x / 180) * Math.PI);
            var _local_9= ((k.y / 180) * Math.PI);
            var _local_10= ((k.z / 180) * Math.PI);
            var _local_11= Math.cos(_local_8);
            var _local_12= Math.sin(_local_8);
            var _local_13= Vector3d.sum(Vector3d.product(_local_5, _local_11), Vector3d.product(_local_7, -_local_12));
            var _local_14= new Vector3d(_local_6.x, _local_6.y, _local_6.z);
            var _local_15= Vector3d.sum(Vector3d.product(_local_5, _local_12), Vector3d.product(_local_7, _local_11));
            var _local_16= Math.cos(_local_9);
            var _local_17= Math.sin(_local_9);
            var _local_18= new Vector3d(_local_13.x, _local_13.y, _local_13.z);
            var _local_19= Vector3d.sum(Vector3d.product(_local_14, _local_16), Vector3d.product(_local_15, _local_17));
            var _local_20= Vector3d.sum(Vector3d.product(_local_14, -_local_17), Vector3d.product(_local_15, _local_16));
            if (_local_10 != 0)
            {
                _local_21 = Math.cos(_local_10);
                _local_22 = Math.sin(_local_10);
                _local_23 = Vector3d.sum(Vector3d.product(_local_18, _local_21), Vector3d.product(_local_19, _local_22));
                _local_24 = Vector3d.sum(Vector3d.product(_local_18, -_local_22), Vector3d.product(_local_19, _local_21));
                _local_25 = new Vector3d(_local_20.x, _local_20.y, _local_20.z);
                this._x.assign(_local_23);
                this._y.assign(_local_24);
                this._z.assign(_local_25);
                this._directionAxis.assign(this._z);
            }
            else
            {
                this._x.assign(_local_18);
                this._y.assign(_local_19);
                this._z.assign(_local_20);
                this._directionAxis.assign(this._z);
            }
return k;
        }

        public function dispose()
        {
            this._x = null;
            this._y = null;
            this._z = null;
            this._loc = null;
            this._dir = null;
            this._directionAxis = null;
            this._location = null;
            if (this._displacements != null)
            {
                this._displacements.dispose();
                this._displacements = null;
            }
        }

        public function setDisplacement(k:IVector3d, _arg_2:IVector3d)
        {
            var _local_3:String;
            var _local_4:Vector3d;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            if (this._displacements != null)
            {
                _local_3 = ((((Std.int(Math.fround(k.x)) + "_") + Std.int(Math.fround(k.y))) + "_") + Std.int(Math.fround(k.z)));
                this._displacements.remove(_local_3);
                _local_4 = new Vector3d();
                _local_4.assign(_arg_2);
                this._displacements.add(_local_3, _local_4);
                this._updateId++;
            }
        }

        function getDisplacement(k:IVector3d):IVector3d
        {
            var _local_2:String;
            if (this._displacements != null)
            {
                _local_2 = ((((Std.int(Math.fround(k.x)) + "_") + Std.int(Math.fround(k.y))) + "_") + Std.int(Math.fround(k.z)));
                return this._displacements.getValue(_local_2);
            }
            return null;
        }

        public function setDepthVector(k:IVector3d)
        {
            var _local_18:Float;
            var _local_19:Float;
            var _local_20:Vector3d;
            var _local_21:Vector3d;
            var _local_22:Vector3d;
            var _local_2= new Vector3d(0, 1, 0);
            var _local_3= new Vector3d(0, 0, 1);
            var _local_4= new Vector3d(1, 0, 0);
            var _local_5= ((k.x / 180) * Math.PI);
            var _local_6= ((k.y / 180) * Math.PI);
            var _local_7= ((k.z / 180) * Math.PI);
            var _local_8= Math.cos(_local_5);
            var _local_9= Math.sin(_local_5);
            var _local_10= Vector3d.sum(Vector3d.product(_local_2, _local_8), Vector3d.product(_local_4, -_local_9));
            var _local_11= new Vector3d(_local_3.x, _local_3.y, _local_3.z);
            var _local_12= Vector3d.sum(Vector3d.product(_local_2, _local_9), Vector3d.product(_local_4, _local_8));
            var _local_13= Math.cos(_local_6);
            var _local_14= Math.sin(_local_6);
            var _local_15= new Vector3d(_local_10.x, _local_10.y, _local_10.z);
            var _local_16= Vector3d.sum(Vector3d.product(_local_11, _local_13), Vector3d.product(_local_12, _local_14));
            var _local_17= Vector3d.sum(Vector3d.product(_local_11, -_local_14), Vector3d.product(_local_12, _local_13));
            if (_local_7 != 0)
            {
                _local_18 = Math.cos(_local_7);
                _local_19 = Math.sin(_local_7);
                _local_20 = Vector3d.sum(Vector3d.product(_local_15, _local_18), Vector3d.product(_local_16, _local_19));
                _local_21 = Vector3d.sum(Vector3d.product(_local_15, -_local_19), Vector3d.product(_local_16, _local_18));
                _local_22 = new Vector3d(_local_17.x, _local_17.y, _local_17.z);
                this._depth.assign(_local_22);
            }
            else
            {
                this._depth.assign(_local_17);
            }
            this._updateId++;
        }

        public function adjustLocation(k:IVector3d, _arg_2:Float)
        {
            if (((k == null) || (this._z == null)))
            {
                return;
            }
            var _local_3= Vector3d.product(this._z, -_arg_2);
            var _local_4= new Vector3d((k.x + _local_3.x), (k.y + _local_3.y), (k.z + _local_3.z));
            this.location = _local_4;
        }

        public function getCoordinatePosition(k:IVector3d):IVector3d
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= Vector3d.scalarProjection(k, this._x);
            var _local_3= Vector3d.scalarProjection(k, this._y);
            var _local_4= Vector3d.scalarProjection(k, this._z);
            var _local_5= new Vector3d(_local_2, _local_3, _local_4);
            return _local_5;
        }

        public function getScreenPosition(k:IVector3d):IVector3d
        {
            var _local_2= Vector3d.dif(k, this._loc);
            _local_2.x = (_local_2.x * this._x_scale);
            _local_2.y = (_local_2.y * this._y_scale);
            _local_2.z = (_local_2.z * this._z_scale);
            var _local_3= Vector3d.scalarProjection(_local_2, this._depth);
            if (((_local_3 < this._clipNear) || (_local_3 > this._clipFar)))
            {
                return null;
            }
            var _local_4= Vector3d.scalarProjection(_local_2, this._x);
            var _local_5= -Vector3d.scalarProjection(_local_2, this._y);
            _local_4 = (_local_4 * this._scale);
            _local_5 = (_local_5 * this._scale);
            var _local_6= this.getDisplacement(k);
            if (_local_6 != null)
            {
                _local_2 = Vector3d.dif(k, this._loc);
                _local_2.add(_local_6);
                _local_2.x = (_local_2.x * this._x_scale);
                _local_2.y = (_local_2.y * this._y_scale);
                _local_2.z = (_local_2.z * this._z_scale);
                _local_3 = Vector3d.scalarProjection(_local_2, this._depth);
            }
            _local_2.x = _local_4;
            _local_2.y = _local_5;
            _local_2.z = _local_3;
            return _local_2;
        }

        public function getScreenPoint(k:IVector3d):Point
        {
            var _local_2= this.getScreenPosition(k);
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= new Point(_local_2.x, _local_2.y);
            return _local_3;
        }

        public function getPlanePosition(k:Point, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d):Point
        {
            var _local_15:Float;
            var _local_16:Float;
            var _local_5= (k.x / this._scale);
            var _local_6= (-k.y / this._scale);
            var _local_7= Vector3d.product(this._x, _local_5);
            _local_7.add(Vector3d.product(this._y, _local_6));
            var _local_8= new Vector3d((this._loc.x * this._x_scale), (this._loc.y * this._y_scale), (this._loc.z * this._z_scale));
            _local_8.add(_local_7);
            var _local_9:IVector3d = this._z;
            var _local_10= new Vector3d((_arg_2.x * this._x_scale), (_arg_2.y * this._y_scale), (_arg_2.z * this._z_scale));
            var _local_11= new Vector3d((_arg_3.x * this._x_scale), (_arg_3.y * this._y_scale), (_arg_3.z * this._z_scale));
            var _local_12= new Vector3d((_arg_4.x * this._x_scale), (_arg_4.y * this._y_scale), (_arg_4.z * this._z_scale));
            var _local_13:IVector3d = Vector3d.crossProduct(_local_11, _local_12);
            var _local_14= new Vector3d();
            _local_14.assign(RoomGeometry.getIntersectionVector(_local_8, _local_9, _local_10, _local_13));
            if (_local_14 != null)
            {
                _local_14.sub(_local_10);
                _local_15 = ((Vector3d.scalarProjection(_local_14, _arg_3) / _local_11.length) * _arg_3.length);
                _local_16 = ((Vector3d.scalarProjection(_local_14, _arg_4) / _local_12.length) * _arg_4.length);
                return new Point(_local_15, _local_16);
            }
            return null;
        }

        public function performZoom()
        {
            if (this.isZoomedIn())
            {
                this.scale = SCALE_ZOOMED_OUT;
            }
            else
            {
                this.scale = SCALE_ZOOMED_IN;
            }
        }

        public function isZoomedIn():Bool
        {
            return this.scale == SCALE_ZOOMED_IN;
        }

        public function performZoomOut()
        {
            this.scale = SCALE_ZOOMED_OUT;
        }

        public function performZoomIn()
        {
            this.scale = SCALE_ZOOMED_IN;
        }
    }

