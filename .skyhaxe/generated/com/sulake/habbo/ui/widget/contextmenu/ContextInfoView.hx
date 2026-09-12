package com.sulake.habbo.ui.widget.contextmenu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.utils.FixedSizeStack;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.assets.XmlAsset;

     class ContextInfoView implements IDisposable 
    {
        static inline final _Str_21789:UInt = 3000;
        static inline final _Str_16565:UInt = 0xFF2D2A27;
        static inline final _Str_13825:UInt = 0xFF48A4CD;
        static inline final _Str_18586:UInt = 0xFF993300;
        static inline final _Str_6292:UInt = 0xFFFFFF;
        static inline final _Str_6801:UInt = 9552639;
        static inline final _Str_17354:UInt = 0xFFFFFF;
        static inline final _Str_17165:UInt = 5789011;
        static inline final _Str_16357:UInt = 13947341;
        static inline final _Str_17248:UInt = 5789011;
        static inline final _Str_18514= 25;
        static inline final _Str_14408= 3;
        static var _Str_3452:Bool = false;

        var _window:IWindowContainer;
        var _Str_5032:IWindowContainer;
        var _Str_3007:IWindowContainer;
        /** Set once the window has been placed against its owner; until then it stays hidden. */
        var _positioned:Bool = false;
        var _Str_16285:Bool = false;
        var _widget:IContextMenuParentWidget;
        var isMouseOver:Bool = false;
        var _Str_17886:FixedSizeStack;
        var _Str_18538:Int = -1000000;
        var _disposed:Bool = false;
        var _Str_21071:Bool = true;
        var _Str_5435:Timer;
        var _Str_12637:Int = 3000;
        var _Str_14625:Bool = false;
        var _Str_13141:Bool = false;
        var _Str_1917:Float = Math.NaN;
        var _Str_5321:Int = 0;
        var _Str_22193:Int = 500;
        var _Str_3403:Bool = false;

        public function new(k:IContextMenuParentWidget)
        {
            this._Str_17886 = new FixedSizeStack(_Str_18514);
            this._widget = k;
            this._Str_3403 = true;
            this._Str_14625 = false;
            this._Str_13141 = false;
        }

        public static function _Str_8532(k:ContextInfoView)
        {
            k._Str_14625 = false;
            k._Str_22193 = 500;
            k._Str_13141 = false;
            k._Str_1917 = 1;
            if (k._Str_3403)
            {
                if (k._Str_5435 == null)
                {
                    k._Str_5435 = new Timer(k._Str_12637, 1);
                    k._Str_5435.addEventListener(TimerEvent.TIMER_COMPLETE, (k.onTimerComplete : ASAny));
                }
                k._Str_5435.reset();
                k._Str_5435.start();
            }
            k.updateWindow();
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var maximumBlend(get,never):Float;
public function  get_maximumBlend():Float
        {
            return 1;
        }

        public function dispose()
        {
            this._widget = null;
            this._Str_3007 = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._Str_5032 != null)
            {
                this._Str_5032.dispose();
                this._Str_5032 = null;
            }
            if (this._Str_5435 != null)
            {
                this._Str_5435.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._Str_5435.reset();
                this._Str_5435 = null;
            }
            this._disposed = true;
        }

        function onTimerComplete(k:TimerEvent)
        {
            this._Str_13141 = true;
            this._Str_5321 = 0;
            this.hide(true);
        }

        function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function updateWindow()
        {
        }

        function clickHandler(k:WindowMouseEvent)
        {
            this._widget.messageListener.processWidgetMessage(new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_START_NAME_CHANGE));
            this._widget.removeView(this, false);
        }

        public function _Str_16818(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:Bool=false)
        {
            var _local_6:Point = null;
            if ((((!(k != null)) || (!(this._widget != null))) || (!(this._widget.assets != null))))
            {
                return;
            }
            var _local_4= Std.downcast(this._widget.assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= ASCompat.dynamicAs(_local_4.content , BitmapData);
            if (_local_5 == null)
            {
                return;
            }
            if (k.bitmap != null)
            {
                k.bitmap.fillRect(k.bitmap.rect, 0);
            }
            else
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
            }
            if (_arg_3)
            {
                _local_6 = new Point(((k.bitmap.width - _local_5.width) / 2), ((k.bitmap.height - _local_5.height) / 2));
            }
            else
            {
                _local_6 = new Point(0, 0);
            }
            k.bitmap.copyPixels(_local_5, _local_5.rect, _local_6, null, null, true);
            k.invalidate();
        }

        public function show()
        {
            if (this._Str_3007 != null)
            {
                this._Str_3007.visible = true;
                if (!Std.is(this._Str_3007.parent , IDesktopWindow))
                {
                    this._widget.windowManager.getDesktop(0).addChild(this._Str_3007);
                }
                if (this._Str_21071)
                {
                    this._Str_3007.activate();
                }
            }
        }

        public function hide(k:Bool)
        {
            if (this._Str_3007 != null)
            {
                if (((!this._Str_14625) && k))
                {
                    this._Str_14625 = true;
                    this._Str_5435.start();
                }
                else
                {
                    this._Str_3007.visible = false;
                    this._Str_3007.parent = null;
                }
            }
        }

        function getOffset(k:Rectangle):Int
        {
            var _local_2= -this._Str_3007.height;
            _local_2 = (_local_2 - 4);
            return _local_2;
        }

        public function update(k:Rectangle, _arg_2:Point, _arg_3:UInt)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            // Both are needed to place the window: the rectangle sizes it against the avatar, the
            // point positions it. Without the point this drew at the room view's origin instead of
            // above its owner, so wait for a frame that has one rather than guessing -- and stay
            // hidden until then, so an owner whose location never resolves shows nothing at all
            // rather than a tag parked in the corner.
            if (k == null || _arg_2 == null)
            {
                if (!this._positioned && this._Str_3007 != null) this._Str_3007.visible = false;
                return;
            }
            if (this._Str_3007 == null)
            {
                this.updateWindow();
            }
            if (this._Str_13141)
            {
                this._Str_5321 = ASCompat.toInt(this._Str_5321 + _arg_3);
                this._Str_1917 = ((1 - (this._Str_5321 / this._Str_22193)) * this.maximumBlend);
            }
            else
            {
                this._Str_1917 = this.maximumBlend;
            }
            if (this._Str_1917 <= 0)
            {
                this._widget.removeView(this, false);
                return;
            }
            if (((!this.isMouseOver) || this._Str_16285))
            {
                _local_4 = this.getOffset(k);
                _local_5 = Std.int(_arg_2.y - k.top);
                this._Str_17886._Str_22775(_local_5);
                _local_6 = this._Str_17886._Str_25797();
                if (_local_6 < (this._Str_18538 - _Str_14408))
                {
                    _local_6 = (this._Str_18538 - _Str_14408);
                }
                _local_7 = Std.int(_arg_2.y - _local_6);
                this._Str_18538 = _local_6;
                this._Str_3007.x = Std.int(_arg_2.x - (this._Str_3007.width / 2));
                this._Str_3007.y = (_local_7 + _local_4);
                this._Str_16285 = false;
                this._positioned = true;
            }
            this._Str_3007.blend = this._Str_1917;
            this.show();
        }

        function onMouseOverOut(k:WindowMouseEvent)
        {
            if (k.type == WindowMouseEvent.OVER)
            {
                this.isMouseOver = true;
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    if (!k.window.hitTestGlobalPoint(new Point(k.stageX, k.stageY)))
                    {
                        this.isMouseOver = false;
                    }
                }
            }
        }

        function _Str_5129(k:Bool)
        {
            _Str_3452 = k;
            this._Str_16285 = true;
            this.updateWindow();
        }

        function createMinimizedView():IWindowContainer
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if (this._Str_5032 == null)
            {
                k = ((cast(this._widget.assets.getAssetByName("minimized_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                this._Str_5032 = Std.downcast(this._widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                this._Str_5032.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, this.onMinimizeClick);
                this._Str_5032.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, this.onMinimizeButtonEvent);
                this._Str_5032.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, this.onMinimizeButtonEvent);
                this._Str_5032.addEventListener(WindowMouseEvent.OVER, this.onMouseOverOut);
                this._Str_5032.addEventListener(WindowMouseEvent.OUT, this.onMouseOverOut);
            }
            return this._Str_5032;
        }

        function onMinimizeClick(k:WindowMouseEvent)
        {
            this._Str_5129(false);
        }

        var activeView(never,set):IWindowContainer;
function  set_activeView(k:IWindowContainer):IWindowContainer        {
            if (k == null)
            {
                return k;
            }
            if (this._Str_3007 != null)
            {
                this._Str_3007.parent = null;
            }
            this._Str_3007 = k;
            // A window built from XML is visible the moment it exists, and these are only placed
            // later by update(). Left visible it paints once at the desktop origin -- a name tag in
            // the corner of the screen -- before jumping to its owner. Reveal it in show(), which
            // runs after the first successful placement.
            if (!this._positioned)
            {
                this._Str_3007.visible = false;
            }
return k;
        }

        function _Str_4457(k:WindowMouseEvent)
        {
            this._Str_5129(true);
        }

        function onMinimizeButtonEvent(k:WindowMouseEvent)
        {
            var _local_3:IWindow = null;
            var _local_2= Std.downcast(k.window , IWindowContainer);
            if (_local_2 != null)
            {
                _local_3 = _local_2.findChildByName("icon");
                if (_local_3 != null)
                {
                    if (k.type == WindowMouseEvent.OVER)
                    {
                        _local_3.color = _Str_13825;
                    }
                    else
                    {
                        _local_3.color = 0xFFFFFF;
                    }
                }
            }
        }

        public var _Str_26171(never,set):Bool;
public function  set__Str_26171(k:Bool):Bool        {
            return this._Str_21071 = k;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
    }

