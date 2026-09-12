package snowwar._str_427
;
    import snowwar._str_39.HumanGameObject;
    import snowwar._str_39._SafeStr_4670;
    import snowwar.SnowWarEngine;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4684 extends _SafeStr_4020 
    {
        var _SafeStr_22183:HumanGameObject;
        var _SafeStr_22190:_SafeStr_4670;

        public function new(k:HumanGameObject, _arg_2:_SafeStr_4670)
        {
            super();
            this._SafeStr_22183 = k;
            this._SafeStr_22190 = _arg_2;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22183 = null;
            this._SafeStr_22190 = null;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            var _local_3 = 0;
            var _local_4:HumanGameObject = null;
            var _local_2= this._SafeStr_22183._SafeStr_18850();
            if (_local_2 > 0)
            {
                _local_3 = this._SafeStr_22190._SafeStr_22071(1);
                if (_local_3 > 0)
                {
                    this._SafeStr_22183._SafeStr_18851(_local_3);
                    _local_4 = Std.downcast(k.getGameObject(this._SafeStr_22183._SafeStr_13241) , HumanGameObject);
                    if (_local_4 != null)
                    {
                        _local_4._SafeStr_18851(_local_3);
                    }
                    SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_GET_SNOWBALL);
                }
            }
        }

        public var _SafeStr_22184(get,never):HumanGameObject;
public function  get__SafeStr_22184():HumanGameObject
        {
            return this._SafeStr_22183;
        }
    }

