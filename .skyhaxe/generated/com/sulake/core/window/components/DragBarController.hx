package com.sulake.core.window.components
;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;

     class DragBarController extends InteractiveController implements IDragBarWindow 
    {
        var _Str_18200:Float = Math.NaN;
        var _Str_18429:Float = Math.NaN;
        var _scrollBar:ScrollBarController;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._Str_18200 = 0;
            this._Str_18429 = 0;
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT));
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TARGET));
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TRIGGER));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            var _local_12= _arg_7;
            while (_local_12 != null)
            {
                if (Std.is(_local_12 , IScrollbarWindow))
                {
                    this._scrollBar = cast(_local_12, ScrollBarController);
                    _local_12 = null;
                }
                else
                {
                    _local_12 = _local_12.parent;
                }
            }
            if (this._scrollBar.horizontal)
            {
                limits.minWidth = width;
            }
            else
            {
                limits.minHeight = height;
            }
        }

        
        public var _Str_14866(get,set):Float;
public function  get__Str_14866():Float
        {
            return this._Str_18200;
        }

        
        public var _Str_15234(get,set):Float;
public function  get__Str_15234():Float
        {
            return this._Str_18429;
        }
public function  set__Str_14866(k:Float):Float        {
return k;
        }
public function  set__Str_15234(k:Float):Float        {
return k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3:WindowEvent = null;
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_RELOCATED)
            {
                this._Str_18200 = ((x != 0) ? (x / (_parent.width - width)) : 0);
                this._Str_18429 = ((y != 0) ? (y / (_parent.height - height)) : 0);
                if ((_parent : ASAny) != (this._scrollBar : ASAny))
                {
                    _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this, null);
                    this._scrollBar.update(this, _local_3);
                    _local_3.recycle();
                }
            }
            return super.update(k, _arg_2);
        }
    }

