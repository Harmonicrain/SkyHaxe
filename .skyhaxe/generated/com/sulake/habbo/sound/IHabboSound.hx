package com.sulake.habbo.sound
;
     interface IHabboSound 
    {
        function play(_arg_1:Float=0):Bool;
        function stop():Bool;
                var volume(get,set):Float;
                var position(get,set):Float;
        var length(get,never):Float;
        var ready(get,never):Bool;
        var finished(get,never):Bool;
                var fadeOutSeconds(get,set):Float;
                var fadeInSeconds(get,set):Float;
    }

