package snowwar._str_39
;
	import com.sulake.habbo.sound.HabboSoundTypesEnum;
	import com.sulake.core.runtime.exceptions.Exception;
	import snowwar._str_231.SynchronizedGameStage;
	import snowwar._str_254.CollisionDetection;
	import snowwar._str_254.Direction360;
	import snowwar._str_254.Direction8;
	import snowwar._str_254.Location;
	import snowwar._str_254.SquareRoot;
	import snowwar._str_254._SafeStr_4667;
	import snowwar.SnowWarGameStage;
	import snowwar.Tile;
	import snowwar.SnowWarEngine;
	import snowwar._str_62.SnowWarGameObjectData;
	import snowwar._str_62._SafeStr_3587;

     class _SafeStr_4035 extends SnowWarGameObject //Snowball
    {
        public static inline final _SafeStr_13247= 0;
        public static inline final _SafeStr_13245= 1;
        public static inline final _SafeStr_13243= 2;
        public static inline final _SafeStr_13249= 3;
        public static inline final _SafeStr_19020= 2000;
        public static inline final _SafeStr_19021= 3000;
        public static final _SafeStr_19022:Float = ((2 / 1.414) / _SafeStr_19020);//0.000707213578500707
        public static final _SafeStr_19023:Float = ((2.236 / 2) / _SafeStr_19020);//0.000559
        public static inline final _SafeStr_19024= 20000;
        public static inline final _SafeStr_19025= 60000;
        public static inline final _SafeStr_19026= 100000;
        public static inline final _SafeStr_19027= 42000;
        public static inline final _SafeStr_19028= 10;
        public static inline final _SafeStr_19029= 25;
        public static inline final _SafeStr_19030= 50;
        public static var _SafeStr_18823:Array<ASAny> = [400];
        public static inline final _SafeStr_19031= 3;
        public static inline final _SafeStr_19032= 15;

        var _location:Location;
        var _direction:Direction360;
        var _SafeStr_19035:Int = 0;
        var _SafeStr_19036:Int = 0;
        var _ttl:Int = 0;
        var _humanGameObject:HumanGameObject;
        var _paraOffs:Int = 0;

        public function new(k:Int)
        {
            this._location = new Location(0, 0, 0);
            this._direction = new Direction360(0);
            super(k, false);
        }

        override public function dispose()
        {
            super.dispose();
            this._location.dispose();
            this._location = null;
            this._direction.dispose();
            this._direction = null;
            this._SafeStr_19035 = 0;
            this._SafeStr_19036 = 0;
            this._ttl = 0;
            this._humanGameObject = null;
            this._paraOffs = 0;
        }

        public function _SafeStr_18982(k:_SafeStr_3587, _arg_2:HumanGameObject)
        {
            this._location.setLocation(k.x, k.y, k._SafeStr_18036);
            this._direction._SafeStr_19043(k._SafeStr_18037);
            this._SafeStr_19035 = k._SafeStr_18038;
            this._SafeStr_19036 = k._SafeStr_18042;
            this._ttl = k._SafeStr_18039;
            this._humanGameObject = _arg_2;
            this._paraOffs = k._SafeStr_18041;
            _active = true;
        }

        public function initialize(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:HumanGameObject)
        {
            var _local_8 = 0;
            _active = true;
            this._location.setLocation(k, _arg_2, _arg_3);
            this._SafeStr_19035 = _arg_4;
            var deltaX= (_arg_5 - k);
            var deltaY= (_arg_6 - _arg_2);
            deltaX = _SafeStr_4667._SafeStr_18698((deltaX / 200));
            deltaY = _SafeStr_4667._SafeStr_18698((deltaY / 200));
            this._direction._SafeStr_19043(Direction360._SafeStr_18792(deltaX, deltaY));
            _local_8 = (SquareRoot._SafeStr_19044(((deltaX * deltaX) + (deltaY * deltaY))) * 200);
            this._SafeStr_19040(_arg_4, _local_8);
            if (this._SafeStr_19035 == _SafeStr_13247)
            {
                this._ttl = Std.int(_SafeStr_19024 / _SafeStr_19020);
                this._SafeStr_19036 = _SafeStr_19020;
            }
            else
            {
                if (this._SafeStr_19035 == _SafeStr_13245)
                {
                    _local_8 = Std.int(Math.min(_local_8, _SafeStr_19025));
                    this._ttl = Std.int(_local_8 * _SafeStr_19023);
                    this._SafeStr_19036 = ((this._ttl == 0) ? 0 : _SafeStr_4667._SafeStr_18698((_local_8 / this._ttl)));
                }
                else
                {
                    if (this._SafeStr_19035 == _SafeStr_13243)
                    {
                        _local_8 = Std.int(Math.min(_local_8, _SafeStr_19026));
                        this._ttl = Std.int(_local_8 * _SafeStr_19022);
                        this._SafeStr_19036 = ((this._ttl == 0) ? 0 : _SafeStr_4667._SafeStr_18698((_local_8 / this._ttl)));
                    }
                }
            }
            this._paraOffs = _SafeStr_4667._SafeStr_18698((this._ttl / 2));
            this._humanGameObject = _arg_7;
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((((((((((((((("Snowball created, id=" + Std.string(_id)) + " ttl:") + Std.string(this._ttl)) + " deltaX:") + Std.string(deltaX)) + " deltaY:") + Std.string(deltaY)) + " deltaX/200:") + Std.string(_SafeStr_4667._SafeStr_18698((deltaX / 200)))) + " deltaY/200:") + Std.string(_SafeStr_4667._SafeStr_18698((deltaY / 200)))) + " deltax^2+deltay^2:") + Std.string((deltaX * deltaX) + (deltaY * deltaY))) + " sqrt(deltax^2+deltay^2):") + Std.string(SquareRoot._SafeStr_19044(((deltaX * deltaX) + (deltaY * deltaY))))) + " sqrt(deltax^2+deltay^2)*200:") + Std.string(SquareRoot._SafeStr_19044(((deltaX * deltaX) + (deltaY * deltaY))) * 200))]);
            }
        }

        function _SafeStr_19040(k:Int, _arg_2:Int)
        {
            if (k == _SafeStr_13249)
            {
                if (_arg_2 <= _SafeStr_19027)
                {
                    this._SafeStr_19035 = _SafeStr_13247;
                }
                else
                {
                    if (_arg_2 <= _SafeStr_19025)
                    {
                        this._SafeStr_19035 = _SafeStr_13245;
                    }
                    else
                    {
                        this._SafeStr_19035 = _SafeStr_13243;
                    }
                }
            }
            else
            {
                this._SafeStr_19035 = k;
            }
        }

        override public function  get_numberOfVariables():Int
        {
            return _SafeStr_3587.NUM_OF_VARIABLES;
        }

        override public function getVariable(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL;
                case 1:
                    return _id;
                case 2:
                    return this._location.x;
                case 3:
                    return this._location.y;
                case 4:
                    return this._location.z;
                case 5:
                    return this._direction.index();
                case 6:
                    return this._SafeStr_19035;
                case 7:
                    return this._ttl;
                case 8:
                    return (this._humanGameObject == null) ? -1 : this._humanGameObject._SafeStr_13236;
                case 9:
                    return this._paraOffs;
                case 10:
                    return this._SafeStr_19036;
            }
            throw new Exception(("No such variable:" + Std.string(k)));
        }

        override public function  get_direction360():Direction360
        {
            return this._direction;
        }

        override public function  get_boundingType():Int
        {
            return CollisionDetection._SafeStr_18853;
        }

        override public function  get_boundingData():Array<ASAny>
        {
            return _SafeStr_18823;
        }

        override public function  get_location3D():Location
        {
            return this._location;
        }

        override public function subturn(k:SynchronizedGameStage)
        {
            var _local_2= Std.downcast(k , SnowWarGameStage);
            if (!_active)
            {
                return;
            }
            this._ttl--;
            if (this._SafeStr_19035 == _SafeStr_13247)
            {
                this._SafeStr_12603(_SafeStr_19028, true);
            }
            else
            {
                if (this._SafeStr_19035 == _SafeStr_13245)
                {
                    this._SafeStr_12603(_SafeStr_19029, false);
                }
                else
                {
                    this._SafeStr_12603(_SafeStr_19030, false);
                }
            }
            var tileX= Tile.fromLocationX(this._location.x);
            var tileY= Tile.fromLocationY(this._location.y);
            var _local_5= _local_2.getTileAt(tileX, tileY);
            var collision= this._SafeStr_19041(_local_2, _local_5);
            if (!collision)
            {
                collision = _local_2.hasCollision(this);
                if (collision)
                {
                    SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_MISS);
                }
            }
            if (collision)
            {
                _local_2._SafeStr_18710(this);
            }
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((((("Snowball " + Std.string(_id)) + " tileX:") + Std.string(tileX)) + " tileY:") + Std.string(tileY)) + " collision:") + Std.string(collision))]);
            }
        }

        function _SafeStr_19041(k:SnowWarGameStage, _arg_2:Tile):Bool
        {
            var _local_4:Direction8 = null;
            var _local_3 = false;
            if (_arg_2 != null)
            {
                _local_3 = this._SafeStr_19042(k, _arg_2);
                if (!_local_3)
                {
                    _local_4 = this._direction.direction8Value();
                    _local_3 = this._SafeStr_19042(k, _arg_2.adjacentTile(_local_4));
                    if (!_local_3)
                    {
                        _local_3 = this._SafeStr_19042(k, _arg_2.adjacentTile(_local_4.rotateDirection45Degrees(false)));
                        if (!_local_3)
                        {
                            _local_3 = this._SafeStr_19042(k, _arg_2.adjacentTile(_local_4.rotateDirection45Degrees(true)));
                        }
                    }
                }
            }
            return _local_3;
        }

        function _SafeStr_19042(k:SnowWarGameStage, _arg_2:Tile):Bool
        {
            var _local_3:SnowWarGameObject = null;
            if (_arg_2 != null)
            {
                _local_3 = _arg_2.gameObject;
                if (_local_3 != null)
                {
                    if (HabboGamesCom.logEnabled)
                    {
                        HabboGamesCom.log([((("Snowball " + Std.string(_id)) + " testing collision with ") + Std.string(_local_3._SafeStr_13236))]);
                    }
                    if (_local_3.testSnowBallCollision(this))
                    {
                        _local_3.onSnowBallHit(k, this);
                        return true;
                    }
                }
            }
            return false;
        }

        function _SafeStr_12603(k:Int, _arg_2:Bool)
        {
            var _local_3= (this._location.x + _SafeStr_4667._SafeStr_18698(((this._direction._SafeStr_19045() * this._SafeStr_19036) / 0xFF)));
            var _local_4= (this._location.y + _SafeStr_4667._SafeStr_18698(((this._direction._SafeStr_19046() * this._SafeStr_19036) / 0xFF)));
            var _local_5= (this._ttl - this._paraOffs);
            var _local_6= ((((this._paraOffs * this._paraOffs) - (_local_5 * _local_5)) * k) + _SafeStr_19021);
            if (_arg_2)
            {
                _local_6 = Std.int(Math.min(_local_6, _SafeStr_19021));
            }
            this._location.setLocation(_local_3, _local_4, _local_6);
        }

        override public function onSnowBallHit(k:SnowWarGameStage, _arg_2:_SafeStr_4035)
        {
        }

        public function toString():String
        {
            return (((((((((((" location=(" + Std.string(this._location.x)) + ",") + Std.string(this._location.y)) + ",") + Std.string(this._location.z)) + ")") + " dir=") + this._direction) + " paraOffs=") + Std.string(this._paraOffs)) + " ttl=") + Std.string(this._ttl);
        }

        public var _SafeStr_18040(get,never):HumanGameObject;
public function  get__SafeStr_18040():HumanGameObject
        {
            return this._humanGameObject;
        }
    }

