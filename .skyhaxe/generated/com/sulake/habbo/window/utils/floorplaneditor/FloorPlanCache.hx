package com.sulake.habbo.window.utils.floorplaneditor
;
    import com.sulake.habbo.communication.messages.incoming.room.engine.FloorHeightMapEvent;
    import com.sulake.habbo.communication.messages.incoming.room.layout.RoomOccupiedTilesMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.layout.RoomOccupiedTilesMessageParser;
    import flash.geom.Point;

     class FloorPlanCache
    {
        static inline final MAX_AXIS_LENGTH:UInt = 100;

        var _bcFloorPlanEditor:BCFloorPlanEditor;
        var _floorWidth:Int = 0;
        var _floorHeight:Int = 0;
        var _floorPlanCache:Array<ASAny>;
        var _floorPlanCacheBuffer:Array<ASAny> = null;
        var _reservedTiles:Array<ASAny>;
        var _entryPoint:Point;
        var _entryPointDir:UInt = 0;
        var _showedPopup:Bool = false;

        public function new(k:BCFloorPlanEditor)
        {
            this._bcFloorPlanEditor = k;
        }

        public function onFloorHeightMap(k:FloorHeightMapEvent)
        {
            this.updateFloorPlanCache(k.getParser().text);
            this._showedPopup = false;
        }

        public function onOccupiedTiles(k:RoomOccupiedTilesMessageEvent)
        {
            var parser:RoomOccupiedTilesMessageParser = null;
            var tile:ASObject = null;
            if (this._floorPlanCache != null)
            {
                parser = k.getParser();
                this.resetReservedTiles();
                final _iter_ = parser.occupiedTiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
tile  = _tmp_;
                    this._reservedTiles[ASCompat.toInt(tile.y)][tile.x] = true;
                }
            }
        }

        function resetReservedTiles()
        {
            var x = 0;
            this._reservedTiles = [];
            var y = 0;
            while (y < this.floorHeight)
            {
                this._reservedTiles.push(([] : Array<Dynamic>));
                x = 0;
                while (x < this.floorWidth)
                {
                    this._reservedTiles[y].push(false);
                    x++;
                }
                y++;
            }
        }

        function updateFloorPlanCache(k:String="")
        {
            var row:String = null;
            var rows:Array<ASAny> = (cast k.split("\r"));
            this._floorPlanCache = [];
            if (checkNullIteratee(rows)) for (_tmp_ in rows)
            {
row  = _tmp_;
                if (row.length > 0)
                {
                    this._floorPlanCache.push(row);
                }
            }
            this.checkDimensions();
        }

        function checkDimensions():Bool
        {
            var row:String = null;
            this._floorWidth = -1;
            this._floorHeight = -1;
            if (this._floorPlanCache.length == 0)
            {
                return false;
            }
            var width= ASCompat.toString(this._floorPlanCache[0]).length;
            var height = 0;
            final _iter_ = this._floorPlanCache; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
row  = _tmp_;
                if (row.length == 0)
                {
                    break;
                }
                height++;
            }
            this._floorWidth = width;
            this._floorHeight = height;
            return true;
        }

        function allowDrawAt(x:Int, y:Int):Bool
        {
            if (((this._floorPlanCache == null) || (!this.checkSizeLimits(y + 1, x + 1))))
            {
                return false;
            }
            if (((x == 0) || (y == 0)))
            {
                return this.isDoorTileAllowedAt(x, y);
            }
            return true;
        }

        function isDoorTileAllowedAt(x:Int, y:Int):Bool
        {
            return this.isFirstColumnZeroOrHasDoorAt(x, y) && this.isFirstRowZeroOrHasDoorAt(x, y);
        }

        function isFirstColumnZeroOrHasDoorAt(x:Int, y:Int):Bool
        {
            var i = 0;
            while (i < this._floorHeight)
            {
                if (((!(i == y)) && (!(this._floorPlanCache[i].substr(0, 1) == "x"))))
                {
                    return false;
                }
                i++;
            }
            return true;
        }

        function isFirstRowZeroOrHasDoorAt(x:Int, y:Int):Bool
        {
            var i = 0;
            while (i < this._floorWidth)
            {
                if (((!(i == x)) && (!(this._floorPlanCache[0].substr(i, 1) == "x"))))
                {
                    return false;
                }
                i++;
            }
            return true;
        }

        public function setHeightAt(x:Int, y:Int, height:Int):Bool
        {
            if (((x < 0) || (y < 0)))
            {
                return false;
            }
            if (!this.allowDrawAt(x, y))
            {
                return false;
            }
            while (x >= this._floorWidth)
            {
                if (!this.addColumn())
                {
                    return false;
                }
            }
            while (y >= this._floorHeight)
            {
                if (!this.addRow())
                {
                    return false;
                }
            }
            if (this.isTileReserved(x, y))
            {
                return false;
            }
            this._floorPlanCache[y] = this.setCharAt(ASCompat.toString(this._floorPlanCache[y]), ((height < 0) ? "x" : ASCompat.toRadix(height, 33)), x);
            return true;
        }

        public function _Str_13296(x:Int, y:Int, height:Int):Bool
        {
            return this.setHeightAt(x, y, height);
        }

        public function getHeightAt(x:Int, y:Int):Int
        {
            if ((((((this._floorPlanCache == null) || (x < 0)) || (x >= this._floorWidth)) || (y < 0)) || (y >= this._floorHeight)))
            {
                return -1;
            }
            var value= ASCompat.toString(this._floorPlanCache[y]).charAt(x);
            return (value == "x") ? -1 : ASCompat.parseInt(value, 33);
        }

        public function _Str_4203(x:Int, y:Int):Int
        {
            return this.getHeightAt(x, y);
        }

        function setCharAt(k:String, value:String, index:Int):String
        {
            return (k.substr(0, index) + value) + k.substr((index + 1));
        }

        public var floorWidth(get,never):Int;
public function  get_floorWidth():Int
        {
            return this._floorWidth;
        }

        public var _Str_17437(get,never):Int;
public function  get__Str_17437():Int
        {
            return this._floorWidth;
        }

        public var floorHeight(get,never):Int;
public function  get_floorHeight():Int
        {
            return this._floorHeight;
        }

        public function getData():String
        {
            var data= "";
            var i = 0;
            while (i < this._floorPlanCache.length)
            {
                data = ((data + this._floorPlanCache[i]) + "\r");
                i++;
            }
            return data;
        }

        public function _Str_21406():String
        {
            return this.getData();
        }

        public function isTileReserved(x:Int, y:Int):Bool
        {
            if (this._reservedTiles == null)
            {
                return false;
            }
            if (this._reservedTiles.length < (y + 1))
            {
                return false;
            }
            if (this._reservedTiles[y].length < (x + 1))
            {
                return false;
            }
            return this._reservedTiles[y][x];
        }

        public function _Str_19261(x:Int, y:Int):Bool
        {
            return this.isTileReserved(x, y);
        }

        public function isEntryPoint(x:Int, y:Int):Bool
        {
            if (this._entryPoint == null)
            {
                return false;
            }
            return (this._entryPoint.x == x) && (this._entryPoint.y == y);
        }

        public function _Str_21855(x:Int, y:Int):Bool
        {
            return this.isEntryPoint(x, y);
        }

        
        public var entryPoint(get,set):Point;
public function  get_entryPoint():Point
        {
            return this._entryPoint;
        }
public function  set_entryPoint(k:Point):Point        {
            return this._entryPoint = k;
        }

        
        public var _Str_7642(get,set):Point;
public function  get__Str_7642():Point
        {
            return this._entryPoint;
        }
public function  set__Str_7642(k:Point):Point        {
            return this._entryPoint = k;
        }

        
        public var entryPointDir(get,set):Int;
public function  get_entryPointDir():Int
        {
            return ASCompat.toInt(this._entryPointDir);
        }
public function  set_entryPointDir(k:Int):Int        {
            if (k < 0)
            {
                k = 7;
            }
            if (k > 7)
            {
                k = 0;
            }
            this._entryPointDir = k;
return k;
        }

        
        public var _Str_6184(get,set):Int;
public function  get__Str_6184():Int
        {
            return ASCompat.toInt(this._entryPointDir);
        }
public function  set__Str_6184(k:Int):Int        {
            return this.entryPointDir = k;
        }

        function addColumn(silent:Bool=false):Bool
        {
            var y = 0;
            if (!this.checkSizeLimits((this._floorWidth + 1), this._floorHeight))
            {
                if (((!this._showedPopup) && (!silent)))
                {
                    this._bcFloorPlanEditor.windowManager.simpleAlert("${floor.plan.editor.alert}", null, "${floor.plan.editor.size.limit.exceeded}");
                    this._bcFloorPlanEditor.heightMapEditor.drawing = false;
                    this._showedPopup = true;
                }
                return false;
            }
            y = 0;
            while (y < this._floorHeight)
            {
                if (ASCompat.toString(this._floorPlanCache[y]).length > 0)
                {
                    this._floorPlanCache[y] = (this._floorPlanCache[y] + "x");
                    this._reservedTiles[y].push(false);
                }
                y++;
            }
            this._floorWidth++;
            return true;
        }

        function addRow(silent:Bool=false):Bool
        {
            var x = 0;
            if (!this.checkSizeLimits(this._floorWidth, (this._floorHeight + 1)))
            {
                if (((!this._showedPopup) && (!silent)))
                {
                    this._bcFloorPlanEditor.windowManager.simpleAlert("${floor.plan.editor.alert}", null, "${floor.plan.editor.size.limit.exceeded}");
                    this._bcFloorPlanEditor.heightMapEditor.drawing = false;
                    this._showedPopup = true;
                }
                return false;
            }
            var row= "";
            x = 0;
            while (x < this._floorWidth)
            {
                row = row + "x";
                x++;
            }
            this._floorPlanCache.push(row);
            var reserved:Array<ASAny> = [];
            x = 0;
            while (x < this._floorWidth)
            {
                reserved.push(false);
                x++;
            }
            this._reservedTiles.push(reserved);
            this._floorHeight++;
            return true;
        }

        public function attemptExpandColumns(x:Int):Bool
        {
            while (x >= this.floorWidth)
            {
                if (!this.addColumn(true))
                {
                    return false;
                }
            }
            return true;
        }

        public function attemptExpandRows(y:Int):Bool
        {
            while (y >= this.floorHeight)
            {
                if (!this.addRow(true))
                {
                    return false;
                }
            }
            return true;
        }

        function checkSizeLimits(width:UInt, height:UInt):Bool
        {
            return !((width > FloorPlanCache.MAX_AXIS_LENGTH) || (height > FloorPlanCache.MAX_AXIS_LENGTH));
        }

        public function initTemporaryCache()
        {
            this._floorPlanCacheBuffer = this._floorPlanCache;
            this.clearTemporaryCache();
        }

        public function clearTemporaryCache()
        {
            var i = 0;
            if (this._floorPlanCacheBuffer != null)
            {
                this._floorPlanCache = [];
                i = 0;
                while (i < this._floorPlanCacheBuffer.length)
                {
                    this._floorPlanCache.push(this._floorPlanCacheBuffer[i]);
                    i++;
                }
                this.checkDimensions();
            }
        }

        public function submitTemporaryCache()
        {
            this._floorPlanCacheBuffer = null;
        }
    }

