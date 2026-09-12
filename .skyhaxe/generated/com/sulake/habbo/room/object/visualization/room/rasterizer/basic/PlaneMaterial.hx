package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.IVector3d;
    import flash.display.BitmapData;

     class PlaneMaterial 
    {
        public static inline final MIN_NORMAL_COORDINATE_VALUE:Float = -1;
        public static inline final MAX_NORMAL_COORDINATE_VALUE:Float = 1;

        var _planeMaterialItems:Array<ASAny>;
        var _isCached:Bool = false;

        public function new()
        {
            this._planeMaterialItems = [];
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:PlaneMaterialCellMatrix = null;
            if (this._planeMaterialItems != null)
            {
                k = 0;
                while (k < this._planeMaterialItems.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._planeMaterialItems[k] , PlaneMaterialCellMatrix);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._planeMaterialItems = null;
            }
        }

        public function clearCache()
        {
            var k = 0;
            var _local_2:PlaneMaterialCellMatrix = null;
            if (!this._isCached)
            {
                return;
            }
            if (this._planeMaterialItems != null)
            {
                k = 0;
                while (k < this._planeMaterialItems.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._planeMaterialItems[k] , PlaneMaterialCellMatrix);
                    if (_local_2 != null)
                    {
                        _local_2.clearCache();
                    }
                    k++;
                }
            }
            this._isCached = false;
        }

        public function addMaterialCellMatrix(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Float=-1, _arg_5:Float=1, _arg_6:Float=-1, _arg_7:Float=1):PlaneMaterialCellMatrix
        {
            var _local_8:PlaneMaterialCellMatrix = null;
            _local_8 = new PlaneMaterialCellMatrix(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            this._planeMaterialItems.push(_local_8);
            return _local_8;
        }

        public function getMaterialCellMatrix(k:IVector3d):PlaneMaterialCellMatrix
        {
            var _local_3:PlaneMaterialCellMatrix = null;
            if (k == null)
            {
                return null;
            }
            var _local_2 = 0;
            while (_local_2 < this._planeMaterialItems.length)
            {
                _local_3 = ASCompat.dynamicAs(this._planeMaterialItems[_local_2] , PlaneMaterialCellMatrix);
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

        public function render(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:Bool, _arg_6:Int, _arg_7:Int, _arg_8:Bool):BitmapData
        {
            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            }
            if (_arg_3 < 1)
            {
                _arg_3 = 1;
            }
            var _local_9= this.getMaterialCellMatrix(_arg_4);
            if (_local_9 != null)
            {
                this._isCached = true;
                return _local_9.render(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            }
            return null;
        }
    }

