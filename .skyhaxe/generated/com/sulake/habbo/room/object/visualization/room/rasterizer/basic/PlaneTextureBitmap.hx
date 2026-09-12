package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import flash.display.BitmapData;

     class PlaneTextureBitmap 
    {
        public static inline final MIN_NORMAL_COORDINATE_VALUE:Float = -1;
        public static inline final MAX_NORMAL_COORDINATE_VALUE:Float = 1;

        var _bitmap:BitmapData = null;
        var _normalMinX:Float = -1;
        var _normalMaxX:Float = 1;
        var _normalMinY:Float = -1;
        var _normalMaxY:Float = 1;
        var _assetName:String = null;

        public function new(k:BitmapData, _arg_2:Float=-1, _arg_3:Float=1, _arg_4:Float=-1, _arg_5:Float=1, _arg_6:String=null)
        {
            this._normalMinX = _arg_2;
            this._normalMaxX = _arg_3;
            this._normalMinY = _arg_4;
            this._normalMaxY = _arg_5;
            this._assetName = _arg_6;
            this._bitmap = k;
        }

        public var bitmap(get,never):BitmapData;
public function  get_bitmap():BitmapData
        {
            return this._bitmap;
        }

        public var normalMinX(get,never):Float;
public function  get_normalMinX():Float
        {
            return this._normalMinX;
        }

        public var normalMaxX(get,never):Float;
public function  get_normalMaxX():Float
        {
            return this._normalMaxX;
        }

        public var normalMinY(get,never):Float;
public function  get_normalMinY():Float
        {
            return this._normalMinY;
        }

        public var normalMaxY(get,never):Float;
public function  get_normalMaxY():Float
        {
            return this._normalMaxY;
        }

        public var assetName(get,never):String;
public function  get_assetName():String
        {
            return this._assetName;
        }

        public function dispose()
        {
            this._bitmap = null;
        }
    }

