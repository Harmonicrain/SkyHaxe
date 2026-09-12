package com.sulake.habbo.room.object.visualization.data
;
     class DirectionData 
    {
        public static inline final USE_DEFAULT_DIRECTION= -1;

        var _layers:Array<ASAny>;

        public function new(k:Int)
        {
            var _local_3:LayerData = null;
            this._layers = [];
            var _local_2 = 0;
            while (_local_2 < k)
            {
                _local_3 = new LayerData();
                this._layers.push(_local_3);
                _local_2++;
            }
        }

        public function dispose()
        {
            this._layers = null;
        }

        public var layerCount(get,never):Int;
public function  get_layerCount():Int
        {
            return this._layers.length;
        }

        function getLayer(k:Int):LayerData
        {
            if (((k < 0) || (k >= this.layerCount)))
            {
                return null;
            }
            return this._layers[k];
        }

        public function _Str_6014(k:Int):String
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2.tag;
            }
            return LayerData.DEFAULT_TAG;
        }

        public function setTag(k:Int, _arg_2:String)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3.tag = _arg_2;
            }
        }

        public function _Str_10682(k:Int):Int
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2.ink;
            }
            return LayerData.DEFAULT_INK;
        }

        public function setInk(k:Int, _arg_2:Int)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3.ink = _arg_2;
            }
        }

        public function _Str_11350(k:Int):Int
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2.alpha;
            }
            return LayerData.DEFAULT_ALPHA;
        }

        public function setAlpha(k:Int, _arg_2:Int)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3.alpha = _arg_2;
            }
        }

        public function _Str_12280(k:Int):Bool
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2.ignoreMouse;
            }
            return LayerData.DEFAULT_IGNORE_MOUSE;
        }

        public function window1(k:Int, _arg_2:Bool)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3.ignoreMouse = _arg_2;
            }
        }

        public function _Str_10372(k:Int):Int
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2._Str_11051;
            }
            return LayerData.DEFAULT_X_OFFSET;
        }

        public function setXOffset(k:Int, _arg_2:Int)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3._Str_11051 = _arg_2;
            }
        }

        public function _Str_10926(k:Int):Int
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2._Str_10285;
            }
            return LayerData.DEFAULT_Y_OFFSET;
        }

        public function setYOffset(k:Int, _arg_2:Int)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3._Str_10285 = _arg_2;
            }
        }

        public function _Str_8329(k:Int):Float
        {
            var _local_2= this.getLayer(k);
            if (_local_2 != null)
            {
                return _local_2._Str_12320;
            }
            return LayerData.DEFAULT_Z_OFFSET;
        }

        public function setZOffset(k:Int, _arg_2:Float)
        {
            var _local_3= this.getLayer(k);
            if (_local_3 != null)
            {
                _local_3._Str_12320 = _arg_2;
            }
        }

        public function _Str_17122(k:DirectionData)
        {
            if (k == null)
            {
                return;
            }
            if (this.layerCount != k.layerCount)
            {
                return;
            }
            var _local_2:LayerData = null;
            var _local_3:LayerData = null;
            var _local_4 = 0;
            while (_local_4 < this.layerCount)
            {
                _local_2 = this.getLayer(_local_4);
                _local_3 = k.getLayer(_local_4);
                if (_local_2 != null)
                {
                    _local_2._Str_17122(_local_3);
                }
                _local_4++;
            }
        }
    }

