package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.IChildEntity;
    import flash.geom.Rectangle;

     interface ISkinTemplateEntity extends IChildEntity 
    {
        var type(get,never):String;
        var region(get,never):Rectangle;
    }

