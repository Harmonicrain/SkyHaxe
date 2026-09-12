package com.sulake.core.window.utils
;
    import com.sulake.core.window.IWindow;

     interface IChildWindowHost 
    {
        var children(get,never):Vector<IWindow>;
    }

