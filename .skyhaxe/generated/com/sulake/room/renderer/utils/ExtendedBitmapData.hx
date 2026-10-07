package com.sulake.room.renderer.utils
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class ExtendedBitmapData extends BitmapData 
    {
        static final ZERO_POINT:Point = new Point(0, 0);

        var _referenceCount:Int = 0;
        var _disposed:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool=true, _arg_4:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        public var referenceCount(get,never):Int;
public function  get_referenceCount():Int
        {
            return this._referenceCount;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_9215()
        {
            this._referenceCount++;
        }

        override public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (--this._referenceCount <= 0)
            {
                super.dispose();
                this._disposed = true;
            }
        }

        override public function clone():BitmapData
        {
            var data:ExtendedBitmapData = null;
            try
            {
                data = new ExtendedBitmapData(width, height, true, 0xFFFFFF);
                data.copyPixels(this, rect, ZERO_POINT, null, null, true);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                data = new ExtendedBitmapData(1, 1, true, 0xFFFFFF);
            }
 }            return data;
        }
    }

