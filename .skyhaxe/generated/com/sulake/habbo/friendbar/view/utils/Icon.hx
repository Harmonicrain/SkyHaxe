package com.sulake.habbo.friendbar.view.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.events.TimerEvent;

     class Icon implements IDisposable 
    {
        static inline final _Str_21407= 0;
        static inline final _Str_8982= 1;
        static inline final _Str_16475= 2;
        static inline final _Str_17719= 3;
        static inline final ALIGN_TOP= 4;
        static inline final _Str_8656= 8;
        static inline final ALIGN_BOTTOM= 18;
        static inline final _Str_18320= 18;

        var _disposed:Bool = false;
        var _disabled:Bool = false;
        var _image:BitmapDataAsset;
        var _Str_1868:IBitmapWrapperWindow;
        var _Str_4220:UInt = 0;
        var _timer:Timer;
        var _frame:Int = 0;
        var _Str_6692:Point;
        var _Str_5470:Bool = false;
        var _hover:Bool = false;

        public function new()
        {
            this._Str_4220 = (_Str_8982 | _Str_8656);
            this._Str_6692 = new Point();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var disabled(get,never):Bool;
public function  get_disabled():Bool
        {
            return this._disabled;
        }

        
        var image(get,set):BitmapDataAsset;
function  set_image(k:BitmapDataAsset):BitmapDataAsset        {
            this._image = k;
            this._Str_6950();
return k;
        }
function  get_image():BitmapDataAsset
        {
            return this._image;
        }

        
        var canvas(get,set):IBitmapWrapperWindow;
function  set_canvas(k:IBitmapWrapperWindow):IBitmapWrapperWindow        {
            this._Str_1868 = k;
            this._Str_6950();
return k;
        }
function  get_canvas():IBitmapWrapperWindow
        {
            return this._Str_1868;
        }

        
        var alignment(get,set):UInt;
function  set_alignment(k:UInt):UInt        {
            this._Str_4220 = k;
            this._Str_6950();
return k;
        }
function  get_alignment():UInt
        {
            return this._Str_4220;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._Str_7231(false, 0);
                this.image = null;
                this.canvas = null;
                this._disposed = true;
            }
        }

        public function notify(k:Bool)
        {
            this._Str_5470 = k;
            if ((this._Str_5470 && this._disabled))
            {
                this.enable(true);
            }
        }

        public function hover(k:Bool)
        {
            this._hover = k;
        }

        public function enable(k:Bool)
        {
            this._disabled = (!k);
        }

        function _Str_6950()
        {
            var k:BitmapData = null;
            if (((this._Str_1868 != null) && (!this._Str_1868.disposed)))
            {
                if (this._Str_1868.bitmap == null)
                {
                    this._Str_1868.bitmap = new BitmapData(this._Str_1868.width, this._Str_1868.height, true, 0);
                }
                else
                {
                    this._Str_1868.bitmap.fillRect(this._Str_1868.bitmap.rect, 0);
                }
                if (((this._image != null) && (!this._image.disposed)))
                {
                    this._Str_6692.x = (this._Str_6692.y = 0);
                    k = ASCompat.dynamicAs(this._image.content , BitmapData);
                    switch ((ASCompat.toInt(this._Str_4220 )& _Str_17719))
                    {
                        case _Str_8982:
                            this._Str_6692.x = ((this._Str_1868.bitmap.width / 2) - (k.width / 2));
                            
                        case _Str_16475:
                            this._Str_6692.x = (this._Str_1868.bitmap.width - k.width);
                            
                    }
                    switch ((ASCompat.toInt(this._Str_4220 )& _Str_18320))
                    {
                        case _Str_8656:
                            this._Str_6692.y = ((this._Str_1868.bitmap.height / 2) - (k.height / 2));
                            
                        case ALIGN_BOTTOM:
                            this._Str_6692.y = (this._Str_1868.bitmap.height - k.height);
                            
                    }
                    this._Str_1868.bitmap.copyPixels(k, k.rect, this._Str_6692);
                    this._Str_1868.invalidate();
                }
            }
        }

        function _Str_7231(k:Bool, _arg_2:Int)
        {
            if (k)
            {
                if (this._timer == null)
                {
                    this._timer = new Timer(_arg_2, 0);
                    this._timer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
                    this._timer.start();
                    this.onTimerEvent(null);
                }
                this._timer.delay = _arg_2;
            }
            else
            {
                this._frame = 0;
                if (this._timer != null)
                {
                    this._timer.reset();
                    this._timer.removeEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
                    this._timer = null;
                }
            }
        }

        function onTimerEvent(k:TimerEvent)
        {
        }
    }

