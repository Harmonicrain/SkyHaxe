package com.sulake.room.object.visualization.utils
;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.display.BitmapDataChannel;

     class GraphicAssetPalette 
    {
        static var _Str_4808:Array<ASAny> = [];

        var _palette:Array<ASAny>;
        var _primaryColor:Int = 0;
        var _secondaryColor:Int = 0;

        public function new(k:com.sulake.core.utils.ByteArray, _arg_2:Int, _arg_3:Int)
        {
            var _local_4:UInt = 0;
            var _local_5:UInt = 0;
            var _local_6:UInt = 0;
            var _local_7:UInt = 0;
            this._palette = [];
            k.position = 0;
            while (k.bytesAvailable >= 3)
            {
                _local_4 = k.readUnsignedByte();
                _local_5 = k.readUnsignedByte();
                _local_6 = k.readUnsignedByte();
                _local_7 = ((((0xFF << 24) | (ASCompat.toInt(_local_4 )<< 16)) | (ASCompat.toInt(_local_5 )<< 8)) | ASCompat.toInt(_local_6));
                this._palette.push(_local_7);
            }
            while (this._palette.length < 0x0100)
            {
                this._palette.push(0);
            }
            while (_Str_4808.length < 0x0100)
            {
                _Str_4808.push(0);
            }
            this._primaryColor = _arg_2;
            this._secondaryColor = _arg_3;
        }

        public var _Str_5845(get,never):Int;
public function  get__Str_5845():Int
        {
            return this._primaryColor;
        }

        public var _Str_6659(get,never):Int;
public function  get__Str_6659():Int
        {
            return this._secondaryColor;
        }

        public function dispose()
        {
            this._palette = [];
        }

        public function colorizeBitmap(k:BitmapData)
        {
            var _local_2= k.clone();
            k.paletteMap(k, k.rect, new Point(0, 0), (cast _Str_4808), (cast this._palette), (cast _Str_4808), (cast _Str_4808));
            k.copyChannel(_local_2, k.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            _local_2.dispose();
        }
    }

