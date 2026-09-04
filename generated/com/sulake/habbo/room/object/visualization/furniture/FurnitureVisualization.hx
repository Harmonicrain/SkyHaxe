package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;
    import com.sulake.room.object._enum.AlphaTolerance;
    import flash.display.BlendMode;
    import com.sulake.habbo.room.object.visualization.data.LayerData;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.visualization.data.ColorData;

     class FurnitureVisualization extends RoomObjectSpriteVisualization 
    {
        static final _Str_19020:Float = Math.sqrt(0.5);

        static function concatListWillEqual(first:Array<ASAny>, second:Array<ASAny>, current:Array<ASAny>):Bool
        {
            if (current == null || first.length + second.length != current.length)
            {
                return false;
            }
            var index:Int;
            var index= 0;while (index < first.length)
            {
                if (first[index] != current[index])
                {
                    return false;
                }
index++;
            }
            var index= 0;while (index < second.length)
            {
                if (second[index] != current[first.length + index])
                {
                    return false;
                }
index++;
            }
            return true;
        }

        var _direction:Int = 0;
        var _lastCameraAngle:Float = Math.NaN;
        var _selectedColor:Int = -1;
        var _Str_1240:Float = 1;
        var _clickUrl:String = null;
        var _clickHandling:Bool = false;
        var _lookThrough:Bool = false;
        var _lookThroughChanged:Bool = false;
        var _data:FurnitureVisualizationData = null;
        var _type:String = "";
        var _assetNames:Array<ASAny>;
        var _assetNamesFrame:Array<ASAny>;
        var _furnitureLift:Float = 0;
        var _cacheSize:Int = -1;
        var _updatedLayers:Int = -1;
        var _spriteTags:Array<ASAny>;
        var _spriteAlphas:Array<ASAny>;
        var _spriteColors:Array<ASAny>;
        var _spriteXOffsets:Array<ASAny>;
        var _spriteYOffsets:Array<ASAny>;
        var _spriteZOffsets:Array<ASAny>;
        var _spriteMouseCaptures:Array<ASAny>;
        var _spriteInks:Array<ASAny>;
        var _Str_11460:Bool = true;
        var _Str_3416:Int = 0;
        var _Str_13574:Int = -1;
        var _maskLayerIndex:Int = 0;
        var Z_MULTIPLIER:Float = 0;
        var _filters:Array<ASAny> = null;
        var _filtersChanged:Bool = false;
        var _invisibleLayer:Bool = false;
        var _isInvisibleFurni:Bool = false;

        public function new()
        {
            this._assetNames = [];
            this._assetNamesFrame = [];
            this._spriteTags = [];
            this._spriteAlphas = [];
            this._spriteColors = [];
            this._spriteXOffsets = [];
            this._spriteYOffsets = [];
            this._spriteZOffsets = [];
            this._spriteMouseCaptures = [];
            this._spriteInks = [];
            super();
            this.reset();
        }

        
        var direction(get,set):Int;
function  set_direction(k:Int):Int        {
            return this._direction = k;
        }
function  get_direction():Int
        {
            return this._direction;
        }

        var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        override public function dispose()
        {
            super.dispose();
            this._data = null;
            this._assetNames = null;
            this._assetNamesFrame = null;
            this._spriteTags = null;
            this._spriteAlphas = null;
            this._spriteColors = null;
            this._spriteXOffsets = null;
            this._spriteYOffsets = null;
            this._spriteZOffsets = null;
            this._spriteMouseCaptures = null;
            this._spriteInks = null;
        }

        override function reset()
        {
            super.reset();
            this.direction = -1;
            this._data = null;
            this._assetNames = [];
            this._assetNamesFrame = [];
            this._spriteTags = [];
            this._spriteAlphas = [];
            this._spriteColors = [];
            this._spriteXOffsets = [];
            this._spriteYOffsets = [];
            this._spriteZOffsets = [];
            this._spriteMouseCaptures = [];
            this._spriteInks = [];
            this.createSprites(0);
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            this.reset();
            if (((k == null) || (!Std.is(k , FurnitureVisualizationData))))
            {
                return false;
            }
            this._data = Std.downcast(k , FurnitureVisualizationData);
            this._type = this._data.getType();
            this._isInvisibleFurni = (this._type.indexOf("room_invisible_") == 0);
            return true;
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            if (k == null)
            {
                return;
            }
            var _local_5 = false;
            var _local_6= k.scale;
            if (this.updateObject(_local_6, k.direction.x))
            {
                _local_5 = true;
            }
            if (this.updateModel(_local_6))
            {
                _local_5 = true;
            }
            if (this._lookThroughChanged)
            {
                _local_5 = true;
                this._lookThroughChanged = false;
            }
            if (this._filtersChanged)
            {
                _local_5 = true;
                this._filtersChanged = false;
            }
            var _local_7 = 0;
            if (_arg_4)
            {
                this._maskLayerIndex = (this._maskLayerIndex | this.updateAnimation(_local_6));
            }
            else
            {
                _local_7 = (this.updateAnimation(_local_6) | this._maskLayerIndex);
                this._maskLayerIndex = 0;
            }
            if ((_local_5 || (!(_local_7 == 0))))
            {
                this.updateSprites(Std.int(_local_6), _local_5, _local_7);
                _currentScale = Std.int(_local_6);
                increaseUpdateId();
            }
        }

        function updateSprites(k:Int, _arg_2:Bool, _arg_3:Int)
        {
            var _local_4:Int;
            var _local_5:Int;
            if (this._Str_3416 != spriteCount)
            {
                createSprites(this._Str_3416);
            }
            if (_arg_2)
            {
                _local_4 = (spriteCount - 1);
                while (_local_4 >= 0)
                {
                    this.updateSprite(k, _local_4);
                    _local_4--;
                }
            }
            else
            {
                _local_5 = 0;
                while (_arg_3 > 0)
                {
                    if (((_arg_3 & 0x01) != 0))
                    {
                        this.updateSprite(k, _local_5);
                    }
                    _local_5++;
                    _arg_3 = (_arg_3 >> 1);
                }
            }
            this._Str_11460 = false;
        }

        function updateSprite(k:Int, _arg_2:Int)
        {
            var _local_5:IGraphicAsset;
            var _local_6:Float;
            var _local_7:Int;
            var _local_3= this.getSpriteAssetName(k, _arg_2);
            var _local_4= getSprite(_arg_2);
            if (((!(_local_4 == null)) && (!(_local_3 == null))))
            {
                _local_5 = this.getAsset(_local_3, _arg_2);
                if (((!(_local_5 == null)) && (!(_local_5.asset == null))))
                {
                    _local_4.visible = true;
                    _local_4.objectType = this._type;
                    _local_4.asset = ASCompat.dynamicAs(_local_5.asset.content , BitmapData);
                    if (_local_5.asset.content == null)
                    {
                        _modelUpdateID++;
                    }
                    _local_4.flipH = _local_5.flipH;
                    _local_4.flipV = _local_5.flipV;
                    _local_4.direction = this._direction;
                    _local_6 = 0;
                    if (_arg_2 != this._Str_13574)
                    {
                        _local_4.tag = this.getSpriteTag(k, this._direction, _arg_2);
                        _local_4.alpha = this.getSpriteAlpha(k, this._direction, _arg_2);
                        _local_4.color = this.getSpriteColor(k, _arg_2, this._selectedColor);
                        _local_4.offsetX = (_local_5.offsetX + this.getSpriteXOffset(k, this._direction, _arg_2));
                        _local_4.offsetY = (_local_5.offsetY + this.getSpriteYOffset(k, this._direction, _arg_2));
                        _local_4.alphaTolerance = (this.getSpriteMouseCapture(k, this._direction, _arg_2) ? AlphaTolerance.MATCH_OPAQUE_PIXELS : AlphaTolerance.MATCH_NOTHING);
                        if ((this._invisibleLayer && ((_local_4.tag == "invisible") || this._isInvisibleFurni)))
                        {
                            _local_4.alpha = 0;
                            _local_4.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
                        }
                        _local_4.blendMode = this.getBlendMode(this.getSpriteInk(k, this._direction, _arg_2));
                        if (this.getSpriteFlipH(k, this._direction, _arg_2))
                        {
                            _local_4.flipH = !_local_4.flipH;
                        }
                        _local_6 = this.getSpriteZOffset(k, this._direction, _arg_2);
                        _local_6 = (_local_6 - (_arg_2 * 0.001));
                    }
                    else
                    {
                        _local_4.offsetX = _local_5.offsetX;
                        _local_4.offsetY = (_local_5.offsetY + this.getSpriteYOffset(k, this._direction, _arg_2));
                        _local_7 = 48;
                        _local_7 = Std.int(_local_7 * this._Str_1240);
                        _local_4.alpha = _local_7;
                        _local_4.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
                        _local_6 = 1;
                    }
                    if (this._lookThrough)
                    {
                        _local_4.alpha = Std.int(_local_4.alpha * 0.2);
                    }
                    _local_6 = (_local_6 * _Str_19020);
                    _local_4.relativeDepth = _local_6;
                    _local_4.assetName = _local_5.assetName;
                    _local_4.libraryAssetName = this.getLibraryAssetNameForSprite(_local_5, _local_4);
                    _local_4.assetPosture = this.getPostureForAssetFile(k, _local_5.libraryAssetName);
                    _local_4.clickHandling = this._clickHandling;
                    this.updateSpriteFilters(k, _local_4, _arg_2);
                }
                else
                {
                    this.resetSprite(_local_4);
                }
            }
            else
            {
                if (_local_4 != null)
                {
                    this.resetSprite(_local_4);
                }
            }
        }

        function updateSpriteFilters(size:Int, sprite:IRoomObjectSprite, spriteIndex:Int)
        {
            if (sprite.blendMode != BlendMode.ADD)
            {
                var spriteFilters= this.getSpriteFilters(size, this._direction, spriteIndex);
                if (spriteFilters == null)
                {
                    sprite.filters = this._filters;
                }
                else if (this._filters == null)
                {
                    sprite.filters = spriteFilters;
                }
                else if (!concatListWillEqual(this._filters, spriteFilters, sprite.filters))
                {
                    sprite.filters = this._filters.concat(spriteFilters);
                }
            }
            else if (sprite.filters != null)
            {
                sprite.filters = null;
            }
        }

        public var lookThrough(never,set):Bool;
function  set_lookThrough(k:Bool):Bool        {
            if (this._lookThrough != k)
            {
                this._lookThroughChanged = true;
                this._lookThrough = k;
            }
return k;
        }

        function getLibraryAssetNameForSprite(k:IGraphicAsset, _arg_2:IRoomObjectSprite):String
        {
            return k.libraryAssetName;
        }

        function resetSprite(k:IRoomObjectSprite)
        {
            k.asset = null;
            k.assetName = "";
            k.assetPosture = null;
            k.tag = "";
            k.flipH = false;
            k.flipV = false;
            k.offsetX = 0;
            k.offsetY = 0;
            k.relativeDepth = 0;
            k.clickHandling = false;
            k.filters = null;
        }

        function getBlendMode(k:Int):String
        {
            var _local_2= BlendMode.NORMAL;
            switch (k)
            {
                case LayerData.DEFAULT_INK:
                    
                case LayerData.INK_ADD:
                    _local_2 = BlendMode.ADD;
                    
                case LayerData.INK_DARKEN:
                    _local_2 = BlendMode.DARKEN;
                    
                case LayerData.INK_SUBTRACT:
                    _local_2 = BlendMode.SUBTRACT;
                    
            }
            return _local_2;
        }

        function updateObject(k:Float, _arg_2:Float):Bool
        {
            var _local_4:Float;
            var _local_5:Int;
            var _local_3= object;
            if (_local_3 == null)
            {
                return false;
            }
            if ((((!(_objectUpdateID == _local_3.getUpdateID())) || (!(k == _currentScale))) || (!(_arg_2 == this._lastCameraAngle))))
            {
                _local_4 = (_local_3.getDirection().x - (_arg_2 + 135));
                _local_4 = (((_local_4 % 360) + 360) % 360);
                if (this._data != null)
                {
                    _local_5 = this._data._Str_15687(Std.int(k), Std.int(_local_4));
                    this.direction = _local_5;
                }
                _objectUpdateID = _local_3.getUpdateID();
                this._lastCameraAngle = _arg_2;
                _currentScale = Std.int(k);
                this.updateAssetAndSpriteCache(k, this._direction);
                return true;
            }
            return false;
        }

        function updateModel(k:Float):Bool
        {
            var _local_4:Float;
            var _local_2= object;
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= _local_2.getModel();
            if (_local_3 == null)
            {
                return false;
            }
            if (_modelUpdateID != _local_3.getUpdateID())
            {
                this._selectedColor = Std.int(_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_COLOR));
                var _local_5= (_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_INVISIBLE_LAYER) > 0);
                if (_local_5 != this._invisibleLayer)
                {
                    this._invisibleLayer = _local_5;
                    this._Str_11460 = true;
                }
                _local_4 = _local_3.getNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER);
                if (Math.isNaN(_local_4))
                {
                    _local_4 = 1;
                }
                if (_local_4 != this._Str_1240)
                {
                    this._Str_1240 = _local_4;
                    this._Str_11460 = true;
                }
                this._clickUrl = this.getAdClickUrl(_local_3);
                this._clickHandling = (((!(this._clickUrl == null)) && (!(this._clickUrl == ""))) && (this._clickUrl.indexOf("http") == 0));
                this.Z_MULTIPLIER = _local_3.getNumber(RoomObjectVariableEnum.FURNITURE_LIFT_AMOUNT);
                _modelUpdateID = _local_3.getUpdateID();
                return true;
            }
            return false;
        }

        function getAdClickUrl(k:IRoomObjectModel):String
        {
            return k.getString(RoomObjectVariableEnum.FURNITURE_AD_URL);
        }

        function updateAnimation(k:Float):Int
        {
            return 0;
        }

        function updateAssetAndSpriteCache(k:Float, _arg_2:Int)
        {
            if (((!(this._updatedLayers == _arg_2)) || (!(this._furnitureLift == k))))
            {
                this._assetNames = [];
                this._assetNamesFrame = [];
                this._spriteTags = [];
                this._spriteAlphas = [];
                this._spriteColors = [];
                this._spriteXOffsets = [];
                this._spriteYOffsets = [];
                this._spriteZOffsets = [];
                this._spriteMouseCaptures = [];
                this._spriteInks = [];
                this._updatedLayers = _arg_2;
                this._furnitureLift = k;
                this._cacheSize = this._Str_3033(Std.int(k));
                this.updateLayerCount((this._data.getLayerCount(Std.int(k)) + this.getAdditionalSpriteCount()));
            }
        }

        function updateLayerCount(k:Int)
        {
            this._Str_3416 = k;
            this._Str_13574 = (this._Str_3416 - this.getAdditionalSpriteCount());
        }

        function getAdditionalSpriteCount():Int
        {
            return 1;
        }

        function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            return 0;
        }

        function getPostureForAssetFile(k:Int, _arg_2:String):String
        {
            return null;
        }

        function getAsset(k:String, _arg_2:Int=-1):IGraphicAsset
        {
            var _local_3:IGraphicAsset;
            if (assetCollection != null)
            {
                _local_3 = assetCollection.getAsset(k);
                return _local_3;
            }
            return null;
        }

        function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            if (((this._data == null) || (_arg_2 >= FurnitureVisualizationData.LAYER_NAMES.length)))
            {
                return "";
            }
            var _local_3:String = this._assetNames[_arg_2];
            var _local_4:Bool = this._assetNamesFrame[_arg_2];
            if (((_local_3 == null) || (_local_3.length == 0)))
            {
                _local_3 = this.getSpriteAssetNameWithoutFrame(k, _arg_2, true);
                _local_4 = (!(this._cacheSize == 1));
            }
            if (_local_4)
            {
                _local_3 = (_local_3 + this.getFrameNumber(k, _arg_2));
            }
            return _local_3;
        }

        function getSpriteAssetNameWithoutFrame(k:Int, _arg_2:Int, _arg_3:Bool):String
        {
            var _local_4= this._type;
            var _local_5= "";
            var _local_6= (_arg_3 ? this._cacheSize : this._Str_3033(k));
            var _local_7:ASAny = (!(_local_6 == 1));
            if (_arg_2 != this._Str_13574)
            {
                _local_5 = FurnitureVisualizationData.LAYER_NAMES[_arg_2];
            }
            else
            {
                _local_5 = "sd";
            }
            _local_4 = (_local_4 + (_local_7 ? (((((("_" + _local_6) + "_") + _local_5) + "_") + this._direction) + "_") : ("_icon_" + _local_5)));
            if (_arg_3)
            {
                this._assetNames[_arg_2] = _local_4;
                this._assetNamesFrame[_arg_2] = _local_7;
            }
            return _local_4;
        }

        function getSpriteTag(k:Int, _arg_2:Int, _arg_3:Int):String
        {
            if (this._spriteTags[_arg_3] != null)
            {
                return this._spriteTags[_arg_3];
            }
            if (this._data == null)
            {
                return "";
            }
            var _local_4= this._data._Str_6014(k, _arg_2, _arg_3);
            this._spriteTags[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteFilters(k:Int, _arg_2:Int, _arg_3:Int):Array<ASAny>
        {
            return null;
        }

        function getSpriteAlpha(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (((!(this._spriteAlphas[_arg_3] == null)) && (!this._Str_11460)))
            {
                return ASCompat.toInt(this._spriteAlphas[_arg_3]);
            }
            if (this._data == null)
            {
                return LayerData.DEFAULT_ALPHA;
            }
            var _local_4= this._data._Str_11350(k, _arg_2, _arg_3);
            _local_4 = Std.int(_local_4 * this._Str_1240);
            this._spriteAlphas[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (this._spriteColors[_arg_2] != null)
            {
                return ASCompat.toInt(this._spriteColors[_arg_2]);
            }
            if (this._data == null)
            {
                return ColorData.DEFAULT_COLOR;
            }
            var _local_4= this._data.getColor(k, _arg_2, _arg_3);
            this._spriteColors[_arg_2] = _local_4;
            return _local_4;
        }

        function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (this._spriteXOffsets[_arg_3] != null)
            {
                return ASCompat.toInt(this._spriteXOffsets[_arg_3]);
            }
            if (this._data == null)
            {
                return LayerData.DEFAULT_X_OFFSET;
            }
            var _local_4= this._data._Str_10372(k, _arg_2, _arg_3);
            this._spriteXOffsets[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4:Int;
            if (_arg_3 != this._Str_13574)
            {
                if (this._spriteYOffsets[_arg_3] != null)
                {
                    return ASCompat.toInt(this._spriteYOffsets[_arg_3]);
                }
                if (this._data != null)
                {
                    _local_4 = this._data._Str_10926(k, _arg_2, _arg_3);
                    this._spriteYOffsets[_arg_3] = _local_4;
                    return _local_4;
                }
                return LayerData.DEFAULT_Y_OFFSET;
            }
            return Math.ceil((this.Z_MULTIPLIER * (k / 2)));
        }

        function getSpriteMouseCapture(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            if (this._spriteMouseCaptures[_arg_3] != null)
            {
                return this._spriteMouseCaptures[_arg_3];
            }
            if (this._data == null)
            {
                return true;
            }
            var _local_4:ASAny = (!this._data._Str_12280(k, _arg_2, _arg_3));
            this._spriteMouseCaptures[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteInk(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (this._spriteInks[_arg_3] != null)
            {
                return ASCompat.toInt(this._spriteInks[_arg_3]);
            }
            if (this._data == null)
            {
                return LayerData.DEFAULT_INK;
            }
            var _local_4= this._data._Str_10682(k, _arg_2, _arg_3);
            this._spriteInks[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            if (this._spriteZOffsets[_arg_3] != null)
            {
                return ASCompat.toNumber(this._spriteZOffsets[_arg_3]);
            }
            if (this._data == null)
            {
                return LayerData.DEFAULT_Z_OFFSET;
            }
            var _local_4= this._data._Str_8329(k, _arg_2, _arg_3);
            this._spriteZOffsets[_arg_3] = _local_4;
            return _local_4;
        }

        function getSpriteFlipH(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            return false;
        }

        function _Str_3033(k:Int):Int
        {
            if (this._data != null)
            {
                return this._data._Str_3033(k);
            }
            return k;
        }

        var data(get,never):FurnitureVisualizationData;
function  get_data():FurnitureVisualizationData
        {
            return this._data;
        }

        
        public var filters(get,set):Array<ASAny>;
function  set_filters(k:Array<ASAny>):Array<ASAny>        {
            this._filters = k;
            this._filtersChanged = true;
return k;
        }
function  get_filters():Array<ASAny>
        {
            return this._filters;
        }
    }

