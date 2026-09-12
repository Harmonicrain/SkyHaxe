package com.sulake.habbo.avatar.animation
;
    import flash.geom.ColorTransform;

     interface IAvatarDataContainer 
    {
        var ink(get,never):Int;
        var colorTransform(get,never):ColorTransform;
        var paletteIsGrayscale(get,never):Bool;
        var reds(get,never):Array<ASAny>;
        var greens(get,never):Array<ASAny>;
        var blues(get,never):Array<ASAny>;
        var alphas(get,never):Array<ASAny>;
    }

