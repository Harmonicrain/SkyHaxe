package com.sulake.habbo.sound
;
    import flash.events.IEventDispatcher;

     interface IHabboMusicController 
    {
        function getRoomItemPlaylist(_arg_1:Int=-1):IPlayListController;
        function getSongDiskInventorySize():Int;
        function getSongDiskInventoryDiskId(_arg_1:Int):Int;
        function getSongDiskInventorySongId(_arg_1:Int):Int;
        function getSongInfo(_arg_1:Int):ISongInfo;
        function getSongIdPlayingAtPriority(_arg_1:Int):Int;
        function playSong(_arg_1:Int, _arg_2:Int, _arg_3:Float=0, _arg_4:Float=0, _arg_5:Float=0.5, _arg_6:Float=0.5):Bool;
        function stop(_arg_1:Int):Void;
        function addSongInfoRequest(_arg_1:Int):Void;
        function requestSongInfoWithoutSamples(_arg_1:Int):Void;
        function requestUserSongDisks():Void;
        function onSongLoaded(_arg_1:Int):Void;
        function updateVolume(_arg_1:Float):Void;
        function samplesUnloaded(_arg_1:Array<ASAny>):Void;
        var samplesIdsInUse(get,never):Array<ASAny>;
        var events(get,never):IEventDispatcher;
        function dispose():Void;
    }

