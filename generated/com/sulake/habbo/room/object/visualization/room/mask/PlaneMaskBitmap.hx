package com.sulake.habbo.room.object.visualization.room.mask
;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;

     class PlaneMaskBitmap 
    {
        public static inline final MIN_NORMAL_COORDINATE_VALUE:Float = -1;
        public static inline final MAX_NORMAL_COORDINATE_VALUE:Float = 1;

        var _asset:IGraphicAsset = null;
        var _normalMinX:Float = -1;
        var _normalMaxX:Float = 1;
        var _normalMinY:Float = -1;
        var _normalMaxY:Float = 1;

        public function new(k:IGraphicAsset, _arg_2:Float=-1, _arg_3:Float=1, _arg_4:Float=-1, _arg_5:Float=1)
        {
            this._normalMinX = _arg_2;
            this._normalMaxX = _arg_3;
            this._normalMinY = _arg_4;
            this._normalMaxY = _arg_5;
            this._asset = k;
        }

        public var asset(get,never):IGraphicAsset;
function  get_asset():IGraphicAsset
        {
            return this._asset;
        }

        public var normalMinX(get,never):Float;
function  get_normalMinX():Float
        {
            return this._normalMinX;
        }

        public var normalMaxX(get,never):Float;
function  get_normalMaxX():Float
        {
            return this._normalMaxX;
        }

        public var normalMinY(get,never):Float;
function  get_normalMinY():Float
        {
            return this._normalMinY;
        }

        public var normalMaxY(get,never):Float;
function  get_normalMaxY():Float
        {
            return this._normalMaxY;
        }

        public function dispose()
        {
            this._asset = null;
        }
    }

