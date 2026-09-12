package com.sulake.core.runtime.events
;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.EventDispatcher;
    import com.sulake.core.Core;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import flash.events.Event;

     class EventDispatcherWrapper implements IEventDispatcher implements  IDisposable 
    {
        static inline final EVENT_RESULT_TRUE:UInt = 0;
        static inline final EVENT_RESULT_FALSE:UInt = 1;
        static inline final EVENT_RESULT_ERROR:UInt = 2;

        var _disposed:Bool = false;
        var _eventDispatcher:EventDispatcher;
        var _eventListenerTable:ASDictionary<ASAny,ASAny>;
        var _result:UInt = 0;
        var _error:ASError;

        public function new(parent:IEventDispatcher=null)
        {
            this._eventListenerTable = new ASDictionary<ASAny,ASAny>();
            this._eventDispatcher = new EventDispatcher(((parent != null) ? parent : this));
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

        public function addEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false, _arg_4:Int=0, _arg_5:Bool=false)
        {
            var _local_8:EventListenerStruct = null;
            var _local_6:Array<ASAny> = this._eventListenerTable[k];
            var _local_7= new EventListenerStruct(_arg_2, _arg_3, _arg_4, _arg_5);
            if (_local_6 == null)
            {
                _local_6 = [_local_7];
                this._eventListenerTable[k] = _local_6;
                this._eventDispatcher.addEventListener(k, (this.eventProcessor : ASAny));
            }
            else
            {
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_8  = _tmp_;
                    if (((_local_8.callback == _arg_2) && (_local_8.useCapture == _arg_3)))
                    {
                        return;
                    }
                    if (_arg_4 > _local_8.priority)
                    {
                        _local_6.insert(_local_6.indexOf(_local_8), _local_7);
                        return;
                    }
                }
                _local_6.push(_local_7);
            }
        }

        public function removeEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false)
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:UInt = 0;
            var _local_6:EventListenerStruct = null;
            if (!this._disposed)
            {
                _local_4 = this._eventListenerTable[k];
                if (_local_4 != null)
                {
                    _local_5 = 0;
                    if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                    {
_local_6  = _tmp_;
                        if (((_local_6.callback == _arg_2) && (_local_6.useCapture == _arg_3)))
                        {
                            _local_4.splice(ASCompat.toInt(_local_5), 1);
                            _local_6.callback = null;
                            if (_local_4.length == 0)
                            {
                                this._eventListenerTable.remove(k);
                                this._eventDispatcher.removeEventListener(k, (this.eventProcessor : ASAny));
                            }
                            return;
                        }
                        _local_5++;
                    }
                }
            }
        }

        public function dispatchEvent(k:Event):Bool
        {
            if (!this._disposed)
            {
                this._result = EVENT_RESULT_TRUE;
                this._eventDispatcher.dispatchEvent(k);
                if (this._result == EVENT_RESULT_ERROR)
                {
                    if (this._error != null)
                    {
                        Core.crash(((("Error caught when handling " + getQualifiedClassName(k)) + ": ") + this._error.message), this._error.errorID, this._error);
                    }
                    else
                    {
                        Core.crash((("Error caught when handling " + getQualifiedClassName(k)) + ". No error data available!"), 0, this._error);
                    }
                }
                return this._result == EVENT_RESULT_TRUE;
            }
            return false;
        }

        public function hasEventListener(k:String):Bool
        {
            return this._disposed ? false : (!(this._eventListenerTable[k] == null));
        }

        public function callEventListeners(k:String)
        {
            var _local_3:EventListenerStruct = null;
            var _local_2:Array<ASAny> = this._eventListenerTable[k];
            if (_local_2 != null)
            {
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    _local_3.callback(null);
                }
            }
        }

        public function willTrigger(k:String):Bool
        {
            return this._disposed ? false : (!(this._eventListenerTable[k] == null));
        }

        function eventProcessor(event:Event)
        {
            var callbacks:Array<ASAny> = null;
            var callback:ASFunction = null;
            var struct:EventListenerStruct = null;
            var array:Array<ASAny> = this._eventListenerTable[event.type];
            if (array != null)
            {
                callbacks = [];
                if (checkNullIteratee(array)) for (_tmp_ in array)
                {
struct  = _tmp_;
                    callbacks.push(struct.callback);
                }
                while (callbacks.length > 0)
                {
                    try
                    {
                        callback = callbacks.shift();
                        callback(event);
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                        Logger.log([e.getStackTrace()]);
                        _result = EVENT_RESULT_ERROR;
                        _error = e;
                        return;
                    }
 }                }
            }
            this._result = (event.isDefaultPrevented() ? EVENT_RESULT_FALSE : EVENT_RESULT_TRUE);
        }

        public function dispose()
        {
var type:String  = null, listeners:Array<ASAny>  = null, struct:EventListenerStruct  = null;            if (!this._disposed)
            {
                final _iter_ = this._eventListenerTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
type = _tmp_;
listeners= ASCompat.dynamicAs(this._eventListenerTable[type] , Array);
                    if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
                    {
struct = _tmp_;
                        struct.callback = null;
                    }
                    this._eventListenerTable.remove(type);
                    this._eventDispatcher.removeEventListener(type, (this.eventProcessor : ASAny));
                }
                this._eventListenerTable = null;
                this._eventDispatcher = null;
                this._disposed = true;
            }
        }
    }

