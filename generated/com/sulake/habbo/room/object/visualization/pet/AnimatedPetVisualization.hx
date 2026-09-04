package com.sulake.habbo.room.object.visualization.pet
;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureAnimatedVisualization;
    import com.sulake.habbo.room.object.visualization.data.AnimationStateData;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.habbo.room.object.visualization.data.AnimationData;
    import com.sulake.habbo.room.object.visualization.data.AnimationFrame;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.habbo.room.object.visualization.data.LayerData;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.data.DirectionData;

     class AnimatedPetVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final HEAD= "head";
        static inline final SADDLE= "saddle";
        static inline final HAIR= "hair";
        static inline final ADDITIONAL_SPRITE_COUNT= 1;
        static inline final EXPERIENCE_BUBBLE_VISIBLE_IN_MS= 1000;
        static inline final PET_EXPERIENCE_BUBBLE_PNG= "pet_experience_bubble_png";
        static inline final POSTURE_ANIMATION_INDEX= 0;
        static inline final GESTURE_ANIMATION_INDEX= 1;
        static inline final ANIMATION_INDEX_COUNT= 2;

        var _posture:String = "";
        var _gesture:String = "";
        var _isSleeping:Bool = false;
        var _headDirection:Int = 0;
        var _experienceData:ExperienceData;
        var _experienceTimeStamp:Int = 0;
        var _experience:Int = 0;
        var _animationData:AnimatedPetVisualizationData = null;
        var _paletteName:String = "";
        var _paletteIndex:Int = -1;
        var _customLayerIds:Array<ASAny>;
        var _customPartIds:Array<ASAny>;
        var _customPaletteIds:Array<ASAny>;
        var _color:Int = 0xFFFFFF;
        var _headOnly:Bool = false;
        var _isRiding:Bool = false;
        var _animationStates:Array<ASAny>;
        var _animationOver:Bool = false;
        var _headSprites:Array<ASAny>;
        var _nonHeadSprites:Array<ASAny>;
        var _saddleSprites:Array<ASAny>;
        var _previousAnimationDirection:Int = -1;

        public function new()
        {
            this._customLayerIds = [];
            this._customPartIds = [];
            this._customPaletteIds = [];
            this._animationStates = [];
            this._headSprites = [];
            this._nonHeadSprites = [];
            this._saddleSprites = [];
            super();
            while (this._animationStates.length < ANIMATION_INDEX_COUNT)
            {
                this._animationStates.push(new AnimationStateData());
            }
        }

        override public function dispose()
        {
            var k:Int;
            var _local_2:AnimationStateData;
            super.dispose();
            if (this._animationStates != null)
            {
                k = 0;
                while (k < this._animationStates.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._animationStates[k] , AnimationStateData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._animationStates = null;
            }
            if (this._experienceData != null)
            {
                this._experienceData.dispose();
                this._experienceData = null;
            }
        }

        override function getAnimationId(k:AnimationStateData):Int
        {
            return k.animationId;
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            var _local_3:BitmapDataAsset;
            if (!Std.is(k , AnimatedPetVisualizationData))
            {
                return false;
            }
            this._animationData = Std.downcast(k , AnimatedPetVisualizationData);
            var _local_2:BitmapData;
            if (this._animationData._Str_14822 != null)
            {
                _local_3 = Std.downcast(this._animationData._Str_14822.getAssetByName(PET_EXPERIENCE_BUBBLE_PNG) , BitmapDataAsset);
                if (_local_3 != null)
                {
                    _local_2 = ASCompat.dynamicAs(_local_3.content , BitmapData).clone();
                    this._experienceData = new ExperienceData(_local_2);
                }
            }
            if (super.initialize(k))
            {
                return true;
            }
            return false;
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            super.update(k, _arg_2, _arg_3, _arg_4);
            this.updateExperienceBubble(_arg_2);
        }

        override function updateAnimation(k:Float):Int
        {
            var _local_3:Int;
            var _local_2= object;
            if (_local_2 != null)
            {
                _local_3 = Std.int(_local_2.getDirection().x);
                if (_local_3 != this._previousAnimationDirection)
                {
                    this._previousAnimationDirection = _local_3;
                    this.resetAllAnimationFrames();
                }
            }
            return super.updateAnimation(k);
        }

        override function updateModel(k:Float):Bool
        {
            var _local_4:String;
            var _local_5:String;
            var _local_6:Float;
            var _local_7:Float;
            var _local_8:Float;
            var _local_9:Float;
            var _local_10:Int;
            var _local_11:Array<ASAny>;
            var _local_12:Array<ASAny>;
            var _local_13:Array<ASAny>;
            var _local_14:Int;
            var _local_15:Float;
            var _local_16:Int;
            var _local_17:Int;
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
            if (_local_3.getUpdateID() != _modelUpdateID)
            {
                _local_4 = _local_3.getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                _local_5 = _local_3.getString(RoomObjectVariableEnum.FIGURE_GESTURE);
                _local_6 = _local_3.getNumber(RoomObjectVariableEnum.FIGURE_POSTURE);
                if (!Math.isNaN(_local_6))
                {
                    _local_16 = this._animationData._Str_17398(_currentScale);
                    if (_local_16 > 0)
                    {
                        _local_4 = this._animationData._Str_14207(_currentScale, Std.int(_local_6 % _local_16), true);
                        _local_5 = null;
                    }
                }
                _local_7 = _local_3.getNumber(RoomObjectVariableEnum.FIGURE_GESTURE);
                if (!Math.isNaN(_local_7))
                {
                    _local_17 = this._animationData._Str_16869(_currentScale);
                    if (_local_17 > 0)
                    {
                        _local_5 = this._animationData._Str_17844(_currentScale, Std.int(_local_7 % _local_17));
                    }
                }
                this.validateActions(_local_4, _local_5);
                _local_8 = _local_3.getNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER);
                if (Math.isNaN(_local_8))
                {
                    _local_8 = 1;
                }
                if (_local_8 != _Str_1240)
                {
                    _Str_1240 = _local_8;
                    _Str_11460 = true;
                }
                this._isSleeping = (_local_3.getNumber(RoomObjectVariableEnum.FIGURE_SLEEP) > 0);
                _local_9 = _local_3.getNumber(RoomObjectVariableEnum.HEAD_DIRECTION);
                if (((!Math.isNaN(_local_9)) && this._animationData.isAllowedToTurnHead))
                {
                    this._headDirection = Std.int(_local_9);
                }
                else
                {
                    this._headDirection = Std.int(_local_2.getDirection().x);
                }
                this._experienceTimeStamp = Std.int(_local_3.getNumber(RoomObjectVariableEnum.FIGURE_EXPERIENCE_TIMESTAMP));
                this._experience = Std.int(_local_3.getNumber(RoomObjectVariableEnum.FIGURE_GAINED_EXPERIENCE));
                _local_10 = Std.int(_local_3.getNumber(RoomObjectVariableEnum.PET_PALETTE_INDEX));
                if (_local_10 != this._paletteIndex)
                {
                    this._paletteIndex = _local_10;
                    this._paletteName = Std.string(this._paletteIndex);
                }
                _local_11 = _local_3.getNumberArray(RoomObjectVariableEnum.PET_CUSTOM_LAYER_IDS);
                this._customLayerIds = ((_local_11 != null) ? _local_11 : []);
                _local_12 = _local_3.getNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PARTS_IDS);
                this._customPartIds = ((_local_12 != null) ? _local_12 : []);
                _local_13 = _local_3.getNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PALETTE_IDS);
                this._customPaletteIds = ((_local_13 != null) ? _local_13 : []);
                _local_14 = Std.int(_local_3.getNumber(RoomObjectVariableEnum.PET_IS_RIDING));
                this._isRiding = ((!Math.isNaN(_local_14)) && (_local_14 > 0));
                _local_15 = _local_3.getNumber(RoomObjectVariableEnum.PET_COLOR);
                if (((!Math.isNaN(_local_15)) && (!(_local_15 == this._color))))
                {
                    this._color = Std.int(_local_15);
                }
                this._headOnly = (_local_3.getNumber(RoomObjectVariableEnum.PET_HEAD_ONLY) > 0);
                _modelUpdateID = _local_3.getUpdateID();
                return true;
            }
            return false;
        }

        function updateExperienceBubble(k:Int)
        {
            var _local_2:Int;
            var _local_3:IRoomObjectSprite;
            if (this._experienceData != null)
            {
                this._experienceData.alpha = 0;
                if (this._experienceTimeStamp > 0)
                {
                    _local_2 = (k - this._experienceTimeStamp);
                    if (_local_2 < EXPERIENCE_BUBBLE_VISIBLE_IN_MS)
                    {
                        this._experienceData.alpha = Std.int((Math.sin(((_local_2 / EXPERIENCE_BUBBLE_VISIBLE_IN_MS) * Math.PI)) * 0xFF));
                        this._experienceData.setExperience(this._experience);
                    }
                    else
                    {
                        this._experienceTimeStamp = 0;
                    }
                    _local_3 = getSprite((spriteCount - 1));
                    if (_local_3 != null)
                    {
                        if (this._experienceData.alpha > 0)
                        {
                            _local_3.asset = this._experienceData.image;
                            _local_3.offsetX = -20;
                            _local_3.offsetY = -80;
                            _local_3.alpha = this._experienceData.alpha;
                            _local_3.visible = true;
                        }
                        else
                        {
                            _local_3.asset = null;
                            _local_3.visible = false;
                        }
                    }
                }
            }
        }

        function validateActions(k:String, _arg_2:String)
        {
            var _local_3:Int;
            if (k != this._posture)
            {
                this._posture = k;
                _local_3 = this._animationData._Str_17648(_currentScale, k);
                this.setAnimationForIndex(POSTURE_ANIMATION_INDEX, _local_3);
            }
            if (this._animationData._Str_18284(_currentScale, k))
            {
                _arg_2 = null;
            }
            if (_arg_2 != this._gesture)
            {
                this._gesture = _arg_2;
                _local_3 = this._animationData._Str_18268(_currentScale, _arg_2);
                this.setAnimationForIndex(GESTURE_ANIMATION_INDEX, _local_3);
            }
        }

        override function updateLayerCount(k:Int)
        {
            super.updateLayerCount(k);
            this._headSprites = [];
        }

        override function getAdditionalSpriteCount():Int
        {
            return super.getAdditionalSpriteCount() + ADDITIONAL_SPRITE_COUNT;
        }

        override function setAnimation(k:Int)
        {
        }

        function getAnimationStateData(k:Int):AnimationStateData
        {
            var _local_2:AnimationStateData;
            if (((k >= 0) && (k < this._animationStates.length)))
            {
                _local_2 = this._animationStates[k];
                return _local_2;
            }
            return null;
        }

        function setAnimationForIndex(k:Int, _arg_2:Int)
        {
            var _local_3= this.getAnimationStateData(k);
            if (_local_3 != null)
            {
                if (_Str_17687(_local_3, _arg_2))
                {
                    this._animationOver = false;
                }
            }
        }

        override function resetAllAnimationFrames()
        {
            var _local_2:AnimationStateData;
            this._animationOver = false;
            var k= (this._animationStates.length - 1);
            while (k >= 0)
            {
                _local_2 = this._animationStates[k];
                if (_local_2 != null)
                {
                    _local_2.setLayerCount(_Str_24695);
                }
                k--;
            }
        }

        override function updateAnimations(k:Float):Int
        {
            var _local_5:AnimationStateData;
            var _local_6:Int;
            if (this._animationOver)
            {
                return 0;
            }
            var _local_2= true;
            var _local_3 = 0;
            var _local_4 = 0;
            while (_local_4 < this._animationStates.length)
            {
                _local_5 = this._animationStates[_local_4];
                if (_local_5 != null)
                {
                    if (!_local_5._Str_5293)
                    {
                        _local_6 = _Str_18198(_local_5, k);
                        _local_3 = (_local_3 | _local_6);
                        if (!_local_5._Str_5293)
                        {
                            _local_2 = false;
                        }
                        else
                        {
                            if ((AnimationData.isTransitionFromAnimation(_local_5.animationId) || AnimationData.isTransitionToAnimation(_local_5.animationId)))
                            {
                                this.setAnimationForIndex(_local_4, _local_5._Str_5355);
                                _local_2 = false;
                            }
                        }
                    }
                }
                _local_4++;
            }
            this._animationOver = _local_2;
            return _local_3;
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            var _local_4:AnimationStateData;
            var _local_5:AnimationFrame;
            var _local_3= (this._animationStates.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = this._animationStates[_local_3];
                if (_local_4 != null)
                {
                    _local_5 = _local_4.getFrame(_arg_2);
                    if (_local_5 != null)
                    {
                        return _local_5.id;
                    }
                }
                _local_3--;
            }
            return super.getFrameNumber(k, _arg_2);
        }

        override function getPostureForAssetFile(k:Int, _arg_2:String):String
        {
            var _local_7:String;
            var _local_3:Array<ASAny> = (cast _arg_2.split("_"));
            var _local_4= _local_3.length;
            var _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                if (((_local_3[_local_5] == "64") || (_local_3[_local_5] == "32")))
                {
                    _local_4 = (_local_5 + 3);
                    break;
                }
                _local_5++;
            }
            var _local_6:String = null;
            if (_local_4 < _local_3.length)
            {
                _local_7 = _local_3[_local_4];
                _local_7 = _local_7.split("@")[0];
                _local_6 = this._animationData._Str_14207(k, Std.int(ASCompat.toInt(_local_7) / 100), false);
                if (_local_6 == null)
                {
                    _local_6 = this._animationData._Str_17976(k, Std.int(ASCompat.toInt(_local_7) / 100));
                }
            }
            return _local_6;
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_6:AnimationStateData;
            var _local_7:AnimationFrame;
            var _local_4= super.getSpriteXOffset(k, _arg_2, _arg_3);
            var _local_5= (this._animationStates.length - 1);
            while (_local_5 >= 0)
            {
                _local_6 = this._animationStates[_local_5];
                if (_local_6 != null)
                {
                    _local_7 = _local_6.getFrame(_arg_3);
                    if (_local_7 != null)
                    {
                        _local_4 = (_local_4 + _local_7.x);
                    }
                }
                _local_5--;
            }
            return _local_4;
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_6:AnimationStateData;
            var _local_7:AnimationFrame;
            var _local_4= super.getSpriteYOffset(k, _arg_2, _arg_3);
            var _local_5= (this._animationStates.length - 1);
            while (_local_5 >= 0)
            {
                _local_6 = this._animationStates[_local_5];
                if (_local_6 != null)
                {
                    _local_7 = _local_6.getFrame(_arg_3);
                    if (_local_7 != null)
                    {
                        _local_4 = (_local_4 + _local_7.y);
                    }
                }
                _local_5--;
            }
            return _local_4;
        }

        override function getAsset(k:String, _arg_2:Int=-1):IGraphicAsset
        {
            var _local_3:Int;
            var _local_4:String;
            var _local_5:Int;
            var _local_6:Int;
            var _local_7:IGraphicAsset;
            if (assetCollection != null)
            {
                _local_3 = this._customLayerIds.indexOf(_arg_2);
                _local_4 = this._paletteName;
                _local_5 = -1;
                _local_6 = -1;
                if (_local_3 > -1)
                {
                    _local_5 = ASCompat.toInt(this._customPartIds[_local_3]);
                    _local_6 = ASCompat.toInt(this._customPaletteIds[_local_3]);
                    _local_4 = ((_local_6 > -1) ? Std.string(_local_6) : this._paletteName);
                }
                if (((!Math.isNaN(_local_5)) && (_local_5 > -1)))
                {
                    k = (k + ("_" + _local_5));
                }
                _local_7 = assetCollection.getAssetWithPalette(k, _local_4);
                return _local_7;
            }
            return null;
        }

        override function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            if (this._animationData == null)
            {
                return LayerData.DEFAULT_Z_OFFSET;
            }
            var _local_4= this._animationData._Str_8329(k, this.getDirection(k, _arg_3), _arg_3);
            return _local_4;
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_4:Int;
            var _local_5:String;
            if ((this._headOnly && this.isNonHeadSprite(_arg_2)))
            {
                return null;
            }
            if ((this._isRiding && this._parser3(_arg_2)))
            {
                return null;
            }
            var _local_3= spriteCount;
            if (_arg_2 < (_local_3 - ADDITIONAL_SPRITE_COUNT))
            {
                _local_4 = _Str_3033(k);
                if (_arg_2 < (_local_3 - (1 + ADDITIONAL_SPRITE_COUNT)))
                {
                    if (_arg_2 >= FurnitureVisualizationData.LAYER_NAMES.length)
                    {
                        return null;
                    }
                    _local_5 = FurnitureVisualizationData.LAYER_NAMES[_arg_2];
                    if (_local_4 == 1)
                    {
                        return (type + "_icon_") + _local_5;
                    }
                    return (((((((type + "_") + _local_4) + "_") + _local_5) + "_") + this.getDirection(k, _arg_2)) + "_") + this.getFrameNumber(_local_4, _arg_2);
                }
                return ((((type + "_") + _local_4) + "_sd_") + this.getDirection(k, _arg_2)) + "_0";
            }
            return null;
        }

        override function getSpriteColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (_arg_2 < (spriteCount - ADDITIONAL_SPRITE_COUNT))
            {
                return this._color;
            }
            return 0xFFFFFF;
        }

        function getDirection(k:Int, _arg_2:Int):Int
        {
            if (this.isHeadSprite(_arg_2))
            {
                return this._animationData._Str_15687(k, this._headDirection);
            }
            return direction;
        }

        function isHeadSprite(k:Int):Bool
        {
            var _local_2:Bool;
            var _local_3:Bool;
            if (this._headSprites[k] == null)
            {
                _local_2 = (this._animationData._Str_6014(_currentScale, DirectionData.USE_DEFAULT_DIRECTION, k) == HEAD);
                _local_3 = (this._animationData._Str_6014(_currentScale, DirectionData.USE_DEFAULT_DIRECTION, k) == HAIR);
                if ((_local_2 || _local_3))
                {
                    this._headSprites[k] = true;
                }
                else
                {
                    this._headSprites[k] = false;
                }
            }
            return this._headSprites[k];
        }

        function isNonHeadSprite(k:Int):Bool
        {
            var _local_2:String;
            if (this._nonHeadSprites[k] == null)
            {
                if (k < (spriteCount - (1 + ADDITIONAL_SPRITE_COUNT)))
                {
                    _local_2 = this._animationData._Str_6014(_currentScale, DirectionData.USE_DEFAULT_DIRECTION, k);
                    if (((((!(_local_2 == null)) && (_local_2.length > 0)) && (!(_local_2 == HEAD))) && (!(_local_2 == HAIR))))
                    {
                        this._nonHeadSprites[k] = true;
                    }
                    else
                    {
                        this._nonHeadSprites[k] = false;
                    }
                }
                else
                {
                    this._nonHeadSprites[k] = true;
                }
            }
            return this._nonHeadSprites[k];
        }

        function _parser3(k:Int):Bool
        {
            if (this._saddleSprites[k] == null)
            {
                if (this._animationData._Str_6014(_currentScale, DirectionData.USE_DEFAULT_DIRECTION, k) == SADDLE)
                {
                    this._saddleSprites[k] = true;
                }
                else
                {
                    this._saddleSprites[k] = false;
                }
            }
            return this._saddleSprites[k];
        }
    }

