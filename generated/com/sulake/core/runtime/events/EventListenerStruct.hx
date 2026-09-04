package com.sulake.core.runtime.events
;

     class EventListenerStruct 
    {
        var _dictionary:ASDictionary<ASAny,ASAny>;
        public var useCapture:Bool = false;
        public var priority:Int = 0;
        public var useWeakReference:Bool = false;

        public function new(callback:ASFunction, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false)
        {
            this._dictionary = new ASDictionary<ASAny,ASAny>(useWeakReference);
            this.callback = callback;
            this.useCapture = useCapture;
            this.priority = priority;
            this.useWeakReference = useWeakReference;
        }

        
        public var callback(get,set):ASFunction;
function  set_callback(callback:ASFunction):ASFunction        {
            for (_tmp_ in this._dictionary.keys())
            {
var key:ASObject  = _tmp_;
                this._dictionary.remove(key);
            }
            this._dictionary[callback] = null;
return callback;
        }
function  get_callback():ASFunction
        {
            for (_tmp_ in this._dictionary.keys())
            {
var key:ASObject  = _tmp_;
                return ASCompat.asFunction(key );
            }
            return null;
        }
    }

