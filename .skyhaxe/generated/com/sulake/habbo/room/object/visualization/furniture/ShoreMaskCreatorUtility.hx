package com.sulake.habbo.room.object.visualization.furniture
;
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.room.utils.Rasterizer;

     class ShoreMaskCreatorUtility 
    {
        public static inline final OUTER_CUT= 0;
        public static inline final STRAIGHT_CUT= 1;
        public static inline final INNER_CUT= 2;
        static inline final CUT_TYPE_COUNT= 3;
        static inline final MASK_COLOR_TRANSPARENT:UInt = 0;
        static inline final MASK_COLOR_SOLID:UInt = 0xFFFFFFFF;


        public static function createEmptyMask(k:Int, _arg_2:Int):BitmapData
        {
            var _local_3= new BitmapData(k, _arg_2, true, MASK_COLOR_TRANSPARENT);
            return _local_3;
        }

        public static function getInstanceMaskName(k:Int, _arg_2:Int):String
        {
            var _local_3= ((("instance_mask_" + Std.string(k)) + "_") + Std.string(_arg_2));
            return _local_3;
        }

        public static function getBorderType(k:Int, _arg_2:Int):Int
        {
            return k + (_arg_2 * CUT_TYPE_COUNT);
        }

        public static function _Str_18302(k:Int, _arg_2:Int, _arg_3:IGraphicAssetCollection, _arg_4:IGraphicAsset):IGraphicAsset
        {
            var _local_7:BitmapDataAsset = null;
            var _local_8:BitmapData = null;
            var _local_5= getInstanceMaskName(k, _arg_2);
            var _local_6= _arg_3.getAsset(_local_5);
            if (_local_6 == null)
            {
                if (_arg_4 != null)
                {
                    _local_7 = Std.downcast(_arg_4.asset , BitmapDataAsset);
                    if (_local_7 != null)
                    {
                        _local_8 = ASCompat.dynamicAs(_local_7.content , BitmapData);
                        if (_local_8 != null)
                        {
                            _arg_3.addAsset(_local_5, new BitmapData(_local_8.width, _local_8.height, true, MASK_COLOR_TRANSPARENT), false, _arg_4.offsetX, _arg_4.offsetY);
                            _local_6 = _arg_3.getAsset(_local_5);
                        }
                    }
                }
            }
            return _local_6;
        }

        public static function disposeInstanceMask(k:Int, _arg_2:Int, _arg_3:IGraphicAssetCollection)
        {
            var _local_4= getInstanceMaskName(k, _arg_2);
            _arg_3.disposeAsset(_local_4);
        }

        public static function createShoreMask2x2(k:BitmapData, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Array<ASAny>, _arg_5:IGraphicAssetCollection):BitmapData
        {
            var _local_7:String = null;
            var _local_8:IGraphicAsset = null;
            var _local_9:BitmapData = null;
            k.fillRect(k.rect, MASK_COLOR_TRANSPARENT);
            var _local_6 = 0;
            while (_local_6 < _arg_3.length)
            {
                if (_arg_3[_local_6] == true)
                {
                    _local_7 = ((((("mask_" + Std.string(_arg_2)) + "_") + Std.string(_local_6)) + "_") + _arg_4[_local_6]);
                    _local_8 = _arg_5.getAsset(_local_7);
                    if (((!(_local_8 == null)) && (!(_local_8.asset == null))))
                    {
                        _local_9 = ASCompat.dynamicAs(_local_8.asset.content , BitmapData);
                        if (_local_9 != null)
                        {
                            k.copyPixels(_local_9, _local_9.rect, new Point(0, 0), _local_9, new Point(0, 0), true);
                        }
                    }
                }
                _local_6++;
            }
            return k;
        }

        public static function _Str_18695(k:Int, _arg_2:IGraphicAssetCollection, _arg_3:IGraphicAsset):Bool
        {
            var _local_4:String = null;
            var _local_5:BitmapDataAsset = null;
            var _local_6:BitmapData = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:BitmapData = null;
            var _local_10 = 0;
            if (_arg_2 != null)
            {
                _local_4 = ("masks_done_" + Std.string(k));
                if (_arg_2.getAsset(_local_4) == null)
                {
                    if (_arg_3 != null)
                    {
                        _local_5 = Std.downcast(_arg_3.asset , BitmapDataAsset);
                        if (_local_5 != null)
                        {
                            _local_6 = ASCompat.dynamicAs(_local_5.content , BitmapData);
                            _local_7 = [OUTER_CUT, STRAIGHT_CUT, INNER_CUT, OUTER_CUT, STRAIGHT_CUT, INNER_CUT];
                            _local_8 = [STRAIGHT_CUT, STRAIGHT_CUT, STRAIGHT_CUT, INNER_CUT, INNER_CUT, INNER_CUT];
                            _local_9 = null;
                            _local_10 = 0;
                            if (_local_6 != null)
                            {
                                _local_10 = 0;
                                while (((_local_10 < _local_7.length) && (_local_10 < _local_8.length)))
                                {
                                    _local_9 = createMaskLeft(_local_6.width, _local_6.height);
                                    cutLeftMask(_local_9, k, ASCompat.toInt(_local_7[_local_10]), ASCompat.toInt(_local_8[_local_10]));
                                    storeLeftMask(_arg_2, _local_9, k, ASCompat.toInt(_local_7[_local_10]), ASCompat.toInt(_local_8[_local_10]));
                                    _local_9 = createMaskRight(_local_6.width, _local_6.height);
                                    cutRightMask(_local_9, k, ASCompat.toInt(_local_8[_local_10]), ASCompat.toInt(_local_7[_local_10]));
                                    storeRightMask(_arg_2, _local_9, k, ASCompat.toInt(_local_8[_local_10]), ASCompat.toInt(_local_7[_local_10]));
                                    _local_10++;
                                }
                            }
                        }
                        _arg_2.addAsset(_local_4, new BitmapData(1, 1), false);
                        return true;
                    }
                    return false;
                }
                return true;
            }
            return false;
        }

        static function createMaskLeft(k:Int, _arg_2:Int):BitmapData
        {
            var _local_3= new BitmapData(k, _arg_2, true, MASK_COLOR_TRANSPARENT);
            fillTopLeftCorner(_local_3, Std.int(_local_3.width / 2), Std.int((_local_3.height / 2) - 1), 1, MASK_COLOR_SOLID);
            return _local_3;
        }

        static function cutLeftMask(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            if (_arg_3 == STRAIGHT_CUT)
            {
                cutLeftMaskOuterCorner(k, _arg_2, false);
            }
            else
            {
                if (_arg_3 == INNER_CUT)
                {
                    cutLeftMaskOuterCorner(k, _arg_2, true);
                }
            }
            if (_arg_4 == INNER_CUT)
            {
                cutLeftMaskInnerCorner(k, _arg_2);
            }
        }

        static function cutLeftMaskOuterCorner(k:BitmapData, _arg_2:Int, _arg_3:Bool)
        {
            var _local_4= Std.int((k.height / 2) - (_arg_2 / 2));
            var _local_5= Std.int(k.width / 2);
            if (_arg_3)
            {
                k.fillRect(new Rectangle(_local_5, 0, k.width, _local_4), MASK_COLOR_TRANSPARENT);
            }
            else
            {
                fillTopLeftCorner(k, _local_5, (_local_4 - 1), 1, MASK_COLOR_TRANSPARENT);
            }
        }

        static function cutLeftMaskInnerCorner(k:BitmapData, _arg_2:Int)
        {
            var _local_3= Std.int((k.width / 2) + (_arg_2 / 2));
            k.fillRect(new Rectangle(_local_3, 0, k.width, (k.height / 2)), MASK_COLOR_TRANSPARENT);
        }

        static function createMaskRight(k:Int, _arg_2:Int):BitmapData
        {
            var _local_3= new BitmapData(k, _arg_2, true, MASK_COLOR_TRANSPARENT);
            fillBottomRightCorner(_local_3, Std.int((_local_3.width / 2) + 1), Std.int((_local_3.height / 2) - 1), MASK_COLOR_SOLID);
            return _local_3;
        }

        static function cutRightMask(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            if (_arg_4 == STRAIGHT_CUT)
            {
                cutRightMaskOuterCorner(k, _arg_2, false);
            }
            else
            {
                if (_arg_4 == INNER_CUT)
                {
                    cutRightMaskOuterCorner(k, _arg_2, true);
                }
            }
            if (_arg_3 == INNER_CUT)
            {
                cutRightMaskInnerCorner(k, _arg_2);
            }
        }

        static function cutRightMaskInnerCorner(k:BitmapData, _arg_2:Int)
        {
            var _local_3= Std.int((k.width / 2) + (_arg_2 / 2));
            k.fillRect(new Rectangle(_local_3, 0, k.width, ((k.height / 2) - (_arg_2 / 4))), MASK_COLOR_TRANSPARENT);
        }

        static function cutRightMaskOuterCorner(k:BitmapData, _arg_2:Int, _arg_3:Bool)
        {
            var _local_4= Std.int(k.height / 2);
            var _local_5= Std.int((k.width / 2) + _arg_2);
            if (_arg_3)
            {
                k.fillRect(new Rectangle(_local_5, 0, k.width, _local_4), MASK_COLOR_TRANSPARENT);
            }
            else
            {
                fillBottomRightCorner(k, (_local_5 + 1), (_local_4 - 1), MASK_COLOR_TRANSPARENT);
            }
        }

        static function storeLeftMask(k:IGraphicAssetCollection, _arg_2:BitmapData, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            var _local_6:String = null;
            if (k != null)
            {
                _local_6 = "";
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_0_") + Std.string(getBorderType(_arg_4, _arg_5)));
                k.addAsset(_local_6, _arg_2, false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_3_") + Std.string(getBorderType(_arg_5, _arg_4)));
                k.addAsset(_local_6, Rasterizer.getFlipVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_4_") + Std.string(getBorderType(_arg_4, _arg_5)));
                k.addAsset(_local_6, Rasterizer.getFlipHVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_7_") + Std.string(getBorderType(_arg_5, _arg_4)));
                k.addAsset(_local_6, Rasterizer.getFlipHBitmapData(_arg_2), false);
            }
        }

        static function storeRightMask(k:IGraphicAssetCollection, _arg_2:BitmapData, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            var _local_6:String = null;
            if (k != null)
            {
                _local_6 = "";
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_1_") + Std.string(getBorderType(_arg_4, _arg_5)));
                k.addAsset(_local_6, _arg_2, false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_2_") + Std.string(getBorderType(_arg_5, _arg_4)));
                k.addAsset(_local_6, Rasterizer.getFlipVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_5_") + Std.string(getBorderType(_arg_4, _arg_5)));
                k.addAsset(_local_6, Rasterizer.getFlipHVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + Std.string(_arg_3)) + "_6_") + Std.string(getBorderType(_arg_5, _arg_4)));
                k.addAsset(_local_6, Rasterizer.getFlipHBitmapData(_arg_2), false);
            }
        }

        static function fillTopLeftCorner(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:UInt)
        {
            var _local_9 = 0;
            var _local_6= _arg_2;
            var _local_7= _arg_3;
            var _local_8= _arg_4;
            while (_local_7 >= 0)
            {
                _local_9 = _local_7;
                while (_local_9 >= 0)
                {
                    k.setPixel32(_local_6, _local_9, _arg_5);
                    _local_9--;
                }
                _local_8++;
                if (_local_8 >= 2)
                {
                    _local_7--;
                    _local_8 = 0;
                }
                _local_6++;
            }
        }

        static function fillBottomRightCorner(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:UInt)
        {
            var _local_7 = 0;
            var _local_5= _arg_2;
            var _local_6= _arg_3;
            while (_local_5 < k.width)
            {
                _local_7 = _local_5;
                while (_local_7 < k.width)
                {
                    k.setPixel32(_local_7, _local_6, _arg_4);
                    _local_7++;
                }
                _local_6--;
                _local_5 = (_local_5 + 2);
            }
        }

	public function new() {}
    }

