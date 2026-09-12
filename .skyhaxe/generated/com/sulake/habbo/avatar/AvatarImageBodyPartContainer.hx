package com.sulake.habbo.avatar
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class AvatarImageBodyPartContainer 
    {
        var _image:BitmapData;
        var _regPoint:Point;
        var _offset:Point;
        var _isCacheable:Bool = false;

        public function new(k:BitmapData, _arg_2:Point, _arg_3:Bool)
        {
            this._offset = new Point(0, 0);
            this._image = k;
            this._regPoint = _arg_2;
            this._isCacheable = _arg_3;
            this.cleanPoints();
        }

        public var isCacheable(get,never):Bool;
public function  get_isCacheable():Bool
        {
            return this._isCacheable;
        }

        public function dispose()
        {
            if (this._image != null)
            {
                this._image.dispose();
            }
            this._image = null;
            this._regPoint = null;
            this._offset = null;
        }

        
        public var image(get,set):BitmapData;
public function  set_image(k:BitmapData):BitmapData        {
            if (((this._image != null) && (!(this._image == k))))
            {
                this._image.dispose();
            }
            return this._image = k;
        }
public function  get_image():BitmapData
        {
            return this._image;
        }

        public function _Str_1387(k:Point)
        {
            this._regPoint = k;
            this.cleanPoints();
        }

        public var _Str_1076(get,never):Point;
public function  get__Str_1076():Point
        {
            return this._regPoint.add(this._offset);
        }

        public var offset(never,set):Point;
public function  set_offset(k:Point):Point        {
            this._offset = k;
            this.cleanPoints();
return k;
        }

        function cleanPoints()
        {
            this._regPoint.x = Std.int(this._regPoint.x);
            this._regPoint.y = Std.int(this._regPoint.y);
            this._offset.x = Std.int(this._offset.x);
            this._offset.y = Std.int(this._offset.y);
        }
    }

