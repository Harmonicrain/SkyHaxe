package com.sulake.habbo.window.utils.floorplaneditor
;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import com.sulake.habbo.window.utils.floorplaneditor.images.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class FloorPlanPreviewer
    {
        public static var tile_preview_0:Class<Dynamic> = FloorPlanPreviewer_tile_preview_0;
        public static var tile_preview_1:Class<Dynamic> = FloorPlanPreviewer_tile_preview_1;
        public static var tile_preview_2:Class<Dynamic> = FloorPlanPreviewer_tile_preview_2;
        public static var tile_preview_3:Class<Dynamic> = FloorPlanPreviewer_tile_preview_3;
        public static var tile_preview_4:Class<Dynamic> = FloorPlanPreviewer_tile_preview_4;
        public static var tile_preview_5:Class<Dynamic> = FloorPlanPreviewer_tile_preview_5;
        public static var tile_preview_6:Class<Dynamic> = FloorPlanPreviewer_tile_preview_6;
        public static var tile_preview_7:Class<Dynamic> = FloorPlanPreviewer_tile_preview_7;
        public static var tile_preview_8:Class<Dynamic> = FloorPlanPreviewer_tile_preview_8;
        public static var tile_preview_9:Class<Dynamic> = FloorPlanPreviewer_tile_preview_9;
        public static var tile_preview_a:Class<Dynamic> = FloorPlanPreviewer_tile_preview_a;
        public static var tile_preview_b:Class<Dynamic> = FloorPlanPreviewer_tile_preview_b;
        public static var tile_preview_c:Class<Dynamic> = FloorPlanPreviewer_tile_preview_c;
        public static var tile_preview_d:Class<Dynamic> = FloorPlanPreviewer_tile_preview_d;
        public static var tile_preview_e:Class<Dynamic> = FloorPlanPreviewer_tile_preview_e;
        public static var tile_preview_f:Class<Dynamic> = FloorPlanPreviewer_tile_preview_f;
        public static var tile_preview_entry:Class<Dynamic> = FloorPlanPreviewer_tile_preview_entry;

        var _bcFloorPlanEditor:BCFloorPlanEditor;
        var _tileImages:Vector<BitmapData>;
        var _floorPlan:FloorPlanCache;

        public function new(k:BCFloorPlanEditor)
        {
            this._bcFloorPlanEditor = k;
            this._floorPlan = k.floorPlanCache;
            this._tileImages = new Vector<BitmapData>(0);
            this._tileImages.push(cast(Type.createInstance(tile_preview_0, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_1, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_2, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_3, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_4, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_5, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_6, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_7, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_8, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_9, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_a, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_b, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_c, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_d, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_e, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_f, []), Bitmap).bitmapData);
            this._tileImages.push(cast(Type.createInstance(tile_preview_entry, []), Bitmap).bitmapData);
        }

        static function getCanvasPoint(x:Int, y:Int, z:Int):Point
        {
            return new Point((8 * (x - y)), ((4 * (x + y)) - (8 * z)));
        }

        public function updatePreview()
        {
            var x = 0;
            var y = 0;
            var tile:ASObject = null;
            var height = 0;
            var point:Point = null;
            var topLeft = 0;
            var top = 0;
            var topRight = 0;
            var left = 0;
            var right = 0;
            var bottomLeft = 0;
            var bottom = 0;
            var bottomRight = 0;
            var nextHeight = 0;
            var type = 0;
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
                    height = this._floorPlan.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        point = getCanvasPoint(x, y, height);
                        minX = Std.int(Math.min(minX, point.x));
                        minY = Std.int(Math.min(minY, point.y));
                        maxX = Std.int(Math.max(maxX, point.x));
                        maxY = Std.int(Math.max(maxY, point.y));
                        topLeft = this._floorPlan.getHeightAt((x - 1), (y - 1));
                        top = this._floorPlan.getHeightAt(x, (y - 1));
                        topRight = this._floorPlan.getHeightAt((x + 1), (y - 1));
                        left = this._floorPlan.getHeightAt((x - 1), y);
                        right = this._floorPlan.getHeightAt((x + 1), y);
                        bottomLeft = this._floorPlan.getHeightAt((x - 1), (y + 1));
                        bottom = this._floorPlan.getHeightAt(x, (y + 1));
                        bottomRight = this._floorPlan.getHeightAt((x + 1), (y + 1));
                        nextHeight = height + 1;
                        type = (((((((topLeft == nextHeight) || (top == nextHeight)) || (left == nextHeight)) ? 1 : 0) | ((((topRight == nextHeight) || (top == nextHeight)) || (right == nextHeight)) ? 2 : 0)) | ((((bottomLeft == nextHeight) || (bottom == nextHeight)) || (left == nextHeight)) ? 4 : 0)) | ((((bottomRight == nextHeight) || (bottom == nextHeight)) || (right == nextHeight)) ? 8 : 0));
                        if (type == 15)
                        {
                            type = 0;
                        }
                        if (this._floorPlan.isEntryPoint(x, y))
                        {
                            type = this._tileImages.length - 1;
                        }
                        tiles.push({
                            "point":point,
                            "type":type
                        });
                    }
                    x++;
                }
                y++;
            }
            var width= Std.int(Math.min(((maxX - minX) + 18), TrackedBitmapData.MIN_HEIGHT));
            var heightPixels= Std.int(Math.min(((maxY - minY) + 18), TrackedBitmapData.MIN_HEIGHT));
            var bitmap= new BitmapData(width, heightPixels, false, 0xFFFFFFFF);
            var offset= new Point(-minX, -minY);
            if (checkNullIteratee(tiles)) for (_tmp_ in tiles)
            {
tile  = _tmp_;
                bitmap.copyPixels(this._tileImages[ASCompat.toInt(tile.type)], this._tileImages[ASCompat.toInt(tile.type)].rect, tile.point.add(offset));
            }
            this._bcFloorPlanEditor.updatePreviewBitmap(bitmap);
        }
    }

