package com.sulake.habbo.freeflowchat.viewer.visualization
;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class ManualNineSliceSprite extends Sprite
    {
        static final ZERO_POINT:Point = new Point();

        var _bitmap:Bitmap;
        var _patches:Vector<BitmapData>;
        var _leftWidth:Int = 0;
        var _centerWidth:Int = 0;
        var _rightWidth:Int = 0;
        var _topHeight:Int = 0;
        var _middleHeight:Int = 0;
        var _bottomHeight:Int = 0;
        var _width:Int = 0;
        var _height:Int = 0;

        public function new(scale9Grid:Rectangle, source:BitmapData)
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            _leftWidth = Std.int(scale9Grid.x);
            _centerWidth = Std.int(scale9Grid.width);
            _rightWidth = source.width - Std.int(scale9Grid.right);
            _topHeight = Std.int(scale9Grid.y);
            _middleHeight = Std.int(scale9Grid.height);
            _bottomHeight = source.height - Std.int(scale9Grid.bottom);
            _width = source.width;
            _height = source.height;
            _patches = createPatches(source);
            _bitmap = new Bitmap(null, "always", false);
            addChild(_bitmap);
            redraw();
        }

        override public function  get_width():Float
        {
            return _width;
        }

        override public function  set_width(value:Float):Float        {
            var nextWidth= Std.int(Math.max(_leftWidth + _rightWidth, Math.fround(value)));
            if (_width == nextWidth)
            {
                return value;
            }
            _width = nextWidth;
            redraw();
return value;
        }

        override public function  get_height():Float
        {
            return _height;
        }

        override public function  set_height(value:Float):Float        {
            var nextHeight= Std.int(Math.max(_topHeight + _bottomHeight, Math.fround(value)));
            if (_height == nextHeight)
            {
                return value;
            }
            _height = nextHeight;
            redraw();
return value;
        }

        function createPatches(source:BitmapData):Vector<BitmapData>
        {
            var patches= new Vector<BitmapData>(9, true);
            patches[0] = extractPatch(source, 0, 0, _leftWidth, _topHeight);
            patches[1] = extractPatch(source, _leftWidth, 0, _centerWidth, _topHeight);
            patches[2] = extractPatch(source, _leftWidth + _centerWidth, 0, _rightWidth, _topHeight);
            patches[3] = extractPatch(source, 0, _topHeight, _leftWidth, _middleHeight);
            patches[4] = extractPatch(source, _leftWidth, _topHeight, _centerWidth, _middleHeight);
            patches[5] = extractPatch(source, _leftWidth + _centerWidth, _topHeight, _rightWidth, _middleHeight);
            patches[6] = extractPatch(source, 0, _topHeight + _middleHeight, _leftWidth, _bottomHeight);
            patches[7] = extractPatch(source, _leftWidth, _topHeight + _middleHeight, _centerWidth, _bottomHeight);
            patches[8] = extractPatch(source, _leftWidth + _centerWidth, _topHeight + _middleHeight, _rightWidth, _bottomHeight);
            return patches;
        }

        function extractPatch(source:BitmapData, x:Int, y:Int, width:Int, height:Int):BitmapData
        {
            if (width <= 0 || height <= 0)
            {
                return null;
            }
            var patch= new BitmapData(width, height, true, 0);
            patch.copyPixels(source, new Rectangle(x, y, width, height), ZERO_POINT);
            return patch;
        }

        function redraw()
        {
            var bitmapWidth= Std.int(Math.max(_leftWidth + _rightWidth, _width));
            var bitmapHeight= Std.int(Math.max(_topHeight + _bottomHeight, _height));
            var centerWidth= bitmapWidth - _leftWidth - _rightWidth;
            var middleHeight= bitmapHeight - _topHeight - _bottomHeight;
            var bitmapData= new BitmapData(bitmapWidth, bitmapHeight, true, 0);
            drawPatch(bitmapData, _patches[0], 0, 0, _leftWidth, _topHeight);
            drawPatch(bitmapData, _patches[1], _leftWidth, 0, centerWidth, _topHeight);
            drawPatch(bitmapData, _patches[2], _leftWidth + centerWidth, 0, _rightWidth, _topHeight);
            drawPatch(bitmapData, _patches[3], 0, _topHeight, _leftWidth, middleHeight);
            drawPatch(bitmapData, _patches[4], _leftWidth, _topHeight, centerWidth, middleHeight);
            drawPatch(bitmapData, _patches[5], _leftWidth + centerWidth, _topHeight, _rightWidth, middleHeight);
            drawPatch(bitmapData, _patches[6], 0, _topHeight + middleHeight, _leftWidth, _bottomHeight);
            drawPatch(bitmapData, _patches[7], _leftWidth, _topHeight + middleHeight, centerWidth, _bottomHeight);
            drawPatch(bitmapData, _patches[8], _leftWidth + centerWidth, _topHeight + middleHeight, _rightWidth, _bottomHeight);
            if (_bitmap.bitmapData != null)
            {
                _bitmap.bitmapData.dispose();
            }
            _bitmap.bitmapData = bitmapData;
        }

        function drawPatch(target:BitmapData, patch:BitmapData, x:Int, y:Int, width:Int, height:Int)
        {
            if (patch == null || width <= 0 || height <= 0)
            {
                return;
            }
            if (patch.width == width && patch.height == height)
            {
                target.copyPixels(patch, patch.rect, new Point(x, y));
                return;
            }
            var matrix= new Matrix();
            matrix.scale(width / patch.width, height / patch.height);
            matrix.translate(x, y);
            target.draw(patch, matrix, null, null, new Rectangle(x, y, width, height), false);
        }
    }

