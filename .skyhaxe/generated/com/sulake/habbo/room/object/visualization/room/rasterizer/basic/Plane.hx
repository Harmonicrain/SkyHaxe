package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.IRoomGeometry;

     class Plane 
    {
        var _planeVisualizations:Map;
        var _sizes:Array<ASAny>;
        var _lastPlaneVisualization:PlaneVisualization = null;
        var _lastSize:Int = -1;

        public function new()
        {
            this._sizes = [];
            this._planeVisualizations = new Map();
        }

        public function isStatic(k:Int):Bool
        {
            return true;
        }

        public function dispose()
        {
            var k:PlaneVisualization = null;
            var _local_2 = 0;
            if (this._planeVisualizations != null)
            {
                k = null;
                _local_2 = 0;
                while ((_local_2 : UInt) < this._planeVisualizations.length)
                {
                    k = ASCompat.dynamicAs(this._planeVisualizations.getWithIndex(_local_2) , PlaneVisualization);
                    if (k != null)
                    {
                        k.dispose();
                    }
                    _local_2++;
                }
                this._planeVisualizations.dispose();
                this._planeVisualizations = null;
            }
            this._lastPlaneVisualization = null;
            this._sizes = null;
        }

        public function clearCache()
        {
            var _local_2:PlaneVisualization = null;
            var k = 0;
            while ((k : UInt) < this._planeVisualizations.length)
            {
                _local_2 = ASCompat.dynamicAs(this._planeVisualizations.getWithIndex(k) , PlaneVisualization);
                if (_local_2 != null)
                {
                    _local_2.clearCache();
                }
                k++;
            }
        }

        public function createPlaneVisualization(k:Int, _arg_2:Int, _arg_3:IRoomGeometry):PlaneVisualization
        {
            if (this._planeVisualizations.getValue(Std.string(k)) != null)
            {
                return null;
            }
            var _local_4= new PlaneVisualization(k, _arg_2, _arg_3);
            this._planeVisualizations.add(Std.string(k), _local_4);
            this._sizes.push(k);
            this._sizes.sort(Reflect.compare);
            return _local_4;
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

        function getPlaneVisualization(k:Int):PlaneVisualization
        {
            if (k == this._lastSize)
            {
                return this._lastPlaneVisualization;
            }
            var _local_2= this._Str_8560(k);
            if (_local_2 < this._sizes.length)
            {
                this._lastPlaneVisualization = ASCompat.dynamicAs(this._planeVisualizations.getValue(ASCompat.toString(this._sizes[_local_2])) , PlaneVisualization);
            }
            else
            {
                this._lastPlaneVisualization = null;
            }
            this._lastSize = k;
            return this._lastPlaneVisualization;
        }

        public function getLayers():Array<ASAny>
        {
            return this.getPlaneVisualization(this._lastSize).getLayers();
        }
    }

