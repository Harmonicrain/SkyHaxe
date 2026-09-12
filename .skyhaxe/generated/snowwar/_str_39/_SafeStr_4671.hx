package snowwar._str_39
;
    import snowwar.Tile;
    import snowwar._str_62._SafeStr_3586;
    import snowwar.SnowWarGameStage;
    import snowwar._str_62.SnowWarGameObjectData;
    import com.sulake.core.runtime.exceptions.Exception;

     class _SafeStr_4671 extends _SafeStr_4670 
    {
        static inline final _SafeStr_22072= 100;

        var _SafeStr_22073:Array<ASAny>;
        var _SafeStr_22074:Int = 0;

        public function new(k:_SafeStr_3586, _arg_2:SnowWarGameStage)
        {
            super(k.id, k._SafeStr_18035, _arg_2.getTileAt(Tile.fromLocationX(k.x), Tile.fromLocationY(k.y)), k._SafeStr_18032);
            this._SafeStr_22074 = k._SafeStr_18034;
            if (_SafeStr_18830 > 0)
            {
                _arg_2.addSnowWarGameObject(this);
            }
            this._SafeStr_22073 = [(_SafeStr_18830 * _SafeStr_22072)];
        }

        override public function  get_numberOfVariables():Int
        {
            return _SafeStr_3586.NUM_OF_VARIABLES;
        }

        override public function getVariable(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL_PILE;
                case 1:
                    return _id;
                case 2:
                    return _SafeStr_18809.location.x;
                case 3:
                    return _SafeStr_18809.location.y;
                case 4:
                    return this._SafeStr_22074;
                case 5:
                    return _SafeStr_18830;
                case 6:
                    return _SafeStr_22070;
            }
            throw new Exception(("No such variable:" + Std.string(k)));
        }

        override public function  get_boundingData():Array<ASAny>
        {
            return this._SafeStr_22073;
        }

        override function onSnowballPickup()
        {
            this._SafeStr_22073 = [(_SafeStr_18830 * _SafeStr_22072)];
            if (_SafeStr_18830 <= 0)
            {
                _SafeStr_18809.removeGameObject();
            }
        }

        public var _SafeStr_18034(get,never):Int;
public function  get__SafeStr_18034():Int
        {
            return this._SafeStr_22074;
        }
    }

