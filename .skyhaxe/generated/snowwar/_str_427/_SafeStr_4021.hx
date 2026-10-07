package snowwar._str_427
;
    import snowwar._str_39.HumanGameObject;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4021 extends _SafeStr_4020 
    {
        var _SafeStr_18601:HumanGameObject;
        var _SafeStr_6268:Int = 0;
        var _SafeStr_6269:Int = 0;

        public function new(k:HumanGameObject, _arg_2:Int, _arg_3:Int)
        {
            super();
            this._SafeStr_18601 = k;
            this._SafeStr_6268 = _arg_2;
            this._SafeStr_6269 = _arg_3;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_18601 = null;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            this._SafeStr_18601._SafeStr_18603(this._SafeStr_6268, this._SafeStr_6269);
        }

        public var _SafeStr_18602(get,never):HumanGameObject;
public function  get__SafeStr_18602():HumanGameObject
        {
            return this._SafeStr_18601;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._SafeStr_6268;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._SafeStr_6269;
        }
    }

