package com.sulake.habbo.room.object.visualization.data
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XMLValidator;

     class SizeData 
    {
        public static inline final LAYER_LIMIT= 1000;
        public static inline final DEFAULT_DIRECTION= 0;

        var _layerCount:Int = 0;
        var _angle:Int = 360;
        var _defaultDirection:DirectionData = null;
        var _directions:Map;
        var _colors:Map;
        var _lastDirectionData:DirectionData = null;
        var _lastDirection:Int = -1;

        public function new(k:Int, _arg_2:Int)
        {
            if (k < 0)
            {
                k = 0;
            }
            if (k > LAYER_LIMIT)
            {
                k = LAYER_LIMIT;
            }
            this._layerCount = k;
            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            }
            if (_arg_2 > 360)
            {
                _arg_2 = 360;
            }
            this._angle = _arg_2;
            this._defaultDirection = new DirectionData(k);
            this._directions = new Map();
            this._colors = new Map();
        }

        public function dispose()
        {
            var _local_2:DirectionData;
            var _local_3:ColorData;
            if (this._defaultDirection != null)
            {
                this._defaultDirection.dispose();
                this._defaultDirection = null;
            }
            var k:Int;
            if (this._directions != null)
            {
                _local_2 = null;
                k = 0;
                while ((k : UInt) < this._directions.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._directions.getWithIndex(k) , DirectionData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._directions.dispose();
                this._directions = null;
            }
            this._lastDirectionData = null;
            if (this._colors != null)
            {
                _local_3 = null;
                k = 0;
                while ((k : UInt) < this._colors.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._colors.getWithIndex(k) , ColorData);
                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    }
                    k++;
                }
                this._colors.dispose();
                this._colors = null;
            }
        }

        public var layerCount(get,never):Int;
function  get_layerCount():Int
        {
            return this._layerCount;
        }

        public function defineLayers(k:com.sulake.core.utils.xml.XML):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= k.child("layer");
            return this.defineDirection(this._defaultDirection, _local_2);
        }

        public function defineDirections(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_6:com.sulake.core.utils.xml.XML;
            var _local_7:Int;
            var _local_8:com.sulake.core.utils.xml.XMLList;
            if (k == null)
            {
                return false;
            }
            var _local_2:Array<ASAny> = ["id"];
            var _local_3:DirectionData;
            var _local_4= k.child("direction");
            var _local_5 = 0;
            while (_local_5 < _local_4.length())
            {
                _local_6 = _local_4.at(_local_5);
                if (!XMLValidator.checkRequiredAttributes(_local_6, _local_2))
                {
                    return false;
                }
                _local_7 = ASCompat.toInt(_local_6.attribute("id").toString());
                _local_8 = _local_6.child("layer");
                if (this._directions.getValue(Std.string(_local_7)) != null)
                {
                    return false;
                }
                _local_3 = new DirectionData(this.layerCount);
                _local_3._Str_17122(this._defaultDirection);
                this.defineDirection(_local_3, _local_8);
                this._directions.add(Std.string(_local_7), _local_3);
                this._lastDirection = -1;
                this._lastDirectionData = null;
                _local_5++;
            }
            return true;
        }

        function defineDirection(k:DirectionData, _arg_2:com.sulake.core.utils.xml.XMLList):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:Int;
            var _local_7:String;
            var _local_8:String;
            var _local_9:Int;
            var _local_10:Int;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            var _local_3:Array<ASAny> = ["id"];
            var _local_4 = 0;
            while (_local_4 < _arg_2.length())
            {
                _local_5 = _arg_2.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, _local_3))
                {
                    return false;
                }
                _local_6 = ASCompat.toInt(_local_5.attribute("id").toString());
                if (((_local_6 < 0) || (_local_6 >= this.layerCount)))
                {
                    return false;
                }
                _local_7 = _local_5.attribute("tag").toString();
                if (_local_7.length > 0)
                {
                    k.setTag(_local_6, _local_7);
                }
                _local_8 = _local_5.attribute("ink").toString();
                switch (_local_8)
                {
                    case "ADD":
                        k.setInk(_local_6, LayerData.INK_ADD);
                        
                    case "SUBTRACT":
                        k.setInk(_local_6, LayerData.INK_SUBTRACT);
                        
                    case "DARKEN":
                        k.setInk(_local_6, LayerData.INK_DARKEN);
                        
                }
                _local_7 = _local_5.attribute("alpha").toString();
                if (_local_7.length > 0)
                {
                    k.setAlpha(_local_6, ASCompat.toInt(_local_7));
                }
                _local_7 = _local_5.attribute("ignoreMouse").toString();
                if (_local_7.length > 0)
                {
                    _local_9 = ASCompat.toInt(_local_7);
                    k.window1(_local_6, (!(_local_9 == 0)));
                }
                _local_7 = _local_5.attribute("x").toString();
                if (_local_7.length > 0)
                {
                    k.setXOffset(_local_6, ASCompat.toInt(_local_7));
                }
                _local_7 = _local_5.attribute("y").toString();
                if (_local_7.length > 0)
                {
                    k.setYOffset(_local_6, ASCompat.toInt(_local_7));
                }
                _local_7 = _local_5.attribute("z").toString();
                if (_local_7.length > 0)
                {
                    _local_10 = ASCompat.toInt(_local_7);
                    k.setZOffset(_local_6, (_local_10 / -1000));
                }
                _local_4++;
            }
            return true;
        }

        public function defineColors(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_7:com.sulake.core.utils.xml.XML;
            var _local_8:String;
            var _local_9:com.sulake.core.utils.xml.XMLList;
            var _local_10:Int;
            var _local_11:com.sulake.core.utils.xml.XML;
            var _local_12:Int;
            var _local_13:Int;
            if (k == null)
            {
                return true;
            }
            var _local_2:ColorData;
            var _local_3:Array<ASAny> = ["id"];
            var _local_4:Array<ASAny> = ["id", "color"];
            var _local_5= k.child("color");
            var _local_6 = 0;
            while (_local_6 < _local_5.length())
            {
                _local_7 = _local_5.at(_local_6);
                if (!XMLValidator.checkRequiredAttributes(_local_7, _local_3))
                {
                    return false;
                }
                _local_8 = _local_7.attribute("id").toString();
                if (this._colors.getValue(_local_8) != null)
                {
                    return false;
                }
                _local_2 = new ColorData(this.layerCount);
                _local_9 = _local_7.child("colorLayer");
                _local_10 = 0;
                while (_local_10 < _local_9.length())
                {
                    _local_11 = _local_9.at(_local_10);
                    if (!XMLValidator.checkRequiredAttributes(_local_11, _local_4))
                    {
                        _local_2.dispose();
                        return false;
                    }
                    _local_12 = ASCompat.toInt(_local_11.attribute("id").toString());
                    _local_13 = ASCompat.parseInt(_local_11.attribute("color").toString(), 16);
                    _local_2.setColor(_local_13, _local_12);
                    _local_10++;
                }
                if (_local_2 != null)
                {
                    this._colors.add(_local_8, _local_2);
                }
                _local_6++;
            }
            return true;
        }

        public function _Str_15687(k:Int):Int
        {
            var _local_6:Int;
            var _local_7:Int;
            var _local_2= Std.int(((((k % 360) + 360) + (this._angle / 2)) % 360) / this._angle);
            if (this._directions.getValue(Std.string(_local_2)) != null)
            {
                return _local_2;
            }
            _local_2 = (((k % 360) + 360) % 360);
            var _local_3= -1;
            var _local_4= -1;
            var _local_5 = 0;
            while ((_local_5 : UInt) < this._directions.length)
            {
                _local_6 = (ASCompat.toInt(this._directions.getKey(_local_5)) * this._angle);
                _local_7 = (((_local_6 - _local_2) + 360) % 360);
                if (_local_7 > 180)
                {
                    _local_7 = (360 - _local_7);
                }
                if (((_local_7 < _local_3) || (_local_3 < 0)))
                {
                    _local_3 = _local_7;
                    _local_4 = _local_5;
                }
                _local_5++;
            }
            if (_local_4 >= 0)
            {
                return ASCompat.toInt(this._directions.getKey(_local_4));
            }
            return DEFAULT_DIRECTION;
        }

        function getDirectionData(k:Int):DirectionData
        {
            if (((k == this._lastDirection) && (!(this._lastDirectionData == null))))
            {
                return this._lastDirectionData;
            }
            var _local_2:DirectionData;
            _local_2 = ASCompat.dynamicAs(this._directions.getValue(Std.string(k)) , DirectionData);
            if (_local_2 == null)
            {
                _local_2 = this._defaultDirection;
            }
            this._lastDirection = k;
            this._lastDirectionData = _local_2;
            return this._lastDirectionData;
        }

        public function _Str_6014(k:Int, _arg_2:Int):String
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_6014(_arg_2);
            }
            return LayerData.DEFAULT_TAG;
        }

        public function _Str_10682(k:Int, _arg_2:Int):Int
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_10682(_arg_2);
            }
            return LayerData.DEFAULT_INK;
        }

        public function _Str_11350(k:Int, _arg_2:Int):Int
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_11350(_arg_2);
            }
            return LayerData.DEFAULT_ALPHA;
        }

        public function getColor(k:Int, _arg_2:Int):UInt
        {
            var _local_3= ASCompat.dynamicAs(this._colors.getValue(Std.string(_arg_2)) , ColorData);
            if (_local_3 != null)
            {
                return _local_3.getColor(k);
            }
            return ColorData.DEFAULT_COLOR;
        }

        public function _Str_12280(k:Int, _arg_2:Int):Bool
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_12280(_arg_2);
            }
            return LayerData.DEFAULT_IGNORE_MOUSE;
        }

        public function _Str_10372(k:Int, _arg_2:Int):Int
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_10372(_arg_2);
            }
            return LayerData.DEFAULT_X_OFFSET;
        }

        public function _Str_10926(k:Int, _arg_2:Int):Int
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_10926(_arg_2);
            }
            return LayerData.DEFAULT_Y_OFFSET;
        }

        public function _Str_8329(k:Int, _arg_2:Int):Float
        {
            var _local_3:DirectionData;
            _local_3 = this.getDirectionData(k);
            if (_local_3 != null)
            {
                return _local_3._Str_8329(_arg_2);
            }
            return LayerData.DEFAULT_Z_OFFSET;
        }
    }

