package com.sulake.habbo.session.product
;
    import com.sulake.core.runtime.IDisposable;

     interface IProductDataListener extends IDisposable 
    {
        function productDataReady():Void;
    }

