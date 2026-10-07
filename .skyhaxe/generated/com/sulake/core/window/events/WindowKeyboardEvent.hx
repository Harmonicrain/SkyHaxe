package com.sulake.core.window.events
;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import com.sulake.core.window.IWindow;

     class WindowKeyboardEvent extends WindowEvent 
    {
        public static inline final WINDOW_EVENT_KEY_UP= "WKE_KEY_UP";
        public static inline final WINDOW_EVENT_KEY_DOWN= "WKE_KEY_DOWN";
        static final POOL:Array<ASAny> = [];

        var _event:KeyboardEvent;

        public static function allocate(type:String, event:Event, window:IWindow, related:IWindow, cancelable:Bool=false):WindowKeyboardEvent
        {
            var keyboardEvent:WindowKeyboardEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowKeyboardEvent, []));
            keyboardEvent._type = type;
            keyboardEvent._event = Std.downcast(event , KeyboardEvent);
            keyboardEvent._window = window;
            keyboardEvent._related = related;
            keyboardEvent._recycled = false;
            keyboardEvent._cancelable = cancelable;
            keyboardEvent._pool = POOL;
            return keyboardEvent;
        }

        public var charCode(get,never):UInt;
public function  get_charCode():UInt
        {
            return this._event.charCode;
        }

        public var keyCode(get,never):UInt;
public function  get_keyCode():UInt
        {
            return this._event.keyCode;
        }

        public var keyLocation(get,never):UInt;
public function  get_keyLocation():UInt
        {
            return this._event.keyLocation;
        }

        public var altKey(get,never):Bool;
public function  get_altKey():Bool
        {
            return this._event.altKey;
        }

        public var shiftKey(get,never):Bool;
public function  get_shiftKey():Bool
        {
            return this._event.shiftKey;
        }

        public var ctrlKey(get,never):Bool;
public function  get_ctrlKey():Bool
        {
            return this._event.ctrlKey;
        }

        override public function clone():WindowEvent
        {
            return allocate(_type, this._event, window, related, cancelable);
        }

        override public function toString():String
        {
            return ((((((("WindowKeyboardEvent { type: " + _type) + " cancelable: ") + Std.string(_cancelable)) + " window: ") + window) + " charCode: ") + Std.string(this.charCode)) + " }";
        }

	public function new() { super(); }
    }

