package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar.actions.IActiveActionData;
    import com.sulake.habbo.avatar.alias.AssetAliasCollection;
    import com.sulake.habbo.avatar.cache.AvatarImageCache;
    import com.sulake.habbo.avatar.animation.IAvatarDataContainer;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar.actions.ActiveActionData;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar._enum.AvatarDirectionAngle;
    import com.sulake.habbo.avatar.animation.ISpriteDataContainer;
    import com.sulake.habbo.avatar.animation.IAnimationLayerData;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.filters.ConvolutionFilter;
    import flash.geom.Rectangle;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.avatar.actions.ActionDefinition;
    import com.sulake.habbo.avatar.actions.IActionDefinition;
    import com.sulake.habbo.avatar.animation.Animation;
    import flash.filters.ColorMatrixFilter;

     class AvatarImage implements IAvatarImage implements  IDisposable implements  _Str_936 
    {
        static inline final CHANNELS_EQUAL= "CHANNELS_EQUAL";
        static inline final CHANNELS_UNIQUE= "CHANNELS_UNIQUE";
        static inline final CHANNELS_RED= "CHANNELS_RED";
        static inline final CHANNELS_GREEN= "CHANNELS_GREEN";
        static inline final CHANNELS_BLUE= "CHANNELS_BLUE";
        static inline final CHANNELS_SATURATED= "CHANNELS_SATURATED";
        static inline final DEFAULT= "Default";
        static inline final DEFAULT_DIR= 2;
        static final DEFAULT_AVATAR_SET:String = AvatarSetType.FULL;//"full"

        var _Str_581:AvatarStructure;
        var _scale:String;
        var _Str_1668:Int = 0;
        var _Str_1374:Int = 0;
        var _Str_1708:IActiveActionData;
        var _Str_580:Bool = false;
        var _Str_903:Array<ASAny>;
        var _assets:AssetAliasCollection;
        var _Str_586:AvatarImageCache;
        var _figure:AvatarFigureContainer;
        var _avatarDataContainer:IAvatarDataContainer;
        var _Str_614:Array<ASAny>;
        var _image:BitmapData;
        var _defaultAction:IActiveActionData;
        var _frameCounter:Int = 0;
        var _directionOffset:Int = 0;
        var _useTextures:Bool = false;
        var _layersInUse:Array<ASAny>;
        var _isAnimating:Bool = false;
        var _gpuMode:Bool = false;
        var _animationHasResetOnToggle:Bool = false;
        var _Str_1163:Array<ASAny>;
        var _lastActionsStr:String;
        var _currentActionsStr:String;
        var _fullImageCache:Map;
        var _Str_1586:Bool = false;
        var _actionsSorted:Bool = false;
        var _effectIdInUse:Int = -1;
        var _animFrameCount:Int = 0;
        var _Str_1945:Array<ASAny>;
        var _cachedBodyPartsDirection:Int = -1;
        var _cachedBodyPartsGeometryType:String = null;
        var _cachedBodyPartsAvatarSet:String = null;
        var _effectAssetDownloadManager:EffectAssetDownloadManager;
        var _Str_1153:_Str_936;

        public function new(k:AvatarStructure, _arg_2:AssetAliasCollection, _arg_3:AvatarFigureContainer, _arg_4:String, _arg_5:EffectAssetDownloadManager, _arg_6:_Str_936)
        {
            this._Str_903 = new Array<ASAny>();
            this._Str_614 = [];
            this._Str_1945 = [];
            this._useTextures = true;
            this._effectAssetDownloadManager = _arg_5;
            this._Str_581 = k;
            this._assets = _arg_2;
            this._scale = _arg_4;
            this._Str_1153 = _arg_6;
            if (this._scale == null)
            {
                this._scale = AvatarScaleType.LARGE;
            }
            if (_arg_3 == null)
            {
                _arg_3 = new AvatarFigureContainer("hr-893-45.hd-180-2.ch-210-66.lg-270-82.sh-300-91.wa-2007-.ri-1-");
                Logger.log(["Using default avatar figure"]);
            }
            this._figure = _arg_3;
            this._Str_586 = new AvatarImageCache(this._Str_581, this, this._assets, this._scale);
            this.setDirection(DEFAULT_AVATAR_SET, DEFAULT_DIR);
            this._Str_614 = new Array<ASAny>();
            this._defaultAction = new ActiveActionData(AvatarAction.POSTURE_STAND);
            this._defaultAction.definition = this._Str_581._Str_1675(DEFAULT);
            this._Str_1632();
            this._fullImageCache = new Map();
        }

        public function _Str_1009():Array<ASAny>
        {
            this.errorThis(AvatarSetType.FULL);
            return this._Str_586._Str_1009();
        }

        public function dispose()
        {
            var k:BitmapData = null;
            if (!this._Str_580)
            {
                this._Str_581 = null;
                this._assets = null;
                this._Str_1708 = null;
                this._figure = null;
                this._avatarDataContainer = null;
                this._Str_614 = null;
                if (this._image != null)
                {
                    this._image.dispose();
                }
                if (this._Str_586 != null)
                {
                    this._Str_586.dispose();
                    this._Str_586 = null;
                }
                if (this._fullImageCache != null)
                {
                    final _iter_ = this._fullImageCache; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                    {
k  = _tmp_;
                        k.dispose();
                    }
                    this._fullImageCache.dispose();
                    this._fullImageCache = null;
                }
                this._image = null;
                this._Str_903 = null;
                this._Str_580 = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._Str_580;
        }

        public function _Str_784():IAvatarFigureContainer
        {
            return this._figure;
        }

        public function scale():String
        {
            return this._scale;
        }

        public function _Str_867(k:String):IPartColor
        {
            return this._Str_581._Str_867(this._figure, k);
        }

        public function setDirection(k:String, _arg_2:Int)
        {
            _arg_2 = (_arg_2 + this._directionOffset);
            if (_arg_2 < AvatarDirectionAngle._Str_1562)
            {
                _arg_2 = (AvatarDirectionAngle._Str_1257 + (_arg_2 + 1));
            }
            if (_arg_2 > AvatarDirectionAngle._Str_1257)
            {
                _arg_2 = (_arg_2 - (AvatarDirectionAngle._Str_1257 + 1));
            }
            if (this._Str_581._Str_1939(k))
            {
                this._Str_1668 = _arg_2;
            }
            if (((k == AvatarSetType.HEAD) || (k == AvatarSetType.FULL)))
            {
                if (((k == AvatarSetType.HEAD) && this.resetActions()))
                {
                    _arg_2 = this._Str_1668;
                }
                this._Str_1374 = _arg_2;
            }
            this._Str_586.setDirection(k, _arg_2);
            this._useTextures = true;
        }

        public function setDirectionAngle(k:String, _arg_2:Int)
        {
            var _local_3 = 0;
            _local_3 = Std.int(_arg_2 / 45);
            this.setDirection(k, _local_3);
        }

        public function _Str_754():Array<ASAny>
        {
            return this._layersInUse;
        }

        public function _Str_781():Array<ASAny>
        {
            return this._Str_903;
        }

        public function getLayerData(k:ISpriteDataContainer):IAnimationLayerData
        {
            return this._Str_581.getBodyPartData(k.animation.id, this._frameCounter, k.id);
        }

        public function _Str_953(k:Int=1)
        {
            this._frameCounter = (this._frameCounter + k);
            this._useTextures = true;
        }

        public function _Str_833()
        {
            this._frameCounter = 0;
            this._useTextures = true;
        }

        function getFullImageCacheKey():String
        {
            var k:IActiveActionData = null;
            var _local_2 = 0;
            if (!this._actionsSorted)
            {
                return null;
            }
            if (((this._Str_1163.length == 1) && (this._Str_1668 == this._Str_1374)))
            {
                if (((this._currentActionsStr == "std") || (this._currentActionsStr == "lay")) || (this._currentActionsStr == "sit"))
                {
                    return (Std.string(this._Str_1668) + this._currentActionsStr) + Std.string(this._frameCounter % 8);
                }
                return (Std.string(this._Str_1668) + this._currentActionsStr) + Std.string(this._frameCounter % 4);
            }
            if (this._Str_1163.length == 2)
            {
                final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (((k.actionType == "fx") && ((((k.actionParameter == "33") || (k.actionParameter == "34")) || (k.actionParameter == "35")) || (k.actionParameter == "36"))))
                    {
                        return (Std.string(this._Str_1668) + this._currentActionsStr) + Std.string(0);
                    }
                    if (((k.actionType == "fx") && ((k.actionParameter == "38") || (k.actionParameter == "39"))))
                    {
                        _local_2 = (this._frameCounter % 11);
                        return (((Std.string(this._Str_1668) + "_") + Std.string(this._Str_1374)) + this._currentActionsStr) + Std.string(_local_2);
                    }
                }
            }
            return null;
        }

        function getBodyParts(k:String, _arg_2:String, _arg_3:Int):Array<ASAny>
        {
            if ((((!(_arg_3 == this._cachedBodyPartsDirection)) || (!(_arg_2 == this._cachedBodyPartsGeometryType))) || (!(k == this._cachedBodyPartsAvatarSet))))
            {
                this._cachedBodyPartsDirection = _arg_3;
                this._cachedBodyPartsGeometryType = _arg_2;
                this._cachedBodyPartsAvatarSet = k;
                this._Str_1945 = this._Str_581.getBodyParts(k, _arg_2, _arg_3);
            }
            return this._Str_1945;
        }

        public function errorThis(k:String)
        {
            var _local_4:String = null;
            var _local_5:AvatarImageBodyPartContainer = null;
            if (this._Str_1708 == null)
            {
                return;
            }
            var _local_2= this._Str_581.getCanvas(this._scale, this._Str_1708.definition.geometryType);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this.getBodyParts(k, this._Str_1708.definition.geometryType, this._Str_1668);
            var _local_6= (_local_3.length - 1);
            while (_local_6 >= 0)
            {
                _local_4 = _local_3[_local_6];
                _local_5 = this._Str_586.getImageContainer(_local_4, this._frameCounter, true);
                _local_6--;
            }
        }

        public function getImage(k:String, _arg_2:Bool, _arg_3:Float=1):BitmapData
        {
            var _local_7:String = null;
            var _local_8:AvatarImageBodyPartContainer = null;
            var _local_9:BitmapData = null;
            var _local_10:Point = null;
            var _local_13:BitmapData = null;
            var _local_14:BitmapData = null;
            var _local_15:Matrix = null;
            if (!this._useTextures)
            {
                return this._image;
            }
			
            if (this._Str_1708 == null)
            {
                return null;
            }
			
            if (!this._animationHasResetOnToggle)
            {
                this._Str_962();
            }
			
            var _local_4= this.getFullImageCacheKey();
            if (_local_4 != null)
            {
                if (this.getFullImage(_local_4) != null)
                {
                    this._useTextures = false;
                    if (_arg_2)
                    {
                        return this.getFullImage(_local_4) .clone();
                    }
                    this._image = this.getFullImage(_local_4) ;
                    this._Str_1586 = true;
                    return this._image;
                }
            }
			
            var _local_5= this._Str_581.getCanvas(this._scale, this._Str_1708.definition.geometryType);
            if (_local_5 == null)
            {
                return null;
            }
			
            if (((this._Str_1586 || (this._image == null)) || ((!(this._image.width == _local_5.width)) || (!(this._image.height == _local_5.height)))))
            {
                if (((!(this._image == null)) && (!this._Str_1586)))
                {
                    this._image.dispose();
                }
                this._image = new BitmapData(_local_5.width, _local_5.height, true, 0);
                this._Str_1586 = false;
            }
			
            var _local_6= this.getBodyParts(k, this._Str_1708.definition.geometryType, this._Str_1668);
            this._image.lock();
            this._image.fillRect(this._image.rect, 0);
            var _local_11= true;
            var _local_12= (_local_6.length - 1);
            while (_local_12 >= 0)
            {
                _local_7 = _local_6[_local_12];
                _local_8 = this._Str_586.getImageContainer(_local_7, this._frameCounter);
                if (_local_8 != null)
                {
                    _local_11 = (_local_11 && _local_8.isCacheable);
                    _local_9 = _local_8.image;
                    _local_10 = _local_8._Str_1076.add(_local_5.offset);
                    if (((_local_9 != null) && (_local_10 != null)))
                    {
                        _local_10 = _local_10.add(_local_5._Str_1076);
                        this._image.copyPixels(_local_9, _local_9.rect, _local_10, null, null, true);
                    }
                }
                _local_12--;
            }
            this._image.unlock();
            this._useTextures = false;
            if (this._avatarDataContainer != null)
            {
                if (this._avatarDataContainer.paletteIsGrayscale)
                {
                    _local_13 = this.convertToGrayscale(this._image);
                    if (this._image != null)
                    {
                        this._image.dispose();
                    }
                    this._image = _local_13;
                    this._image.paletteMap(this._image, this._image.rect, new Point(0, 0), (cast this._avatarDataContainer.reds), [], []);
                }
                else
                {
                    this._image.copyChannel(this._image, this._image.rect, new Point(0, 0), 2, 8);
                }
            }
            if (((!(_local_4 == null)) && _local_11))
            {
                this.cacheFullImage(_local_4, this._image.clone());
            }
            if (_arg_3 != 1)
            {
                _local_14 = new BitmapData(Std.int(this._image.width * _arg_3), Std.int(this._image.height * _arg_3), true, 0);
                _local_15 = new Matrix();
                _local_15.scale(_arg_3, _arg_3);
                _local_14.draw(this._image, _local_15, null, null, null, true);
                _local_14.applyFilter(_local_14, _local_14.rect, new Point(), this._Str_1901());
                this._image = _local_14;
            }
            if (((this._image != null) && _arg_2))
            {
                return this._image.clone();
            }
            return this._image;
        }

        function _Str_1901():ConvolutionFilter
        {
            var k:Float = 8;
            var _local_2= (k / -100);
            var _local_3= ((_local_2 * -8) + 1);
            var _local_4:Array<ASAny> = [_local_2, _local_2, _local_2, _local_2, _local_3, _local_2, _local_2, _local_2, _local_2];
            return new ConvolutionFilter(3, 3, (cast _local_4), 1);
        }

public function getCroppedImage(k:String, _arg_2:Float=1):BitmapData
        {
            var _local_6:Rectangle = null;
            var _local_7:String = null;
            var _local_8:AvatarImageBodyPartContainer = null;
            var _local_9:BitmapData = null;
            var _local_10:Point = null;
            var _local_14:BitmapData = null;
            var _local_15:Matrix = null;
            if (this._Str_1708 == null)
            {
                return null;
            }
            if (!this._animationHasResetOnToggle)
            {
                this._Str_962();
            }
            var _local_3= this._Str_581.getCanvas(this._scale, this._Str_1708.definition.geometryType);
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= new BitmapData(_local_3.width, _local_3.height, true, 0xFFFFFF);
            var _local_5= this._Str_581.getBodyParts(k, this._Str_1708.definition.geometryType, this._Str_1668);
            var _local_11= new Rectangle();
            var _local_12= (_local_5.length - 1);
            while (_local_12 >= 0)
            {
                _local_7 = _local_5[_local_12];
                _local_8 = this._Str_586.getImageContainer(_local_7, this._frameCounter);
                if (_local_8 != null)
                {
                    _local_9 = _local_8.image;
                    if (_local_9 == null)
                    {
                        _local_4.dispose();
                        return null;
                    }
                    _local_10 = _local_8._Str_1076;
                    _local_4.copyPixels(_local_9, _local_9.rect, _local_10, null, null, true);
                    _local_11.x = _local_10.x;
                    _local_11.y = _local_10.y;
                    _local_11.width = _local_9.width;
                    _local_11.height = _local_9.height;
                    if (_local_6 == null)
                    {
                        _local_6 = _local_11.clone();
                    }
                    else
                    {
                        _local_6 = _local_6.union(_local_11);
                    }
                }
                _local_12--;
            }
            if (_local_6 == null)
            {
                _local_6 = new Rectangle(0, 0, 1, 1);
            }
            var _local_13= new BitmapData(Std.int(_local_6.width), Std.int(_local_6.height), true, 0xFFFFFF);
            _local_13.copyPixels(_local_4, _local_6, new Point(0, 0), null, null, true);
            _local_4.dispose();
            if (_arg_2 != 1)
            {
                _local_14 = new BitmapData(Std.int(_local_13.width * _arg_2), Std.int(_local_13.height * _arg_2), true, 0);
                _local_15 = new Matrix();
                _local_15.scale(_arg_2, _arg_2);
                _local_14.draw(_local_13, _local_15, null, null, null, true);
                _local_14.applyFilter(_local_14, _local_14.rect, new Point(), this._Str_1901());
                _local_13 = _local_14;
            }
            return _local_13;
        }

        function getFullImage(k:String):BitmapData
        {
            return this._fullImageCache.getValue(k);
        }

        function cacheFullImage(k:String, _arg_2:BitmapData)
        {
            if (this._fullImageCache.getValue(k))
            {
                ASCompat.dynamicAs(this._fullImageCache.getValue(k) , BitmapData).dispose();
                this._fullImageCache.remove(k);
            }
            this._fullImageCache.setProperty(k, _arg_2);
        }

        public function getAsset(k:String):BitmapDataAsset
        {
            return Std.downcast(this._assets.getAssetByName(k) , BitmapDataAsset);
        }

        public function getDirection():Int
        {
            return this._Str_1668;
        }

        public function _Str_913()
        {
            this._Str_614 = new Array<ASAny>();
            this._animationHasResetOnToggle = false;
            this._currentActionsStr = "";
            this._actionsSorted = false;
        }

        public function _Str_962()
        {
            var k:ActiveActionData = null;
            if (this.isHeadTurnPreventedByAction())
            {
                final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (k.actionType == AvatarAction.EFFECT)
                    {
                        if (!this._effectAssetDownloadManager.isReady(ASCompat.parseInt(k.actionParameter)))
                        {
                            this._effectAssetDownloadManager._Str_1914(ASCompat.parseInt(k.actionParameter), this);
                        }
                    }
                }
                this._Str_1632();
                this.setActionsToParts();
            }
        }

        public function appendAction(k:String,  _args:Array<ASAny> = null):Bool
        {
if (_args == null) _args = [];
            var _local_3:String = null;
            var _local_4:ActionDefinition = null;
            this._animationHasResetOnToggle = false;
            if (((!(_args == null)) && (_args.length > 0)))
            {
                _local_3 = _args[0];
            }
            switch (k)
            {
                case AvatarAction.POSTURE:
                    switch (_local_3)
                    {
                        case AvatarAction.POSTURE_LAY:
                            if (this._Str_1668 == 0)
                            {
                                this.setDirection(AvatarSetType.FULL, 4);
                            }
                            else
                            {
                                this.setDirection(AvatarSetType.FULL, 2);
                            }
                            this._actionsSorted = true;
                            this.addActionData(_local_3);
                            
                        case AvatarAction.POSTURE_WALK:
                            this._actionsSorted = true;
                            this.addActionData(_local_3);
                            
                        case AvatarAction.POSTURE_STAND:
                            this._actionsSorted = true;
                            this.addActionData(_local_3);
                            
                        case AvatarAction.POSTURE_SWIM
                           | AvatarAction.POSTURE_FLOAT
                           | AvatarAction.POSTURE_SIT
                           | AvatarAction.SNOWWAR_RUN
                           | AvatarAction.SNOWWAR_DIE_FRONT
                           | AvatarAction.SNOWWAR_DIE_BACK
                           | AvatarAction.SNOWWAR_PICK
                           | AvatarAction.SNOWWAR_THROW:
                            this.addActionData(_local_3);
                            
                        default:
                            this.logThis(("appendAction() >> UNKNOWN POSTURE TYPE: " + _local_3));
                    }
                    
                case AvatarAction.GESTURE:
                    switch (_local_3)
                    {
                        case AvatarAction.GESTURE_AGGRAVATED
                           | AvatarAction.GESTURE_SAD
                           | AvatarAction.GESTURE_SMILE
                           | AvatarAction.GESTURE_SURPRISED:
                            this.addActionData(_local_3);
                            
                        default:
                            this.logThis(("appendAction() >> UNKNOWN GESTURE TYPE: " + _local_3));
                    }
                    
                case AvatarAction.EFFECT:
                    if (((((((_local_3 == "33") || (_local_3 == "34")) || (_local_3 == "35")) || (_local_3 == "36")) || (_local_3 == "38")) || (_local_3 == "39")))
                    {
                        this._actionsSorted = true;
                    }
                    this.addActionData(k, _local_3);
                    
                case AvatarAction.DANCE
                   | AvatarAction.TALK
                   | AvatarAction.EXPRESSION_WAVE
                   | AvatarAction.SLEEP
                   | AvatarAction.SIGN
                   | AvatarAction.EXPRESSION_RESPECT
                   | AvatarAction.EXPRESSION_BLOW_A_KISS
                   | AvatarAction.EXPRESSION_67
                   | AvatarAction.EXPRESSION_LAUGH
                   | AvatarAction.EXPRESSION_CRY
                   | AvatarAction.EXPRESSION_IDLE
                   | AvatarAction.EXPRESSION_SNOWBOARD_OLLIE
                   | AvatarAction.EXPRESSION_SNOWBORD_360
                   | AvatarAction.EXPRESSION_RIDE_JUMP:
                    this.addActionData(k, _local_3);
                    
                case AvatarAction.CARRY_OBJECT
                   | AvatarAction.USE_OBJECT:
                    _local_4 = this._Str_581._Str_2018(k);
                    if (_local_4 != null)
                    {
                        this.setUniqueIdentifier(("appendAction:" + ASCompat.toString([_local_3, "->", _local_4.getParameterValue(_local_3)])));
                        _local_3 = _local_4.getParameterValue(_local_3);
                    }
                    this.addActionData(k, _local_3);
                    
                default:
                    this.logThis(("appendAction() >> UNKNOWN ACTION TYPE: " + k));
            }
            return true;
        }

        function addActionData(k:String, _arg_2:String="")
        {
            var _local_3:ActiveActionData = null;
            if (this._Str_614 == null)
            {
                this._Str_614 = new Array<ASAny>();
            }
            var _local_4 = 0;
            while (_local_4 < this._Str_614.length)
            {
                _local_3 = this._Str_614[_local_4];
                if (((_local_3.actionType == k) && (_local_3.actionParameter == _arg_2)))
                {
                    return;
                }
                _local_4++;
            }
            this._Str_614.push(new ActiveActionData(k, _arg_2, this._frameCounter));
        }

        public function isAnimating():Bool
        {
            return this._isAnimating || (this._animFrameCount > 1);
        }

        function _Str_1632():Bool
        {
            this._gpuMode = false;
            this._isAnimating = false;
            this._layersInUse = [];
            this._avatarDataContainer = null;
            this._directionOffset = 0;
            this._Str_581._Str_2101(this);
            this._Str_1708 = this._defaultAction;
            this._Str_1708.definition = this._defaultAction.definition;
            this.resetBodyPartCache(this._defaultAction);
            return true;
        }

        function resetActions():Bool
        {
            var _local_2:IActionDefinition = null;
            var _local_3:ActiveActionData = null;
            var k = false;
            if (this._Str_1163 == null)
            {
                return false;
            }
            final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2 = this._Str_581._Str_2018(_local_3.actionType);
                if (((!(_local_2 == null)) && _local_2.getPreventHeadTurn(_local_3.actionParameter)))
                {
                    k = true;
                }
            }
            return k;
        }

        function isHeadTurnPreventedByAction():Bool
        {
            var _local_2 = false;
            var _local_3 = false;
            var _local_4:ActiveActionData = null;
            var _local_5 = 0;
            var k = false;
            this._currentActionsStr = "";
            this._Str_1163 = this._Str_581.isHeadTurnPreventedByAction(this._Str_614);
            this._animFrameCount = this._Str_581._Str_1936(this._Str_1163);
            if (this._Str_1163 == null)
            {
                this._Str_903 = [0, 0, 0];
                if (this._lastActionsStr != "")
                {
                    k = true;
                    this._lastActionsStr = "";
                }
            }
            else
            {
                this._Str_903 = this._Str_581._Str_781(this._Str_1163, this._scale, this._Str_1668);
                final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    this._currentActionsStr = (this._currentActionsStr + (_local_4.actionType + _local_4.actionParameter));
                    if (_local_4.actionType == AvatarAction.EFFECT)
                    {
                        _local_5 = ASCompat.parseInt(_local_4.actionParameter);
                        if (this._effectIdInUse != _local_5)
                        {
                            _local_2 = true;
                        }
                        this._effectIdInUse = _local_5;
                        _local_3 = true;
                    }
                }
                if (!_local_3)
                {
                    if (this._effectIdInUse > -1)
                    {
                        _local_2 = true;
                    }
                    this._effectIdInUse = -1;
                }
                if (_local_2)
                {
                    this._Str_586._Str_1086(0);
                }
                if (this._lastActionsStr != this._currentActionsStr)
                {
                    k = true;
                    this._lastActionsStr = this._currentActionsStr;
                }
            }
            this._animationHasResetOnToggle = true;
            return k;
        }

        function setActionsToParts()
        {
            var k:ActiveActionData = null;
            var _local_2:Animation = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            if (this._Str_1163 == null)
            {
                return;
            }
            var _local_3= flash.Lib.getTimer();
            var _local_4= new Array<ASAny>();
            final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_4.push(k.actionType);
            }
            final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if ((((k != null) && (k.definition != null)) && k.definition.isAnimation))
                {
                    _local_2 = this._Str_581.getAnimation(((k.definition.state + ".") + k.actionParameter));
                    if (((_local_2 != null) && _local_2.hasOverriddenActions()))
                    {
                        _local_5 = _local_2.overriddenActionNames();
                        if (_local_5 != null)
                        {
                            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                            {
_local_6  = _tmp_;
                                if (_local_4.indexOf(_local_6) >= 0)
                                {
                                    k.overridingAction = _local_2.overridingAction(_local_6);
                                }
                            }
                        }
                    }
                    if (((_local_2 != null) && _local_2.resetOnToggle))
                    {
                        this._gpuMode = true;
                    }
                }
            }
            final _iter_ = this._Str_1163; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (!((!(k != null)) || (!(k.definition != null))))
                {
                    if ((k.definition.isAnimation && (k.actionParameter == "")))
                    {
                        k.actionParameter = "1";
                    }
                    this._Str_1496(k, _local_3);
                    if (k.definition.isAnimation)
                    {
                        this._isAnimating = k.definition.isAnimated(k.actionParameter);
                        _local_2 = this._Str_581.getAnimation(((k.definition.state + ".") + k.actionParameter));
                        if (_local_2 != null)
                        {
                            this._layersInUse = this._layersInUse.concat(_local_2.spriteData);
                            if (_local_2.hasDirectionData())
                            {
                                this._directionOffset = _local_2.directionData.offset;
                            }
                            if (_local_2.hasAvatarData())
                            {
                                this._avatarDataContainer = _local_2.avatarData;
                            }
                        }
                    }
                }
            }
        }

        function _Str_1496(k:IActiveActionData, _arg_2:Int)
        {
            if (((k == null) || (k.definition == null)))
            {
                return;
            }
            if (k.definition.assetPartDefinition == "")
            {
                return;
            }
            if (k.definition.isMain)
            {
                this._Str_1708 = k;
                this._Str_586.setGeometryType(k.definition.geometryType);
            }
            this._Str_586._Str_1565(k, _arg_2);
            this._useTextures = true;
        }

        function resetBodyPartCache(k:IActiveActionData)
        {
            if (k == null)
            {
                return;
            }
            if (k.definition.assetPartDefinition == "")
            {
                return;
            }
            if (k.definition.isMain)
            {
                this._Str_1708 = k;
                this._Str_586.setGeometryType(k.definition.geometryType);
            }
            this._Str_586.resetBodyPartCache(k);
            this._useTextures = true;
        }

        public var AvatarDataContainer(get,never):IAvatarDataContainer;
public function  get_AvatarDataContainer():IAvatarDataContainer
        {
            return this._avatarDataContainer;
        }

        function convertToGrayscale(k:BitmapData, _arg_2:String="CHANNELS_EQUAL"):BitmapData
        {
            var _local_3= 0.33;
            var _local_4= 0.33;
            var _local_5= 0.33;
            var _local_6:Float = 1;
            switch (_arg_2)
            {
                case "CHANNELS_UNIQUE":
                    _local_3 = 0.3;
                    _local_4 = 0.59;
                    _local_5 = 0.11;
                    
                case "CHANNELS_RED":
                    _local_3 = 1;
                    _local_4 = 0;
                    _local_5 = 0;
                    
                case "CHANNELS_GREEN":
                    _local_3 = 0;
                    _local_4 = 1;
                    _local_5 = 0;
                    
                case "CHANNELS_BLUE":
                    _local_3 = 0;
                    _local_4 = 0;
                    _local_5 = 1;
                    
                case "CHANNELS_DESATURATED":
                    _local_3 = 0.3086;
                    _local_4 = 0.6094;
                    _local_5 = 0.082;
                    
            }
            var _local_7:Array<ASAny> = [_local_3, _local_4, _local_5, 0, 0, _local_3, _local_4, _local_5, 0, 0, _local_3, _local_4, _local_5, 0, 0, 0, 0, 0, 1, 0];
            var _local_8= new ColorMatrixFilter((cast _local_7));
            var _local_9= new BitmapData(k.width, k.height, k.transparent, 0xFFFFFFFF);
            _local_9.copyPixels(k, k.rect, new Point(0, 0), null, null, false);
            _local_9.applyFilter(_local_9, _local_9.rect, new Point(0, 0), _local_8);
            return _local_9;
        }

        function logThis(k:String)
        {
        }

        function setUniqueIdentifier(k:String)
        {
        }

        public function isPlaceholder():Bool
        {
            return false;
        }

        public function _Str_998()
        {
            this._lastActionsStr = "";
        }

        public var _Str_677(get,never):Bool;
public function  get__Str_677():Bool
        {
            return this._gpuMode;
        }

        public var _Str_792(get,never):String;
public function  get__Str_792():String
        {
            return this._Str_1708.actionType;
        }

        public function updateAnimationByFrames(k:Int)
        {
            if (k == this._effectIdInUse)
            {
                this._Str_1632();
                this.setActionsToParts();
                this._gpuMode = true;
                this._useTextures = true;
                if (this._Str_1153 != null)
                {
                    this._Str_1153.updateAnimationByFrames(k);
                }
            }
        }
    }

