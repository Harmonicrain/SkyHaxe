package com.sulake.habbo.room.object.visualization.furniture
;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.geom.Point;

     class FurnitureWaterAreaVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final SHORE= "shore";

        var _hasSomeBorder:Bool = true;
        var _hasBorder:Array<ASAny>;
        var _borderType:Array<ASAny>;
        var _createdInstanceMaskSizes:Array<ASAny>;
        var _needsShoreUpdate:Bool = false;
        var _sizeX:Int = 0;
        var _sizeY:Int = 0;
        var _shoreSpriteIndex:Int = 0;
        var _shoreSpriteScale:Int = -1;
        var _shoreSpriteDirection:Int = -1;
        var _maskBitmapData:BitmapData = null;

        public function new()
        {
            this._hasBorder = [];
            this._borderType = [];
            this._createdInstanceMaskSizes = [];
            super();
        }

        override public function dispose()
        {
            var k = 0;
            if (assetCollection != null)
            {
                final _iter_ = this._createdInstanceMaskSizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = ASCompat.toInt(_tmp_);
                    ShoreMaskCreatorUtility.disposeInstanceMask(object.getInstanceId(), k, assetCollection);
                }
                this._createdInstanceMaskSizes = [];
            }
            if (this._maskBitmapData != null)
            {
                this._maskBitmapData.dispose();
                this._maskBitmapData = null;
            }
            super.dispose();
        }

        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            if (super.updateObject(k, _arg_2))
            {
                this._needsShoreUpdate = true;
                this.updateBorderData();
                return true;
            }
            return false;
        }

        override function updateAnimation(k:Float):Int
        {
            var _local_3 = 0;
            var _local_2= super.updateAnimation(k);
            if (this.updateInstanceShoreMask(k))
            {
                _local_3 = this.getShoreSpriteIndex(Std.int(k));
                _local_2 = (_local_2 | (1 << _local_3));
            }
            return _local_2;
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            if (((k == 1) || (!(_arg_2 == this.getShoreSpriteIndex(k)))))
            {
                return super.getSpriteAssetName(k, _arg_2);
            }
            if (this._hasSomeBorder)
            {
                return ShoreMaskCreatorUtility.getInstanceMaskName(object.getInstanceId(), _Str_3033(k));
            }
            return null;
        }

        function getShoreSpriteIndex(k:Int):Int
        {
            if (((this._shoreSpriteScale == k) && (this._shoreSpriteDirection == direction)))
            {
                return this._shoreSpriteIndex;
            }
            var _local_2= (spriteCount - 1);
            while (_local_2 >= 0)
            {
                if (getSpriteTag(k, direction, _local_2) == SHORE)
                {
                    this._shoreSpriteIndex = _local_2;
                    this._shoreSpriteScale = k;
                    this._shoreSpriteDirection = direction;
                    return this._shoreSpriteIndex;
                }
                _local_2--;
            }
            return -1;
        }

        function getShoreAsset(k:Int):IGraphicAsset
        {
            var _local_2= super.getSpriteAssetName(k, this.getShoreSpriteIndex(k));
            var _local_3= assetCollection.getAsset(_local_2);
            return _local_3;
        }

        function _Str_18302(k:Int):IGraphicAsset
        {
            var _local_2= _Str_3033(k);
            var _local_3= ShoreMaskCreatorUtility._Str_18302(object.getInstanceId(), _local_2, assetCollection, this.getShoreAsset(k));
            if (_local_3 != null)
            {
                if (this._createdInstanceMaskSizes.indexOf(_local_2) < 0)
                {
                    this._createdInstanceMaskSizes.push(_local_2);
                }
            }
            return _local_3;
        }

        function updateBorderData()
        {
            this.resetBorders();
            var k= object.getState(0);
            var _local_2= this.getAreaData();
            var _local_3= (this._sizeX + 2);
            var _local_4= (this._sizeY + 2);
            var _local_5 = 0;
            var _local_6:Array<ASAny> = _local_2[(_local_4 - 1)];
            _local_5 = (_local_3 - 1);
            while (_local_5 >= 0)
            {
                if (((k & 0x01) != 0))
                {
                    _local_6[_local_5] = true;
                }
                k = (k >> 1);
                _local_5--;
            }
            _local_5 = (_local_4 - 2);
            while (_local_5 >= 1)
            {
                _local_6 = _local_2[_local_5];
                if (((k & 0x01) != 0))
                {
                    _local_6[(_local_3 - 1)] = true;
                }
                k = (k >> 1);
                if (((k & 0x01) != 0))
                {
                    _local_6[0] = true;
                }
                k = (k >> 1);
                _local_5--;
            }
            _local_6 = _local_2[0];
            _local_5 = (_local_3 - 1);
            while (_local_5 >= 0)
            {
                if (((k & 0x01) != 0))
                {
                    _local_6[_local_5] = true;
                }
                k = (k >> 1);
                _local_5--;
            }
            var _local_7 = 0;
            _local_7 = this.updateTopBorder(_local_2, _local_7);
            _local_7 = this.updateRightBorder(_local_2, _local_7);
            _local_7 = this.updateBottomBorder(_local_2, _local_7);
            _local_7 = this.updateLeftBorder(_local_2, _local_7);
            this._hasSomeBorder = false;
            _local_5 = 0;
            while (_local_5 < this._hasBorder.length)
            {
                if (this._hasBorder[_local_5] == true)
                {
                    this._hasSomeBorder = true;
                }
                _local_5++;
            }
        }

        function updateTopBorder(k:Array<ASAny>, _arg_2:Int):Int
        {
            var _local_3= (this._sizeX + 2);
            var _local_4:Array<ASAny> = k[0];
            var _local_5:Array<ASAny> = k[1];
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8= 1;
            while (_local_8 < (_local_3 - 1))
            {
                if (_local_4[_local_8] == false)
                {
                    this._hasBorder[_arg_2] = true;
                    if (((_local_5[(_local_8 - 1)] == false) && (_local_4[(_local_8 - 1)] == false)))
                    {
                        _local_6 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_4[(_local_8 - 1)] == true)
                        {
                            _local_6 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_6 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    if (((_local_5[(_local_8 + 1)] == false) && (_local_4[(_local_8 + 1)] == false)))
                    {
                        _local_7 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_4[(_local_8 + 1)] == true)
                        {
                            _local_7 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_7 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    this._borderType[_arg_2] = ShoreMaskCreatorUtility.getBorderType(_local_6, _local_7);
                }
                _arg_2++;
                _local_8++;
            }
            return _arg_2;
        }

        function updateRightBorder(k:Array<ASAny>, _arg_2:Int):Int
        {
            var _local_3= (this._sizeX + 2);
            var _local_4= (this._sizeY + 2);
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:Array<ASAny> = null;
            var _local_10= 1;
            while (_local_10 < (_local_4 - 1))
            {
                _local_7 = k[_local_10];
                _local_8 = k[(_local_10 - 1)];
                _local_9 = k[(_local_10 + 1)];
                if (_local_7[(_local_3 - 1)] == false)
                {
                    this._hasBorder[_arg_2] = true;
                    if (((_local_8[(_local_3 - 2)] == false) && (_local_8[(_local_3 - 1)] == false)))
                    {
                        _local_5 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_8[(_local_3 - 1)] == true)
                        {
                            _local_5 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_5 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    if (((_local_9[(_local_3 - 2)] == false) && (_local_9[(_local_3 - 1)] == false)))
                    {
                        _local_6 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_9[(_local_3 - 1)] == true)
                        {
                            _local_6 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_6 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    this._borderType[_arg_2] = ShoreMaskCreatorUtility.getBorderType(_local_5, _local_6);
                }
                _arg_2++;
                _local_10++;
            }
            return _arg_2;
        }

        function updateBottomBorder(k:Array<ASAny>, _arg_2:Int):Int
        {
            var _local_3= (this._sizeX + 2);
            var _local_4= (this._sizeY + 2);
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = k[(_local_4 - 1)];
            var _local_8:Array<ASAny> = k[(_local_4 - 2)];
            var _local_9= (_local_3 - 2);
            while (_local_9 >= 1)
            {
                if (_local_7[_local_9] == false)
                {
                    this._hasBorder[_arg_2] = true;
                    if (((_local_8[(_local_9 + 1)] == false) && (_local_7[(_local_9 + 1)] == false)))
                    {
                        _local_5 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_7[(_local_9 + 1)] == true)
                        {
                            _local_5 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_5 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    if (((_local_8[(_local_9 - 1)] == false) && (_local_7[(_local_9 - 1)] == false)))
                    {
                        _local_6 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_7[(_local_9 - 1)] == true)
                        {
                            _local_6 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_6 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    this._borderType[_arg_2] = ShoreMaskCreatorUtility.getBorderType(_local_5, _local_6);
                }
                _arg_2++;
                _local_9--;
            }
            return _arg_2;
        }

        function updateLeftBorder(k:Array<ASAny>, _arg_2:Int):Int
        {
            var _local_3= (this._sizeX + 2);
            var _local_4= (this._sizeY + 2);
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:Array<ASAny> = null;
            var _local_10= (_local_4 - 2);
            while (_local_10 >= 1)
            {
                _local_7 = k[_local_10];
                _local_8 = k[(_local_10 + 1)];
                _local_9 = k[(_local_10 - 1)];
                if (_local_7[0] == false)
                {
                    this._hasBorder[_arg_2] = true;
                    if (((_local_8[1] == false) && (_local_8[0] == false)))
                    {
                        _local_5 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_8[0] == true)
                        {
                            _local_5 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_5 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    if (((_local_9[1] == false) && (_local_9[0] == false)))
                    {
                        _local_6 = ShoreMaskCreatorUtility.OUTER_CUT;
                    }
                    else
                    {
                        if (_local_9[0] == true)
                        {
                            _local_6 = ShoreMaskCreatorUtility.INNER_CUT;
                        }
                        else
                        {
                            _local_6 = ShoreMaskCreatorUtility.STRAIGHT_CUT;
                        }
                    }
                    this._borderType[_arg_2] = ShoreMaskCreatorUtility.getBorderType(_local_5, _local_6);
                }
                _arg_2++;
                _local_10--;
            }
            return _arg_2;
        }

        function resetBorders()
        {
            var _local_2:IRoomObjectModel = null;
            if (((this._sizeX == 0) || (this._sizeY == 0)))
            {
                if (((object == null) || (object.getModel() == null)))
                {
                    return;
                }
                _local_2 = object.getModel();
                this._sizeX = Std.int(_local_2.getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X));
                this._sizeY = Std.int(_local_2.getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y));
            }
            this._hasBorder = [];
            this._borderType = [];
            var k = 0;
            while (k < ((this._sizeX * 2) + (this._sizeY * 2)))
            {
                this._hasBorder.push(false);
                this._borderType.push(ShoreMaskCreatorUtility.STRAIGHT_CUT);
                k++;
            }
        }

        function getAreaData():Array<ASAny>
        {
            var k= (this._sizeX + 2);
            var _local_2= (this._sizeY + 2);
            var _local_3:Array<ASAny> = [];
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_6 = 0;
            _local_6 = 0;
            while (_local_6 < _local_2)
            {
                _local_4 = [];
                _local_5 = (k - 1);
                while (_local_5 >= 0)
                {
                    _local_4.push(false);
                    _local_5--;
                }
                _local_3.push(_local_4);
                _local_6++;
            }
            _local_6 = 1;
            while (_local_6 < (_local_2 - 1))
            {
                _local_4 = _local_3[_local_6];
                _local_5 = 1;
                while (_local_5 < (k - 1))
                {
                    _local_4[_local_5] = true;
                    _local_5++;
                }
                _local_6++;
            }
            return _local_3;
        }

        function _Str_18695(k:Float):Bool
        {
            return ShoreMaskCreatorUtility._Str_18695(_Str_3033(Std.int(k)), assetCollection, this.getShoreAsset(Std.int(k)));
        }

        function createShoreMask(k:Int, _arg_2:Int, _arg_3:Float):BitmapData
        {
            if ((((this._maskBitmapData == null) || (this._maskBitmapData.width < k)) || (this._maskBitmapData.height < _arg_2)))
            {
                if (this._maskBitmapData != null)
                {
                    this._maskBitmapData.dispose();
                }
                this._maskBitmapData = ShoreMaskCreatorUtility.createEmptyMask(k, _arg_2);
            }
            return ShoreMaskCreatorUtility.createShoreMask2x2(this._maskBitmapData, _Str_3033(Std.int(_arg_3)), this._hasBorder, this._borderType, assetCollection);
        }

        function updateInstanceShoreMask(k:Float):Bool
        {
            var _local_3:BitmapData = null;
            var _local_4:BitmapData = null;
            var _local_5:IGraphicAsset = null;
            var _local_6:BitmapData = null;
            if (!this._needsShoreUpdate)
            {
                return false;
            }
            var _local_2= this._Str_18302(Std.int(k));
            if ((((!(_local_2 == null)) && (!(_local_2.asset == null))) && this._Str_18695(k)))
            {
                _local_3 = ASCompat.dynamicAs(_local_2.asset.content , BitmapData);
                if (_local_3 != null)
                {
                    _local_4 = this.createShoreMask(_local_3.width, _local_3.height, k);
                    _local_5 = this.getShoreAsset(Std.int(k));
                    if (((!(_local_5 == null)) && (!(_local_5.asset == null))))
                    {
                        _local_6 = ASCompat.dynamicAs(_local_5.asset.content , BitmapData);
                        if (_local_6 != null)
                        {
                            _local_3.fillRect(_local_3.rect, 0);
                            _local_3.copyPixels(_local_6, _local_6.rect, new Point(0, 0), _local_4, new Point(0, 0), true);
                        }
                        this._needsShoreUpdate = false;
                    }
                }
                return true;
            }
            return false;
        }

        override function setAnimation(k:Int)
        {
            super.setAnimation(0);
        }
    }

