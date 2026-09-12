package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowDisposeEvent extends WindowEvent 
    {
        public static inline final DISPOSED= "WINDOW_DISPOSE_EVENT";
        static final POOL:Array<ASAny> = [];

        public function new()
        {
            super();
            _type = DISPOSED;
        }

        public static function allocate(window:IWindow):WindowDisposeEvent
        {
            var event:WindowDisposeEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowDisposeEvent, []));
            event._window = window;
            event._recycled = false;
            event._pool = POOL;
            return event;
        }


        override public function clone():WindowEvent
        {
            return allocate(_window);
        }

        override public function toString():String
        {
            return ((("WindowDisposeEvent { type: " + _type) + " window: ") + _window) + " }";
        }
    }

