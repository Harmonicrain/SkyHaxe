package com.sulake.habbo.window.utils
;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.IAssetLibrary;

     class LimitedItemOverlayNumberBitmapGenerator 
    {
        static inline final UNIQUE_ITEM_NUMBER_GLYPH_= "unique_item_number_glyph_";


        public static function _Str_14181(k:IAssetLibrary, _arg_2:Int, _arg_3:Int, _arg_4:Int):BitmapData
        {
            var _local_12:BitmapDataAsset = null;
            var _local_14 = 0;
            var _local_5= new BitmapData(_arg_3, _arg_4, true, 0);
            var _local_6= (_arg_2 % 10);
            var _local_7= Std.int((_arg_2 / 10) % 10);
            var _local_8= Std.int((_arg_2 / 100) % 10);
            var _local_9= Std.int((_arg_2 / 1000) % 10);
            var _local_10= new Array<ASAny>();
            var _local_11 = 0;
            if (_local_9 > 0)
            {
                _local_12 = cast(k.getAssetByName((UNIQUE_ITEM_NUMBER_GLYPH_ + Std.string(_local_9))), BitmapDataAsset);
                _local_10.push(_local_12);
                _local_11 = Std.int(_local_11 + _local_12.rectangle.width);
            }
            if (((_local_9 > 0) || (_local_8 > 0)))
            {
                _local_12 = cast(k.getAssetByName((UNIQUE_ITEM_NUMBER_GLYPH_ + Std.string(_local_8))), BitmapDataAsset);
                _local_10.push(_local_12);
                _local_11 = Std.int(_local_11 + _local_12.rectangle.width);
            }
            if ((((_local_9 > 0) || (_local_8 > 0)) || (_local_7 > 0)))
            {
                _local_12 = cast(k.getAssetByName((UNIQUE_ITEM_NUMBER_GLYPH_ + Std.string(_local_7))), BitmapDataAsset);
                _local_10.push(_local_12);
                _local_11 = Std.int(_local_11 + _local_12.rectangle.width);
            }
            _local_12 = cast(k.getAssetByName((UNIQUE_ITEM_NUMBER_GLYPH_ + Std.string(_local_6))), BitmapDataAsset);
            _local_10.push(_local_12);
            _local_11 = Std.int(_local_11 + _local_12.rectangle.width);
            _local_11--;
            var _local_13= new Point(((_arg_3 - _local_11) / 2), 0);
            while (_local_14 < _local_10.length)
            {
                _local_12 = _local_10[_local_14];
                _local_5.copyPixels(cast(_local_12.content, BitmapData), _local_12.rectangle, _local_13);
                _local_13.x = (_local_13.x + _local_12.rectangle.width);
                _local_14++;
            }
            return _local_5;
        }

	public function new() {}
    }

