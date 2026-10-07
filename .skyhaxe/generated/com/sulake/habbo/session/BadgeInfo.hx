package com.sulake.habbo.session
;
    import flash.display.BitmapData;

     class BadgeInfo 
    {
        var _image:BitmapData;
        var _placeHolder:Bool = false;

        public function new(k:BitmapData, _arg_2:Bool)
        {
            this._image = k;
            this._placeHolder = _arg_2;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }

        public var placeHolder(get,never):Bool;
public function  get_placeHolder():Bool
        {
            return this._placeHolder;
        }
    }

