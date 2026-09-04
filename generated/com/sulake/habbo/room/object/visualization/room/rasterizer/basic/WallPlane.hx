package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;

     class WallPlane extends Plane 
    {
        public static inline final DEFAULT_COLOR:UInt = 0xFFFFFF;
        public static inline final HORIZONTAL_ANGLE_DEFAULT:Float = 45;
        public static inline final VERTICAL_ANGLE_DEFAULT:Float = 30;


        public function render(k:BitmapData, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:IVector3d, _arg_6:Bool):BitmapData
        {
            var _local_7= getPlaneVisualization(Std.int(_arg_4));
            if (((_local_7 == null) || (_local_7.geometry == null)))
            {
                return null;
            }
            var _local_8= _local_7.geometry.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_9= _local_7.geometry.getScreenPoint(new Vector3d(0, 0, (_arg_3 / _local_7.geometry.scale)));
            var _local_10= _local_7.geometry.getScreenPoint(new Vector3d(0, (_arg_2 / _local_7.geometry.scale), 0));
            if ((((!(_local_8 == null)) && (!(_local_9 == null))) && (!(_local_10 == null))))
            {
                _arg_2 = Math.fround(Math.abs((_local_8.x - _local_10.x)));
                _arg_3 = Math.fround(Math.abs((_local_8.y - _local_9.y)));
            }
            return _local_7.render(k, Std.int(_arg_2), Std.int(_arg_3), _arg_5, _arg_6);
        }

	public function new() { super(); }
    }

