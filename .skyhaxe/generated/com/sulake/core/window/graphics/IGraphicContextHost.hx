package com.sulake.core.window.graphics
;
     interface IGraphicContextHost 
    {
        var name(get,never):String;
        function getGraphicContext(_arg_1:Bool):IGraphicContext;
        function hasGraphicsContext():Bool;
    }

