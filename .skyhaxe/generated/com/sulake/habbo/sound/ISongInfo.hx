package com.sulake.habbo.sound
;
     interface ISongInfo 
    {
        var loaded(get,never):Bool;
        var id(get,never):Int;
        var diskId(get,never):Int;
        var length(get,never):Int;
        var name(get,never):String;
        var creator(get,never):String;
        var songData(get,never):String;
        var soundObject(get,never):IHabboSound;
    }

