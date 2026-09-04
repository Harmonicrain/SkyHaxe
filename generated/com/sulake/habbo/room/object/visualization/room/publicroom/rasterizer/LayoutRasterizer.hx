package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object._enum.AlphaTolerance;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import flash.display.BlendMode;

     class LayoutRasterizer
    {
        var _layouts:Map;
        var _anchor:Vector3d;
        var _currentLayout:String;
        var _assetCollection:IGraphicAssetCollection;
        var _graphicsChanged:Bool = false;
        var _alphaOverrideTags:Array<ASAny>;
        var _alphaOverrideValues:Array<ASAny>;

        public function new()
        {
            this._layouts = new Map();
            this._anchor = new Vector3d(-0.5, 0.5, 0);
            this._currentLayout = "";
            this._alphaOverrideTags = [];
            this._alphaOverrideValues = [];
        }

        public var graphicsChanged(get,never):Bool;
function  get_graphicsChanged():Bool
        {
            return this._graphicsChanged;
        }

        public function changeElementAlpha(k:String, _arg_2:Float)
        {
            this._graphicsChanged = true;
            this._alphaOverrideTags.push(k);
            this._alphaOverrideValues.push(_arg_2);
        }

        public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2= k.attribute("name").toString();
            this._layouts.add(_local_2, new LayoutRasterizerData(k));
        }

        public var hasAnimations(get,never):Bool;
function  get_hasAnimations():Bool
        {
            var k= ASCompat.dynamicAs(this._layouts.getValue(this._currentLayout) , LayoutRasterizerData);
            return ((!(k == null)) && k.hasAnimations);
        }

        public var layout(never,set):String;
function  set_layout(k:String):String        {
            return this._currentLayout = k;
        }

        public function initializeAssetCollection(k:IGraphicAssetCollection)
        {
            this._assetCollection = k;
        }

        public function elementCount():Int
        {
            var k= ASCompat.dynamicAs(this._layouts.getValue(this._currentLayout) , LayoutRasterizerData);
            if (k == null)
            {
                return 0;
            }
            var _local_2= k.elementList;
            if (_local_2 == null)
            {
                return 0;
            }
            return _local_2.length();
        }

        public function setElementToSprite(k:Int, _arg_2:IRoomObjectSprite, _arg_3:IRoomGeometry, _arg_4:Int=0)
        {
            if (((this._assetCollection == null) || (_arg_2 == null)) || (_arg_3 == null))
            {
                return;
            }
            var _local_4= ASCompat.dynamicAs(this._layouts.getValue(this._currentLayout) , LayoutRasterizerData);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_4.elementList;
            if (_local_5 == null)
            {
                return;
            }
            if (((k < 0) || (k >= _local_5.length())))
            {
                return;
            }
            var _local_6= _local_5.at(k);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= _local_6.child("visualization");
            if (((_local_7.length() == 0) || (_local_7.child("visualizationLayer").length() == 0)))
            {
                return;
            }
            var _local_8= _local_7.child("visualizationLayer").at(0);
            var _local_9= this.getLayerAssetName(_local_8, _arg_4);
            var _local_10= this._assetCollection.getAsset(_local_9);
            if (_local_10 == null)
            {
                return;
            }
            var _local_11= _arg_3.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_12= _arg_3.getScreenPoint(this._anchor);
            _local_12.x = Math.fround((_local_12.x - _local_11.x));
            _local_12.y = Math.fround((_local_12.y - _local_11.y));
            _arg_2.asset = ASCompat.dynamicAs(_local_10.asset.content , BitmapData);
            _arg_2.assetName = _local_9;
            _arg_2.offsetX = Std.int((ASCompat.toInt(_local_8.attribute("x").toString()) + _local_10.offsetX) + _local_12.x);
            _arg_2.offsetY = Std.int((ASCompat.toInt(_local_8.attribute("y").toString()) + _local_10.offsetY) + _local_12.y);
            _arg_2.blendMode = this.getBlendMode(_local_8.attribute("ink").toString());
            _arg_2.clickHandling = false;
            _arg_2.tag = "";
            _arg_2.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
            _arg_2.flipH = false;
            if (ASCompat.parseInt(_local_8.attribute("capturesMouse").toString()) > 0)
            {
                _arg_2.clickHandling = true;
                _arg_2.alphaTolerance = AlphaTolerance.MATCH_OPAQUE_PIXELS;
                _arg_2.tag = _local_6.attribute("id").toString();
            }
            if (_local_8.attribute("z").toString() != "")
            {
                _arg_2.relativeDepth = ((-ASCompat.toNumber(_local_8.attribute("z").toString()) / Math.sqrt(2)) - (0.00001 * k));
            }
            else
            {
                _arg_2.relativeDepth = (-(0.001 * k));
            }
            if (_local_8.attribute("blend").toString().toString().length > 0)
            {
                _arg_2.alpha = Std.int((ASCompat.toNumber(_local_8.attribute("blend").toString()) * 2.55));
            }
            if (_local_8.attribute("flipH").toString().toString().length > 0)
            {
                _arg_2.flipH = ((_local_8.attribute("flipH") .toString()== "true") || (_local_8.attribute("flipH") .toString()== "1"));
            }
            var _local_13= _local_6.attribute("id").toString();
            if (((_local_13.length > 0) && this._graphicsChanged))
            {
                var _local_14= this._alphaOverrideTags.indexOf(_local_13);
                if (_local_14 >= 0)
                {
                    _arg_2.alpha = ASCompat.toInt(this._alphaOverrideValues[_local_14]);
                    this._alphaOverrideTags.splice(_local_14, 1);
                    this._alphaOverrideValues.splice(_local_14, 1);
                    if (this._alphaOverrideTags.length == 0)
                    {
                        this._graphicsChanged = false;
                    }
                }
            }
        }

        function getLayerAssetName(k:com.sulake.core.utils.xml.XML, _arg_2:Int):String
        {
            var _local_3= k.attribute("asset").toString();
            var _local_4= k.attribute("frames").toString();
            if (_local_4.length == 0)
            {
                return _local_3;
            }
            var _local_5:Array<ASAny> = (cast _local_4.split(","));
            if (_local_5.length == 0)
            {
                return _local_3;
            }
            var _local_6:Float = ASCompat.parseInt(k.attribute("frameInterval").toString());
            if ((Math.isNaN(_local_6) || (_local_6 <= 0)))
            {
                _local_6 = 160;
            }
            var _local_7= (Std.int((_arg_2 / _local_6)) % _local_5.length);
            var _local_8= ASCompat.toString(_local_5[_local_7]);
            if (_local_8.length == 0)
            {
                return _local_3;
            }
            return _local_8;
        }

        function getBlendMode(k:String):String
        {
            switch (k)
            {
                case "ADD":
                    return BlendMode.ADD;
                case "SUBTRACT":
                    return BlendMode.SUBTRACT;
                case "DARKEN":
                    return BlendMode.DARKEN;
                default:
                    return BlendMode.NORMAL;
            }
        }

        public function dispose()
        {
            var k:Int;
            var _local_2:LayoutRasterizerData;
            this._assetCollection = null;
            this._anchor = null;
            if (this._layouts != null)
            {
                k = 0;
                while ((k : UInt) < this._layouts.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._layouts.getWithIndex(k) , LayoutRasterizerData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._layouts.dispose();
                this._layouts = null;
            }
        }
    }

