package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowTouchEvent extends WindowEvent 
    {
        public static inline final WTE_BEGIN= "WTE_BEGIN";
        public static inline final WTE_END= "WTE_END";
        public static inline final WTE_MOVE= "WTE_MOVE";
        public static inline final WTE_OUT= "WTE_OUT";
        public static inline final WTE_OVER= "WTE_OVER";
        public static inline final WTE_ROLL_OUT= "WTE_ROLL_OUT";
        public static inline final WTE_ROLL_OVER= "WTE_ROLL_OVER";
        public static inline final WTE_TAP= "WTE_TAP";
        static final POOL:Array<ASAny> = [];

        public var localX:Float = Math.NaN;
        public var localY:Float = Math.NaN;
        public var stageX:Float = Math.NaN;
        public var stageY:Float = Math.NaN;
        public var altKey:Bool = false;
        public var ctrlKey:Bool = false;
        public var shiftKey:Bool = false;
        public var pressure:Float = Math.NaN;
        public var sizeX:Float = Math.NaN;
        public var sizeY:Float = Math.NaN;


        public static function allocate(type:String, window:IWindow, related:IWindow, localX:Float, localY:Float, sizeX:Float, sizeY:Float, stageX:Float, stageY:Float, pressure:Float, altKey:Bool, ctrlKey:Bool, shiftKey:Bool):WindowTouchEvent
        {
            var touchEvent:WindowTouchEvent = null;
            touchEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowTouchEvent, []));
            touchEvent._type = type;
            touchEvent._window = window;
            touchEvent._related = related;
            touchEvent._recycled = false;
            touchEvent._pool = POOL;
            touchEvent.sizeX = sizeX;
            touchEvent.sizeY = sizeY;
            touchEvent.localX = localX;
            touchEvent.localY = localY;
            touchEvent.stageX = stageX;
            touchEvent.stageY = stageY;
            touchEvent.pressure = pressure;
            touchEvent.altKey = altKey;
            touchEvent.ctrlKey = ctrlKey;
            touchEvent.shiftKey = shiftKey;
            return touchEvent;
        }


        override public function clone():WindowEvent
        {
            return allocate(_type, window, related, this.localX, this.localY, this.sizeX, this.sizeY, this.stageX, this.stageY, this.pressure, this.altKey, this.ctrlKey, this.shiftKey);
        }

        override public function toString():String
        {
            return ((((((((("WindowTouchEvent { type: " + _type) + " cancelable: ") + Std.string(_cancelable)) + " window: ") + window) + " localX: ") + Std.string(this.localX)) + " localY: ") + Std.string(this.localY)) + " }";
        }

	public function new() { super(); }
    }

