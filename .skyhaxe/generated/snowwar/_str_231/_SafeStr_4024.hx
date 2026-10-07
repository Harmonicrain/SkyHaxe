package snowwar._str_231
;
	import com.sulake.core.runtime.IDisposable;
    import snowwar._str_496.SnowWarGameStageMessageParser;

     interface _SafeStr_4024 extends IDisposable 
    {
        function initialize(gameArena:SynchronizedGameArena, _arg_2:SnowWarGameStageMessageParser):Void;
        var synchronizedGameArena(get,never):SynchronizedGameArena;
        var roomType(get,never):String;
    }

