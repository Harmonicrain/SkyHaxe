package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;

     interface ITrackedWindow extends IDisposable 
    {
        function getType():Int;
        function getId():String;
        function getFrame():IFrameWindow;
        function show():Void;
    }

