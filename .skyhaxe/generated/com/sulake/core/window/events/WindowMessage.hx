package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowMessage extends WindowEvent 
    {
        static inline final WINDOW_EVENT_MESSAGE= "WE_MESSAGE";
        static final POOL:Array<ASAny> = [];

        public var message:String;

        public function new()
        {
            super();
            _type = WINDOW_EVENT_MESSAGE;
        }

        public static function allocate(message:String, window:IWindow, related:IWindow, cancelable:Bool=false):WindowEvent
        {
            var windowMessage:WindowMessage = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowMessage, []));
            windowMessage.message = message;
            windowMessage._window = window;
            windowMessage._related = related;
            windowMessage._cancelable = cancelable;
            windowMessage._recycled = false;
            windowMessage._pool = POOL;
            return windowMessage;
        }

        override public function clone():WindowEvent
        {
            return allocate(this.message, window, related, cancelable);
        }

        override public function toString():String
        {
            return ((((((("WindowLinkEvent { type: " + _type) + " message: ") + this.message) + " cancelable: ") + Std.string(_cancelable)) + " window: ") + window) + " }";
        }
    }

