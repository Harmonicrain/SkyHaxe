package com.sulake.habbo.avatar.cache
;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.ColorTransform;

     class ImageData 
    {
        var _bitmap:BitmapData;
        var _rect:Rectangle;
        var _regPoint:Point;
        var _flipH:Bool = false;
        var _colorTransform:ColorTransform;

        public function new(k:BitmapData, _arg_2:Rectangle, _arg_3:Point, _arg_4:Bool, _arg_5:ColorTransform)
        {
            this._bitmap = k;
            this._rect = _arg_2;
            this._regPoint = _arg_3;
            this._flipH = _arg_4;
            this._colorTransform = _arg_5;
            if (_arg_4)
            {
                this._regPoint.x = (-this._regPoint.x + _arg_2.width);
            }
        }

        public function dispose()
        {
            this._bitmap = null;
            this._regPoint = null;
            this._colorTransform = null;
        }

        public var bitmap(get,never):BitmapData;
function  get_bitmap():BitmapData
        {
            return this._bitmap;
        }

        public var rect(get,never):Rectangle;
function  get_rect():Rectangle
        {
            return this._rect;
        }

        public var _Str_1076(get,never):Point;
function  get__Str_1076():Point
        {
            return this._regPoint;
        }

        public var flipH(get,never):Bool;
function  get_flipH():Bool
        {
            return this._flipH;
        }

        public var colorTransform(get,never):ColorTransform;
function  get_colorTransform():ColorTransform
        {
            return this._colorTransform;
        }

        public var offsetRect(get,never):Rectangle;
function  get_offsetRect():Rectangle
        {
            var k= new Rectangle(0, 0, this._rect.width, this._rect.height);
            k.offset(-this._regPoint.x, -this._regPoint.y);
            return k;
        }
    }

