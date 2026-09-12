package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.animated.PlaneVisualizationAnimationLayer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

     class PlaneVisualization 
    {
        var _layers:Array<ASAny>;
        var _geometry:IRoomGeometry = null;
        var _cachedBitmapData:BitmapData;
        var _cachedBitmapNormal:Vector3d = null;
        var _isCached:Bool = false;
        var _hasAnimationLayers:Bool = false;

        public function new(k:Float, _arg_2:Int, _arg_3:IRoomGeometry)
        {
            this._layers = [];
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            }
            var _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                this._layers.push(null);
                _local_4++;
            }
            this._geometry = _arg_3;
            this._cachedBitmapNormal = new Vector3d();
        }

        public var geometry(get,never):IRoomGeometry;
public function  get_geometry():IRoomGeometry
        {
            return this._geometry;
        }

        public var hasAnimationLayers(get,never):Bool;
public function  get_hasAnimationLayers():Bool
        {
            return this._hasAnimationLayers;
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:IDisposable = null;
            if (this._layers != null)
            {
                k = 0;
                while (k < this._layers.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._layers[k] , IDisposable);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._layers = null;
            }
            this._geometry = null;
            if (this._cachedBitmapData != null)
            {
                this._cachedBitmapData.dispose();
            }
            if (this._cachedBitmapNormal != null)
            {
                this._cachedBitmapNormal = null;
            }
        }

        public function clearCache()
        {
            var k = 0;
            var _local_2:PlaneVisualizationLayer = null;
            var _local_3:PlaneVisualizationAnimationLayer = null;
            if (!this._isCached)
            {
                return;
            }
            if (this._cachedBitmapData != null)
            {
                this._cachedBitmapData.dispose();
                this._cachedBitmapData = null;
            }
            if (this._cachedBitmapNormal != null)
            {
                this._cachedBitmapNormal.assign(new Vector3d());
            }
            if (this._layers != null)
            {
                k = 0;
                while (k < this._layers.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._layers[k] , PlaneVisualizationLayer);
                    _local_3 = ASCompat.dynamicAs(this._layers[k] , PlaneVisualizationAnimationLayer);
                    if (_local_2 != null)
                    {
                        _local_2.clearCache();
                    }
                    else
                    {
                        if (_local_3 != null)
                        {
                            _local_3.clearCache();
                        }
                    }
                    k++;
                }
            }
            this._isCached = false;
        }

        public function setLayer(k:Int, _arg_2:PlaneMaterial, _arg_3:UInt, _arg_4:Int, _arg_5:Int=0):Bool
        {
            if (((k < 0) || (k > this._layers.length)))
            {
                return false;
            }
            var _local_6= ASCompat.dynamicAs(this._layers[k] , IDisposable);
            if (_local_6 != null)
            {
                _local_6.dispose();
                _local_6 = null;
            }
            _local_6 = new PlaneVisualizationLayer(_arg_2, _arg_3, _arg_4, _arg_5);
            this._layers[k] = _local_6;
            return true;
        }

        public function setAnimationLayer(k:Int, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:IGraphicAssetCollection):Bool
        {
            if (((k < 0) || (k > this._layers.length)))
            {
                return false;
            }
            var _local_4= ASCompat.dynamicAs(this._layers[k] , IDisposable);
            if (_local_4 != null)
            {
                _local_4.dispose();
                _local_4 = null;
            }
            _local_4 = new PlaneVisualizationAnimationLayer(_arg_2, _arg_3);
            this._layers[k] = _local_4;
            this._hasAnimationLayers = true;
            return true;
        }

        public function getLayers():Array<ASAny>
        {
            return this._layers;
        }

        public function render(canvas:BitmapData, width:Int, height:Int, normal:IVector3d, useTexture:Bool, offsetX:Int=0, offsetY:Int=0, maxX:Int=0, maxY:Int=0, dimensionX:Float=0, dimensionY:Float=0, timeSinceStartMs:Int=0):BitmapData
        {
            var layer:PlaneVisualizationLayer = null;
            var animationLayer:PlaneVisualizationAnimationLayer = null;
            if (width < 1)
            {
                width = 1;
            }
            if (height < 1)
            {
                height = 1;
            }
            if ((((canvas == null) || (!(canvas.width == width))) || (!(canvas.height == height))))
            {
                canvas = null;
            }
            if (this._cachedBitmapData != null)
            {
                try
                {
                    if ((((this._cachedBitmapData.width == width) && (this._cachedBitmapData.height == height)) && Vector3d.isEqual(this._cachedBitmapNormal, normal)))
                    {
                        if (!this.hasAnimationLayers)
                        {
                            if (canvas != null)
                            {
                                canvas.copyPixels(this._cachedBitmapData, this._cachedBitmapData.rect, new Point(0, 0), null, null, false);
                                return canvas;
                            }
                            return this._cachedBitmapData;
                        }
                    }
                    else
                    {
                        this._cachedBitmapData.dispose();
                        this._cachedBitmapData = null;
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    _cachedBitmapData.dispose();
                    _cachedBitmapData = null;
                    return null;
                }
 }            }
            this._isCached = true;
            if (this._cachedBitmapData == null)
            {
                try
                {
                    this._cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFF);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    if (_cachedBitmapData != null)
                    {
                        _cachedBitmapData.dispose();
                    }
                    _cachedBitmapData = null;
                    return null;
                }
 }            }
            else
            {
                this._cachedBitmapData.fillRect(this._cachedBitmapData.rect, 0xFFFFFF);
            }
            if (canvas == null)
            {
                canvas = this._cachedBitmapData;
            }
            this._cachedBitmapNormal.assign(normal);
            var i = 0;
            while (i < this._layers.length)
            {
                layer = ASCompat.dynamicAs(this._layers[i] , PlaneVisualizationLayer);
                animationLayer = ASCompat.dynamicAs(this._layers[i] , PlaneVisualizationAnimationLayer);
                if (layer != null)
                {
                    layer.render(canvas, width, height, normal, useTexture, offsetX, offsetY);
                }
                else
                {
                    if (animationLayer != null)
                    {
                        animationLayer.render(canvas, width, height, normal, offsetX, offsetY, maxX, maxY, dimensionX, dimensionY, timeSinceStartMs);
                    }
                }
                i = (i + 1);
            }
            if (((!(canvas == null)) && (!(canvas == this._cachedBitmapData))))
            {
                this._cachedBitmapData.copyPixels(canvas, canvas.rect, new Point(0, 0), null, null, false);
                return canvas;
            }
            return this._cachedBitmapData;
        }
    }

