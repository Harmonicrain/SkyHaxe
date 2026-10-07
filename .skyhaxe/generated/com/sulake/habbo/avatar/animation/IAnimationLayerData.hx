package com.sulake.habbo.avatar.animation
;
    import com.sulake.habbo.avatar.actions.IActiveActionData;

     interface IAnimationLayerData 
    {
        var id(get,never):String;
        var action(get,never):IActiveActionData;
        var animationFrame(get,never):Int;
        var dx(get,never):Int;
        var dy(get,never):Int;
        var dz(get,never):Int;
        var dd(get,never):Int;
    }

