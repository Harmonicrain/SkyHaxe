package com.sulake.core.window.services
;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.DisplayObject;
    import com.sulake.core.window.WindowController;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.sulake.core.window.events.WindowEvent;

     class WindowMouseOperator implements IDisposable 
    {
        var _root:DisplayObject;
        var window:WindowController;
        var _Str_5527:Bool = false;
        var _offset:Point;
        var _Str_3282:Point;
        var _Str_3368:Point;
        var _Str_829:UInt = 0;
        var _disposed:Bool = false;

        public function new(k:DisplayObject)
        {
            this._root = k.stage != null ? k.stage : k; // Release must also reach drags outside the window host.
            this._Str_3368 = new Point();
            this._Str_3282 = new Point();
            this._offset = new Point();
            this._Str_5527 = false;
            this._Str_829 = 0;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this.end(this.window);
            this._offset = null;
            this._Str_3282 = null;
            this._Str_3368 = null;
            this._root = null;
            this._disposed = true;
        }

        public function begin(k:IWindow, _arg_2:UInt=0):IWindow
        {
            this._Str_829 = _arg_2;
            var _local_3:IWindow = this.window;
            if (this.window != null)
            {
                this.end(this.window);
            }
            if (((k != null) && (!k.disposed)))
            {
                this._root.addEventListener(MouseEvent.MOUSE_DOWN, (this.handler : ASAny), false);
                this._root.addEventListener(MouseEvent.MOUSE_UP, (this.handler : ASAny), false);
                this._root.addEventListener(Event.ENTER_FRAME, (this.handler : ASAny));
                this._Str_3282.x = this._root.mouseX;
                this._Str_3282.y = this._root.mouseY;
                this.window = cast(k, WindowController);
                this.getMousePositionRelativeTo(k, this._Str_3282, this._offset);
                this.window.addEventListener(WindowEvent.WINDOW_EVENT_DESTROYED, this.clientWindowDestroyed);
                this._Str_5527 = true;
            }
            return _local_3;
        }

        public function end(k:IWindow):IWindow
        {
            var _local_2:IWindow = this.window;
            if (this._Str_5527)
            {
                if ((this.window : ASAny) == (k : ASAny))
                {
                    this._root.removeEventListener(MouseEvent.MOUSE_DOWN, (this.handler : ASAny), false);
                    this._root.removeEventListener(MouseEvent.MOUSE_UP, (this.handler : ASAny), false);
                    this._root.removeEventListener(Event.ENTER_FRAME, (this.handler : ASAny));
                    if (!this.window.disposed)
                    {
                        this.window.removeEventListener(WindowEvent.WINDOW_EVENT_DESTROYED, this.clientWindowDestroyed);
                    }
                    this.window = null;
                    this._Str_5527 = false;
                }
            }
            return _local_2;
        }

        function handler(k:Event)
        {
            var _local_2:MouseEvent = null;
            if (this._Str_5527)
            {
                if (k.type == Event.ENTER_FRAME)
                {
                    if (this.window.disposed)
                    {
                        this.end(this.window);
                    }
                    else
                    {
                        if (((!(this._Str_3282.x == this._root.mouseX)) || (!(this._Str_3282.y == this._root.mouseY))))
                        {
                            this.operate(Std.int(this._root.mouseX), Std.int(this._root.mouseY));
                            this._Str_3282.x = this._root.mouseX;
                            this._Str_3282.y = this._root.mouseY;
                        }
                    }
                    return;
                }
                _local_2 = Std.downcast(k , MouseEvent);
                if (_local_2 != null)
                {
                    switch (_local_2.type)
                    {
                        case MouseEvent.MOUSE_UP:
                            this.end(this.window);
                            return;
                    }
                }
            }
        }

        public function operate(k:Int, _arg_2:Int)
        {
            this._Str_3282.x = k;
            this._Str_3282.y = _arg_2;
            this.getMousePositionRelativeTo(this.window, this._Str_3282, this._Str_3368);
            this.window.offset((this._Str_3368.x - this._offset.x), (this._Str_3368.y - this._offset.y));
        }

        function clientWindowDestroyed(k:WindowEvent)
        {
            this.end(this.window);
        }

        function getMousePositionRelativeTo(k:IWindow, _arg_2:Point, _arg_3:Point)
        {
            k.getGlobalPosition(_arg_3);
            _arg_3.x = (_arg_2.x - _arg_3.x);
            _arg_3.y = (_arg_2.y - _arg_3.y);
        }
    }

