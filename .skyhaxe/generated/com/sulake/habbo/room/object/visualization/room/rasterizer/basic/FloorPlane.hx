package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;

     class FloorPlane extends Plane 
    {
        public static inline final DEFAULT_COLOR:UInt = 0xFFFFFF;
        public static inline final HORIZONTAL_ANGLE_DEFAULT:Float = 45;
        public static inline final VERTICAL_ANGLE_DEFAULT:Float = 30;


        public function render(k:BitmapData, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:IVector3d, _arg_6:Bool, _arg_7:Float, _arg_8:Float):BitmapData
        {
            var _local_15 = Math.NaN;
            var _local_9= getPlaneVisualization(Std.int(_arg_4));
            if (((_local_9 == null) || (_local_9.geometry == null)))
            {
                return null;
            }
            var _local_10= _local_9.geometry.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_11= _local_9.geometry.getScreenPoint(new Vector3d(0, (_arg_3 / _local_9.geometry.scale), 0));
            var _local_12= _local_9.geometry.getScreenPoint(new Vector3d((_arg_2 / _local_9.geometry.scale), 0, 0));
            var _local_13 = 0;
            var _local_14 = 0;
            if ((((!(_local_10 == null)) && (!(_local_11 == null))) && (!(_local_12 == null))))
            {
                _arg_2 = Math.fround(Math.abs((_local_10.x - _local_12.x)));
                _arg_3 = Math.fround(Math.abs((_local_10.x - _local_11.x)));
                _local_15 = (_local_10.x - _local_9.geometry.getScreenPoint(new Vector3d(1, 0, 0)).x);
                _local_13 = Std.int(_arg_7 * Std.int(Math.abs(_local_15)));
                _local_14 = Std.int(_arg_8 * Std.int(Math.abs(_local_15)));
            }
            return _local_9.render(k, Std.int(_arg_2), Std.int(_arg_3), _arg_5, _arg_6, _local_13, _local_14);
        }

	public function new() { super(); }
    }

