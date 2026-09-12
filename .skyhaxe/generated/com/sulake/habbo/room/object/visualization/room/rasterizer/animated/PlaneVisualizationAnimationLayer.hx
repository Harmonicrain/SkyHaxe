package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

     class PlaneVisualizationAnimationLayer implements IDisposable 
    {
        var _color:UInt = 0;
        var _bitmapData:BitmapData = null;
        var _isDisposed:Bool = false;
        var _items:Array<ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML, _arg_2:IGraphicAssetCollection)
        {
            var _local_3:com.sulake.core.utils.xml.XMLList = null;
            var _local_4 = 0;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:String = null;
            var _local_7:IGraphicAsset = null;
            var _local_8:BitmapDataAsset = null;
            var _local_9:BitmapData = null;
            var _local_10:AnimationItem = null;
            this._items = [];
            if (((!(k == null)) && (!(_arg_2 == null))))
            {
                _local_3 = k.child("item");
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = ((_local_3.at(_local_4) : com.sulake.core.utils.xml.XML));
                    if (_local_5 != null)
                    {
                        _local_6 = _local_5.attribute("asset").toString();
                        _local_7 = _arg_2.getAsset(_local_6);
                        if (_local_7 != null)
                        {
                            _local_8 = Std.downcast(_local_7.asset , BitmapDataAsset);
                            if (_local_8 != null)
                            {
                                _local_9 = ASCompat.dynamicAs(_local_8.content , BitmapData);
                                if (_local_9 != null)
                                {
                                    _local_10 = new AnimationItem(Std.parseFloat(_local_5.attribute("x").toString()), Std.parseFloat(_local_5.attribute("y").toString()), Std.parseFloat(_local_5.attribute("speedX").toString()), Std.parseFloat(_local_5.attribute("speedY").toString()), _local_9);
                                    this._items.push(_local_10);
                                }
                            }
                        }
                    }
                    _local_4++;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:AnimationItem = null;
            this._isDisposed = true;
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
            if (this._items != null)
            {
                k = 0;
                while (k < this._items.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._items[k] , AnimationItem);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._items = [];
            }
        }

        public function clearCache()
        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
        }

        public function render(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Float, _arg_10:Float, _arg_11:Int):BitmapData
        {
            var _local_12 = 0;
            var _local_13:AnimationItem = null;
            var _local_14:Point = null;
            if ((((k == null) || (!(k.width == _arg_2))) || (!(k.height == _arg_3))))
            {
                if ((((this._bitmapData == null) || (!(this._bitmapData.width == _arg_2))) || (!(this._bitmapData.height == _arg_3))))
                {
                    if (this._bitmapData != null)
                    {
                        this._bitmapData.dispose();
                    }
                    this._bitmapData = new BitmapData(_arg_2, _arg_3, true, 0xFFFFFF);
                }
                else
                {
                    this._bitmapData.fillRect(this._bitmapData.rect, 0xFFFFFF);
                }
                k = this._bitmapData;
            }
            if (((_arg_7 > 0) && (_arg_8 > 0)))
            {
                _local_12 = 0;
                while (_local_12 < this._items.length)
                {
                    _local_13 = ASCompat.dynamicAs(this._items[_local_12] , AnimationItem);
                    if (_local_13 != null)
                    {
                        _local_14 = _local_13.getPosition(_arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
                        _local_14.x = (_local_14.x - _arg_5);
                        _local_14.y = (_local_14.y - _arg_6);
                        if (_local_13.bitmapData != null)
                        {
                            if (((((_local_14.x > -_local_13.bitmapData.width) && (_local_14.x < k.width)) && (_local_14.y > -_local_13.bitmapData.height)) && (_local_14.y < k.height)))
                            {
                                k.copyPixels(_local_13.bitmapData, _local_13.bitmapData.rect, _local_14, null, null, true);
                            }
                            if ((((((_local_14.x - _arg_7) > -_local_13.bitmapData.width) && ((_local_14.x - _arg_7) < k.width)) && (_local_14.y > -_local_13.bitmapData.height)) && (_local_14.y < k.height)))
                            {
                                k.copyPixels(_local_13.bitmapData, _local_13.bitmapData.rect, new Point((_local_14.x - _arg_7), _local_14.y), null, null, true);
                            }
                            if (((((_local_14.x > -_local_13.bitmapData.width) && (_local_14.x < k.width)) && ((_local_14.y - _arg_8) > -_local_13.bitmapData.height)) && ((_local_14.y - _arg_8) < k.height)))
                            {
                                k.copyPixels(_local_13.bitmapData, _local_13.bitmapData.rect, new Point(_local_14.x, (_local_14.y - _arg_8)), null, null, true);
                            }
                            if ((((((_local_14.x - _arg_7) > -_local_13.bitmapData.width) && ((_local_14.x - _arg_7) < k.width)) && ((_local_14.y - _arg_8) > -_local_13.bitmapData.height)) && ((_local_14.y - _arg_8) < k.height)))
                            {
                                k.copyPixels(_local_13.bitmapData, _local_13.bitmapData.rect, new Point((_local_14.x - _arg_7), (_local_14.y - _arg_8)), null, null, true);
                            }
                        }
                    }
                    _local_12++;
                }
            }
            return k;
        }
    }

