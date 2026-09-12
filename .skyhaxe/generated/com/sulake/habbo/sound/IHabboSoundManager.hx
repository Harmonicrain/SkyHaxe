package com.sulake.habbo.sound
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboSoundManager extends IUnknown 
    {
                var genericVolume(get,set):Float;
                var traxVolume(get,set):Float;
                var furniVolume(get,set):Float;
        var musicController(get,never):IHabboMusicController;
        function playSound(_arg_1:String, _arg_2:Int=0):Void;
        function stopSound(_arg_1:String):Void;
        function playSoundAtPitch(_arg_1:String, _arg_2:Float):IHabboSound;
        function loadTraxSong(_arg_1:Int, _arg_2:String):IHabboSound;
        function mute(_arg_1:Bool):Void;
        function previewVolume(_arg_1:Float, _arg_2:Float, _arg_3:Float):Void;
        var events(get,never):IEventDispatcher;
    }

