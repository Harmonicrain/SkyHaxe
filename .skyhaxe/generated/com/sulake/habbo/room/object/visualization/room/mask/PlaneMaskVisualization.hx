package com.sulake.habbo.room.object.visualization.room.mask
;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.utils.IVector3d;

     class PlaneMaskVisualization 
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
            var k = 0;
            var _local_2:PlaneMaskBitmap = null;
            if (this._bitmaps != null)
            {
                k = 0;
                while (k < this._bitmaps.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._bitmaps[k] , PlaneMaskBitmap);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._bitmaps = null;
            }
        }

        public function addBitmap(k:IGraphicAsset, _arg_2:Float=-1, _arg_3:Float=1, _arg_4:Float=-1, _arg_5:Float=1)
        {
            var _local_6= new PlaneMaskBitmap(k, _arg_2, _arg_3, _arg_4, _arg_5);
            this._bitmaps.push(_local_6);
        }

        public function getAsset(k:IVector3d):IGraphicAsset
        {
            var _local_3:PlaneMaskBitmap = null;
            if (k == null)
            {
                return null;
            }
            var _local_2 = 0;
            while (_local_2 < this._bitmaps.length)
            {
                _local_3 = ASCompat.dynamicAs(this._bitmaps[_local_2] , PlaneMaskBitmap);
                if (_local_3 != null)
                {
                    if (((((k.x >= _local_3.normalMinX) && (k.x <= _local_3.normalMaxX)) && (k.y >= _local_3.normalMinY)) && (k.y <= _local_3.normalMaxY)))
                    {
                        return _local_3.asset;
                    }
                }
                _local_2++;
            }
            return null;
        }
    }

