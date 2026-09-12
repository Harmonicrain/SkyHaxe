package snowwar._str_427
;
    import snowwar._str_231._SafeStr_4019;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4020 implements _SafeStr_4019 
    {
        var _disposed:Bool = false;

        public function apply(k:SynchronizedGameStage)
        {
        }

        public function dispose()
        {
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

	public function new() {}
    }

