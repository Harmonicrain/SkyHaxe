package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.NeighborhoodFloor;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.BitmapViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class FloorDrawingPreset extends WiredUIPreset
    {
        static final FLOOR_EDITOR_BORDER_NAMES:Array<ASAny> = [
            "floor_editor_border_N", "floor_editor_border_NE",
            "floor_editor_border_E", "floor_editor_border_SE",
            "floor_editor_border_S", "floor_editor_border_SW",
            "floor_editor_border_W", "floor_editor_border_NW"
        ];
        static final TAKEN_TILE_RGB:Array<ASAny> = [0, 0.4, 0.8];
        static final UNTAKEN_TILE_RGB:Array<ASAny> = [0.2, 0.2, 0.2];
        static final DRAW_MODES:Array<ASAny> = ["add_tile", "remove_tile", "set_root_tile"];

        var _bitmapPreset:BitmapViewPreset;
        var _onRootTileChanged:ASFunction;
        var _floorEditorBorders:Array<ASAny>;
        var _tileImageBase:BitmapData;
        var _tileImageEntry:BitmapData;
        var _tileTaken:BitmapData;
        var _tileUntaken:BitmapData;
        var _drawing:Bool = false;
        var _lastDrawAddress:Point = new Point(-1000, -1000);
        var _selectionStartPoint:Point = new Point(-1000, -1000);
        var _isRectSelect:Bool = false;
        var _drawMode:String = DRAW_MODES[0];
        var _rootTile:Point = new Point(0, 0);
        var _floor:NeighborhoodFloor;

        public function new(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, onRootTileChanged:ASFunction)
        {
var borderName:String  = null;            super(roomEvents, presets, style);
            this._onRootTileChanged = onRootTileChanged;
            this._floorEditorBorders = [];
            final _iter_ = FLOOR_EDITOR_BORDER_NAMES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
borderName = _tmp_;
                this._floorEditorBorders.push(this.getBitmapAsset(borderName));
            }
            this._tileImageBase = this.getBitmapAsset("floor_editor_tile_base");
            this._tileImageEntry = this.getBitmapAsset("floor_editor_tile_entry");
            this._bitmapPreset = presets.createBitmapViewPreset();
            this._bitmapPreset.bitmapWindow.procedure = this.editorWindowProcedure;
            this._tileTaken = this._tileImageBase.clone();
            this._tileTaken.colorTransform(this._tileImageBase.rect, new ColorTransform(ASCompat.toNumber(TAKEN_TILE_RGB[0]), ASCompat.toNumber(TAKEN_TILE_RGB[1]), ASCompat.toNumber(TAKEN_TILE_RGB[2])));
            this._tileUntaken = this._tileImageBase.clone();
            this._tileUntaken.colorTransform(this._tileImageBase.rect, new ColorTransform(ASCompat.toNumber(UNTAKEN_TILE_RGB[0]), ASCompat.toNumber(UNTAKEN_TILE_RGB[1]), ASCompat.toNumber(UNTAKEN_TILE_RGB[2])));
        }

        function getBitmapAsset(name:String):BitmapData
        {
            var asset= Std.downcast(this._roomEvents.assets.getAssetByName(name)
, BitmapDataAsset);
            if (asset == null || asset.content == null)
            {
                throw new ASError("Missing Wired floor editor asset: " + name);
            }
            return ASCompat.dynamicAs(asset.content , BitmapData);
        }

        static function transformFromScreenSpace(x:Int, y:Int):Point
        {
            var halfX= x / 16;
            var halfY= y / 8;
            return new Point(Std.int(halfY + halfX - 1), Std.int(halfY - halfX - 1));
        }

        static function transformToScreenSpace(x:Int, y:Int):Point
        {
            return new Point(8 * (x - y + 1), 4 * (x + y + 1));
        }

        static function interpolationPoints(x0:Int, y0:Int, x1:Int, y1:Int):Array<ASAny>
        {
var doubledError = 0;            var points:Array<ASAny> = [];
            var dx= Std.int(Math.abs(x1 - x0));
            var dy= Std.int(Math.abs(y1 - y0));
            var sx= x0 < x1 ? 1 : -1;
            var sy= y0 < y1 ? 1 : -1;
            var error= dx - dy;
            while (true)
            {
                points.push(new Point(x0, y0));
                if (x0 == x1 && y0 == y1) break;
doubledError= 2 * error;
                if (doubledError > -dy) { error -= dy; x0 += sx; }
                if (doubledError < dx) { error += dx; y0 += sy; }
            }
            return points;
        }

        public function setFloor(floor:NeighborhoodFloor) { this._floor = floor; this.updateView(); }
        public function setRootTile(x:Int, y:Int) { this._rootTile.x = x; this._rootTile.y = y; this.updateView(); }
        public function setMode(mode:String) { this._drawMode = mode; }

        function editorWindowProcedure(event:WindowEvent, window:IWindow)
        {
var minX = 0, maxX = 0, minY = 0, maxY = 0, x = 0, y = 0, delta:ASObject  = null;            if (this.bitmapWindow == null || this._floor == null) return;
            if (event.type != WindowMouseEvent.UP && event.type != WindowMouseEvent.UP_OUTSIDE
                    && event.type != WindowMouseEvent.DOWN && !(this._drawing && event.type == WindowMouseEvent.MOVE)) return;

            var mouseEvent= Std.downcast(event , WindowMouseEvent);
            var centerX= Std.int(this.bitmapWindow.width / 2);
            var bitmapHeight= this.bitmapWindow.bitmap != null ? this.bitmapWindow.bitmap.height : 0;
            var topY= Std.int(this.bitmapWindow.height / 2 - bitmapHeight / 2);
            var address= transformFromScreenSpace(Std.int(mouseEvent.localX - centerX), Std.int(mouseEvent.localY - topY));
            var changed= false;

            if (event.type == WindowMouseEvent.UP || event.type == WindowMouseEvent.UP_OUTSIDE)
            {
                this._drawing = false;
                if (this._isRectSelect)
                {
                    this._isRectSelect = false;
                    this._floor.submitTemporaryCache();
                }
            }

            if (event.type == WindowMouseEvent.DOWN)
            {
                this._drawing = true;
                this._lastDrawAddress = new Point(-1000, -1000);
                if (mouseEvent.shiftKey)
                {
                    this._isRectSelect = true;
                    this._selectionStartPoint = address;
                    this._floor.initTemporaryCache();
                }
                this.applyDraw(Std.int(address.x), Std.int(address.y));
                changed = true;
                this.updateView();
                this._lastDrawAddress = address;
            }

            if (this._drawing && event.type == WindowMouseEvent.MOVE)
            {
                if (this._isRectSelect && this._drawMode != DRAW_MODES[2])
                {
minX= Std.int(Math.min(this._selectionStartPoint.x, address.x));
maxX= Std.int(Math.max(this._selectionStartPoint.x, address.x));
minY= Std.int(Math.min(this._selectionStartPoint.y, address.y));
maxY= Std.int(Math.max(this._selectionStartPoint.y, address.y));
                    this._floor.clearTemporaryCache();
                    for (_tmp_ in minX...maxX + 1)
                    {
x= _tmp_;
                        for (_tmp_ in minY...maxY + 1)
                        {
y= _tmp_;
                            this.applyDraw(x, y);
                            changed = true;
                        }
                    }
                    this.updateView();
                }
                else
                {
                    if (this._lastDrawAddress.x != address.x || this._lastDrawAddress.y != address.y)
                    {
                        this.applyDraw(Std.int(address.x), Std.int(address.y));
                        changed = true;
                    }
delta= this.interpolateBetweenLastPointAndDrawPoint(address);
                    if (Math.abs(ASCompat.toNumber(delta.x)) > 0 || Math.abs(ASCompat.toNumber(delta.y)) > 0) this.updateView();
                }
                this._lastDrawAddress = address;
            }

            if (changed) this._floor.occupationHasChanged();
        }

        function interpolateBetweenLastPointAndDrawPoint(address:Point):ASObject
        {
var point:Point  = null;            if (this._lastDrawAddress.x == -1000 && this._lastDrawAddress.y == -1000)
            {
                this._lastDrawAddress.x = address.x;
                this._lastDrawAddress.y = address.y;
            }
            var deltaX= Std.int(address.x - this._lastDrawAddress.x);
            var deltaY= Std.int(address.y - this._lastDrawAddress.y);
            final _iter_ = interpolationPoints(Std.int(this._lastDrawAddress.x), Std.int(this._lastDrawAddress.y), Std.int(address.x), Std.int(address.y)); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
point = _tmp_;
                if (!((this._lastDrawAddress.x == point.x && this._lastDrawAddress.y == point.y)
                        || (address.x == point.x && address.y == point.y))) this.applyDraw(Std.int(point.x), Std.int(point.y));
            }
            return {x:deltaX, y:deltaY};
        }

        function applyDraw(x:Int, y:Int):Bool
        {
            if (!this.allowDraw(x, y)) return false;
            var offset= NeighborhoodFloor.RADIUS - this._floor.visualizingRadius;
            switch (this._drawMode)
            {
                case (_ == DRAW_MODES[0] => true):
                    this._floor.setOccupied(x + offset, y + offset, true);
                    
                case (_ == DRAW_MODES[1] => true):
                    this._floor.setOccupied(x + offset, y + offset, false);
                    
                case (_ == DRAW_MODES[2] => true):
                    this.setRootTileInternal(x - this._floor.visualizingRadius, y - this._floor.visualizingRadius);
                    if (this._onRootTileChanged != null) this._onRootTileChanged(this._rootTile.x, this._rootTile.y);
                    

default:
            }
            return true;
        }

        function setRootTileInternal(x:Int, y:Int) { this._rootTile.x = x; this._rootTile.y = y; }
        function allowDraw(x:Int, y:Int):Bool { return x >= 0 && y >= 0 && x < this._floor.visualizingDimension && y < this._floor.visualizingDimension; }

        function updateView()
        {
var             y = 0,                 x = 0, layer:ASObject  = null, point:Point  = null, rectangle:Rectangle  = null;            if (this.bitmapWindow == null || this._floor == null) return;
            var layers:Array<ASAny> = [];
            var offset= NeighborhoodFloor.RADIUS - this._floor.visualizingRadius;
            var x = 0;
            var y = 0;
            y= 0;while (y < this._floor.visualizingDimension)
            {
                x= 0;while (x < this._floor.visualizingDimension)
                {
                    layers.push({point:transformToScreenSpace(x, y), image:this._floor.isOccupied(x + offset, y + offset) ? this._tileTaken : this._tileUntaken});
x++;
                }
y++;
            }

            if (this._rootTile.x >= -this._floor.visualizingRadius && this._rootTile.x <= this._floor.visualizingRadius
                    && this._rootTile.y >= -this._floor.visualizingRadius && this._rootTile.y <= this._floor.visualizingRadius)
            {
                layers.push({point:transformToScreenSpace(Std.int(this._rootTile.x + this._floor.visualizingRadius), Std.int(this._rootTile.y + this._floor.visualizingRadius)), image:this._tileImageEntry});
            }

            x= 0;while (x < this._floor.visualizingDimension)
            {
                layers.push({point:transformToScreenSpace(x, -1), image:this._floorEditorBorders[0]});
                layers.push({point:transformToScreenSpace(x, this._floor.visualizingDimension), image:this._floorEditorBorders[4]});
x++;
            }
            y= 0;while (y < this._floor.visualizingDimension)
            {
                layers.push({point:transformToScreenSpace(-1, y), image:this._floorEditorBorders[6]});
                layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, y), image:this._floorEditorBorders[2]});
y++;
            }
            layers.push({point:transformToScreenSpace(-1, -1), image:this._floorEditorBorders[7]});
            layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, -1), image:this._floorEditorBorders[1]});
            layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, this._floor.visualizingDimension), image:this._floorEditorBorders[3]});
            layers.push({point:transformToScreenSpace(-1, this._floor.visualizingDimension), image:this._floorEditorBorders[5]});

            var minX= ASCompat.MAX_INT;
            var minY= ASCompat.MAX_INT;
            var maxX= ASCompat.MIN_INT;
            var maxY= ASCompat.MIN_INT;
            if (checkNullIteratee(layers)) for (_tmp_ in layers)
            {
layer = _tmp_;
point= ASCompat.dynamicAs(layer.point , Point);
rectangle= layer.image.rect;
                minX = Std.int(Math.min(minX, point.x));
                minY = Std.int(Math.min(minY, point.y));
                maxX = Std.int(Math.max(maxX, point.x + rectangle.width));
                maxY = Std.int(Math.max(maxY, point.y + rectangle.height));
            }

            var bitmap= new BitmapData(maxX - minX, maxY - minY, false, _style.advancedBackgroundColor);
            var translation= new Point(-minX, -minY);
            if (checkNullIteratee(layers)) for (_tmp_ in layers)
            {
layer  = _tmp_;
                bitmap.copyPixels(layer.image, layer.image.rect, layer.point.add(translation));
            }
            this.bitmapWindow.bitmap = bitmap;
            this._bitmapPreset.setBitmapSize(bitmap.width, bitmap.height);
            resize();
        }

        var bitmapWindow(get,never):IBitmapWrapperWindow;
function  get_bitmapWindow():IBitmapWrapperWindow { return this._bitmapPreset != null ? this._bitmapPreset.bitmapWindow : null; }
        override public function  get_window():IWindow { return this._bitmapPreset.window; }
        override public function resizeToWidth(width:Int) { super.resizeToWidth(width); this._bitmapPreset.resizeToWidth(width); }
        override public function hasStaticWidth():Bool { return this._bitmapPreset.hasStaticWidth(); }
        override public function  get_staticWidth():Int { return this._bitmapPreset.staticWidth; }
        override function  get_childPresets():Array<ASAny> { return [this._bitmapPreset]; }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._bitmapPreset = null;
            this._onRootTileChanged = null;
            this._floor = null;
        }
    }

