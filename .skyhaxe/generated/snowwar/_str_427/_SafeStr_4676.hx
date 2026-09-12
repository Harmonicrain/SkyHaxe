package snowwar._str_427
;
    import snowwar._str_39.HumanGameObject;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4676 extends _SafeStr_4020 
    {
        var _SafeStr_22183:HumanGameObject;

        public function new(k:HumanGameObject)
        {
            super();
            this._SafeStr_22183 = k;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22183 = null;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            this._SafeStr_22183._SafeStr_18849();
        }

        public var _SafeStr_22184(get,never):HumanGameObject;
public function  get__SafeStr_22184():HumanGameObject
        {
            return this._SafeStr_22183;
        }
    }

