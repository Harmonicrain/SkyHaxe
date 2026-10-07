package com.sulake.habbo.room.object.visualization.room.mask
;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import com.sulake.room.utils.IVector3d;

     class PlaneMaskManager 
    {
        var _assetCollection:IGraphicAssetCollection = null;
        var _masks:Map = null;
        var _data:com.sulake.core.utils.xml.XML = null;

        public function new()
        {
            this._masks = new Map();
        }

        public var data(get,never):com.sulake.core.utils.xml.XML;
public function  get_data():com.sulake.core.utils.xml.XML
        {
            return this._data;
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:PlaneMask = null;
            this._assetCollection = null;
            this._data = null;
            if (this._masks != null)
            {
                k = 0;
                while ((k : UInt) < this._masks.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._masks.getWithIndex(k) , PlaneMask);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._masks.dispose();
            }
        }

        public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            this._data = k;
        }

        public function initializeAssetCollection(k:IGraphicAssetCollection)
        {
            if (this.data == null)
            {
                return;
            }
            this._assetCollection = k;
            this.parseMasks(this.data, k);
        }

        function parseMasks(k:com.sulake.core.utils.xml.XML, _arg_2:IGraphicAssetCollection)
        {
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:String = null;
            var _local_9:PlaneMask = null;
            var _local_10:com.sulake.core.utils.xml.XMLList = null;
            var _local_11 = 0;
            var _local_12:com.sulake.core.utils.xml.XML = null;
            var _local_13 = 0;
            var _local_14:PlaneMaskVisualization = null;
            var _local_15:com.sulake.core.utils.xml.XMLList = null;
            var _local_16:String = null;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            var _local_3:Array<ASAny> = ["id"];
            var _local_4:Array<ASAny> = ["size"];
            var _local_5= k.child("mask");
            var _local_6 = 0;
            while (_local_6 < _local_5.length())
            {
                _local_7 = _local_5.at(_local_6);
                if (XMLValidator.checkRequiredAttributes(_local_7, _local_3))
                {
                    _local_8 = _local_7.attribute("id").toString();
                    if (this._masks.getValue(_local_8) == null)
                    {
                        _local_9 = new PlaneMask();
                        _local_10 = _local_7.child("maskVisualization");
                        _local_11 = 0;
                        while (_local_11 < _local_10.length())
                        {
                            _local_12 = _local_10.at(_local_11);
                            if (XMLValidator.checkRequiredAttributes(_local_12, _local_4))
                            {
                                _local_13 = ASCompat.parseInt(_local_12.attribute("size").toString());
                                _local_14 = _local_9.createMaskVisualization(_local_13);
                                if (_local_14 != null)
                                {
                                    _local_15 = _local_12.child("bitmap");
                                    _local_16 = this._Str_25815(_local_15, _local_14, _arg_2);
                                    _local_9._Str_24425(_local_13, _local_16);
                                }
                            }
                            _local_11++;
                        }
                        this._masks.add(_local_8, _local_9);
                    }
                }
                _local_6++;
            }
        }

        function _Str_25815(k:com.sulake.core.utils.xml.XMLList, _arg_2:PlaneMaskVisualization, _arg_3:IGraphicAssetCollection):String
        {
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            var _local_11:String = null;
            var _local_12:IGraphicAsset = null;
            if (k == null)
            {
                return null;
            }
            var _local_4:String = null;
            var _local_5 = 0;
            while (_local_5 < k.length())
            {
                _local_6 = k.at(_local_5);
                if (XMLValidator.checkRequiredAttributes(_local_6, ["assetName"]))
                {
                    _local_7 = PlaneMaskVisualization.MIN_NORMAL_COORDINATE_VALUE;
                    _local_8 = PlaneMaskVisualization.MAX_NORMAL_COORDINATE_VALUE;
                    _local_9 = PlaneMaskVisualization.MIN_NORMAL_COORDINATE_VALUE;
                    _local_10 = PlaneMaskVisualization.MAX_NORMAL_COORDINATE_VALUE;
                    if (_local_6.attribute("normalMinX").toString() != "")
                    {
                        _local_7 = Std.parseFloat(_local_6.attribute("normalMinX").toString());
                    }
                    if (_local_6.attribute("normalMaxX").toString() != "")
                    {
                        _local_8 = Std.parseFloat(_local_6.attribute("normalMaxX").toString());
                    }
                    if (_local_6.attribute("normalMinY").toString() != "")
                    {
                        _local_9 = Std.parseFloat(_local_6.attribute("normalMinY").toString());
                    }
                    if (_local_6.attribute("normalMaxY").toString() != "")
                    {
                        _local_10 = Std.parseFloat(_local_6.attribute("normalMaxY").toString());
                    }
                    _local_11 = _local_6.attribute("assetName").toString();
                    _local_12 = _arg_3.getAsset(_local_11);
                    if (_local_12 != null)
                    {
                        if (!_local_12.flipH)
                        {
                            _local_4 = _local_11;
                        }
                        _arg_2.addBitmap(_local_12, _local_7, _local_8, _local_9, _local_10);
                    }
                }
                _local_5++;
            }
            return _local_4;
        }

        public function updateMask(k:BitmapData, _arg_2:String, _arg_3:Float, _arg_4:IVector3d, _arg_5:Int, _arg_6:Int):Bool
        {
            var _local_8:IGraphicAsset = null;
            var _local_9:BitmapDataAsset = null;
            var _local_10:BitmapData = null;
            var _local_11:Point = null;
            var _local_12:Matrix = null;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_7= ASCompat.dynamicAs(this._masks.getValue(_arg_2) , PlaneMask);
            if (_local_7 != null)
            {
                _local_8 = _local_7.getGraphicAsset(_arg_3, _arg_4);
                if (_local_8 != null)
                {
                    _local_9 = Std.downcast(_local_8.asset , BitmapDataAsset);
                    if (_local_9 != null)
                    {
                        _local_10 = ASCompat.dynamicAs(_local_9.content , BitmapData);
                        if (_local_10 != null)
                        {
                            _local_11 = new Point((_arg_5 + _local_8.offsetX), (_arg_6 + _local_8.offsetY));
                            _local_12 = new Matrix();
                            _local_13 = 1;
                            _local_14 = 1;
                            _local_15 = 0;
                            _local_16 = 0;
                            if (_local_8.flipH)
                            {
                                _local_13 = -1;
                                _local_15 = _local_10.width;
                            }
                            if (_local_8.flipV)
                            {
                                _local_14 = -1;
                                _local_16 = _local_10.height;
                            }
                            _local_12.scale(_local_13, _local_14);
                            _local_12.translate((_local_11.x + _local_15), (_local_11.y + _local_16));
                            k.draw(_local_10, _local_12);
                        }
                    }
                }
            }
            return true;
        }

        public function getMask(k:String):PlaneMask
        {
            return ASCompat.dynamicAs(this._masks.getValue(k) , PlaneMask);
        }
    }

