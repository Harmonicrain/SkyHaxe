package com.sulake.core.window
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.utils.IIterable;

     interface IWidget extends IDisposable extends  IIterable 
    {
                var properties(get,set):Array<ASAny>;
    }

