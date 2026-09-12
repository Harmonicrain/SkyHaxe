package snowwar
;
	import com.sulake.core.utils.Map;
    import snowwar._str_231.SynchronizedGameStage;
    import snowwar._str_254.Direction360;
    import snowwar._str_254.Direction8;
    import snowwar._str_231.SynchronizedGameArena;
    import snowwar._str_496.SnowWarGameStageMessageParser;
    import snowwar._str_496.SnowWarFurnitureObject;
    import snowwar._str_39.SnowWarGameObject;
    import snowwar._str_254._SafeStr_4030;

     class SnowWarGameStage extends SynchronizedGameStage 
    {
        public static inline final _SafeStr_18856= 25;
        public static inline final _SafeStr_18857= 25;
        static inline final TILE_STATE_VOID= 100000;

        var _tileMap:Array<ASAny>;

        public function new()
        {
            this._tileMap = [];
            super();
        }

        public static function _SafeStr_18859(k:Tile):Direction8
        {
            return Direction360.direction360ValueToDirection8(Direction360._SafeStr_18792(ASCompat.toInt(_SafeStr_18856 - ASCompat.toNumber(k._SafeStr_18688[0])), ASCompat.toInt(_SafeStr_18857 - ASCompat.toNumber(k._SafeStr_18688[1]))));
        }

        override public function dispose()
        {
            var x = 0;
            var y = 0;
            var tile:Tile = null;
            super.dispose();
            if (((this._tileMap != null) && (this._tileMap.length > 0)))
            {
                x = 0;
                while (x < this._tileMap.length)
                {
                    y = 0;
                    while (y < ((ASCompat.dynamicAs(this._tileMap[0] , Array) : Array<ASAny>)).length)
                    {
                        tile = this._tileMap[x][y];
                        if (tile != null)
                        {
                            tile.dispose();
                        }
                        y++;
                    }
                    x++;
                }
            }
            this._tileMap = [];
        }

        override public function initialize(gameArena:SynchronizedGameArena, gameStageMessageParser:SnowWarGameStageMessageParser)
        {
            super.initialize(gameArena, gameStageMessageParser);
            if (_gameObjects == null)
            {
                _gameObjects = new Map();
            }
            this.initializeTileMap(gameStageMessageParser);
            this.initializeFuseObjects(gameStageMessageParser.fuseObjects);
        }

        function initializeFuseObjects(k:Array<ASAny>)
        {
            var object:SnowWarFurnitureObject = null;
            var tile:Tile = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
object  = _tmp_;
                tile = this.getTileAt(object.x, object.y);
                if (tile != null)
                {
                    tile.addObject(object);
                    this.updateTiles(object);
                }
            }
        }

        function updateTiles(object:SnowWarFurnitureObject)
        {
            var tile:Tile = null;
            var index = 0;
            var oldWidth = 0;
            var direction= object.direction;
            var width= object.width;
            var length= object.length;
			
            if (((direction == Direction8.E.index()) || (direction == Direction8.W.index())))
            {
                oldWidth = width;
                width = length;
                length = oldWidth;
            }
			
            index = 1;
            while (index < width)
            {
                tile = this.getTileAt((object.x + index), object.y);
                if (tile != null)
                {
                    tile.addHeight(object.height);
                    if (!object.walkable)
                    {
                        tile.blocked = true;
                    }
                }
                index++;
            }
            index = 1;
            while (index < length)
            {
                tile = this.getTileAt(object.x, (object.y + index));
                if (tile != null)
                {
                    tile.addHeight(object.height);
                    if (!object.walkable)
                    {
                        tile.blocked = true;
                    }
                }
                index++;
            }
        }

        public function addSnowWarGameObject(object:SnowWarGameObject)
        {
            var tile= this.getTileAt(Tile.fromLocationX(object.location3D.x), Tile.fromLocationY(object.location3D.y));
            if (tile != null)
            {
                tile.addActiveGameObject(object);
            }
        }

        function initializeTileMap(gameStageMessageParser:SnowWarGameStageMessageParser)
        {
            var tile:Tile = null;
            var y = 0;
            var tileNE:Tile = null;
            var tileN:Tile = null;
            var tileNW:Tile = null;
            var tileW:Tile = null;
            var parsedHeightMap= this.parseHeightMap(gameStageMessageParser.model, gameStageMessageParser.width, gameStageMessageParser.height);
            this._tileMap = [];
            var x = 0;
            while (x < gameStageMessageParser.height)
            {
                this._tileMap[x] = ([] : Array<Dynamic>);
                y = 0;
                while (y < gameStageMessageParser.width)
                {
                    this._tileMap[x][y] = null;
                    if (parsedHeightMap[x][y] == TILE_STATE_VOID)
                    {
                    }
                    else
                    {
                        tile = new Tile(y, x);
                        this._tileMap[x][y] = tile;
						
                        tileNE = this.getTileAt((y + 1), (x - 1));
                        if (tileNE != null)
                        {
                            tile.linkAdjacentTile(tileNE, Direction8.NE);
                        }
						
                        tileN = this.getTileAt(y, (x - 1));
                        if (tileN != null)
                        {
                            tile.linkAdjacentTile(tileN, Direction8.N);
                        }
						
                        tileNW = this.getTileAt((y - 1), (x - 1));
                        if (tileNW != null)
                        {
                            tile.linkAdjacentTile(tileNW, Direction8.NW);
                        }
						
                        tileW = this.getTileAt((y - 1), x);
                        if (tileW != null)
                        {
                            tile.linkAdjacentTile(tileW, Direction8.W);
                        }
                    }
                    y++;
                }
                x++;
            }
        }

        public function tileMap():Array<ASAny>
        {
            return this._tileMap;
        }

        public function hasCollision(object:_SafeStr_4030):Bool
        {
            if (object.location3D.z < 1)
            {
                return true;
            }
            var x= Tile.fromLocationX(object.location3D.x);
            var y= Tile.fromLocationY(object.location3D.y);
            var tile= this.getTileAt(x, y);
            if (tile != null)
            {
                return object.location3D.z < tile.height;
            }
            return false;
        }

        public function _SafeStr_18866(x:Int, y:Int):Bool
        {
            var newX= Tile.fromLocationX(x);
            var newY= Tile.fromLocationY(y);
            var tile= this.getTileAt(newX, newY);
            if (tile != null)
            {
                return tile.walkable(null);
            }
            return false;
        }

        public function getTileAt(x:Int, y:Int):Tile
        {
            if (((((x < 0) || (x >= this._tileMap[0].length)) || (y < 0)) || (y >= this._tileMap.length)))
            {
                return null;
            }
            return this._tileMap[y][x];
        }

        function parseHeightMap(modelData:String, width:Int, height:Int):Array<ASAny>
        {
            var row:String = null;
            var y = 0;
            var tileCharacter:String = null;
            var tileValue = 0;
            var highestTile = 0;
            var modelRows:Array<ASAny> = (cast modelData.split("\r"));
            var heightmap= new Array<ASAny>();
            var x = 0;
            while (x < modelRows.length)
            {
                row = modelRows[x];
                heightmap[x] = ([] : Array<Dynamic>);
                y = (row.length - 1);
                while (y >= 0)
                {
                    tileCharacter = row.charAt(y);
                    tileValue = ASCompat.parseInt(tileCharacter);
                    if (!Math.isNaN(ASCompat.parseInt(tileCharacter)))
                    {
                        heightmap[x][y] = tileValue;
                    }
                    else
                    {
                        if (tileCharacter == "x")
                        {
                            heightmap[x][y] = TILE_STATE_VOID;
                        }
                        else
                        {
                            heightmap[x][y] = (10 + (tileCharacter.charCodeAt(0) - "a".charCodeAt(0)));
                        }
                    }
					
					//Probably obselete.
                    if (((heightmap[x][y] > highestTile) && (!(heightmap[x][y] == TILE_STATE_VOID))))
                    {
                        highestTile = ASCompat.toInt(heightmap[x][y]);
                    }
					
                    y--;
                }
                x++;
            }
            return heightmap;
        }

        public function removeGameObjects()
        {
            var x = 0;
            var y = 0;
            var tile:Tile = null;
            if (((this._tileMap != null) && (this._tileMap.length > 0)))
            {
                x = 0;
                while (x < this._tileMap.length)
                {
                    y = 0;
                    while (y < ((ASCompat.dynamicAs(this._tileMap[0] , Array) : Array<ASAny>)).length)
                    {
                        tile = this._tileMap[x][y];
                        if (tile != null)
                        {
                            tile.removeGameObject();
                        }
                        y++;
                    }
                    x++;
                }
            }
        }
    }

