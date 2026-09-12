package snowwar._str_39
;
    import snowwar._str_231.ISnowWarGameObject;
    import snowwar._str_254._SafeStr_4030;
    import snowwar._str_231.SynchronizedGameStage;
    import snowwar._str_254.Location;
    import snowwar._str_254.Direction360;
    import snowwar._str_254.CollisionDetection;
    import snowwar.SnowWarGameStage;

     class SnowWarGameObject implements ISnowWarGameObject implements  _SafeStr_4030 
    {
        var _active:Bool = false;
        var _id:Int = -1;
        var _SafeStr_18805:Bool = false;
        var _disposed:Bool = false;

        public function new(k:Int, _arg_2:Bool)
        {
            this._id = (_arg_2 ? -k : k);
            this._SafeStr_18805 = _arg_2;
        }

        public function dispose()
        {
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var isActive(get,set):Bool;
public function  get_isActive():Bool
        {
            return this._active;
        }
public function  set_isActive(k:Bool):Bool        {
            return this._active = k;
        }

        public var numberOfVariables(get,never):Int;
public function  get_numberOfVariables():Int
        {
            return -1;
        }

        public function getVariable(k:Int):Int
        {
            return -1;
        }

        
        public var _SafeStr_13236(get,set):Int;
public function  get__SafeStr_13236():Int
        {
            return this._id;
        }
public function  set__SafeStr_13236(k:Int):Int        {
            return this._id = k;
        }

        public function subturn(k:SynchronizedGameStage)
        {
        }

        public var boundingType(get,never):Int;
public function  get_boundingType():Int
        {
            return 0;
        }

        public var boundingData(get,never):Array<ASAny>;
public function  get_boundingData():Array<ASAny>
        {
            return null;
        }

        public var location3D(get,never):Location;
public function  get_location3D():Location
        {
            return null;
        }

        public var direction360(get,never):Direction360;
public function  get_direction360():Direction360
        {
            return null;
        }

        public var _SafeStr_18700(get,never):Bool;
public function  get__SafeStr_18700():Bool
        {
            return this._SafeStr_18805;
        }

        public var _SafeStr_13241(get,never):Int;
public function  get__SafeStr_13241():Int
        {
            return -(this._id + 1);
        }

        public function onRemove()
        {
        }

        public var collisionHeight(get,never):Int;
public function  get_collisionHeight():Int
        {
            return ASCompat.toInt(this.boundingData[0]);
        }

        public function testSnowBallCollision(k:_SafeStr_4035):Bool
        {
            return (k.location3D.z < this.collisionHeight) && CollisionDetection._SafeStr_18806(this, k);
        }

        public function onSnowBallHit(k:SnowWarGameStage, _arg_2:_SafeStr_4035)
        {
        }
    }

