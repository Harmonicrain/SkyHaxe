package snowwar._str_427
;
    import snowwar._str_39._SafeStr_4672;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4682 extends _SafeStr_4020 
    {
        var _SafeStr_22190:_SafeStr_4672;

        public function new(k:_SafeStr_4672)
        {
            super();
            this._SafeStr_22190 = k;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22190 = null;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            if (this._SafeStr_22190 != null)
            {
                this._SafeStr_22190._SafeStr_22075();
            }
            else
            {
                HabboGamesCom.log(["Too early for this stuff.."]);
            }
        }
    }

