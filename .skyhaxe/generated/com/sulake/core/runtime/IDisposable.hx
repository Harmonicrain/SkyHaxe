package com.sulake.core.runtime
;
     interface IDisposable 
    {
        function dispose():Void;
        var disposed(get,never):Bool;
    }

