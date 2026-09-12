package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ShapeController;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Rectangle;

     class ShapeSkinRenderer extends SkinRenderer
    {
        static final SHAPE:Shape = new Shape();

        public function new(k:String)
        {
            super(k);
        }

        public static function alphaFromColor(color:UInt):Float
        {
            var alpha= ASCompat.toUInt(((ASCompat.toInt(color )>>> 24) & 0xFF));
            return ((alpha == 0) ? 1 : (alpha / 0xFF));
        }

        static function cornerRadius(radius:Float, width:Float, height:Float):Int
        {
            if ((Math.isNaN(radius) || Math.isNaN(width) || Math.isNaN(height) || (radius <= 0) || (width <= 0) || (height <= 0)))
            {
                return 0;
            }
            return Std.int(Math.min(Math.fround(radius), Math.min(Math.ffloor(width / 2), Math.ffloor(height / 2))));
        }

        static function snap(value:Float):Int
        {
            return (Math.isNaN(value) ? 0 : Std.int(Math.fround(value)));
        }

        static function snappedThickness(value:Float):Int
        {
            return ((Math.isNaN(value) || (value <= 0)) ? 0 : Std.int(Math.max(1, Math.fround(value))));
        }

        static function roundRectContainsPixel(px:Int, py:Int, left:Int, top:Int, right:Int, bottom:Int, radius:Int):Bool
        {
            var nearestX = Math.NaN;
            var nearestY = Math.NaN;
            var dx = Math.NaN;
            var dy = Math.NaN;
            var r:Float = radius;
            var cx= (px + 0.5);
            var cy= (py + 0.5);
            if (((cx < left) || (cy < top) || (cx >= right) || (cy >= bottom)))
            {
                return false;
            }
            if (r <= 0)
            {
                return true;
            }
            nearestX = ((cx < (left + r)) ? (left + r) : ((cx >= (right - r)) ? (right - r) : cx));
            nearestY = ((cy < (top + r)) ? (top + r) : ((cy >= (bottom - r)) ? (bottom - r) : cy));
            dx = (cx - nearestX);
            dy = (cy - nearestY);
            return (((dx * dx) + (dy * dy)) <= (r * r));
        }

        static function argbFromColor(color:UInt):UInt
        {
            var alpha= ASCompat.toUInt(((ASCompat.toInt(color )>>> 24) & 0xFF));
            return ((ASCompat.toInt((alpha == 0) ? 0xFF : ASCompat.toInt(alpha)) << 24) | (ASCompat.toInt(color )& 0xFFFFFF));
        }

        static function blendPixel(target:BitmapData, px:Int, py:Int, color:UInt, coverage:Float)
        {
            if (coverage <= 0)
            {
                return;
            }
            if (coverage > 1)
            {
                coverage = 1;
            }
            var alphaByte= ASCompat.toUInt(((ASCompat.toInt(color )>>> 24) & 0xFF));
            var srcAlpha= ((ASCompat.toNumber((alphaByte == 0) ? 0xFF : alphaByte) / 0xFF) * coverage);
            if (srcAlpha >= 1)
            {
                target.setPixel32(px, py, (ASCompat.toInt(0xFF000000 )| (ASCompat.toInt(color )& 0xFFFFFF)));
                return;
            }
            var dst= target.getPixel32(px, py);
            var dstAlpha= (((ASCompat.toInt(dst )>>> 24) & 0xFF) / 0xFF);
            var outAlpha= (srcAlpha + (dstAlpha * (1 - srcAlpha)));
            if (outAlpha <= 0)
            {
                target.setPixel32(px, py, 0);
                return;
            }
            var srcR:Float = ((ASCompat.toInt(color )>>> 16) & 0xFF);
            var srcG:Float = ((ASCompat.toInt(color )>>> 8) & 0xFF);
            var srcB:Float = (ASCompat.toInt(color )& 0xFF);
            var dstR:Float = ((ASCompat.toInt(dst )>>> 16) & 0xFF);
            var dstG:Float = ((ASCompat.toInt(dst )>>> 8) & 0xFF);
            var dstB:Float = (ASCompat.toInt(dst )& 0xFF);
            var outR:UInt = Std.int(Math.min(0xFF, Math.fround((((srcR * srcAlpha) + ((dstR * dstAlpha) * (1 - srcAlpha))) / outAlpha))));
            var outG:UInt = Std.int(Math.min(0xFF, Math.fround((((srcG * srcAlpha) + ((dstG * dstAlpha) * (1 - srcAlpha))) / outAlpha))));
            var outB:UInt = Std.int(Math.min(0xFF, Math.fround((((srcB * srcAlpha) + ((dstB * dstAlpha) * (1 - srcAlpha))) / outAlpha))));
            var outA:UInt = Std.int(Math.min(0xFF, Math.fround(outAlpha * 0xFF)));
            target.setPixel32(px, py, ((((ASCompat.toInt(outA )<< 24) | (ASCompat.toInt(outR )<< 16)) | (ASCompat.toInt(outG )<< 8)) | ASCompat.toInt(outB)));
        }

        static function fillPixelRect(target:BitmapData, left:Int, top:Int, right:Int, bottom:Int, color:UInt)
        {
            left = Std.int(Math.max(0, left));
            top = Std.int(Math.max(0, top));
            right = Std.int(Math.min(target.width, right));
            bottom = Std.int(Math.min(target.height, bottom));
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            target.fillRect(new Rectangle(left, top, (right - left), (bottom - top)), argbFromColor(color));
        }

        static function drawRectFill(target:BitmapData, x:Float, y:Float, width:Float, height:Float, color:UInt)
        {
            fillPixelRect(target, snap(x), snap(y), snap(x + width), snap(y + height), color);
        }

        static function drawRectStroke(target:BitmapData, x:Float, y:Float, width:Float, height:Float, thickness:Float, color:UInt)
        {
            var px = 0;
            var py = 0;
            var left= snap(x);
            var top= snap(y);
            var right= snap(x + width);
            var bottom= snap(y + height);
            var snapped= snappedThickness(thickness);
            var clipLeft= Std.int(Math.max(0, left));
            var clipTop= Std.int(Math.max(0, top));
            var clipRight= Std.int(Math.min(target.width, right));
            var clipBottom= Std.int(Math.min(target.height, bottom));
            if (((snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (((px < (left + snapped)) || (px >= (right - snapped)) || (py < (top + snapped)) || (py >= (bottom - snapped))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        public static function drawRectStrokeSides(target:BitmapData, x:Float, y:Float, width:Float, height:Float, thickness:Float, color:UInt, top:Bool, right:Bool, bottom:Bool, left:Bool)
        {
            var leftEdge= snap(x);
            var topEdge= snap(y);
            var rightEdge= snap(x + width);
            var bottomEdge= snap(y + height);
            var snapped= snappedThickness(thickness);
            if (((target == null) || (snapped <= 0) || (rightEdge <= leftEdge) || (bottomEdge <= topEdge)))
            {
                return;
            }
            if (top)
            {
                fillPixelRect(target, leftEdge, topEdge, rightEdge, (topEdge + snapped), color);
            }
            if (right)
            {
                fillPixelRect(target, (rightEdge - snapped), topEdge, rightEdge, bottomEdge, color);
            }
            if (bottom)
            {
                fillPixelRect(target, leftEdge, (bottomEdge - snapped), rightEdge, bottomEdge, color);
            }
            if (left)
            {
                fillPixelRect(target, leftEdge, topEdge, (leftEdge + snapped), bottomEdge, color);
            }
        }

        static function drawRoundRectFill(target:BitmapData, x:Float, y:Float, width:Float, height:Float, radius:Float, color:UInt)
        {
            var px = 0;
            var py = 0;
            var left= snap(x);
            var top= snap(y);
            var right= snap(x + width);
            var bottom= snap(y + height);
            var r= cornerRadius(radius, (right - left), (bottom - top));
            var clipLeft= Std.int(Math.max(0, left));
            var clipTop= Std.int(Math.max(0, top));
            var clipRight= Std.int(Math.min(target.width, right));
            var clipBottom= Std.int(Math.min(target.height, bottom));
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (roundRectContainsPixel(px, py, left, top, right, bottom, r))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        public static function drawRoundRectStroke(target:BitmapData, x:Float, y:Float, width:Float, height:Float, radius:Float, thickness:Float, color:UInt)
        {
            var clipLeft = 0;
            var clipTop = 0;
            var clipRight = 0;
            var clipBottom = 0;
            var px = 0;
            var py = 0;
            var left= snap(x);
            var top= snap(y);
            var right= snap(x + width);
            var bottom= snap(y + height);
            var snapped= snappedThickness(thickness);
            var outerRadius= cornerRadius(radius, (right - left), (bottom - top));
            var innerLeft= (left + snapped);
            var innerTop= (top + snapped);
            var innerRight= (right - snapped);
            var innerBottom= (bottom - snapped);
            var innerRadius= cornerRadius(Math.max(0, (radius - snapped)), (innerRight - innerLeft), (innerBottom - innerTop));
            if (((target == null) || (snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            clipLeft = Std.int(Math.max(0, left));
            clipTop = Std.int(Math.max(0, top));
            clipRight = Std.int(Math.min(target.width, right));
            clipBottom = Std.int(Math.min(target.height, bottom));
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if ((roundRectContainsPixel(px, py, left, top, right, bottom, outerRadius) && (!roundRectContainsPixel(px, py, innerLeft, innerTop, innerRight, innerBottom, innerRadius))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        static function rhombusContainsPixel(px:Int, py:Int, left:Int, top:Int, right:Int, bottom:Int):Bool
        {
            var width= (right - left);
            var height= (bottom - top);
            if (((px < left) || (py < top) || (px >= right) || (py >= bottom) || (width <= 0) || (height <= 0)))
            {
                return false;
            }
            var centerX= (width / 2);
            var centerY= (height / 2);
            var halfWidth= (width / 2);
            var halfHeight= (height / 2);
            var localX= ((px - left) + 0.5);
            var localY= ((py - top) + 0.5);
            return (((Math.abs(localX - centerX) / halfWidth) + (Math.abs(localY - centerY) / halfHeight)) <= 1);
        }

        static function drawRhombusFill(target:BitmapData, x:Float, y:Float, width:Float, height:Float, color:UInt)
        {
            var px = 0;
            var py = 0;
            var left= snap(x);
            var top= snap(y);
            var right= snap(x + width);
            var bottom= snap(y + height);
            var clipLeft= Std.int(Math.max(0, left));
            var clipTop= Std.int(Math.max(0, top));
            var clipRight= Std.int(Math.min(target.width, right));
            var clipBottom= Std.int(Math.min(target.height, bottom));
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (rhombusContainsPixel(px, py, left, top, right, bottom))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        static function drawRhombusStroke(target:BitmapData, x:Float, y:Float, width:Float, height:Float, thickness:Float, color:UInt)
        {
            var px = 0;
            var py = 0;
            var left= snap(x);
            var top= snap(y);
            var right= snap(x + width);
            var bottom= snap(y + height);
            var snapped= snappedThickness(thickness);
            var innerLeft= (left + snapped);
            var innerTop= (top + snapped);
            var innerRight= (right - snapped);
            var innerBottom= (bottom - snapped);
            var clipLeft= Std.int(Math.max(0, left));
            var clipTop= Std.int(Math.max(0, top));
            var clipRight= Std.int(Math.min(target.width, right));
            var clipBottom= Std.int(Math.min(target.height, bottom));
            if (((snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if ((rhombusContainsPixel(px, py, left, top, right, bottom) && (!rhombusContainsPixel(px, py, innerLeft, innerTop, innerRight, innerBottom))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        override public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:UInt, _arg_5:Bool)
        {
            var shapeWindow= Std.downcast(k , ShapeController);
            if (((shapeWindow == null) || (_arg_2 == null) || (_arg_3 == null) || (_arg_3.width <= 0) || (_arg_3.height <= 0)))
            {
                return;
            }
            var thickness= snappedThickness(shapeWindow.strokeThickness);
            var strokeColor= ((shapeWindow.strokeHsvShade != 0) ? HsvLayerColor.deriveColor(k.color, shapeWindow.strokeHsvShade) : shapeWindow.strokeColor);
            var gfx= SHAPE.graphics;
            _arg_2.fillRect(_arg_3, 0);
            if (shapeWindow.shape == ShapeController.SHAPE_ROUND_RECTANGLE)
            {
                drawRoundRectFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, shapeWindow.radius, k.color);
                if (thickness > 0)
                {
                    drawRoundRectStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, shapeWindow.radius, thickness, strokeColor);
                }
                return;
            }
            if (shapeWindow.shape == ShapeController.SHAPE_RECTANGLE)
            {
                drawRectFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, k.color);
                if (thickness > 0)
                {
                    drawRectStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, thickness, strokeColor);
                }
                return;
            }
            if (shapeWindow.shape == ShapeController.SHAPE_RHOMBUS)
            {
                drawRhombusFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, k.color);
                if (thickness > 0)
                {
                    drawRhombusStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, thickness, strokeColor);
                }
                return;
            }
            gfx.clear();
            gfx.beginFill((ASCompat.toInt(k.color )& 0xFFFFFF), alphaFromColor(k.color));
            if (thickness > 0)
            {
                gfx.lineStyle(thickness, (ASCompat.toInt(strokeColor )& 0xFFFFFF), alphaFromColor(strokeColor));
            }
            if (shapeWindow.shape == ShapeController.SHAPE_ELLIPSE)
            {
                gfx.drawEllipse((_arg_3.x + (thickness / 2)), (_arg_3.y + (thickness / 2)), Math.max(0, (_arg_3.width - thickness)), Math.max(0, (_arg_3.height - thickness)));
            }
            else
            {
                gfx.drawRect(_arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height);
            }
            gfx.endFill();
            _arg_2.draw(SHAPE, null, null, null, _arg_3);
            gfx.clear();
        }

        override public function isStateDrawable(k:UInt):Bool
        {
            return true;
        }
    }

