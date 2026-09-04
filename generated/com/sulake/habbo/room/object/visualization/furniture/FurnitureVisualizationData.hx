package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.object.visualization.data.SizeData;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.visualization.data.LayerData;
    import com.sulake.habbo.room.object.visualization.data.ColorData;

     class FurnitureVisualizationData implements IRoomObjectVisualizationData 
    {
        public static inline final LAYER_LIMIT= 1000;
        public static final LAYER_NAMES:Array<ASAny> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

        var _sizeDatas:Map;
        var _sizes:Array<ASAny>;
        var _lastSizeData:SizeData = null;
        var _lastSizeDataScale:Int = -1;
        var _lastSize:Int = -1;
        var _lastSizeScale:Int = -1;
        var _type:String = "";

        public function new()
        {
            this._sizes = [];
            this._sizeDatas = new Map();
        }

        public function dispose()
        {
            var k:SizeData;
            var _local_2:Int;
            if (this._sizeDatas != null)
            {
                k = null;
                _local_2 = 0;
                while ((_local_2 : UInt) < this._sizeDatas.length)
                {
                    k = ASCompat.dynamicAs(this._sizeDatas.getWithIndex(_local_2) , SizeData);
                    if (k != null)
                    {
                        k.dispose();
                    }
                    _local_2++;
                }
                this._sizeDatas.dispose();
                this._sizeDatas = null;
            }
            this._lastSizeData = null;
            this._sizes = null;
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            this.reset();
            if (k == null)
            {
                return false;
            }
            var _local_2= k.attribute("type").toString();
            if (_local_2.length == 0)
            {
                return false;
            }
            this._type = _local_2;
            if (!this.defineVisualizations(k))
            {
                this.reset();
                return false;
            }
            return true;
        }

        function reset()
        {
            this._type = "";
            var k:SizeData;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._sizeDatas.length)
            {
                k = ASCompat.dynamicAs(this._sizeDatas.getWithIndex(_local_2) , SizeData);
                if (k != null)
                {
                    k.dispose();
                }
                _local_2++;
            }
            this._sizeDatas.reset();
            this._sizes = [];
            this._lastSizeData = null;
            this._lastSizeDataScale = -1;
        }

        function defineVisualizations(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:Int;
            var _local_7:Int;
            var _local_8:Int;
            var _local_9:SizeData;
            var _local_10:com.sulake.core.utils.xml.XMLList;
            var _local_11:Int;
            var _local_12:com.sulake.core.utils.xml.XML;
            var _local_2= k.child("graphics").child("visualization");
            if (_local_2.length() == 0)
            {
                _local_2 = k.child("visualization");
            }
            if (_local_2.length() == 0)
            {
                return false;
            }
            var _local_3:Int;
            var _local_4 = 0;
            while (_local_4 < _local_2.length())
            {
                _local_5 = _local_2.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, ["size", "layerCount", "angle"]))
                {
                    return false;
                }
                _local_6 = ASCompat.toInt(_local_5.attribute("size").toString());
                _local_7 = ASCompat.toInt(_local_5.attribute("layerCount").toString());
                _local_8 = ASCompat.toInt(_local_5.attribute("angle").toString());
                if (_local_6 < 1)
                {
                    _local_6 = 1;
                }
                if (this._sizeDatas.getValue(Std.string(_local_6)) != null)
                {
                    return false;
                }
                _local_9 = this.createSizeData(_local_6, _local_7, _local_8);
                if (_local_9 == null)
                {
                    return false;
                }
                _local_10 = _local_5.children();
                _local_11 = 0;
                while (_local_11 < _local_10.length())
                {
                    _local_12 = _local_10.at(_local_11);
                    if (!this.processVisualizationElement(_local_9, _local_12))
                    {
                        _local_9.dispose();
                        return false;
                    }
                    _local_11++;
                }
                this._sizeDatas.add(Std.string(_local_6), _local_9);
                this._sizes.push(_local_6);
                ASCompat.ASArray.sortWithOptions(this._sizes, ASCompat.ASArray.NUMERIC);
                _local_4++;
            }
            return true;
        }

        function createSizeData(k:Int, _arg_2:Int, _arg_3:Int):SizeData
        {
            var _local_4:SizeData;
            _local_4 = new SizeData(_arg_2, _arg_3);
            return _local_4;
        }

        function processVisualizationElement(k:SizeData, _arg_2:com.sulake.core.utils.xml.XML):Bool
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            switch (_arg_2.name())
            {
                case "layers":
                    if (!k.defineLayers(_arg_2))
                    {
                        return false;
                    }
                    
                case "directions":
                    if (!k.defineDirections(_arg_2))
                    {
                        return false;
                    }
                    
                case "colors":
                    if (!k.defineColors(_arg_2))
                    {
                        return false;
                    }
                    
            }
            return true;
        }

        public function getType():String
        {
            return this._type;
        }

        function _Str_8560(k:Int):Int
        {
            var _local_3:Int;
            var _local_2 = 0;
            if (k > 0)
            {
                _local_3 = 1;
                while (_local_3 < this._sizes.length)
                {
                    if (this._sizes[_local_3] > k)
                    {
                        if ((ASCompat.toNumber(this._sizes[_local_3]) / k) < (k / ASCompat.toNumber(this._sizes[(_local_3 - 1)])))
                        {
                            _local_2 = _local_3;
                        }
                        break;
                    }
                    _local_2 = _local_3;
                    _local_3++;
                }
            }
            return _local_2;
        }

        public function _Str_3033(k:Int):Int
        {
            if (k == this._lastSizeScale)
            {
                return this._lastSize;
            }
            var _local_2= this._Str_8560(k);
            var _local_3= -1;
            if (_local_2 < this._sizes.length)
            {
                _local_3 = ASCompat.toInt(this._sizes[_local_2]);
            }
            this._lastSizeScale = k;
            this._lastSize = _local_3;
            return _local_3;
        }

        public function getLayerCount(k:Int):Int
        {
            var _local_2= this.getSizeData(k);
            if (_local_2 != null)
            {
                return _local_2.layerCount;
            }
            return 0;
        }

        public function _Str_15687(k:Int, _arg_2:Int):Int
        {
            var _local_3= this.getSizeData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_15687(_arg_2);
            }
            return 0;
        }

        public function _Str_6014(k:Int, _arg_2:Int, _arg_3:Int):String
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_6014(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_TAG;
        }

        public function _Str_10682(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_10682(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_INK;
        }

        public function _Str_11350(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_11350(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_ALPHA;
        }

        public function getColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4.getColor(_arg_2, _arg_3);
            }
            return ColorData.DEFAULT_COLOR;
        }

        public function _Str_12280(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_12280(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_IGNORE_MOUSE;
        }

        public function _Str_10372(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_10372(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_X_OFFSET;
        }

        public function _Str_10926(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_10926(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_Y_OFFSET;
        }

        public function _Str_8329(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            var _local_4= this.getSizeData(k);
            if (_local_4 != null)
            {
                return _local_4._Str_8329(_arg_2, _arg_3);
            }
            return LayerData.DEFAULT_Z_OFFSET;
        }

        function getSizeData(k:Int):SizeData
        {
            if (k == this._lastSizeDataScale)
            {
                return this._lastSizeData;
            }
            var _local_2= this._Str_8560(k);
            if (_local_2 < this._sizes.length)
            {
                this._lastSizeData = ASCompat.dynamicAs(this._sizeDatas.getValue(ASCompat.toString(this._sizes[_local_2])) , SizeData);
            }
            else
            {
                this._lastSizeData = null;
            }
            this._lastSizeDataScale = k;
            return this._lastSizeData;
        }
    }

