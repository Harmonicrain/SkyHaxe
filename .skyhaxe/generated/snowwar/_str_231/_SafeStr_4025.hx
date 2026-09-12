package snowwar._str_231
;
    import snowwar._str_496.SnowWarGameStageMessageParser;

     class _SafeStr_4025 implements _SafeStr_4024 
    {
        var _synchronizedGameArena:SynchronizedGameArena;
        var _SafeStr_18702:SnowWarGameStageMessageParser;
        var _SafeStr_5041:Bool = false;


        public function dispose()
        {
            this._SafeStr_5041 = true;
            this._synchronizedGameArena = null;
            this._SafeStr_18702 = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        public function initialize(k:SynchronizedGameArena, _arg_2:SnowWarGameStageMessageParser)
        {
            this._synchronizedGameArena = k;
            this._SafeStr_18702 = _arg_2;
        }

        public var synchronizedGameArena(get,never):SynchronizedGameArena;
public function  get_synchronizedGameArena():SynchronizedGameArena
        {
            return this._synchronizedGameArena;
        }

        public var _SafeStr_18703(get,never):SnowWarGameStageMessageParser;
public function  get__SafeStr_18703():SnowWarGameStageMessageParser
        {
            return this._SafeStr_18702;
        }

        public var roomType(get,never):String;
public function  get_roomType():String
        {
            return "";
        }

	public function new() {}
    }




