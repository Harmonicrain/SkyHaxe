package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowLinkEvent extends WindowEvent 
    {
        public static inline final WINDOW_EVENT_LINK= "WE_LINK";
        static final POOL:Array<ASAny> = [];

        var _link:String;

        public function new()
        {
            super();
            _type = WINDOW_EVENT_LINK;
        }

        public static function allocate(link:String, window:IWindow, related:IWindow):WindowEvent
        {
            var event:WindowLinkEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowLinkEvent, []));
            event._link = link;
            event._window = window;
            event._related = related;
            event._recycled = false;
            event._pool = POOL;
            return event;
        }


        public var link(get,never):String;
public function  get_link():String
        {
            return this._link;
        }

        override public function clone():WindowEvent
        {
            return allocate(this._link, window, related);
        }

        override public function toString():String
        {
            return ((((((("WindowLinkEvent { type: " + _type) + " link: ") + this.link) + " cancelable: ") + Std.string(_cancelable)) + " window: ") + window) + " }";
        }
    }

