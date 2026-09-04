package com.sulake.habbo.room.object.visualization.room.mask
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.utils.IVector3d;

     class PlaneMask 
    {
        var _maskVisualizations:Map;
        var _sizes:Array<ASAny>;
        var _assetNames:Map;
        var _lastMaskVisualization:PlaneMaskVisualization = null;
        var _lastSize:Int = -1;

        public function new()
        {
            this._sizes = [];
            this._maskVisualizations = new Map();
            this._assetNames = new Map();
        }

        public function dispose()
        {
            var k:PlaneMaskVisualization;
            var _local_2:Int;
            if (this._maskVisualizations != null)
            {
                k = null;
                _local_2 = 0;
                while ((_local_2 : UInt) < this._maskVisualizations.length)
                {
                    k = ASCompat.dynamicAs(this._maskVisualizations.getWithIndex(_local_2) , PlaneMaskVisualization);
                    if (k != null)
                    {
                        k.dispose();
                    }
                    _local_2++;
                }
                this._maskVisualizations.dispose();
                this._maskVisualizations = null;
            }
            this._lastMaskVisualization = null;
            this._sizes = null;
        }

        public function createMaskVisualization(k:Int):PlaneMaskVisualization
        {
            if (this._maskVisualizations.getValue(Std.string(k)) != null)
            {
                return null;
            }
            var _local_2= new PlaneMaskVisualization();
            this._maskVisualizations.add(Std.string(k), _local_2);
            this._sizes.push(k);
            this._sizes.sort(Reflect.compare);
            return _local_2;
        }

        function _Str_8560(k:Int):Int
        {
            var _local_2 = 0;
            var _local_3= 1;
            while (_local_3 < this._sizes.length)
            {
                if (this._sizes[_local_3] > k)
                {
                    if ((ASCompat.toNumber(this._sizes[_local_3]) - k) < (k - ASCompat.toNumber(this._sizes[(_local_3 - 1)])))
                    {
                        _local_2 = _local_3;
                    }
                    break;
                }
                _local_2 = _local_3;
                _local_3++;
            }
            return _local_2;
        }

        function getMaskVisualization(k:Int):PlaneMaskVisualization
        {
            if (k == this._lastSize)
            {
                return this._lastMaskVisualization;
            }
            var _local_2= this._Str_8560(k);
            if (_local_2 < this._sizes.length)
            {
                this._lastMaskVisualization = ASCompat.dynamicAs(this._maskVisualizations.getValue(ASCompat.toString(this._sizes[_local_2])) , PlaneMaskVisualization);
            }
            else
            {
                this._lastMaskVisualization = null;
            }
            this._lastSize = k;
            return this._lastMaskVisualization;
        }

        public function getGraphicAsset(k:Float, _arg_2:IVector3d):IGraphicAsset
        {
            var _local_3= this.getMaskVisualization(Std.int(k));
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= _local_3.getAsset(_arg_2);
            return _local_4;
        }

        public function getAliasByName(k:Int):String
        {
            return this._assetNames.getValue(k);
        }

        public function _Str_24425(k:Int, _arg_2:String)
        {
            this._assetNames.add(k, _arg_2);
        }
    }

