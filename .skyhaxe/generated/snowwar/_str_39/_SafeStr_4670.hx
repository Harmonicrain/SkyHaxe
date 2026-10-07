package snowwar._str_39
;
    import snowwar.Tile;
    import snowwar._str_254.Direction360;
    import snowwar._str_254.CollisionDetection;
    import snowwar._str_254.Location;
    import snowwar._str_231.SynchronizedGameStage;
    import snowwar.SnowWarGameStage;

     class _SafeStr_4670 extends SnowWarGameObject 
    {
        var _SafeStr_22070:Int = 0;
        var _SafeStr_18830:Int = 0;
        var _SafeStr_18809:Tile;

        public function new(k:Int, _arg_2:Int, _arg_3:Tile, _arg_4:Int)
        {
            super(k, false);
            _active = true;
            this._SafeStr_18830 = _arg_2;
            this._SafeStr_18809 = _arg_3;
            this._SafeStr_22070 = _arg_4;
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_18809 = null;
        }

        override public function  get_direction360():Direction360
        {
            return null;
        }

        override public function  get_boundingType():Int
        {
            return CollisionDetection._SafeStr_18853;
        }

        override public function  get_location3D():Location
        {
            return this._SafeStr_18809.location;
        }

        public var _SafeStr_18032(get,never):Int;
public function  get__SafeStr_18032():Int
        {
            return this._SafeStr_22070;
        }

        public var _SafeStr_18035(get,never):Int;
public function  get__SafeStr_18035():Int
        {
            return this._SafeStr_18830;
        }

        override public function subturn(k:SynchronizedGameStage)
        {
        }

        public function _SafeStr_22071(k:Int):Int
        {
            if (this._SafeStr_18830 < k)
            {
                k = this._SafeStr_18830;
            }
            this._SafeStr_18830 = (this._SafeStr_18830 - k);
            this.onSnowballPickup();
            return k;
        }

        override public function onSnowBallHit(k:SnowWarGameStage, _arg_2:_SafeStr_4035)
        {
        }

        function onSnowballPickup()
        {
        }
    }

