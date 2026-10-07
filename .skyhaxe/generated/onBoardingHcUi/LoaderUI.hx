package onBoardingHcUi
;
    import flash.filters.DropShadowFilter;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.text.AntiAliasType;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.Sprite;
    import flash.display.Shape;
    import onBoardingHcUi.images.*;
    import fonts.*;

     class LoaderUI 
    {
        static final _Str_1249:Class<Dynamic> = LoaderUI__Str_1249;
        public static var ubuntu_regular:Class<Dynamic> = _Str_771;
        public static var ubuntu_bold:Class<Dynamic> = _Str_955;
        public static var ubuntu_italic:Class<Dynamic> = _Str_1000;
        public static var ubuntu_bold_italic:Class<Dynamic> = _Str_666;
        static final _Str_1115:Class<Dynamic> = LoaderUI__Str_1115;
        static final _Str_1325:Class<Dynamic> = LoaderUI__Str_1325;
        static final _Str_2054:Class<Dynamic> = LoaderUI__Str_2054;
        static final _Str_1832:Class<Dynamic> = LoaderUI__Str_1832;
        public static inline final _Str_2056= 1;
        public static inline final _Str_1585= 2;
        public static inline final L= "l";
        public static inline final C= "c";
        public static inline final R= "r";
        public static inline final T= "t";
        public static inline final M= "m";
        public static inline final B= "b";
        public static inline final _Str_1232:UInt = 8309486;
        public static inline final _Str_1545:UInt = 0xFFFFFF;
        static final ETCHING_FILTER:DropShadowFilter = new DropShadowFilter(1, 90, 0xD1D400, 1, 1, 1);
        static final NEGATIVE_ETCHING_FILTER:DropShadowFilter = new DropShadowFilter(1, 270, 0, 0.7, 1, 1);


        public static function createTextField(k:String, _arg_2:Int, _arg_3:UInt, _arg_4:Bool=false, _arg_5:Bool=false, _arg_6:Bool=false, _arg_7:Bool=false, _arg_8:String="left", _arg_9:Bool=false, _arg_10:Bool=false):TextField
        {
            var _local_11= new TextFormat("Ubuntu", _arg_2, ASCompat.toInt(_arg_3), _arg_4, _arg_7, _arg_10);
            _local_11.align = _arg_8;
            _local_11.kerning = _arg_9;
            var _local_12= new TextField();
            _local_12.embedFonts = true;
            _local_12.antiAliasType = AntiAliasType.ADVANCED;
            _local_12.defaultTextFormat = _local_11;
            _local_12.multiline = _arg_5;
            _local_12.wordWrap = _arg_5;
            _local_12.type = (_arg_6 ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            _local_12.selectable = _arg_6;
            _local_12.htmlText = k;
            _local_12.autoSize = TextFieldAutoSize.LEFT;
            _local_12.width = _local_12.textWidth;
            _local_12.height = _local_12.textHeight;
            return _local_12;
        }

        public static function addEtching(k:DisplayObject, _arg_2:Bool=false)
        {
            k.filters = [(_arg_2 ? NEGATIVE_ETCHING_FILTER.clone() : ETCHING_FILTER.clone())];
        }

        public static function lineUpHorizontally(k:DisplayObject,  _args:Array<ASAny> = null)
        {
if (_args == null) _args = [];
            var _local_5 = 0;
            var _local_6:DisplayObject = null;
            var _local_3= Std.int(_args.length / 2);
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_5 = ASCompat.toInt(_args[(_local_4 * 2)]);
                _local_6 = _args[((_local_4 * 2) + 1)];
                _local_6.x = ((k.x + k.width) + _local_5);
                k = _local_6;
                _local_4++;
            }
        }

        public static function lineUpVertically(k:DisplayObject,  _args:Array<ASAny> = null)
        {
if (_args == null) _args = [];
            var _local_5 = 0;
            var _local_6:DisplayObject = null;
            var _local_3= Std.int(_args.length / 2);
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_5 = ASCompat.toInt(_args[(_local_4 * 2)]);
                _local_6 = _args[((_local_4 * 2) + 1)];
                _local_6.y = ((k.y + k.height) + _local_5);
                k = _local_6;
                _local_4++;
            }
        }

        public static function alignAnchors(k:DisplayObject, _arg_2:String,  _args:Array<ASAny> = null)
        {
if (_args == null) _args = [];
            var _local_4:DisplayObject = null;
            if (checkNullIteratee(_args)) for (_tmp_ in _args)
            {
_local_4  = _tmp_;
                if (_arg_2.indexOf(L) >= 0)
                {
                    _local_4.x = k.x;
                }
                if (_arg_2.indexOf(C) >= 0)
                {
                    _local_4.x = (k.x + Std.int(((k.width - _local_4.width) / 2)));
                }
                if (_arg_2.indexOf(R) >= 0)
                {
                    _local_4.x = ((k.x + k.width) - _local_4.width);
                }
                if (_arg_2.indexOf(T) >= 0)
                {
                    _local_4.y = k.y;
                }
                if (_arg_2.indexOf(M) >= 0)
                {
                    _local_4.y = (k.y + Std.int(((k.height - _local_4.height) / 2)));
                }
                if (_arg_2.indexOf(B) >= 0)
                {
                    _local_4.y = ((k.y + k.height) - _local_4.height);
                }
            }
        }

        public static function createBalloon(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:UInt=0xFFFFFF, _arg_6:String="up"):Bitmap
        {
            var _local_8:Bitmap = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:Bitmap = null;
            if (_arg_3 < 0)
            {
                _arg_3 = Std.int(((k - 9) / 2));
            }
            var _local_7= NineSplitSprite._Str_2249;
            switch (_arg_6)
            {
                case "up":
                    _local_8 = Type.createInstance(_Str_1325, []);
                    _local_9 = Std.int(_local_8.height);
                    _local_11 = new Bitmap(new BitmapData(k, Std.int(_arg_2 + _local_8.height), true, 860986));
                    _local_7._Str_2086(_local_11, new Rectangle(0, _local_9, k, _arg_2));
                    _local_11.bitmapData.copyPixels(_local_8.bitmapData, _local_8.bitmapData.rect, new Point(_arg_3, 0));
                    
                case "down":
                    _local_8 = Type.createInstance(_Str_1115, []);
                    _local_9 = Std.int(_local_8.height);
                    _local_11 = new Bitmap(new BitmapData(k, Std.int(_arg_2 + _local_8.height), true, 860986));
                    _local_7._Str_2086(_local_11, new Rectangle(0, _local_9, k, _arg_2));
                    _local_11.bitmapData.copyPixels(_local_8.bitmapData, _local_8.bitmapData.rect, new Point(_arg_3, (_arg_2 + _local_9)));
                    
                case "left":
                    _local_8 = Type.createInstance(_Str_2054, []);
                    _local_10 = Std.int(_local_8.width);
                    _local_11 = new Bitmap(new BitmapData((k + _local_10), _arg_2, true, 0xFFFFFF));
                    _local_7._Str_2086(_local_11, new Rectangle(_local_10, 0, k, _arg_2));
                    _local_11.bitmapData.copyPixels(_local_8.bitmapData, _local_8.bitmapData.rect, new Point(0, (_arg_3 - _local_10)));
                    
                case "right":
                    _local_8 = Type.createInstance(_Str_1832, []);
                    _local_10 = Std.int(_local_8.width);
                    _local_11 = new Bitmap(new BitmapData((k + _local_10), _arg_2, true, 860986));
                    _local_7._Str_2086(_local_11, new Rectangle(0, 0, k, _arg_2));
                    _local_11.bitmapData.copyPixels(_local_8.bitmapData, _local_8.bitmapData.rect, new Point(k, (_arg_3 - _local_10)));
                    
                case "none":
                    _local_11 = new Bitmap(new BitmapData(k, _arg_2, true, 860986));
                    _local_7._Str_2086(_local_11, new Rectangle(0, 0, k, _arg_2));
                    
            }
            _local_11.bitmapData.colorTransform(_local_11.bitmapData.rect, new ColorTransform((((ASCompat.toInt(_arg_5 )>> 16) & 0xFF) / 0xFF), (((ASCompat.toInt(_arg_5 )>> 8) & 0xFF) / 0xFF), ((ASCompat.toInt(_arg_5 )& 0xFF) / 0xFF)));
            return _local_11;
        }

        public static function createFrame(k:String, _arg_2:String, _arg_3:Rectangle, _arg_4:Int=1):Sprite
        {
            var _local_7:TextField = null;
            var _local_5= new Sprite();
            _local_5.x = _arg_3.x;
            _local_5.y = _arg_3.y;
            if (_arg_4 == LoaderUI._Str_2056)
            {
                _local_5.addChild(NineSplitSprite._Str_2163.render(Std.int(_arg_3.width), Std.int(_arg_3.height)));
            }
            var _local_6= createTextField(k, 40, 0xFFFFFF, false, false, false, false);
            _local_6.y = -48;
            _local_6.autoSize = TextFieldAutoSize.LEFT;
            _local_5.addChild(_local_6);
            if (((!(_arg_2 == null)) && (!(_arg_2 == ""))))
            {
                _local_7 = createTextField(_arg_2, 10, 0xAAAAAA, true);
                _local_7.x = 8;
                _local_7.y = -54;
                _local_7.autoSize = TextFieldAutoSize.LEFT;
                _local_5.addChild(_local_7);
            }
            return _local_5;
        }

        public static function resizeFrame(k:Sprite, _arg_2:Int, _arg_3:Int)
        {
            k.removeChildAt(0);
            k.addChildAt(NineSplitSprite._Str_2163.render(_arg_2, _arg_3), 0);
        }

        public static function createScale9GridShapeFromImage(k:BitmapData, _arg_2:Rectangle):Shape
        {
            var _local_8 = Math.NaN;
            var _local_9 = 0;
            var _local_3:Array<ASAny> = [(_arg_2.left - 0.001), (_arg_2.right + 0.001), k.width];
            var _local_4:Array<ASAny> = [(_arg_2.top - 0.001), (_arg_2.bottom + 0.001), k.height];
            var _local_5= new Shape();
            var _local_6:Float = 0;
            var _local_7 = 0;
            while (_local_7 < 3)
            {
                _local_8 = 0;
                _local_9 = 0;
                while (_local_9 < 3)
                {
                    _local_5.graphics.beginBitmapFill(k);
                    _local_5.graphics.drawRect(_local_6, _local_8, ASCompat.toNumber(ASCompat.toNumber(_local_3[_local_7]) - _local_6), ASCompat.toNumber(ASCompat.toNumber(_local_4[_local_9]) - _local_8));
                    _local_5.graphics.endFill();
                    _local_8 = ASCompat.toNumber(_local_4[_local_9]);
                    _local_9++;
                }
                _local_6 = ASCompat.toNumber(_local_3[_local_7]);
                _local_7++;
            }
            _local_5.scale9Grid = _arg_2;
            return _local_5;
        }

        public static function createTextBorder():Shape
        {
            return createScale9GridShapeFromImage(cast(Type.createInstance(_Str_1249, []), Bitmap).bitmapData, new Rectangle(10, 10, 10, 10));
        }

	public function new() {}
    }

