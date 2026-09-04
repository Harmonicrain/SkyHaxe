package com.sulake.core.window.events
;
    import com.sulake.core.window.IWindow;

     class WindowEvent 
    {
        public static inline final WINDOW_EVENT_DESTROY= "WE_DESTROY";
        public static inline final WINDOW_EVENT_DESTROYED= "WE_DESTROYED";
        public static inline final WINDOW_EVENT_OPEN= "WE_OPEN";
        public static inline final WINDOW_EVENT_OPENED= "WE_OPENED";
        public static inline final WINDOW_EVENT_CLOSE= "WE_CLOSE";
        public static inline final WINDOW_EVENT_CLOSED= "WE_CLOSED";
        public static inline final WINDOW_EVENT_FOCUS= "WE_FOCUS";
        public static inline final WINDOW_EVENT_FOCUSED= "WE_FOCUSED";
        public static inline final WINDOW_EVENT_UNFOCUS= "WE_UNFOCUS";
        public static inline final WINDOW_EVENT_UNFOCUSED= "WE_UNFOCUSED";
        public static inline final WINDOW_EVENT_ACTIVATE= "WE_ACTIVATE";
        public static inline final WINDOW_EVENT_ACTIVATED= "WE_ACTIVATED";
        public static inline final WINDOW_EVENT_DEACTIVATE= "WE_DEACTIVATE";
        public static inline final WINDOW_EVENT_DEACTIVATED= "WE_DEACTIVATED";
        public static inline final WINDOW_EVENT_SELECT= "WE_SELECT";
        public static inline final WINDOW_EVENT_SELECTED= "WE_SELECTED";
        public static inline final WINDOW_EVENT_UNSELECT= "WE_UNSELECT";
        public static inline final WINDOW_EVENT_UNSELECTED= "WE_UNSELECTED";
        public static inline final WINDOW_EVENT_LOCK= "WE_LOCK";
        public static inline final WINDOW_EVENT_LOCKED= "WE_LOCKED";
        public static inline final WINDOW_EVENT_UNLOCK= "WE_UNLOCK";
        public static inline final WINDOW_EVENT_UNLOCKED= "WE_UNLOCKED";
        public static inline final WINDOW_EVENT_ENABLE= "WE_ENABLE";
        public static inline final WINDOW_EVENT_ENABLED= "WE_ENABLED";
        public static inline final WINDOW_EVENT_DISABLE= "WE_DISABLE";
        public static inline final WINDOW_EVENT_DISABLED= "WE_DISABLED";
        public static inline final WINDOW_EVENT_RELOCATE= "WE_RELOCATE";
        public static inline final WINDOW_EVENT_RELOCATED= "WE_RELOCATED";
        public static inline final WINDOW_EVENT_RESIZE= "WE_RESIZE";
        public static inline final WINDOW_EVENT_RESIZED= "WE_RESIZED";
        public static inline final WINDOW_EVENT_MINIMIZE= "WE_MINIMIZE";
        public static inline final WINDOW_EVENT_MINIMIZED= "WE_MINIMIZED";
        public static inline final WINDOW_EVENT_MAXIMIZE= "WE_MAXIMIZE";
        public static inline final WINDOW_EVENT_MAXIMIZED= "WE_MAXIMIZED";
        public static inline final WINDOW_EVENT_RESTORE= "WE_RESTORE";
        public static inline final WINDOW_EVENT_RESTORED= "WE_RESTORED";
        public static inline final WINDOW_EVENT_CHILD_ADDED= "WE_CHILD_ADDED";
        public static inline final WINDOW_EVENT_CHILD_REMOVED= "WE_CHILD_REMOVED";
        public static inline final WINDOW_EVENT_CHILD_RELOCATED= "WE_CHILD_RELOCATED";
        public static inline final WINDOW_EVENT_CHILD_RESIZED= "WE_CHILD_RESIZED";
        public static inline final WINDOW_EVENT_CHILD_ACTIVATED= "WE_CHILD_ACTIVATED";
        public static inline final WINDOW_EVENT_CHILD_VISIBILITY= "WE_CHILD_VISIBILITY";
        public static inline final WINDOW_EVENT_PARENT_ADDED= "WE_PARENT_ADDED";
        public static inline final WINDOW_EVENT_PARENT_REMOVED= "WE_PARENT_REMOVED";
        public static inline final WINDOW_EVENT_PARENT_RELOCATED= "WE_PARENT_RELOCATED";
        public static inline final WINDOW_EVENT_PARENT_RESIZED= "WE_PARENT_RESIZED";
        public static inline final WINDOW_EVENT_PARENT_ACTIVATED= "WE_PARENT_ACTIVATED";
        public static inline final WINDOW_EVENT_OK= "WE_OK";
        public static inline final WINDOW_EVENT_CANCEL= "WE_CANCEL";
        public static inline final WINDOW_EVENT_CHANGE= "WE_CHANGE";
        public static inline final WINDOW_EVENT_SCROLL= "WE_SCROLL";
        public static inline final UNKNOWN= "";
        static final POOL:Array<ASAny> = [];

        var _type:String;
        var _window:IWindow;
        var _related:IWindow;
        var _cancelled:Bool = false;
        var _cancelable:Bool = false;
        var _recycled:Bool = false;
        var _pool:Array<ASAny>;


        public static function allocate(type:String, window:IWindow, related:IWindow, cancelable:Bool=false):WindowEvent
        {
            var _local_5:WindowEvent = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(WindowEvent, []));
            _local_5._type = type;
            _local_5._window = window;
            _local_5._related = related;
            _local_5._cancelable = cancelable;
            _local_5._recycled = false;
            _local_5._pool = POOL;
            return _local_5;
        }


        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var target(get,never):IWindow;
function  get_target():IWindow
        {
            return this._window;
        }

        public var window(get,never):IWindow;
function  get_window():IWindow
        {
            return this._window;
        }

        public var related(get,never):IWindow;
function  get_related():IWindow
        {
            return this._related;
        }

        public var cancelable(get,never):Bool;
function  get_cancelable():Bool
        {
            return this._cancelable;
        }

        public function recycle()
        {
            if (this._recycled)
            {
                throw new ASError("Event already recycled!");
            }
            this._window = (this._related = null);
            this._recycled = true;
            this._cancelled = false;
            this._pool.push(this);
        }

        public function clone():WindowEvent
        {
            return allocate(this._type, this._window, this.related, this.cancelable);
        }

        public function preventDefault()
        {
            this.preventWindowOperation();
        }

        public function isDefaultPrevented():Bool
        {
            return this._cancelled;
        }

        public function preventWindowOperation()
        {
            if (this.cancelable)
            {
                this._cancelled = true;
            }
            else
            {
                throw new ASError("Attempted to prevent window operation that is not cancelable!");
            }
        }

        public function isWindowOperationPrevented():Bool
        {
            return this._cancelled;
        }

        public function stopPropagation()
        {
            this._cancelled = true;
        }

        public function stopImmediatePropagation()
        {
            this._cancelled = true;
        }

        public function toString():String
        {
            return ((((("WindowEvent { type: " + this._type) + " cancelable: ") + this._cancelable) + " window: ") + this._window) + " }";
        }

	public function new() {}
    }

