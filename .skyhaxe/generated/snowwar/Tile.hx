package snowwar
;
	import snowwar._str_231._SafeStr_4028;
	import snowwar._str_254.Direction8;
	import snowwar._str_254._SafeStr_4022;
	import snowwar._str_254._SafeStr_4023;
	import snowwar._str_254.Location;
	import snowwar._str_254._SafeStr_4667;
	import snowwar._str_39.HumanGameObject;
	import snowwar._str_39.SnowWarGameObject;
	import snowwar._str_496.SnowWarFurnitureObject;

     class Tile extends _SafeStr_4023 
    {
        public static inline final COST= 3200; //_SafeStr_13239
        public static final STEP_COST:Int = _SafeStr_4667._SafeStr_18698((COST / 2)); //_SafeStr_18674
        public static final STEP_DIAG_COST:Int = (COST + STEP_COST); //_SafeStr_18675
        public static final PARA_COST:Int = Std.int(Math.sqrt(((Tile.COST * Tile.COST) + (Tile.COST * Tile.COST)))); //_SafeStr_18676

        var _location:Location;
        var _adjacentTiles:Array<ASAny>;
        var _gameObject:SnowWarGameObject;
        var _tileData:Array<ASAny>;
        var _fuseObjects:Array<ASAny>;
        var _blocked:Bool = false;
        var _height:Int = 0;

        public function new(x:Int, y:Int)
        {
            super();
            this._adjacentTiles = [];
            this._tileData = [x, y, 0];
            this._location = new Location((x * COST), (y * COST), 0);
            this._fuseObjects = [];
        }

        public static function fromLocationX(x:Int):Int
        {
            return _SafeStr_4667._SafeStr_18698(((x + Tile.STEP_COST) / Tile.COST));
        }

        public static function fromLocationY(y:Int):Int
        {
            return _SafeStr_4667._SafeStr_18698(((y + Tile.STEP_COST) / Tile.COST));
        }

        public static function toLocationX(x:Int):Int
        {
            return x * Tile.COST;
        }

        public static function toLocationY(y:Int):Int
        {
            return y * Tile.COST;
        }

        override public function dispose()
        {
            super.dispose();
            if (this._location != null)
            {
                this._location.dispose();
                this._location = null;
            }
            this._adjacentTiles = [];
            this._gameObject = null;
            this._tileData = [];
            this._fuseObjects = [];
            this._blocked = false;
        }

        public var fuseObjects(get,never):Array<ASAny>;
public function  get_fuseObjects():Array<ASAny>
        {
            return this._fuseObjects;
        }

        public function addObject(object:SnowWarFurnitureObject)
        {
            this.fuseObjects.push(object);
            this.addHeight(object.height);
        }

        public function addHeight(k:Int)
        {
            this._height = (this._height + k);
            if (this._height < 0)
            {
                this._height = 0;
            }
        }

        public var _SafeStr_18688(get,never):Array<ASAny>;
public function  get__SafeStr_18688():Array<ASAny>
        {
            return this._tileData;
        }

        public var location(get,never):Location;
public function  get_location():Location
        {
            return this._location;
        }

        public function _SafeStr_18689(k:Location):Bool
        {
            var _local_2= (this._location.x - k.x);
            if (_local_2 < 0)
            {
                _local_2 = -_local_2;
            }
            var _local_3= (this._location.y - k.y);
            if (_local_3 < 0)
            {
                _local_3 = -_local_3;
            }
            return (_local_2 < STEP_COST) && (_local_3 < STEP_COST);
        }

        public function linkAdjacentTile(tile:Tile, direction:Direction8)
        {
            this.registerAdjacentTile(tile, direction);
            tile.registerAdjacentTile(this, direction.rotateDirection180Degrees());
        }

        function registerAdjacentTile(tile:Tile, direction:Direction8)
        {
            this._adjacentTiles[direction.index()] = tile;
        }

        public function adjacentTile(direction:Direction8):Tile
        {
            return this._adjacentTiles[direction.index()];
        }

        public function walkable(ignoreObject:_SafeStr_4028):Bool
        {
            var isSelf = false;
            if (ignoreObject != null)
            {
                isSelf = (((!(this.humanGameObject == null)) && ignoreObject._SafeStr_18700) && (this.humanGameObject._SafeStr_13241 == ignoreObject._SafeStr_13236));
            }
            var objectBlocked = false;
            if (this.fuseObjects.length == 1)
            {
                objectBlocked = (!ASCompat.dynamicAs(this.fuseObjects[0] , SnowWarFurnitureObject).walkable);
            }
            else
            {
                if (this.fuseObjects.length > 1)
                {
                    objectBlocked = true;
                }
            }
            return ((!objectBlocked) && ((this._gameObject == null) || isSelf)) && (!this._blocked);
        }

        public function addActiveGameObject(gameObject:SnowWarGameObject):Bool
        {
            var added = false;
            if (this._gameObject == null)
            {
                this._gameObject = gameObject;
                added = true;
            }
            return added;
        }

        public function removeGameObject():SnowWarGameObject
        {
            var object:SnowWarGameObject = null;
            if (this._gameObject != null)
            {
                object = this._gameObject;
                this._gameObject = null;
            }
            return object;
        }

        public var gameObject(get,never):SnowWarGameObject;
public function  get_gameObject():SnowWarGameObject //_SafeStr_18696
        {
            return this._gameObject;
        }

        public var humanGameObject(get,never):HumanGameObject;
public function  get_humanGameObject():HumanGameObject //humanGameObject
        {
            if (((this._gameObject != null) && Std.is(this._gameObject , HumanGameObject)))
            {
                return Std.downcast(this.gameObject , HumanGameObject);
            }
            return null;
        }

        public function removeHumanGameObject():HumanGameObject //_SafeStr_18697
        {
            var humanObject= this.humanGameObject;
            if (humanObject != null)
            {
                this._gameObject = null;
            }
            return humanObject;
        }

        override public function distanceTo(k:_SafeStr_4022):Int
        {
            var tile= Std.downcast(k , Tile);
            return this._location.distanceTo(tile.location);
        }

        override public function directionTo(k:_SafeStr_4022):Direction8
        {
            var _local_2= Std.downcast(k , Tile);
            return this._location.directionTo(_local_2.location);
        }

        override public function getNodeAt(direction:Direction8):_SafeStr_4022
        {
            return this._adjacentTiles[direction.index()];
        }

        override public function directionIsBlocked(direction:Direction8, _arg_2:_SafeStr_4028):Bool
        {
            return this.walkable(_arg_2);
        }

        override public function getPathCost(direction:Direction8, _arg_2:_SafeStr_4028):Int
        {
            if (direction._SafeStr_18701())
            {
                return COST;
            }
            return PARA_COST;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public function toString():String
        {
            return ((((" X:" + Std.string(this._location.x)) + " Y:") + Std.string(this._location.y)) + " Z:") + Std.string(this._location.z);
        }

        public var blocked(never,set):Bool;
public function  set_blocked(k:Bool):Bool        {
            return this._blocked = k;
        }
    }

