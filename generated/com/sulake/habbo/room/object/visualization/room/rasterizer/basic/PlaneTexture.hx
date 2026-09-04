package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;

     class PlaneTexture 
    {
        public static inline final MIN_NORMAL_COORDINATE_VALUE:Float = -1;
        public static inline final MAX_NORMAL_COORDINATE_VALUE:Float = 1;

        var _bitmaps:Array<ASAny>;

        public function new()
        {
            this._bitmaps = [];
        }

        public function dispose()
        {
            var k:Int;
            var _local_2:PlaneTextureBitmap;
            if (this._bitmaps != null)
            {
                k = 0;
                while (k < this._bitmaps.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._bitmaps[k] , PlaneTextureBitmap);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._bitmaps = null;
            }
        }

        public function addBitmap(k:BitmapData, _arg_2:Float=-1, _arg_3:Float=1, _arg_4:Float=-1, _arg_5:Float=1, _arg_6:String=null)
        {
            var _local_7= new PlaneTextureBitmap(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this._bitmaps.push(_local_7);
        }

        public function getBitmap(k:IVector3d):BitmapData
        {
            var _local_2= this._Str_21702(k);
            return (_local_2 == null) ? null : _local_2.bitmap;
        }

        public function _Str_21702(k:IVector3d):PlaneTextureBitmap
        {
            var _local_3:PlaneTextureBitmap;
            if (k == null)
            {
                return null;
            }
            var _local_2 = 0;
            while (_local_2 < this._bitmaps.length)
            {
                _local_3 = ASCompat.dynamicAs(this._bitmaps[_local_2] , PlaneTextureBitmap);
                if (_local_3 != null)
                {
                    if (((((k.x >= _local_3.normalMinX) && (k.x <= _local_3.normalMaxX)) && (k.y >= _local_3.normalMinY)) && (k.y <= _local_3.normalMaxY)))
                    {
                        return _local_3;
                    }
                }
                _local_2++;
            }
            return null;
        }

        public function getAliasByName(k:IVector3d):String
        {
            var _local_2= this._Str_21702(k);
            return (_local_2 == null) ? null : _local_2.assetName;
        }
    }

