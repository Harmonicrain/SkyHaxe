package onBoardingHcUi
;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.utils._Str_988;
    import onBoardingHcUi.images.*;
@:build(skyhaxe.assets.DeferredStaticMacro.buildAll())

     class NineSplitSprite 
    {
        static final _Str_2137:Class<Dynamic> = NineSplitSprite__Str_2137;
        static final _Str_1905:Class<Dynamic> = NineSplitSprite__Str_1905;
        static final _Str_1879:Class<Dynamic> = NineSplitSprite__Str_1879;
        static final _Str_1290:Class<Dynamic> = NineSplitSprite__Str_1290;
        static final _Str_1071:Class<Dynamic> = NineSplitSprite__Str_1071;
        static final _Str_1597:Class<Dynamic> = NineSplitSprite__Str_1597;
        static final _Str_1844:Class<Dynamic> = NineSplitSprite__Str_1844;
        static final _Str_1026:Class<Dynamic> = NineSplitSprite__Str_1026;
        static final _Str_2007:Class<Dynamic> = NineSplitSprite__Str_2007;
        static final _Str_1839:Class<Dynamic> = NineSplitSprite__Str_1839;
        static final _Str_1716:Class<Dynamic> = NineSplitSprite__Str_1716;
        static final _Str_1051:Class<Dynamic> = NineSplitSprite__Str_1051;
        static final _Str_1346:Bitmap = Type.createInstance(_Str_2137, []);
        public static final _Str_2262:Bitmap = Type.createInstance(_Str_1905, []);
        static final _Str_1706:Bitmap = Type.createInstance(_Str_1879, []);
        static final _Str_1251:Bitmap = Type.createInstance(_Str_1290, []);
        static final _Str_1341:Bitmap = Type.createInstance(_Str_1071, []);
        static final _Str_1555:Bitmap = Type.createInstance(_Str_1597, []);
        static final _Str_1243:Bitmap = Type.createInstance(_Str_1844, []);
        static final _Str_1223:Bitmap = Type.createInstance(_Str_1026, []);
        static final _Str_1180:Bitmap = Type.createInstance(_Str_2007, []);
        static final _Str_1172:Bitmap = Type.createInstance(_Str_1839, []);
        static final _Str_1948:Bitmap = Type.createInstance(_Str_1716, []);
        static final _Str_1642:Bitmap = Type.createInstance(_Str_1051, []);
        public static var _Str_1827:NineSplitSprite = new NineSplitSprite(_Str_1948.bitmapData, Vector.ofArray([5, 4, 5]), Vector.ofArray([11, 1, 5]));
        public static var _Str_1836:NineSplitSprite = new NineSplitSprite(_Str_1948.bitmapData, Vector.ofArray([5, 4, 5]), Vector.ofArray([5, 1, 11]));
        public static var _Str_1605:NineSplitSprite = new NineSplitSprite(_Str_1346.bitmapData, Vector.ofArray([12, 2, 6]), Vector.ofArray([14, 2, 4]));
        public static var _Str_1358:NineSplitSprite = new NineSplitSprite(_Str_2262.bitmapData, Vector.ofArray([5, 5, 5]), Vector.ofArray([5, 12, 5]));
        public static var _Str_2208:NineSplitSprite = new NineSplitSprite(_Str_1706.bitmapData, Vector.ofArray([2, 2, 2]), Vector.ofArray([8, 0, 0]));
        public static var _Str_2163:NineSplitSprite = new NineSplitSprite(_Str_1251.bitmapData, Vector.ofArray([4, 3, 4]), Vector.ofArray([5, 1, 7]));
        public static var _Str_1594:NineSplitSprite = new NineSplitSprite(_Str_1341.bitmapData, Vector.ofArray([5, 2, 5]), Vector.ofArray([5, 2, 6]));
        public static var _Str_1995:NineSplitSprite = new NineSplitSprite(_Str_1555.bitmapData, Vector.ofArray([5, 2, 5]), Vector.ofArray([5, 2, 6]));
        public static var _Str_1852:NineSplitSprite = new NineSplitSprite(_Str_1243.bitmapData, Vector.ofArray([5, 4, 5]), Vector.ofArray([7, 2, 5]));
        public static var _Str_1531:NineSplitSprite = new NineSplitSprite(_Str_1172.bitmapData, Vector.ofArray([330, 0, 0]), Vector.ofArray([31, 0, 0]));
        public static var _Str_2104:NineSplitSprite = new NineSplitSprite(_Str_1180.bitmapData, Vector.ofArray([330, 0, 0]), Vector.ofArray([31, 0, 0]));
        public static var _Str_2099:NineSplitSprite = new NineSplitSprite(_Str_1172.bitmapData, Vector.ofArray([330, 0, 0]), Vector.ofArray([31, 0, 0]));
        public static var _Str_2249:NineSplitSprite = new NineSplitSprite(_Str_1642.bitmapData, Vector.ofArray([5, 4, 5]), Vector.ofArray([11, 1, 5]));

        var _bitmapData:BitmapData;
        var _widths:Vector<Int>;
        var _heights:Vector<Int>;

        public function new(k:BitmapData, _arg_2:Vector<Int>, _arg_3:Vector<Int>)
        {
            this._bitmapData = k;
            this._widths = _arg_2;
            this._heights = _arg_3;
        }

        public function render(k:Int, _arg_2:Int):Bitmap
        {
            var _local_3= new Bitmap(new BitmapData(k, _arg_2, true, 0xFFFFFF));
            this._Str_2086(_local_3, new Rectangle(0, 0, k, _arg_2));
            return _local_3;
        }

        public function _Str_2086(k:Bitmap, _arg_2:Rectangle)
        {
            var _local_16 = 0;
            var _local_17:Rectangle = null;
            var _local_18:Rectangle = null;
            var _local_3= Std.int(_arg_2.x);
            var _local_4= Std.int(_arg_2.y);
            var _local_5= Std.int(_arg_2.width);
            var _local_6= Std.int(_arg_2.height);
            var _local_7= Vector.ofArray([0, this._widths[0], (this._widths[0] + this._widths[1])]);
            var _local_8= Vector.ofArray([0, this._heights[0], (this._heights[0] + this._heights[1])]);
            var _local_9= this._widths;
            var _local_10= this._heights;
            var _local_11= Vector.ofArray([_local_3, (_local_3 + this._widths[0]), ((_local_3 + _local_5) - this._widths[2])]);
            var _local_12= Vector.ofArray([_local_4, (_local_4 + this._heights[0]), ((_local_4 + _local_6) - this._heights[2])]);
            var _local_13= Vector.ofArray([this._widths[0], ((_local_5 - this._widths[0]) - this._widths[2]), this._widths[2]]);
            var _local_14= Vector.ofArray([this._heights[0], ((_local_6 - this._heights[0]) - this._heights[2]), this._heights[2]]);
            var _local_15 = 0;
            while (_local_15 < 3)
            {
                _local_16 = 0;
                while (_local_16 < 3)
                {
                    if (((((_local_13[_local_15] < 1) || (_local_14[_local_16] < 1)) || (_local_9[_local_15] < 1)) || (_local_10[_local_16] < 1)))
                    {
                    }
                    else
                    {
                        _local_17 = new Rectangle(_local_7[_local_15], _local_8[_local_16], _local_9[_local_15], _local_10[_local_16]);
                        if (((!(_local_15 == 1)) && (!(_local_16 == 1))))
                        {
                            k.bitmapData.copyPixels(this._bitmapData, _local_17, new Point(_local_11[_local_15], _local_12[_local_16]));
                        }
                        else
                        {
                            _local_18 = new Rectangle(_local_11[_local_15], _local_12[_local_16], _local_13[_local_15], _local_14[_local_16]);
                            k.bitmapData.draw(this._bitmapData, _Str_988._Str_2065(_local_17, _local_18), null, null, _local_18, false);
                        }
                    }
                    _local_16++;
                }
                _local_15++;
            }
        }

        public var bitmapData(get,never):BitmapData;
public function  get_bitmapData():BitmapData
        {
            return this._bitmapData;
        }
    }

