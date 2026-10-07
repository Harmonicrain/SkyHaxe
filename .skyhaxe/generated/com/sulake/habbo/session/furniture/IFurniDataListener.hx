package com.sulake.habbo.session.furniture
;
    import com.sulake.core.runtime.IDisposable;

     interface IFurniDataListener extends IDisposable 
    {
        function furniDataReady():Void;
    }

