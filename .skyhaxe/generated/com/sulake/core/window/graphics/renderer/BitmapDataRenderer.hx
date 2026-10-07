package com.sulake.core.window.graphics.renderer
;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.filters.ColorMatrixFilter;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window._enum.PivotPoint;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;

     class BitmapDataRenderer extends SkinRenderer 
    {
        static final _MATRIX:Matrix = new Matrix();
        static final _COLOR_TRANSFORM:ColorTransform = new ColorTransform();
        static final _ETCHING_COLOR_TRANSFORM:ColorTransform = new ColorTransform(0, 0, 0, 1, 1, 1, 1, 0);
        static final _GREYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter();
        static inline final R= 0.212671;
        static inline final G= 0.71516;
        static inline final B= 0.072169;

        public function new(k:String)
        {
            super(k);
        }

        override public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:UInt, _arg_5:Bool)
        {
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_17 = 0;
            var _local_18 = 0;
            var _local_6= ASCompat.reinterpretAs(k , IBitmapDataContainer);
            var _local_7= _local_6.bitmapData;
            if (((!(_arg_2 == null)) && (!(_local_7 == null))))
            {
                _local_8 = Std.int((_local_6.stretchedX ? k.width : _local_7.width) * _local_6.zoomX);
                _local_9 = Std.int((_local_6.stretchedY ? k.height : _local_7.height) * _local_6.zoomY);
                _local_10 = Std.int(_local_6.wrapX ? Std.int((k.width / _local_8) + 2) : 1);
                _local_11 = Std.int(_local_6.wrapY ? Std.int((k.height / _local_9) + 2) : 1);
                _MATRIX.a = (_local_8 / _local_7.width);
                _MATRIX.d = (_local_9 / _local_7.height);
                switch (_local_6.pivotPoint)
                {
                    case PivotPoint.TOP_LEFT
                       | PivotPoint.CENTER_LEFT
                       | PivotPoint.BOTTOM_LEFT:
                        _MATRIX.tx = ((_local_6.zoomX < 0) ? -_local_8 : 0);
                        
                    case PivotPoint.TOP_CENTER
                       | PivotPoint.CENTER
                       | PivotPoint.BOTTOM_CENTER:
                        _MATRIX.tx = Std.int(((k.width - _local_8) / 2));
                        
                    case PivotPoint.TOP_RIGHT
                       | PivotPoint.CENTER_RIGHT
                       | PivotPoint.BOTTOM_RIGHT:
                        _MATRIX.tx = ((_local_6.zoomX < 0) ? k.width : (k.width - _local_8));
                        
                }
                _local_12 = Std.int(_MATRIX.tx);
                while ((_local_6.wrapX && (_local_12 > 0)))
                {
                    _local_12 = (_local_12 - _local_8);
                }
                switch (_local_6.pivotPoint)
                {
                    case PivotPoint.TOP_LEFT
                       | PivotPoint.TOP_CENTER
                       | PivotPoint.TOP_RIGHT:
                        _MATRIX.ty = ((_local_6.zoomY < 0) ? -_local_9 : 0);
                        
                    case PivotPoint.CENTER_LEFT
                       | PivotPoint.CENTER
                       | PivotPoint.CENTER_RIGHT:
                        _MATRIX.ty = Std.int(((k.height - _local_9) / 2));
                        
                    case PivotPoint.BOTTOM_LEFT
                       | PivotPoint.BOTTOM_CENTER
                       | PivotPoint.BOTTOM_RIGHT:
                        _MATRIX.ty = ((_local_6.zoomY < 0) ? k.height : (k.height - _local_9));
                        
                }
                _local_13 = Std.int(_MATRIX.ty);
                while ((_local_6.wrapY && (_local_13 > 0)))
                {
                    _local_13 = (_local_13 - _local_9);
                }
                _local_14 = (((ASCompat.toInt(k.color )& 0xFF0000) >> 16) / 0xFF);
                _local_15 = (((ASCompat.toInt(k.color )& 0xFF00) >> 8) / 0xFF);
                _local_16 = ((ASCompat.toInt(k.color )& 0xFF) / 0xFF);
                _ETCHING_COLOR_TRANSFORM.alphaMultiplier = (((ASCompat.toInt(_local_6.etchingColor )>> 24) & 0xFF) / 0xFF);
                _ETCHING_COLOR_TRANSFORM.redOffset = ((ASCompat.toInt(_local_6.etchingColor )>> 16) & 0xFF);
                _ETCHING_COLOR_TRANSFORM.greenOffset = ((ASCompat.toInt(_local_6.etchingColor )>> 8) & 0xFF);
                _ETCHING_COLOR_TRANSFORM.blueOffset = (ASCompat.toInt(_local_6.etchingColor )& 0xFF);
                _arg_2.lock();
                _MATRIX.ty = _local_13;
                _local_17 = 0;
                while (_local_17 < _local_11)
                {
                    _MATRIX.tx = _local_12;
                    _local_18 = 0;
                    while (_local_18 < _local_10)
                    {
                        if (_local_6.greyscale)
                        {
                            _GREYSCALE_FILTER.matrix = [(_local_14 * R), (_local_14 * G), (_local_14 * B), 0, 0, (_local_15 * R), (_local_15 * G), (_local_15 * B), 0, 0, (_local_16 * R), (_local_16 * G), (_local_16 * B), 0, 0, 0, 0, 0, 1, 0];
                            if (_ETCHING_COLOR_TRANSFORM.alphaMultiplier >= 0.001)
                            {
                                _MATRIX.tx = (_MATRIX.tx + _local_6.etchingPoint.x);
                                _MATRIX.ty = (_MATRIX.ty + _local_6.etchingPoint.y);
                                _arg_2.draw(_local_7, _MATRIX, _ETCHING_COLOR_TRANSFORM, null, null, false);
                                _MATRIX.tx = (_MATRIX.tx - _local_6.etchingPoint.x);
                                _MATRIX.ty = (_MATRIX.ty - _local_6.etchingPoint.y);
                            }
                            _arg_2.draw(_local_7, _MATRIX, null, null, null, false);
                            _arg_2.applyFilter(_arg_2, _arg_2.rect, new Point(), _GREYSCALE_FILTER);
                        }
                        else
                        {
                            _COLOR_TRANSFORM.redMultiplier = _local_14;
                            _COLOR_TRANSFORM.greenMultiplier = _local_15;
                            _COLOR_TRANSFORM.blueMultiplier = _local_16;
                            _COLOR_TRANSFORM.alphaMultiplier = 1;
                            _COLOR_TRANSFORM.redOffset = 0;
                            _COLOR_TRANSFORM.greenOffset = 0;
                            _COLOR_TRANSFORM.blueOffset = 0;
                            _COLOR_TRANSFORM.alphaOffset = 0;
                            if (k.dynamicStyleColor != null)
                            {
                                _COLOR_TRANSFORM.concat(k.dynamicStyleColor);
                            }
                            if (_ETCHING_COLOR_TRANSFORM.alphaMultiplier >= 0.001)
                            {
                                _MATRIX.tx = (_MATRIX.tx + _local_6.etchingPoint.x);
                                _MATRIX.ty = (_MATRIX.ty + _local_6.etchingPoint.y);
                                _arg_2.draw(_local_7, _MATRIX, _ETCHING_COLOR_TRANSFORM, null, null, false);
                                _MATRIX.tx = (_MATRIX.tx - _local_6.etchingPoint.x);
                                _MATRIX.ty = (_MATRIX.ty - _local_6.etchingPoint.y);
                            }
                            _arg_2.draw(_local_7, _MATRIX, _COLOR_TRANSFORM, null, null, false);
                        }
                        _MATRIX.tx = (_MATRIX.tx + _local_8);
                        _local_18++;
                    }
                    _MATRIX.ty = (_MATRIX.ty + _local_9);
                    _local_17++;
                }
                _arg_2.unlock();
            }
        }

        override public function isStateDrawable(k:UInt):Bool
        {
            return k == 0;
        }
    }

