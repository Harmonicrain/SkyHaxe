package com.sulake.habbo.game
;
    import com.sulake.core.runtime.IUnknown;
	import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;
    import flash.events.IEventDispatcher;

     interface IHabboGameManager extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        var gameCenterEnabled(get,never):Bool;
        var isHotelClosed(get,never):Bool;
        function loadGameClient(_arg_1:Int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:ASObject):Void;
        function _Str_19055(_arg_1:Int, _arg_2:String, _arg_3:String, _arg_4:String=""):Void;
        function unloadGame(_arg_1:Int, _arg_2:String, _arg_3:String):Void;
        function joinPlayerQueue(_arg_1:Int):Void;
        function leavePlayerQueue(_arg_1:Int):Void;
        function acceptGameInvite(_arg_1:Int, _arg_2:Int):Void;
        function showGameCenter(_arg_1:String, _arg_2:Int=0, _arg_3:Bool=false):Void;
        function showGameCenterByGameName(_arg_1:String, _arg_2:String, _arg_3:Bool=false):Void;
        function _Str_15814():Void;
        function _Str_22863(_arg_1:Int):String;
        function getGameId(_arg_1:String):Int;
        function getGameAssetURL(_arg_1:Int, _arg_2:String):String;
		function initGameDirectoryConnection():Void;
		function _SafeStr_7619(k:String):Void;
		function _SafeStr_7620():Void;
		function _SafeStr_7621():Void;
		function _SafeStr_7624():Void;
		function _SafeStr_7622(k:RoomObjectTileMouseEvent):Void;
		function _SafeStr_7623(k:Int, _arg_2:Bool, _arg_3:Bool):Void;
		function _SafeStr_7625(k:Int, _arg_2:Bool, _arg_3:Bool):Void;
    }

