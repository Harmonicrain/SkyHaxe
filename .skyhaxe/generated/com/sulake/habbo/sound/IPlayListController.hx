package com.sulake.habbo.sound
;
    import com.sulake.core.runtime.IDisposable;

     interface IPlayListController extends IDisposable 
    {
        var priority(get,never):Int;
        var length(get,never):Int;
        var playPosition(get,never):Int;
        var nowPlayingSongId(get,never):Int;
        var isPlaying(get,never):Bool;
        function getEntry(_arg_1:Int):ISongInfo;
        function requestPlayList():Void;
    }

