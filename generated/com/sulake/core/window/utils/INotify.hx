package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;

     interface INotify extends IDisposable 
    {
                var title(get,set):String;
                var summary(get,set):String;
                var callback(get,set):ASFunction;
    }

