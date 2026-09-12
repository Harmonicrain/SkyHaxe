package snowwar._str_427
;
    import snowwar._str_39._SafeStr_4035;
    import snowwar._str_39.HumanGameObject;
    import snowwar._str_231.SynchronizedGameStage;

     class _SafeStr_4685 extends _SafeStr_4020 
    {
        var _SafeStr_22193:_SafeStr_4035;
        var _SafeStr_22183:HumanGameObject;
        var _SafeStr_20901:Int = 0;
        var _SafeStr_20902:Int = 0;
        var _SafeStr_19035:Int = 0;

        public function new(k:Int, _arg_2:HumanGameObject, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            super();
            this._SafeStr_22193 = new _SafeStr_4035(k);
            this._SafeStr_22183 = _arg_2;
            this._SafeStr_20901 = _arg_3;
            this._SafeStr_20902 = _arg_4;
            this._SafeStr_19035 = _arg_5;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22193 = null;
            this._SafeStr_22183 = null;
        }

        public var _SafeStr_22194(never,set):_SafeStr_4035;
public function  set__SafeStr_22194(k:_SafeStr_4035):_SafeStr_4035        {
            return this._SafeStr_22193 = k;
        }

        override public function apply(k:SynchronizedGameStage)
        {
            k.addActiveGameObject(this._SafeStr_22193._SafeStr_13236, this._SafeStr_22193);
            this._SafeStr_22193.isActive = true;
            var _local_2= this._SafeStr_22183.currentLocation.x;
            var _local_3= this._SafeStr_22183.currentLocation.y;
            var _local_4= _SafeStr_4035._SafeStr_19021;
            this._SafeStr_22193.initialize(_local_2, _local_3, _local_4, this._SafeStr_19035, this._SafeStr_20901, this._SafeStr_20902, this._SafeStr_22183);
        }
    }

