package snowwar._str_427
;
    import snowwar._str_39.HumanGameObject;
    import snowwar.SnowWarEngine;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4683 extends _SafeStr_4020 
    {
        var _SafeStr_22183:HumanGameObject;
        var _SafeStr_22191:HumanGameObject;
        var _SafeStr_19035:Int = 0;

        public function new(k:HumanGameObject, _arg_2:HumanGameObject, _arg_3:Int)
        {
            super();
            this._SafeStr_22183 = k;
            this._SafeStr_22191 = _arg_2;
            this._SafeStr_19035 = _arg_3;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22183 = null;
            this._SafeStr_22191 = null;
            this._SafeStr_19035 = 0;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            this._SafeStr_22184._SafeStr_18847(this._SafeStr_22191.currentLocation.x, this._SafeStr_22191.currentLocation.y);
            this._SafeStr_22184._SafeStr_18846();
            SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_THROW);
        }

        public var _SafeStr_22184(get,never):HumanGameObject;
public function  get__SafeStr_22184():HumanGameObject
        {
            return this._SafeStr_22183;
        }

        public var _SafeStr_22192(get,never):HumanGameObject;
public function  get__SafeStr_22192():HumanGameObject
        {
            return this._SafeStr_22191;
        }

        public var _SafeStr_18038(get,never):Int;
public function  get__SafeStr_18038():Int
        {
            return this._SafeStr_19035;
        }
    }

