package com.sulake.habbo.quest.seasonalcalendar
;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class CalendarArrowButton 
    {
        public static inline final _Str_14486= 0;
        public static inline final _Str_13915= 1;
        public static inline final _Str_7947= 0;
        public static inline final STATE_ACTIVE= 1;
        public static inline final _Str_11423= 2;
        static final _Str_13665:Point = new Point(1, 1);

        var _window:IBitmapWrapperWindow;
        var _callback:ASFunction;
        var _state:Int = 0;
        var _pressed:Bool = false;
        var _initialLocation:Point;
        var _bitmapInactive:BitmapData;
        var _bitmapActive:BitmapData;
        var _bitmapHilite:BitmapData;

        public function new(k:IAssetLibrary, _arg_2:IBitmapWrapperWindow, _arg_3:Int, _arg_4:ASFunction)
        {
            this._window = _arg_2;
            this._window.procedure = this.procedure;
            this._callback = _arg_4;
            switch (_arg_3)
            {
                case _Str_14486:
                    this._bitmapActive = cast(k.getAssetByName("arrow_back_active").content, BitmapData).clone();
                    this._bitmapInactive = cast(k.getAssetByName("arrow_back_inactive").content, BitmapData).clone();
                    this._bitmapHilite = cast(k.getAssetByName("arrow_back_hilite").content, BitmapData).clone();
                    
                case _Str_13915:
                    this._bitmapActive = cast(k.getAssetByName("arrow_next_active").content, BitmapData).clone();
                    this._bitmapInactive = cast(k.getAssetByName("arrow_next_inactive").content, BitmapData).clone();
                    this._bitmapHilite = cast(k.getAssetByName("arrow_next_hilite").content, BitmapData).clone();
                    
            }
            this._initialLocation = new Point(this._window.x, this._window.y);
            this.updateWindow();
        }

        public function dispose()
        {
            this._bitmapActive = null;
            this._bitmapHilite = null;
            this._bitmapInactive = null;
            this._window.procedure = null;
            this._window = null;
            this._callback = null;
        }

        public function activate()
        {
            if (((!(this._state == STATE_ACTIVE)) && (!(this._state == _Str_11423))))
            {
                this._state = STATE_ACTIVE;
            }
            this.updateWindow();
        }

        public function deactivate()
        {
            this._state = _Str_7947;
            this.updateWindow();
        }

        public function _Str_21953():Bool
        {
            return this._state == _Str_7947;
        }

        function updateWindow()
        {
            switch (this._state)
            {
                case _Str_7947:
                    this._window.bitmap = this._bitmapInactive;
                    
                case _Str_11423:
                    this._window.bitmap = this._bitmapHilite;
                    
                case STATE_ACTIVE:
                    this._window.bitmap = this._bitmapActive;
                    
            }
            if (this._pressed)
            {
                this._window.x = Std.int(this._initialLocation.x + _Str_13665.x);
                this._window.y = Std.int(this._initialLocation.y + _Str_13665.y);
            }
            else
            {
                this._window.position = this._initialLocation;
            }
        }

        function procedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (Std.downcast(k , WindowMouseEvent) != null)
            {
                switch (k.type)
                {
                    case WindowMouseEvent.OVER:
                        if (this._state != _Str_7947)
                        {
                            this._state = _Str_11423;
                        }
                        
                    case WindowMouseEvent.OUT:
                        if (this._state != _Str_7947)
                        {
                            this._state = STATE_ACTIVE;
                        }
                        
                    case WindowMouseEvent.DOWN:
                        this._pressed = true;
                        
                    case WindowMouseEvent.UP
                       | WindowMouseEvent.UP_OUTSIDE:
                        this._pressed = false;
                        
                }
                this.updateWindow();
                this._callback(k, _arg_2);
            }
        }
    }


