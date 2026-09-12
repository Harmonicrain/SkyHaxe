package com.sulake.habbo.window
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HintStatus;
    import com.sulake.core.window.motion.Queue;
    import com.sulake.core.window.motion.Combo;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.MoveTo;
    import com.sulake.core.window.motion.ResizeTo;
    import com.sulake.core.window.motion.Callback;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.core.window.motion.Motions;
    import flash.geom.Point;

     class HintManager implements IDisposable implements  IUpdateReceiver 
    {
        static inline final HINT_DISTANCE= 10;
        static inline final HINT_ANIM_DISTANCE= 400;
        static inline final HINT_ANIM_SPEED= 15;

        var _windowManager:HabboWindowManagerComponent;
        var _registeredWindows:ASDictionary<ASAny,ASAny>;
        var _activeHint:_Str_7715;
        var _hint:IStaticBitmapWrapperWindow;
        var _absStartRect:Rectangle;
        var _absTargetRect:Rectangle;

        public function new(k:HabboWindowManagerComponent)
        {
            this._registeredWindows = new ASDictionary<ASAny,ASAny>();
            this._windowManager = k;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this.hideHint();
            this._activeHint = null;
            this._registeredWindows = null;
            this._windowManager = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._windowManager == null;
        }

        public function registerWindow(k:String, _arg_2:IWindow, _arg_3:Int)
        {
            if (this._registeredWindows[k] != null)
            {
                this.unregisterWindow(k);
            }
            this._registeredWindows[k] = new _Str_7715(_arg_2, k, _arg_3);
        }

        public function unregisterWindow(k:String)
        {
            if (this.activeKey == k)
            {
                this.hideHint();
            }
            this._registeredWindows.remove(k);
        }

        public function showHint(k:String, _arg_2:Rectangle=null)
        {
            var _local_3:_Str_7715 = this._registeredWindows[k];
            if ((((!(_local_3 == null)) && (!(_local_3.window == null))) && (!(k == this.activeKey))))
            {
                this.hideHint();
                this._hint = Std.downcast(_local_3.window.context.create("", "", WindowType.WINDOW_TYPE_STATIC_BITMAP_WRAPPER, 0, 0, null, null, null, 0) , IStaticBitmapWrapperWindow);
                this._hint.fitSizeToContents = true;
                this._hint.visible = false;
                switch (_local_3.style)
                {
                    case HintStatus.NEW:
                        this._hint.assetUri = "common_green_arrow_vertical";
                        
                    default:
                        this._hint.assetUri = "common_green_arrow_horizontal";
                }
                this._activeHint = _local_3;
                this._absStartRect = _arg_2;
                this._absTargetRect = this.getTargetRect(this._activeHint.window);
                if (_arg_2 != null)
                {
                    this.animateHint(_arg_2);
                }
                else
                {
                    this._windowManager.registerUpdateReceiver(this, 10);
                    this.update(0);
                }
            }
        }

        function animateHint(k:Rectangle)
        {
            this._hint.x = Std.int(k.x);
            this._hint.y = Std.int(k.y);
            this._hint.visible = true;
            var _local_2= Std.int(k.x - this._absTargetRect.x);
            var _local_3= Std.int(k.y - this._absTargetRect.y);
            var _local_4= Math.sqrt(((_local_2 * _local_2) + (_local_3 * _local_3)));
            var _local_5= Std.int(500 - Math.abs(((((1 / _local_4) * 100) * 500) * 0.5)));
            var _local_6= this._hint.width;
            var _local_7= this._hint.height;
            this._hint.width = Std.int(this._hint.width * 0.4);
            this._hint.height = Std.int(this._hint.height * 0.4);
            var _local_8:Motion = new Queue([new Combo([new EaseOut(new MoveTo(this._hint, _local_5, Std.int(this._absTargetRect.x), Std.int(this._absTargetRect.y)), 1), new ResizeTo(this._hint, _local_5, _local_6, _local_7)]), new Callback(this.motionComplete)]);
            Motions._Str_4598(_local_8);
        }

        function motionComplete(k:Motion)
        {
            this._windowManager.registerUpdateReceiver(this, 10);
            this.update(0);
        }

        public function hideHint()
        {
            this._windowManager.removeUpdateReceiver(this);
            this._activeHint = null;
            if (this._hint == null)
            {
                return;
            }
            this._hint.dispose();
            this._hint = null;
        }

        public function hideMatchingHint(k:String)
        {
            if (k == this.activeKey)
            {
                this.hideHint();
            }
        }

        public function update(k:UInt)
        {
            var _local_2:Point = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            if ((((!(this._activeHint == null)) && (!(this._hint == null))) && (!(this._activeHint.window == null))))
            {
                _local_2 = new Point();
                this._activeHint.window.getGlobalPosition(_local_2);
                if (((_local_2.x == 0) && (_local_2.y == 0)))
                {
                    return;
                }
                _local_3 = Std.int(this._hint.zoomX);
                _local_4 = Std.int(this._hint.zoomY);
                switch (this._activeHint.style)
                {
                    case HintStatus.NEW:
                        if (((_local_2.y - this._hint.height) - HINT_DISTANCE) > 0)
                        {
                            _local_5 = Std.int(_local_2.y - this._hint.height);
                            if (this._hint.y == 0)
                            {
                                this._hint.y = Std.int(Math.max((_local_5 - HINT_ANIM_DISTANCE), HINT_ANIM_SPEED));
                            }
                            if ((_local_5 - this._hint.y) > (HINT_ANIM_SPEED + HINT_DISTANCE))
                            {
                                this._hint.y = (this._hint.y + HINT_ANIM_SPEED);
                            }
                            else
                            {
                                this._hint.y = Std.int((_local_5 - HINT_DISTANCE) - (5 * Math.abs(Math.sin((flash.Lib.getTimer() * 0.003)))));
                            }
                            this._hint.zoomY = 1;
                        }
                        else
                        {
                            _local_6 = Std.int(_local_2.y + this._activeHint.window.height);
                            if (this._hint.y == 0)
                            {
                                this._hint.y = Std.int(Math.min((this._windowManager.context.displayObjectContainer.stage.stageHeight - this._hint.height), (this._hint.y + HINT_ANIM_DISTANCE)));
                            }
                            if ((_local_6 - this._hint.y) > (HINT_ANIM_SPEED + HINT_DISTANCE))
                            {
                                this._hint.y = (this._hint.y - HINT_ANIM_SPEED);
                            }
                            else
                            {
                                this._hint.y = Std.int((_local_6 + HINT_DISTANCE) + (5 * Math.abs(Math.sin((flash.Lib.getTimer() * 0.003)))));
                            }
                            this._hint.zoomY = -1;
                        }
                        this._hint.x = Std.int(_local_2.x + ((this._activeHint.window.width - this._hint.width) / 2));
                        
                    default:
                        if ((_local_2.x + (this._activeHint.window.width / 2)) > (this._activeHint.window.desktop.width / 2))
                        {
                            this._hint.x = Std.int(((_local_2.x - this._hint.width) - HINT_DISTANCE) - (5 * Math.abs(Math.sin((flash.Lib.getTimer() * 0.003)))));
                            this._hint.zoomX = 1;
                        }
                        else
                        {
                            this._hint.x = Std.int(((_local_2.x + this._activeHint.window.width) + HINT_DISTANCE) + (5 * Math.abs(Math.sin((flash.Lib.getTimer() * 0.003)))));
                            this._hint.zoomX = -1;
                        }
                        this._hint.y = Std.int(_local_2.y + ((this._activeHint.window.height - this._hint.height) / 2));
                }
                if (((!(this._hint.zoomX == _local_3)) || (!(this._hint.zoomY == _local_4))))
                {
                    this._hint.invalidate();
                }
                this._hint.visible = this._activeHint.window.visible;
            }
        }

        function getTargetRect(k:IWindow):Rectangle
        {
            var _local_2= new Rectangle();
            var _local_3= new Point();
            k.getGlobalPosition(_local_3);
            switch (this._activeHint.style)
            {
                case HintStatus.NEW:
                    if (((_local_3.y - this._hint.height) - HINT_DISTANCE) > 0)
                    {
                        _local_2.y = ((_local_3.y - this._hint.height) - HINT_DISTANCE);
                    }
                    else
                    {
                        _local_2.y = ((_local_3.y + k.height) + HINT_DISTANCE);
                    }
                    _local_2.x = (_local_3.x + ((k.width - this._hint.width) / 2));
                    
                default:
                    if ((_local_3.x + (k.width / 2)) > (k.desktop.width / 2))
                    {
                        _local_2.x = ((_local_3.x - this._hint.width) - HINT_DISTANCE);
                    }
                    else
                    {
                        _local_2.x = ((_local_3.x + k.width) + HINT_DISTANCE);
                    }
                    _local_2.y = (_local_3.y + ((k.height - this._hint.height) / 2));
            }
            return _local_2;
        }

        var activeKey(get,never):String;
function  get_activeKey():String
        {
            return (this._activeHint != null) ? this._activeHint.key : null;
        }
    }

