package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowMouseEvent extends WindowEvent 
    {
        public static inline final CLICK= "WME_CLICK";
        public static inline final DOUBLE_CLICK= "WME_DOUBLE_CLICK";
        public static inline final DOWN= "WME_DOWN";
        public static inline final MIDDLE_CLICK= "WME_MIDDLE_CLICK";
        public static inline final MIDDLE_DOWN= "WME_MIDDLE_DOWN";
        public static inline final MIDDLE_UP= "WME_MIDDLE_UP";
        public static inline final MOVE= "WME_MOVE";
        public static inline final OUT= "WME_OUT";
        public static inline final OVER= "WME_OVER";
        public static inline final UP= "WME_UP";
        public static inline final UP_OUTSIDE= "WME_UP_OUTSIDE";
        public static inline final WHEEL= "WME_WHEEL";
        public static inline final RIGHT_CLICK= "WME_RIGHT_CLICK";
        public static inline final RIGHT_DOWN= "WME_RIGHT_DOWN";
        public static inline final RIGHT_UP= "WME_RIGHT_UP";
        public static inline final ROLL_OUT= "WME_ROLL_OUT";
        public static inline final ROLL_OVER= "WME_ROLL_OVER";
        public static inline final HOVERING= "WME_HOVERING";
        static final POOL:Array<ASAny> = [];

        public var delta:Int = 0;
        public var localX:Float = Math.NaN;
        public var localY:Float = Math.NaN;
        public var stageX:Float = Math.NaN;
        public var stageY:Float = Math.NaN;
        public var altKey:Bool = false;
        public var ctrlKey:Bool = false;
        public var shiftKey:Bool = false;
        public var buttonDown:Bool = false;


        public static function allocate(type:String, window:IWindow, related:IWindow, localX:Float, localY:Float, stageX:Float, stageY:Float, altKey:Bool, ctrlKey:Bool, shiftKey:Bool, buttonDown:Bool, delta:Int):WindowMouseEvent
        {
            var event:WindowMouseEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowMouseEvent, []));
            event._type = type;
            event._window = window;
            event._related = related;
            event._cancelable = true;
            event._recycled = false;
            event._pool = POOL;
            event.localX = localX;
            event.localY = localY;
            event.stageX = stageX;
            event.stageY = stageY;
            event.altKey = altKey;
            event.ctrlKey = ctrlKey;
            event.shiftKey = shiftKey;
            event.buttonDown = buttonDown;
            event.delta = delta;
            return event;
        }


        override public function clone():WindowEvent
        {
            return allocate(_type, window, related, this.localX, this.localY, this.stageX, this.stageY, this.altKey, this.ctrlKey, this.shiftKey, this.buttonDown, this.delta);
        }

        override public function toString():String
        {
            return ((((((((("WindowMouseEvent { type: " + _type) + " cancelable: ") + Std.string(_cancelable)) + " window: ") + window) + " localX: ") + Std.string(this.localX)) + " localY: ") + Std.string(this.localY)) + " }";
        }

	public function new() { super(); }
    }

