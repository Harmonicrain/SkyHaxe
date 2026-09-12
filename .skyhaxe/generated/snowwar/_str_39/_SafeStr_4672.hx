package snowwar._str_39
;
    import snowwar._str_254.Direction8;
    import snowwar.Tile;
    import snowwar._str_62._SafeStr_3585;
    import snowwar.SnowWarGameStage;
    import snowwar._str_62.SnowWarGameObjectData;
    import com.sulake.core.runtime.exceptions.Exception;

     class _SafeStr_4672 extends _SafeStr_4670 
    {
        public static var _SafeStr_18823:Array<ASAny> = [1200];

        var _SafeStr_22074:Int = 0;
        var _SafeStr_6253:Direction8;

        public function new(k:_SafeStr_3585, _arg_2:SnowWarGameStage)
        {
            super(k.id, k._SafeStr_18035, _arg_2.getTileAt(Tile.fromLocationX(k.x), Tile.fromLocationY(k.y)), k._SafeStr_18032);
            this._SafeStr_22074 = k._SafeStr_18034;
            this._SafeStr_6253 = Direction8.fromIndex(k.direction);
            _arg_2.addSnowWarGameObject(this);
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_6253 = null;
        }

        override public function  get_numberOfVariables():Int
        {
            return _SafeStr_3585.NUM_OF_VARIABLES;
        }

        override public function getVariable(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL_MACHINE;
                case 1:
                    return _id;
                case 2:
                    return _SafeStr_18809.location.x;
                case 3:
                    return _SafeStr_18809.location.y;
                case 4:
                    return this._SafeStr_6253.index();
                case 5:
                    return this._SafeStr_22074;
                case 6:
                    return _SafeStr_18830;
                case 7:
                    return _SafeStr_22070;
            }
            throw new Exception(("No such variable:" + Std.string(k)));
        }

        override public function  get_boundingData():Array<ASAny>
        {
            return _SafeStr_18823;
        }

        public function _SafeStr_22075()
        {
            if (_SafeStr_18830 < this._SafeStr_22074)
            {
                _SafeStr_18830++;
            }
        }
    }

