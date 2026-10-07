package com.sulake.habbo.inventory
;
     interface IAvatarEffect 
    {
        var type(get,never):Int;
        var subType(get,never):Int;
        var secondsRemaining(get,never):Int;
        var duration(get,never):Int;
        var isActive(get,never):Bool;
        var Selected(get,never):Bool;
    }

