package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.IDisposable;

     interface IAvatarImageListener extends IDisposable 
    {
        function avatarImageReady(_arg_1:String):Void;
    }

