package com.sulake.core.window.graphics
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import flash.display.BitmapData;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;

     class WindowRendererItem implements IDisposable 
    {
        static inline final RENDER_TYPE_NULL:UInt = 0;
        static inline final RENDER_TYPE_SKIN:UInt = 1;
        static inline final RENDER_TYPE_FILL:UInt = 2;
        static final MATRIX:Matrix = new Matrix();
        static final COLOR_TRANSFORM:ColorTransform = new ColorTransform();

        var _buffer:TrackedBitmapData;
        var _skinContainer:ISkinContainer;
        var _disposed:Bool = false;
        var _refresh:Bool = false;
        var _lastRenderedState:UInt = 0;
        var _nextRenderedState:UInt = 0;

        public function new(skinContainer:ISkinContainer)
        {
            this._disposed = false;
            this._skinContainer = skinContainer;
            this._lastRenderedState = 0xFFFFFFFF;
            this._nextRenderedState = 0;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var buffer(get,never):BitmapData;
public function  get_buffer():BitmapData
        {
            return this._buffer;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
                this._skinContainer = null;
                if (this._buffer != null)
                {
                    this._buffer.dispose();
                    this._buffer = null;
                }
            }
        }

        public function purge()
        {
        }

        public function render(window:IWindow, point:Point, _arg_3:Rectangle, _arg_4:Rectangle, data:BitmapData):BitmapData
        {
            var _local_13 = false;
            var _local_14:BitmapData = null;
            var _local_6= (window.background ? RENDER_TYPE_FILL : RENDER_TYPE_NULL);
            var _local_7= this._skinContainer._Str_18054(window.type, window.style);
            if (_local_7 != null)
            {
                if (_local_7.isStateDrawable(this._nextRenderedState))
                {
                    _local_6 = RENDER_TYPE_SKIN;
                }
            }
            var _local_8= Std.int(Math.max(window.renderingWidth, 1));
            var _local_9= Std.int(Math.max(window.renderingHeight, 1));
            var _local_10= true;
            if (_local_6 != RENDER_TYPE_NULL)
            {
                if ((((!(this._buffer != null)) || (!(this._buffer.width == _local_8))) || (!(this._buffer.height == _local_9))))
                {
                    if (this._buffer != null)
                    {
                        this._buffer.dispose();
                    }
                    this._buffer = new TrackedBitmapData(this, _local_8, _local_9, true, window.color);
                    this._refresh = true;
                    _local_10 = false;
                }
            }
            var _local_11= cast(window, IGraphicContextHost).getGraphicContext(false);
            if (_local_11 != null)
            {
                if (!_local_11.visible)
                {
                    _local_11.visible = true;
                }
                _local_13 = window.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING);
                _local_14 = _local_11._Str_15334(window.renderingRectangle, (!window.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)), (_local_13 ? _arg_4 : null));
                if (_local_14 != null)
                {
                    data = _local_14;
                    this._refresh = true;
                }
            }
            var _local_12:ASAny = (!window.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT));
            if (_local_6 != RENDER_TYPE_NULL)
            {
                if (data != null)
                {
                    data.lock();
                    if (_local_6 == RENDER_TYPE_SKIN)
                    {
                        if (this._refresh)
                        {
                            if (_local_12)
                            {
                                data.fillRect(_arg_3, 0);
                            }
                            this._refresh = false;
                            if (_local_10)
                            {
                                this._buffer.fillRect(this._buffer.rect, window.color);
                            }
                            _local_7.draw(window, this._buffer, this._buffer.rect, this._nextRenderedState, false);
                        }
                        if (((window.blend < 1) && (!_local_12)))
                        {
                            MATRIX.tx = (point.x - _arg_3.x);
                            MATRIX.ty = (point.y - _arg_3.y);
                            COLOR_TRANSFORM.alphaMultiplier = window.blend;
                            _arg_3.offset(MATRIX.tx, MATRIX.ty);
                            data.draw(this._buffer, MATRIX, COLOR_TRANSFORM, null, _arg_3, false);
                            _arg_3.offset(-MATRIX.tx, -MATRIX.ty);
                        }
                        else
                        {
                            data.copyPixels(this._buffer, _arg_3, point, null, null, true);
                        }
                    }
                    else
                    {
                        if (_local_6 == RENDER_TYPE_FILL)
                        {
                            if (!_local_12)
                            {
                                this._buffer.fillRect(this._buffer.rect, window.color);
                                data.copyPixels(this._buffer, _arg_3, point, null, null, true);
                            }
                            else
                            {
                                data.fillRect(new Rectangle(point.x, point.y, _arg_3.width, _arg_3.height), window.color);
                                _local_11.blend = window.blend;
                            }
                        }
                    }
                    data.unlock();
                }
            }
            else
            {
                if ((this._refresh && ASCompat.toBool(_local_12)))
                {
                    this._refresh = false;
                    if (data != null)
                    {
                        data.fillRect(_arg_3, 0);
                    }
                }
            }
            this._lastRenderedState = this._nextRenderedState;
            return data;
        }

        public function testForStateChange(window:IWindow):Bool
        {
            return !(this._skinContainer._Str_15965(window.type, window.style, window.state) == this._lastRenderedState);
        }

        public function invalidate(window:IWindow, flag:UInt):Bool
        {
            var graphicContext:IGraphicContext = null;
            var changed = false;
            switch (flag)
            {
                case WindowRedrawFlag.REDRAW:
                    this._refresh = true;
                    changed = true;
                    
                case WindowRedrawFlag.RESIZE:
                    this._refresh = true;
                    changed = true;
                    
                case WindowRedrawFlag.RELOCATE:
                    if (window.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                    {
                        changed = true;
                    }
                    else
                    {
                        graphicContext = cast(window, IGraphicContextHost).getGraphicContext(true);
                        graphicContext._Str_15334(window.renderingRectangle, false, null);
                        if (!graphicContext.visible)
                        {
                            changed = true;
                        }
                    }
                    
                case WindowRedrawFlag.STATE:
                    this._nextRenderedState = this._skinContainer._Str_15965(window.type, window.style, window.state);
                    if (this._nextRenderedState != this._lastRenderedState)
                    {
                        this._refresh = true;
                        changed = true;
                    }
                    
                case WindowRedrawFlag.BLEND:
                    if (window.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                    {
                        this._refresh = true;
                        changed = true;
                    }
                    else
                    {
                        cast(window, IGraphicContextHost).getGraphicContext(true).blend = window.blend;
                    }
                    
                case WindowRedrawFlag.CASCADE:
                    changed = true;
                    
            }
            return changed;
        }

        function drawRect(data:BitmapData, rect:Rectangle, fillColor:UInt)
        {
            var position = 0;
            position = Std.int(rect.left);
            while (position < rect.right)
            {
                data.setPixel32(position, Std.int(rect.top), fillColor);
                data.setPixel32(position, Std.int(rect.bottom - 1), fillColor);
                position++;
            }
            position = Std.int(rect.top);
            while (position < rect.bottom)
            {
                data.setPixel32(Std.int(rect.left), position, fillColor);
                data.setPixel32(Std.int(rect.right - 1), position, fillColor);
                position++;
            }
        }
    }

