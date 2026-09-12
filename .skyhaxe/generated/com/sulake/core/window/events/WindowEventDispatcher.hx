package com.sulake.core.window.events
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.runtime.events.EventListenerStruct;

     class WindowEventDispatcher implements IDisposable 
    {
        static inline final EVENT_RESULT_TRUE:UInt = 0;
        static inline final EVENT_RESULT_FALSE:UInt = 1;
        static inline final EVENT_RESULT_ERROR:UInt = 2;

        var _disposed:Bool = false;
        var _eventListenerTable:ASDictionary<ASAny,ASAny>;
        var _result:UInt = 0;
        var _error:ASError;

        public function new(window:IWindow)
        {
            this._eventListenerTable = new ASDictionary<ASAny,ASAny>();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var error(get,never):ASError;
public function  get_error():ASError
        {
            return this._error;
        }

        public function addEventListener(type:String, callback:ASFunction, priority:Int=0)
        {
var struct:EventListenerStruct  = null;            var listeners:Array<ASAny> = this._eventListenerTable[type];
            var eventListener= new EventListenerStruct(callback, false, priority);
            if (listeners == null)
            {
                listeners = [eventListener];
                this._eventListenerTable[type] = listeners;
            }
            else
            {
                if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
                {
struct = _tmp_;
                    if (struct.callback == callback)
                    {
                        return;
                    }
                    if (priority > struct.priority)
                    {
                        listeners.insert(listeners.indexOf(struct), eventListener);
                        return;
                    }
                }
                listeners.push(eventListener);
            }
        }

        public function removeEventListener(type:String, callback:ASFunction)
        {
var listeners:Array<ASAny>  = null, index:UInt = 0, eventListener:EventListenerStruct  = null;            if (!this._disposed)
            {
listeners= this._eventListenerTable[type];
                if (listeners != null)
                {
index;
                    if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
                    {
eventListener = _tmp_;
                        if (eventListener.callback == callback)
                        {
                            listeners.splice(ASCompat.toInt(index), 1);
                            eventListener.callback = null;
                            if (listeners.length == 0)
                            {
                                this._eventListenerTable.remove(type);
                            }
                            return;
                        }
                        index++;
                    }
                }
            }
        }

        public function dispatchEvent(event:WindowEvent):Bool
        {
var listeners:Array<ASAny>  = null, callbacks:Array<ASAny>  = null, eventListener:EventListenerStruct  = null, callback:ASFunction  = null;            if (!this._disposed)
            {
                this._result = EVENT_RESULT_TRUE;
listeners= this._eventListenerTable[event.type];
                if (listeners != null)
                {
callbacks= [];
                    if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
                    {
eventListener = _tmp_;
                        callbacks.push(eventListener.callback);
                    }
                    while (callbacks.length > 0)
                    {
callback= callbacks.shift();
                        callback(event);
                    }
                }
                this._result = (event.isDefaultPrevented() ? EVENT_RESULT_FALSE : EVENT_RESULT_TRUE);
                return this._result == EVENT_RESULT_TRUE;
            }
            return false;
        }

        public function hasEventListener(type:String):Bool
        {
            return this._disposed ? false : (!(this._eventListenerTable[type] == null));
        }

        public function dispose()
        {
var key:ASObject  = null, listeners:Array<ASAny>  = null, eventListener:EventListenerStruct  = null;            if (!this._disposed)
            {
                final _iter_ = this._eventListenerTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
listeners= ASCompat.dynamicAs(this._eventListenerTable[key] , Array);
                    if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
                    {
eventListener = _tmp_;
                        eventListener.callback = null;
                    }
                    this._eventListenerTable.remove(key);
                }
                this._eventListenerTable = null;
                this._disposed = true;
            }
        }
    }

