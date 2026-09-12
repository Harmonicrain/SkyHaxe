package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.GradientController;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

     class GradientSkinRenderer extends SkinRenderer
    {
        static final SHAPE:Shape = new Shape();
        static final MATRIX:Matrix = new Matrix();

        public function new(k:String)
        {
            super(k);
        }

        public static function angleForDirection(value:String):Float
        {
            switch (GradientController.normalizeDirection(value))
            {
                case GradientController.DIRECTION_RIGHT:
                    return 0;
                case GradientController.DIRECTION_DOWN:
                    return Math.PI / 2;
                case GradientController.DIRECTION_LEFT:
                    return Math.PI;
                case GradientController.DIRECTION_UP:
                    return -Math.PI / 2;
                case GradientController.DIRECTION_DOWN_RIGHT:
                    return Math.PI / 4;
                case GradientController.DIRECTION_DOWN_LEFT:
                    return 3 * Math.PI / 4;
                case GradientController.DIRECTION_UP_LEFT:
                    return -3 * Math.PI / 4;
                case GradientController.DIRECTION_UP_RIGHT:
                    return -Math.PI / 4;
                default:
                    return Math.PI / 2;
            }
        }

        public static function rgbFromColor(color:UInt):UInt
        {
            return ASCompat.toInt(color )& 0xFFFFFF;
        }

        public static function alphaFromColor(color:UInt):Float
        {
            var alpha= ASCompat.toUInt((ASCompat.toInt(color )>>> 24) & 0xFF);
            return alpha == 0 ? 1 : alpha / 0xFF;
        }

        public static function drawGradient(target:BitmapData, rect:Rectangle, color1:UInt, color2:UInt, mode:String, direction:String)
        {
            var gradientMode= GradientController.normalizeMode(mode) == GradientController.MODE_RADIAL ? GradientController.MODE_RADIAL : GradientController.MODE_LINEAR;
            var angle= gradientMode == GradientController.MODE_LINEAR ? angleForDirection(direction) : 0;
            var graphics= SHAPE.graphics;
            MATRIX.createGradientBox(rect.width, rect.height, angle, rect.x, rect.y);
            graphics.clear();
            graphics.beginGradientFill(gradientMode, [rgbFromColor(color1), rgbFromColor(color2)], [alphaFromColor(color1), alphaFromColor(color2)], [0, 255], MATRIX, "pad", "rgb");
            graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
            graphics.endFill();
            target.fillRect(rect, 0);
            target.draw(SHAPE, null, null, null, rect);
            graphics.clear();
        }

        override public function draw(k:IWindow, target:BitmapData, rect:Rectangle, state:UInt, draw:Bool)
        {
            var gradient= Std.downcast(k , GradientController);
            if (gradient == null || target == null || rect == null || rect.width <= 0 || rect.height <= 0)
            {
                return;
            }
            drawGradient(target, rect, gradient.color1, gradient.color2, gradient.mode, gradient.direction);
        }

        override public function isStateDrawable(k:UInt):Bool
        {
            return true;
        }
    }

