package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.Plane;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class LandscapePlane extends Plane 
    {
        public static inline final DEFAULT_COLOR:UInt = 0xFFFFFF;
        public static inline final HORIZONTAL_ANGLE_DEFAULT:Float = 45;
        public static inline final VERTICAL_ANGLE_DEFAULT:Float = 30;

        var _width:Int = 0;
        var _height:Int = 0;


        override public function isStatic(k:Int):Bool
        {
            var _local_2= getPlaneVisualization(k);
            if (_local_2 != null)
            {
                return !_local_2.hasAnimationLayers;
            }
            return super.isStatic(k);
        }

        public function initializeDimensions(k:Int, _arg_2:Int)
        {
            if (k < 0)
            {
                k = 0;
            }
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            }
            if (((!(k == this._width)) || (!(_arg_2 == this._height))))
            {
                this._width = k;
                this._height = _arg_2;
            }
        }

        public function render(k:BitmapData, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:IVector3d, _arg_6:Bool, _arg_7:Float, _arg_8:Float, _arg_9:Float, _arg_10:Float, _arg_11:Int):BitmapData
        {
            var _local_16 = 0;
            var _local_17 = 0;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20:BitmapData = null;
            var _local_12= getPlaneVisualization(Std.int(_arg_4));
            if (((_local_12 == null) || (_local_12.geometry == null)))
            {
                return null;
            }
            var _local_13= _local_12.geometry.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_14= _local_12.geometry.getScreenPoint(new Vector3d(0, 0, 1));
            var _local_15= _local_12.geometry.getScreenPoint(new Vector3d(0, 1, 0));
            if ((((!(_local_13 == null)) && (!(_local_14 == null))) && (!(_local_15 == null))))
            {
                _arg_2 = Math.fround(Math.abs((((_local_13.x - _local_15.x) * _arg_2) / _local_12.geometry.scale)));
                _arg_3 = Math.fround(Math.abs((((_local_13.y - _local_14.y) * _arg_3) / _local_12.geometry.scale)));
                _local_16 = Std.int(_arg_7 * Math.abs((_local_13.x - _local_15.x)));
                _local_17 = Std.int(_arg_8 * Math.abs((_local_13.y - _local_14.y)));
                _local_18 = Std.int(_arg_9 * Math.abs((_local_13.x - _local_15.x)));
                _local_19 = Std.int(_arg_10 * Math.abs((_local_13.y - _local_14.y)));
                _local_20 = _local_12.render(k, Std.int(_arg_2), Std.int(_arg_3), _arg_5, _arg_6, _local_16, _local_17, _local_18, _local_19, _arg_9, _arg_10, _arg_11);
                return _local_20;
            }
            return null;
        }

	public function new() { super(); }
    }

