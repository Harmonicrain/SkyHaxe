package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;

     class Animation implements IDisposable 
    {
        var _canvas:IBitmapWrapperWindow;
        var _timeElapsedSinceStart:Int = 0;
        var _playing:Bool = false;
        var _sprites:Array<ASAny>;

        public function new(k:IBitmapWrapperWindow)
        {
            this._sprites = new Array<ASAny>();
            this._canvas = k;
            this._canvas.visible = false;
            if (k.bitmap == null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
            }
        }

        public function dispose()
        {
            var k:AnimationObject = null;
            this._canvas = null;
            if (this._sprites != null)
            {
                final _iter_ = this._sprites; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
                this._sprites = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._canvas == null;
        }

        public function addObject(k:AnimationObject)
        {
            this._sprites.push(k);
        }

        public function stop()
        {
            this._playing = false;
            this._canvas.visible = false;
        }

        public function _Str_24676()
        {
            var k:AnimationObject = null;
            this._timeElapsedSinceStart = 0;
            this._playing = true;
            final _iter_ = this._sprites; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_21940();
            }
            this.draw();
            this._canvas.visible = true;
        }

        public function update(k:UInt)
        {
            if (this._playing)
            {
                this._timeElapsedSinceStart = ASCompat.toInt(this._timeElapsedSinceStart + k);
                this.draw();
            }
        }

        function draw()
        {
            var k = false;
            var _local_2:AnimationObject = null;
            var _local_3:BitmapData = null;
            this._canvas.bitmap.fillRect(this._canvas.bitmap.rect, 0);
            if (this._playing)
            {
                k = false;
                final _iter_ = this._sprites; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (!_local_2._Str_22065(this._timeElapsedSinceStart))
                    {
                        k = true;
                        _local_3 = _local_2.getBitmap(this._timeElapsedSinceStart);
                        if (_local_3 != null)
                        {
                            this._canvas.bitmap.copyPixels(_local_3, _local_3.rect, _local_2.getPosition(this._timeElapsedSinceStart));
                        }
                    }
                }
            }
            this._canvas.invalidate();
            this._playing = k;
        }
    }

