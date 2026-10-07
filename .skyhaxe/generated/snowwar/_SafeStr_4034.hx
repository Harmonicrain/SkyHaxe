package snowwar
;
    import snowwar._str_231._SafeStr_4033;
    import snowwar._str_231.SynchronizedGameArena;
    import snowwar._str_231._SafeStr_4024;

     class _SafeStr_4034 implements _SafeStr_4033 
    {
        var _gameArena:SynchronizedGameArena;
        var _disposed:Bool = false;


        public function dispose()
        {
            this._disposed = true;
            this._gameArena = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var synchronizedGameArena(never,set):SynchronizedGameArena;
public function  set_synchronizedGameArena(k:SynchronizedGameArena):SynchronizedGameArena        {
            return this._gameArena = k;
        }

        public function _SafeStr_13253():Int
        {
            return 50;
        }

        public function maxSubTurns():Int
        {
            return 3;
        }

        public function createStage():_SafeStr_4024
        {
            return new SnowWarGameStage();
        }

        public function handleTurn()
        {
        }

        public function _SafeStr_18784():Bool
        {
            return this._gameArena._SafeStr_13274 == 1;
        }
public function new(){}
    }

