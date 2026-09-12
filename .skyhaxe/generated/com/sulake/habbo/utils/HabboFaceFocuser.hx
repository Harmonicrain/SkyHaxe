package com.sulake.habbo.utils
;
    import com.sulake.habbo.avatar.IAvatarImage;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class HabboFaceFocuser
    {
        static inline final ICON_HEIGHT_NORMAL= 50;
        static inline final ICON_WIDTH_NORMAL= 50;

        static final X_OFFSETS:Array<ASAny> = [-100, -100, 21, 21, -100, -100, -100, -100, -100];
        static final Y_OFFSETS:Array<ASAny> = [-100, -100, 28, 30, -100, -100, -100, -100, -100];

        public function new()
        {
        }

        public static function focusUserFace(k:IAvatarImage, _arg_2:String, _arg_3:Int, _arg_4:Float, _arg_5:Float=-1, _arg_6:Float=-1):BitmapData
        {
            if (k == null)
            {
                return null;
            }
            var _local_7= Std.int(ICON_WIDTH_NORMAL * _arg_4);
            var _local_8= Std.int(ICON_HEIGHT_NORMAL * _arg_4);
            if (_arg_5 == -1)
            {
                _arg_5 = _local_7;
            }
            if (_arg_6 == -1)
            {
                _arg_6 = _local_8;
            }
            k.setDirection(_arg_2, _arg_3);
            var _local_9= k.getImage(_arg_2, true, _arg_4);
            if (_local_9 == null)
            {
                return null;
            }
            var _local_10= ((_arg_6 - _local_8) / 2);
            var _local_11= new BitmapData(Std.int(_arg_5), Std.int(_arg_6), true, 0);
            var _local_12= new Rectangle(ASCompat.toNumber(ASCompat.toNumber(X_OFFSETS[_arg_3]) * _arg_4), ASCompat.toNumber(ASCompat.toNumber(Y_OFFSETS[_arg_3]) * _arg_4), _local_7, _local_8);
            _local_11.copyPixels(_local_9, _local_12, new Point(0, _local_10));
            return _local_11;
        }

        public static function cutCircleFromBitmap(k:BitmapData, _arg_2:Float):BitmapData
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= k.width;
            var _local_4= k.height;
            var _local_5= new BitmapData(_local_3, _local_4, true, 0);
            var _local_6= new Shape();
            _local_6.graphics.beginFill(0xFFFFFF);
            _local_6.graphics.drawCircle((_local_3 / 2), (_local_4 / 2), _arg_2);
            _local_6.graphics.endFill();
            var _local_7= new BitmapData(_local_3, _local_4, true, 0);
            _local_7.draw(_local_6);
            _local_5.copyPixels(k, new Rectangle(0, 0, _local_3, _local_4), new Point(0, 0), _local_7, new Point(0, 0), true);
            return _local_5;
        }
    }

