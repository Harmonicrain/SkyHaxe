package snowwar._str_231
;
    import com.sulake.core.runtime.IDisposable;

     interface ISnowWarGameObject extends _SafeStr_4028 extends  IDisposable 
    {
                var isActive(get,set):Bool;
        var numberOfVariables(get,never):Int;
        function getVariable(_arg_1:Int):Int;
        function subturn(_arg_1:SynchronizedGameStage):Void;
        function onRemove():Void;
    }

