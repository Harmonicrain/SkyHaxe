package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class AnimationItem 
    {
        var _x:Float = 0;
        var _y:Float = 0;
        var _speedX:Float = 0;
        var _speedY:Float = 0;
        var _bitmapData:BitmapData = null;

        public function new(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:BitmapData)
        {
            this._x = k;
            this._y = _arg_2;
            this._speedX = _arg_3;
            this._speedY = _arg_4;
            if (Math.isNaN(this._x))
            {
                this._x = 0;
            }
            if (Math.isNaN(this._y))
            {
                this._y = 0;
            }
            if (Math.isNaN(this._speedX))
            {
                this._speedX = 0;
            }
            if (Math.isNaN(this._speedY))
            {
                this._speedY = 0;
            }
            this._bitmapData = _arg_5;
        }

        public var bitmapData(get,never):BitmapData;
public function  get_bitmapData():BitmapData
        {
            return this._bitmapData;
        }

        public function dispose()
        {
            this._bitmapData = null;
        }

        public function getPosition(k:Int, _arg_2:Int, _arg_3:Float, _arg_4:Float, _arg_5:Int):Point
        {
            var _local_6= this._x;
            var _local_7= this._y;
            if (_arg_3 > 0)
            {
                _local_6 = (_local_6 + (((this._speedX / _arg_3) * _arg_5) / 1000));
            }
            if (_arg_4 > 0)
            {
                _local_7 = (_local_7 + (((this._speedY / _arg_4) * _arg_5) / 1000));
            }
            var _local_8= Std.int((_local_6 % 1) * k);
            var _local_9= Std.int((_local_7 % 1) * _arg_2);
            return new Point(_local_8, _local_9);
        }
    }

