package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import flash.display.BitmapData;

     class Twinkle implements AnimationObject implements  IDisposable 
    {
        static inline final _Str_17554= 100;
        static final _Str_15029:Array<ASAny> = [1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1];
        static inline final _Str_18234= -1;
        static inline final _Str_14452= -2;
        static final _Str_14372:Point = new Point(44, 44);

        var _twinkleImages:TwinkleImages;
        var _startTimeInMsecs:Int = 0;
        var _position:Point;

        public function new(k:TwinkleImages, _arg_2:Int)
        {
            this._twinkleImages = k;
            this._startTimeInMsecs = _arg_2;
        }

        public function dispose()
        {
            this._twinkleImages = null;
            this._position = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._twinkleImages == null;
        }

        public function _Str_21940()
        {
            this._position = new Point(Math.fround((Math.random() * _Str_14372.x)), Math.fround((Math.random() * _Str_14372.y)));
        }

        public function getPosition(k:Int):Point
        {
            return this._position;
        }

        public function _Str_22065(k:Int):Bool
        {
            return this.getFrame(k) == _Str_14452;
        }

        public function getBitmap(k:Int):BitmapData
        {
            var _local_2= this.getFrame(k);
            var _local_3= this._twinkleImages.getImage(ASCompat.toInt(_Str_15029[_local_2]));
            return _local_3;
        }

        function getFrame(k:Int):Int
        {
            var _local_2= (k - this._startTimeInMsecs);
            if (_local_2 < 0)
            {
                return _Str_18234;
            }
            var _local_3= Std.int(Math.ffloor((_local_2 / _Str_17554)));
            if (_local_3 >= _Str_15029.length)
            {
                return _Str_14452;
            }
            return _local_3;
        }
    }

