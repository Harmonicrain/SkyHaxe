package com.sulake.core.utils.profiler.tracking
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class TrackedBitmapData extends BitmapData 
    {
        static inline final MAX_SIZE= 0xFFFFFF;
        static inline final MAX_WIDTH= 8191;
        static inline final MAX_HEIGHT= 8191;
        static inline final MIN_SIZE= 1;
        static inline final MIN_WIDTH= 1;
        public static inline final MIN_HEIGHT= 4095;
        static var _numInstances:UInt = 0;
        static var _allocatedByteCount:UInt = 0;
        static final ZERO_POINT:Point = new Point();

        var _owner:ASObject;
        var _disposed:Bool = false;

        public function new(k:ASAny, _arg_2:Int, _arg_3:Int, _arg_4:Bool=true, _arg_5:UInt=0xFFFFFFFF)
        {
            if ((_arg_2 * _arg_3) > MAX_SIZE)
            {
                _arg_2 = MIN_HEIGHT;
                _arg_3 = MIN_HEIGHT;
            }
            else
            {
                if (_arg_2 > MAX_WIDTH)
                {
                    _arg_2 = MAX_WIDTH;
                }
                else
                {
                    if (_arg_2 < MIN_SIZE)
                    {
                        _arg_2 = MIN_SIZE;
                    }
                }
                if (_arg_3 > MAX_HEIGHT)
                {
                    _arg_3 = MAX_HEIGHT;
                }
                else
                {
                    if (_arg_3 < MIN_WIDTH)
                    {
                        _arg_3 = MIN_WIDTH;
                    }
                }
            }
            super(_arg_2, _arg_3, _arg_4, _arg_5);
            _numInstances++;
            _allocatedByteCount = (_allocatedByteCount + ((_arg_2 * _arg_3) * 4));
            this._owner = k;
        }

        public static var numInstances(get,never):UInt;
public static function  get_numInstances():UInt
        {
            return _numInstances;
        }

        public static var allocatedByteCount(get,never):UInt;
public static function  get_allocatedByteCount():UInt
        {
            return _allocatedByteCount;
        }


        override public function dispose()
        {
            if (!this._disposed)
            {
                _allocatedByteCount = (_allocatedByteCount - ((width * height) * 4));
                _numInstances--;
                this._disposed = true;
                this._owner = null;
                super.dispose();
            }
        }

        override public function clone():BitmapData
        {
            if (this._disposed)
            {
                return null;
            }
            var copy= new TrackedBitmapData(this._owner, width, height, transparent);
            copy.copyPixels(this, rect, ZERO_POINT);
            return copy;
        }
    }

