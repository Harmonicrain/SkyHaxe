package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FurnitureBrandedImageVisualization extends FurnitureVisualization 
    {
        static inline final BRANDED_IMAGE= "branded_image";
        static inline final STATE_0= 0;
        static inline final STATE_1= 1;
        static inline final STATE_2= 2;
        static inline final STATE_3= 3;

        var _Str_2991:String;
        var _Str_11348:Bool = false;
        var offsetX:Int = 0;
        var offsetY:Int = 0;
        var offsetZ:Int = 0;
        var _dynamicAssetName:String;


        override public function dispose()
        {
            if ((ASCompat.stringAsBool(this._dynamicAssetName) && (assetCollection != null)))
            {
                assetCollection.disposeAsset(this._dynamicAssetName);
                this._dynamicAssetName = null;
            }
            super.dispose();
            this._Str_2991 = null;
        }

        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            if (super.updateObject(k, _arg_2))
            {
                if (this._Str_11348)
                {
                    this._Str_19978(Std.int(k));
                }
                return true;
            }
            return false;
        }

        override function updateModel(k:Float):Bool
        {
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_2= super.updateModel(k);
            if (_local_2)
            {
                _local_3 = object;
                if (_local_3 != null)
                {
                    _local_4 = _local_3.getModel();
                    if (_local_4 != null)
                    {
                        this.offsetX = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_X));
                        this.offsetY = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Y));
                        this.offsetZ = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Z));
                    }
                }
            }
            if (!this._Str_11348)
            {
                this._Str_11348 = this._Str_25045();
                if (this._Str_11348)
                {
                    this._Str_19978(Std.int(k));
                    return true;
                }
            }
            else
            {
                if (this._Str_23675())
                {
                    this._Str_11348 = false;
                    this._Str_2991 = null;
                    return true;
                }
            }
            return _local_2;
        }

        function _Str_23675():Bool
        {
            var _local_2:IRoomObjectModel = null;
            var _local_3:String = null;
            var k= object;
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL);
                    if (((!(_local_3 == null)) && (!(_local_3 == this._Str_2991))))
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        function _Str_25045():Bool
        {
            var _local_2:IRoomObjectModel = null;
            var _local_3:String = null;
            var _local_4 = Math.NaN;
            var _local_5:IGraphicAsset = null;
            var _local_6:BitmapData = null;
            var k= object;
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL);
                    if (_local_3 != null)
                    {
                        if (((this._Str_2991 == null) || (!(this._Str_2991 == _local_3))))
                        {
                            _local_4 = _local_2.getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_STATUS);
                            if (_local_4 == 1)
                            {
                                _local_5 = assetCollection.getAsset(_local_3);
                                if (_local_5 != null)
                                {
                                    _local_6 = ASCompat.dynamicAs(_local_5.asset.content , BitmapData);
                                    if (_local_6 != null)
                                    {
                                        this.imageReady(_local_6, _local_3);
                                        return true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return false;
        }

        override function updateSprites(k:Int, _arg_2:Bool, _arg_3:Int)
        {
            super.updateSprites(k, _arg_2, _arg_3);
        }

        function imageReady(k:BitmapData, _arg_2:String)
        {
            Logger.log([("billboard visualization got image from url = " + _arg_2)]);
            if (k != null)
            {
                this._Str_2991 = _arg_2;
            }
            else
            {
                this._Str_2991 = null;
            }
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_7 = 0;
            var _local_3= _Str_3033(k);
            var _local_4= type;
            var _local_5= "";
            if (_arg_2 < (spriteCount - 1))
            {
                _local_5 = ASCompat.stringFromCharCode(("a".charCodeAt(0) + _arg_2));
            }
            else
            {
                _local_5 = "sd";
            }
            if (_local_3 == 1)
            {
                _local_4 = (_local_4 + ("_icon_" + _local_5));
            }
            else
            {
                _local_7 = getFrameNumber(k, _arg_2);
                _local_4 = (_local_4 + ((((((("_" + Std.string(_local_3)) + "_") + _local_5) + "_") + Std.string(direction)) + "_") + Std.string(_local_7)));
            }
            var _local_6= getSpriteTag(k, direction, _arg_2);
            if (((!(this._Str_2991 == null)) && (_local_6 == BRANDED_IMAGE)))
            {
                return (((this._Str_2991 + "_") + Std.string(_local_3)) + "_") + Std.string(object.getState(0));
            }
            return _local_4;
        }

        function _Str_19978(k:Int)
        {
            var _local_9:BitmapData = null;
            var _local_15:Matrix = null;
            if (((object == null) || (this._Str_2991 == null)))
            {
                return;
            }
            var _local_2= assetCollection.getAsset(this._Str_2991);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= object.getState(0);
            var _local_4= _Str_3033(k);
            var _local_5= ((((this._Str_2991 + "_") + Std.string(_local_4)) + "_") + Std.string(_local_3));
            var _local_6= assetCollection.getAsset(_local_5);
            if (_local_6 != null)
            {
                return;
            }
            var _local_7= ASCompat.dynamicAs(_local_2.asset.content , BitmapData);
            if (_local_7 == null)
            {
                Logger.log([("could not find bitmap data for image " + _local_5)]);
                return;
            }
            var _local_8= true;
            if (this._Str_2991.indexOf("noscale") > -1)
            {
                _local_8 = false;
            }
            if (((_local_4 == 32) && _local_8))
            {
                _local_15 = new Matrix();
                _local_15.scale(0.5, 0.5);
                _local_9 = new BitmapData(Std.int(_local_7.width / 2), Std.int(_local_7.height / 2), true, 0xFFFFFF);
                _local_9.draw(_local_7, _local_15);
            }
            else
            {
                _local_9 = _local_7.clone();
            }
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = false;
            var _local_13 = false;
            switch (_local_3)
            {
                case STATE_0:
                    _local_10 = 0;
                    _local_11 = 0;
                    _local_12 = false;
                    _local_13 = false;
                    
                case STATE_1:
                    _local_10 = -_local_9.width;
                    _local_11 = 0;
                    _local_12 = true;
                    _local_13 = false;
                    
                case STATE_2:
                    _local_10 = -_local_9.width;
                    _local_11 = -_local_9.height;
                    _local_12 = true;
                    _local_13 = true;
                    
                case STATE_3:
                    _local_10 = 0;
                    _local_11 = -_local_9.height;
                    _local_12 = false;
                    _local_13 = true;
                    
                default:
                    Logger.log([("could not handle unknown state " + Std.string(_local_3))]);
            }
            if (ASCompat.stringAsBool(this._dynamicAssetName))
            {
                assetCollection.disposeAsset(this._dynamicAssetName);
            }
            this._dynamicAssetName = _local_5;
            var _local_14= assetCollection.addAsset(_local_5, _local_9, true, _local_10, _local_11, _local_12, _local_13);
            if (!_local_14)
            {
                Logger.log([("could not add asset for image " + _local_5)]);
            }
        }

        override function getLibraryAssetNameForSprite(k:IGraphicAsset, _arg_2:IRoomObjectSprite):String
        {
            var _local_3:String = null;
            if (_arg_2.tag != BRANDED_IMAGE)
            {
                return super.getLibraryAssetNameForSprite(k, _arg_2);
            }
            if (object != null)
            {
                _local_3 = object.getModel().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL);
            }
            if ((ASCompat.stringAsBool(_local_3) && (_local_3.length > 0)))
            {
                return _local_3;
            }
            return super.getLibraryAssetNameForSprite(k, _arg_2);
        }

	public function new() { super(); }
    }

