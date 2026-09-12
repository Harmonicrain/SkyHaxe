package com.sulake.habbo.window.utils.floorplaneditor
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.utils.floorplaneditor.images.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;

     class HeightMapEditor
    {
        public static inline final LEVELS= 30;

        public static var floor_editor_tile_base:Class<Dynamic> = FloorEditorTileBase;
        public static var floor_editor_tile_entry:Class<Dynamic> = FloorEditorTileEntry;
        public static var floor_editor_tile_base_large:Class<Dynamic> = FloorEditorTileBaseLarge;
        public static var floor_editor_tile_entry_large:Class<Dynamic> = FloorEditorTileEntryLarge;

        var _bcFloorPlanEditor:BCFloorPlanEditor;
        var _drawing:Bool = false;
        var _drawingHeight:Int = 0;
        var _tileImageBase:BitmapData;
        var _tileImageEntry:BitmapData;
        var _tileImageBaseLarge:BitmapData;
        var _tileImageEntryLarge:BitmapData;
        var _heigthColorMap:Vector<Array<ASAny>>;
        var _occupiedHeigthColorMap:Vector<Array<ASAny>>;
        var _bitmapElement:IBitmapWrapperWindow;
        var _lastDrawAddress:Point;
        var _floorPlan:FloorPlanCache;
        var _colorPickMode:Bool = false;
        var _zoomLevel:Int = 1;
        var _coloredTiles:ASDictionary<ASAny,ASAny>;
        var _coloredOccupiedTiles:ASDictionary<ASAny,ASAny>;
        var _coloredTilesLarge:ASDictionary<ASAny,ASAny>;
        var _coloredOccupiedTilesLarge:ASDictionary<ASAny,ASAny>;
        var _selectionStartPoint:Point;
        var _isRectSelect:Bool = false;

        public function new(k:BCFloorPlanEditor)
        {
            var index = 0;
            var hue = Math.NaN;
            this._lastDrawAddress = new Point(-1000, -1000);
            this._selectionStartPoint = new Point(-1000, -1000);
            this._bcFloorPlanEditor = k;
            this._bcFloorPlanEditor.heightMapBitmapElement.procedure = this.editorWindowProcedure;
            this._bcFloorPlanEditor.heightMapMouseCapturer.procedure = this.editorWindowProcedure;
            this._floorPlan = k.floorPlanCache;
            this._tileImageBase = cast(Type.createInstance(floor_editor_tile_base, []), Bitmap).bitmapData;
            this._tileImageEntry = cast(Type.createInstance(floor_editor_tile_entry, []), Bitmap).bitmapData;
            this._tileImageBaseLarge = cast(Type.createInstance(floor_editor_tile_base_large, []), Bitmap).bitmapData;
            this._tileImageEntryLarge = cast(Type.createInstance(floor_editor_tile_entry_large, []), Bitmap).bitmapData;
            this._heigthColorMap = new Vector<Array<ASAny>>();
            this._occupiedHeigthColorMap = new Vector<Array<ASAny>>();
            this._coloredOccupiedTiles = new ASDictionary<ASAny,ASAny>();
            this._coloredTiles = new ASDictionary<ASAny,ASAny>();
            this._coloredTilesLarge = new ASDictionary<ASAny,ASAny>();
            this._coloredOccupiedTilesLarge = new ASDictionary<ASAny,ASAny>();
            while (index < LEVELS)
            {
                hue = 0.6 - ((index / LEVELS) * 0.85);
                if (hue < 0)
                {
                    hue = 1 + hue;
                }
                this._heigthColorMap.push(hslToRgb(hue, 1, 0.5));
                this._occupiedHeigthColorMap.push(hslToRgb(hue, 0.33, 0.4));
                index++;
            }
        }

        public static function hslToRgb(h:Float, s:Float, l:Float):Array<ASAny>
        {
var hue2rgb:ASFunction  = null;            var r = Math.NaN;
            var g = Math.NaN;
            var b = Math.NaN;
            var q = Math.NaN;
            var p = Math.NaN;
            if (s == 0)
            {
                r = (g = (b = l));
            }
            else
            {
hue2rgb= function (p:Float, q:Float, t:Float):Float
                {
                    if (t < 0)
                    {
                        t += 1;
                    }
                    if (t > 1)
                    {
                        t -= 1;
                    }
                    if (t < (1 / 6))
                    {
                        return p + (((q - p) * 6) * t);
                    }
                    if (t < (1 / 2))
                    {
                        return q;
                    }
                    if (t < (2 / 3))
                    {
                        return p + (((q - p) * ((2 / 3) - t)) * 6);
                    }
                    return p;
                }
;                q = ((l < 0.5) ? (l * (1 + s)) : ((l + s) - (l * s)));
                p = ((2 * l) - q);
                r = ASCompat.toNumber(hue2rgb(p, q, (h + (1 / 3))));
                g = ASCompat.toNumber(hue2rgb(p, q, h));
                b = ASCompat.toNumber(hue2rgb(p, q, (h - (1 / 3))));
            }
            return [r, g, b];
        }

        public var heigthColorMap(get,never):Vector<Array<ASAny>>;
public function  get_heigthColorMap():Vector<Array<ASAny>>
        {
            return this._heigthColorMap;
        }

        public var _Str_17977(get,never):Vector<Array<ASAny>>;
public function  get__Str_17977():Vector<Array<ASAny>>
        {
            return this._heigthColorMap;
        }

        
        public var drawingHeight(get,set):Int;
public function  set_drawingHeight(k:Int):Int        {
            this._drawingHeight = Std.int(Math.min(LEVELS, Math.max(0, k)));
return k;
        }
public function  get_drawingHeight():Int
        {
            return this._drawingHeight;
        }

        
        public var _Str_9167(get,set):Int;
public function  set__Str_9167(k:Int):Int        {
            return this.drawingHeight = k;
        }
public function  get__Str_9167():Int
        {
            return this._drawingHeight;
        }

        public var drawing(never,set):Bool;
public function  set_drawing(k:Bool):Bool        {
            return this._drawing = k;
        }

        public var _Str_22137(never,set):Bool;
public function  set__Str_22137(k:Bool):Bool        {
            return this._drawing = k;
        }

        public function refreshFromCache()
        {
            this._bitmapElement = this._bcFloorPlanEditor.heightMapBitmapElement;
            this._lastDrawAddress = new Point(-1000, -1000);
            this.updateView();
        }

        public function _Str_9032()
        {
            this.refreshFromCache();
        }

        function editorWindowProcedure(k:WindowEvent, window:IWindow)
        {
            var tile:Point = null;
            var maxX = 0;
            var minX = 0;
            var minY = 0;
            var maxY = 0;
            var canExpandColumns = false;
            var canExpandRows = false;
            var drawX = 0;
            var drawY = 0;
            var delta:ASObject = null;
            var mouseEvent= Std.downcast(k , WindowMouseEvent);
            if (mouseEvent == null)
            {
                return;
            }
            if (this._colorPickMode)
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    tile = this.getTileAddressFromMousePoint(mouseEvent, window);
                    this._drawingHeight = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(Std.int(tile.x), Std.int(tile.y));
                    this._bcFloorPlanEditor.updateColorSliderTrack(this._drawingHeight);
                }
            }
            else if (((((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)) || (k.type == WindowMouseEvent.DOWN)) || (this._drawing && (k.type == WindowMouseEvent.MOVE))))
            {
                tile = this.getTileAddressFromMousePoint(mouseEvent, window);
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._drawing = false;
                    if (this._isRectSelect)
                    {
                        this._isRectSelect = false;
                        this._bcFloorPlanEditor.floorPlanCache.submitTemporaryCache();
                    }
                }
                if (k.type == WindowMouseEvent.DOWN)
                {
                    this._drawing = true;
                    this._lastDrawAddress = new Point(-1000, -1000);
                    if (mouseEvent.shiftKey)
                    {
                        this._isRectSelect = true;
                        this._selectionStartPoint = tile;
                        this._bcFloorPlanEditor.floorPlanCache.initTemporaryCache();
                    }
                    this.applyDraw(Std.int(tile.x), Std.int(tile.y));
                    this.updateView();
                    this._lastDrawAddress = tile;
                }
                if ((this._drawing && (k.type == WindowMouseEvent.MOVE)))
                {
                    if (this._isRectSelect)
                    {
                        minX = Std.int(Math.min(this._selectionStartPoint.x, tile.x));
                        maxX = Std.int(Math.max(this._selectionStartPoint.x, tile.x));
                        minY = Std.int(Math.min(this._selectionStartPoint.y, tile.y));
                        maxY = Std.int(Math.max(this._selectionStartPoint.y, tile.y));
                        canExpandColumns = this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        canExpandRows = this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        if (((!canExpandColumns) && (!canExpandRows)))
                        {
                            return;
                        }
                        while (((maxY >= minY) && (!canExpandRows)))
                        {
                            maxY--;
                            canExpandRows = this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        }
                        while (((maxX >= minX) && (!canExpandColumns)))
                        {
                            maxX--;
                            canExpandColumns = this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        }
                        if (((!canExpandColumns) || (!canExpandRows)))
                        {
                            return;
                        }
                        this._bcFloorPlanEditor.floorPlanCache.clearTemporaryCache();
                        this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        drawX = minX;
                        while (drawX <= maxX)
                        {
                            drawY = minY;
                            while (drawY <= maxY)
                            {
                                this.applyDraw(drawX, drawY);
                                drawY++;
                            }
                            drawX++;
                        }
                        this.updateView();
                    }
                    else
                    {
                        if (((!(this._lastDrawAddress.x == tile.x)) || (!(this._lastDrawAddress.y == tile.y))))
                        {
                            this.applyDraw(Std.int(tile.x), Std.int(tile.y));
                        }
                        delta = this.interpolateBetweenLastPointAndDrawPoint(tile);
                        if (((Math.abs(ASCompat.toNumber(delta.x)) > 0) || (Math.abs(ASCompat.toNumber(delta.y)) > 0)))
                        {
                            this.updateView();
                        }
                    }
                    this._lastDrawAddress = tile;
                }
            }
        }

        function getMousePositionRelativeToBitmap(k:WindowMouseEvent, window:IWindow):Point
        {
            var point= new Point(k.localX, k.localY);
            window.convertPointFromLocalToGlobalSpace(point);
            this._bcFloorPlanEditor.heightMapBitmapElement.convertPointFromGlobalToLocalSpace(point);
            return point;
        }

        function getTileAddressFromMousePoint(k:WindowMouseEvent, window:IWindow):Point
        {
            var point= this.getMousePositionRelativeToBitmap(k, window);
            return this.transformFromScreenSpace(Std.int(point.x), Std.int(point.y));
        }

        function interpolateBetweenLastPointAndDrawPoint(k:Point):ASObject
        {
            var points:Array<ASAny> = null;
            var point:Point = null;
            if (((this._lastDrawAddress.x == -1000) && (this._lastDrawAddress.y == -1000)))
            {
                this._lastDrawAddress.x = k.x;
                this._lastDrawAddress.y = k.y;
            }
            var deltaX= Std.int(k.x - this._lastDrawAddress.x);
            var deltaY= Std.int(k.y - this._lastDrawAddress.y);
            points = interpolationPoints(Std.int(this._lastDrawAddress.x), Std.int(this._lastDrawAddress.y), Std.int(k.x), Std.int(k.y));
            if (checkNullIteratee(points)) for (_tmp_ in points)
            {
point  = _tmp_;
                if ((!((this._lastDrawAddress.x == point.x) && (this._lastDrawAddress.y == point.y))) && (!((k.x == point.x) && (k.y == point.y))))
                {
                    this.applyDraw(Std.int(point.x), Std.int(point.y));
                }
            }
            return ({
                "x":deltaX,
                "y":deltaY
            });
        }

        static function interpolationPoints(x0:Int, y0:Int, x1:Int, y1:Int):Array<ASAny>
        {
            var points:Array<ASAny> = [];
            var dx= Std.int(Math.abs(x1 - x0));
            var dy= Std.int(Math.abs(y1 - y0));
            var sx= x0 < x1 ? 1 : -1;
            var sy= y0 < y1 ? 1 : -1;
            var err= dx - dy;
            var e2 = 0;
            while (true)
            {
                points.push(new Point(x0, y0));
                if (((x0 == x1) && (y0 == y1)))
                {
                    break;
                }
                e2 = 2 * err;
                if (e2 > -dy)
                {
                    err -= dy;
                    x0 += sx;
                }
                if (e2 < dx)
                {
                    err += dx;
                    y0 += sy;
                }
            }
            return points;
        }

        function applyDraw(x:Int, y:Int)
        {
            var height = 0;
            switch (this._bcFloorPlanEditor.drawMode)
            {
                case (_ == this._bcFloorPlanEditor.drawModes[0] => true):
                    this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, this._drawingHeight);
                    
                case (_ == this._bcFloorPlanEditor.drawModes[1] => true):
                    this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, -1);
                    
                case (_ == this._bcFloorPlanEditor.drawModes[2] => true):
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, Std.int(Math.min((LEVELS - 1), (height + 1))));
                    }
                    
                case (_ == this._bcFloorPlanEditor.drawModes[3] => true):
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, Std.int(Math.max(0, (height - 1))));
                    }
                    
                case (_ == this._bcFloorPlanEditor.drawModes[4] => true):
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.entryPoint = new Point(x, y);
                    }
                    

default:
            }
        }

        function updateView()
        {
            var x = 0;
            var y = 0;
            var image:BitmapData = null;
            var point:Point = null;
            var height = 0;
            var item:ASObject = null;
            var tiles:Array<ASAny> = [];
            var minX= ASCompat.MAX_INT;
            var minY= ASCompat.MAX_INT;
            var maxX= ASCompat.MIN_INT;
            var maxY= ASCompat.MIN_INT;
            y = 0;
            while (y < this._floorPlan.floorHeight)
            {
                x = 0;
                while (x < this._floorPlan.floorWidth)
                {
                    point = this.transformToScreenSpace(x, y);
                    minX = Std.int(Math.min(minX, point.x));
                    minY = Std.int(Math.min(minY, point.y));
                    maxX = Std.int(Math.max(maxX, point.x));
                    maxY = Std.int(Math.max(maxY, point.y));
                    if (this._floorPlan.isEntryPoint(x, y))
                    {
                        image = this.getEntryTile();
                        tiles.push({
                            "point":point,
                            "image":image
                        });
                    }
                    else
                    {
                        height = Std.int(Math.min(this._floorPlan.getHeightAt(x, y), (LEVELS - 1)));
                        if (height >= 0)
                        {
                            image = this.getColoredTile(height, this._floorPlan.isTileReserved(x, y));
                            tiles.push({
                                "point":point,
                                "image":image
                            });
                        }
                    }
                    x++;
                }
                y++;
            }
            var bitmap= new BitmapData(((maxX - minX) + 18), ((maxY - minY) + 27), false, 0);
            var offset= new Point(-minX, -minY);
            if (checkNullIteratee(tiles)) for (_tmp_ in tiles)
            {
item  = _tmp_;
                bitmap.copyPixels(item.image, item.image.rect, item.point.add(offset));
            }
            this._bcFloorPlanEditor.heightMapBitmapElement.bitmap = bitmap;
        }

        function getColoredTile(height:Int, occupied:Bool):BitmapData
        {
            var cache= occupied ? ((this._zoomLevel == 1) ? this._coloredOccupiedTiles : this._coloredOccupiedTilesLarge) : ((this._zoomLevel == 1) ? this._coloredTiles : this._coloredTilesLarge);
            if (cache[height] != null)
            {
                return cache[height];
            }
            var color= occupied ? this._occupiedHeigthColorMap[height] : this._heigthColorMap[height];
            var bitmap= ((this._zoomLevel == 1) ? this._tileImageBase : this._tileImageBaseLarge).clone();
            bitmap.colorTransform(bitmap.rect, new ColorTransform(ASCompat.toNumber(color[0]), ASCompat.toNumber(color[1]), ASCompat.toNumber(color[2])));
            cache[height] = bitmap;
            return bitmap;
        }

        function getEntryTile():BitmapData
        {
            return (this._zoomLevel == 1) ? this._tileImageEntry : this._tileImageEntryLarge;
        }

        function transformFromScreenSpace(x:Int, y:Int):Point
        {
            var localX= ((x / 16) / this._zoomLevel);
            var localY= ((y / 8) / this._zoomLevel);
            var height:Float = this._floorPlan.floorHeight;
            var tileX= Std.int(localY + (localX - (height / 2)));
            var tileY= Std.int(localY - (localX - (height / 2)));
            return new Point(tileX, tileY);
        }

        function transformToScreenSpace(x:Int, y:Int):Point
        {
            return new Point(((this._zoomLevel * 8) * (x - y)), ((this._zoomLevel * 4) * (x + y)));
        }

        
        public var colorPickMode(get,set):Bool;
public function  get_colorPickMode():Bool
        {
            return this._colorPickMode;
        }
public function  set_colorPickMode(k:Bool):Bool        {
            return this._colorPickMode = k;
        }

        
        public var _Str_12874(get,set):Bool;
public function  get__Str_12874():Bool
        {
            return this._colorPickMode;
        }
public function  set__Str_12874(k:Bool):Bool        {
            return this._colorPickMode = k;
        }

        
        public var zoomLevel(get,set):Int;
public function  get_zoomLevel():Int
        {
            return this._zoomLevel;
        }
public function  set_zoomLevel(k:Int):Int        {
            if (((k < 1) || (k > 2)))
            {
                return k;
            }
            return this._zoomLevel = k;
        }
    }

