package snowwar._str_427
;
    import snowwar._str_39.HumanGameObject;
    import snowwar.SnowWarEngine;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4693 extends _SafeStr_4020 
    {
        var _SafeStr_22183:HumanGameObject;
        var _targetX:Int = 0;
        var _SafeStr_20902:Int = 0;
        var _SafeStr_19035:Int = 0;

        public function new(k:HumanGameObject, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super();
            this._SafeStr_22183 = k;
            this._targetX = _arg_2;
            this._SafeStr_20902 = _arg_3;
            this._SafeStr_19035 = _arg_4;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22183 = null;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            this._SafeStr_22184._SafeStr_18847(this.targetX, this._SafeStr_16005);
            this._SafeStr_22184._SafeStr_18846();
            SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_THROW);
        }

        public var _SafeStr_22184(get,never):HumanGameObject;
public function  get__SafeStr_22184():HumanGameObject
        {
            return this._SafeStr_22183;
        }

        public var targetX(get,never):Int;
public function  get_targetX():Int
        {
            return this._targetX;
        }

        public var _SafeStr_16005(get,never):Int;
public function  get__SafeStr_16005():Int
        {
            return this._SafeStr_20902;
        }

        public var _SafeStr_18038(get,never):Int;
public function  get__SafeStr_18038():Int
        {
            return this._SafeStr_19035;
        }
    }










