package snowwar._str_39
;
    import snowwar.Tile;
    import snowwar._str_254.Direction8;
    import snowwar._str_254.Direction360;
    import snowwar._str_62._SafeStr_3584;
    import snowwar.SnowWarGameStage;
    import snowwar._str_62.SnowWarGameObjectData;
	import com.sulake.core.runtime.exceptions.Exception;
    import snowwar._str_254.CollisionDetection;
    import snowwar._str_231.SynchronizedGameStage;
    import snowwar._str_254.Location;

     class TreeGameObject extends SnowWarGameObject 
    {
        static final _SafeStr_22083:Array<ASAny> = [0];
        static final _SafeStr_18823:Array<ASAny> = [(ASCompat.toNumber(Tile.COST - ASCompat.toNumber(_SafeStr_4035._SafeStr_18823[0])) - 1)];

        var _SafeStr_22070:Int = 0;
        var _SafeStr_22082:Tile;
        var _direction8:Direction8;
        var _direction360:Direction360;
        var _height:Int = 0;
        var _maximumHits:Int = 0;
        var _hits:Int = 0;

        public function new(k:_SafeStr_3584, _arg_2:SnowWarGameStage)
        {
            super(k.id, false);
            isActive = true;
            this._SafeStr_22082 = _arg_2.getTileAt(Tile.fromLocationX(k.x), Tile.fromLocationY(k.y));
            this._direction8 = Direction8.fromIndex(k.direction);
            this._direction360 = new Direction360(Direction360.direction8ToDirection360Value(this._direction8));
            this._SafeStr_22070 = k._SafeStr_18032;
            this._height = k.height;
            this._hits = k.hits;
            this._maximumHits = k.maximumHits;
            if (this._hits < this._maximumHits)
            {
                _arg_2.addSnowWarGameObject(this);
            }
            this._SafeStr_22082.addHeight(-this._height);
            this._SafeStr_22082.blocked = true;
        }

        override public function  get_numberOfVariables():Int
        {
            return _SafeStr_3584.NUM_OF_VARIABLES;
        }

        override public function getVariable(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return SnowWarGameObjectData.OBJECT_TYPE_TREE;
                case 1:
                    return _SafeStr_13236;
                case 2:
                    return this._SafeStr_22082.location.x;
                case 3:
                    return this._SafeStr_22082.location.y;
                case 4:
                    return this._direction8.index();
                case 5:
                    return this._height;
                case 6:
                    return this._SafeStr_22070;
                case 7:
                    return this._maximumHits;
                case 8:
                    return this._hits;
            }
            throw new Exception(("No such variable:" + Std.string(k)));
        }

        override public function  get_boundingType():Int
        {
            return CollisionDetection._SafeStr_18853;
        }

        override public function subturn(k:SynchronizedGameStage)
        {
        }

        override public function  get_boundingData():Array<ASAny>
        {
            if (this._hits < this._maximumHits)
            {
                return _SafeStr_18823;
            }
            return _SafeStr_22083;
        }

        override public function  get_location3D():Location
        {
            return this._SafeStr_22082.location;
        }

        override public function  get_direction360():Direction360
        {
            return this._direction360;
        }

        override public function onSnowBallHit(k:SnowWarGameStage, _arg_2:_SafeStr_4035)
        {
            if (this._hits < this._maximumHits)
            {
                this._hits++;
            }
            if (this._hits >= this._maximumHits)
            {
                this._SafeStr_22082.removeGameObject();
            }
        }

        public var _SafeStr_18033(get,never):Int;
public function  get__SafeStr_18033():Int
        {
            return this._maximumHits;
        }

        public var hits(get,never):Int;
public function  get_hits():Int
        {
            return this._hits;
        }

        public var _SafeStr_18032(get,never):Int;
public function  get__SafeStr_18032():Int
        {
            return this._SafeStr_22070;
        }

        override public function  get_collisionHeight():Int
        {
            return this._height;
        }
    }

