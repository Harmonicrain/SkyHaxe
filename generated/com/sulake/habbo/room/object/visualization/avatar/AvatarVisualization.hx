package com.sulake.habbo.room.object.visualization.avatar
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar._Str_936;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.room.object.visualization.avatar.additions.IAvatarAddition;
    import com.sulake.room.data.RoomObjectSpriteData;
    import com.sulake.habbo.avatar.animation.ISpriteDataContainer;
    import com.sulake.habbo.avatar.animation.IAvatarDataContainer;
    import com.sulake.habbo.avatar.animation.IAnimationLayerData;
    import flash.geom.Rectangle;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.visualization.avatar.additions.FloatingIdleZ;
    import com.sulake.habbo.room.object.visualization.avatar.additions.MutedBubble;
    import com.sulake.habbo.room.object.visualization.avatar.additions.TypingBubble;
    import com.sulake.habbo.avatar._enum.AvatarGuideStatus;
    import com.sulake.habbo.room.object.visualization.avatar.additions.GuideStatusBubble;
    import com.sulake.habbo.room.object.visualization.avatar.additions.GameClickTarget;
    import com.sulake.habbo.room.object.visualization.avatar.additions.NumberBubble;
    import com.sulake.habbo.room.object.visualization.avatar.additions.HabbiconBubble;
    import com.sulake.habbo.room.object.visualization.avatar.additions.ExpressionAdditionFactory;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.filters.BitmapFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import com.sulake.room.object._enum.RoomObjectSpriteType;
    import com.sulake.room.object._enum.AlphaTolerance;
    import flash.display.BlendMode;
    import com.sulake.habbo.avatar._enum.AvatarAction;

     class AvatarVisualization extends RoomObjectSpriteVisualization implements IAvatarImageListener implements  _Str_936 
    {
        static inline final AVATAR= "avatar";
        static inline final AVATAR_SPRITE_DEFAULT_DEPTH= -0.01;
        static inline final AVATAR_OWN_DEPTH_ADJUST= 0.001;
        static inline final AVATAR_SPRITE_LAYING_DEPTH= -0.409;
        static inline final MAX_AVATARS_WITH_EFFECT= 1000;
        static inline final SPRITE_INDEX_AVATAR= 2;
        static final _usedTextureNames:Array<ASAny> = [0, 0, 0];
        static inline final SPRITE_INDEX_SHADOW= 97;
        static inline final INITIAL_RESERVED_SPRITES= 3;
        static inline final ADDITION_ID_IDLE_BUBBLE= 0;
        static inline final ADDITION_ID_TYPING_BUBBLE= 1;
        static inline final ADDITION_ID_EXPRESSION= 2;
        static inline final ADDITION_ID_NUMBER_BUBBLE= 1;
        static inline final ADDITION_ID_GAME_CLICK_TARGET= 2;
        static inline final ADDITION_ID_MUTED_BUBBLE= 3;
        static inline final ADDITION_ID_GUIDE_STATUS_BUBBLE= 4;
        static inline final _Str_11164= 5;
        static inline final _Str_10168= 6;
        static inline final _Str_8837= 7;
        static inline final ADDITION_ID_HABBICON_BUBBLE= 8;

        static inline final _Str_9654= 41;

        static function resolveHabbiconFacingDirection(direction:Int):Int
        {
            direction = (direction % 8 + 8) % 8;
            if (direction <= 2)
            {
                return 1;
            }
            if (direction >= 4 && direction <= 6)
            {
                return -1;
            }
            return 0;
        }

        static function normalizeDirectionAngle(direction:Int):Int
        {
            return (direction % 360 + 360) % 360;
        }

        var _geometryUpdateId:Int = -1000;
        var _visualizationData:AvatarVisualizationData = null;
        var _avatars:Map;
        var _avatarsOnEffect:Map;
        var _headAngle:Int = 0;
        var _isAnimating:Bool = false;
        var _figure:String;
        var _gender:String;
        var _currentAngleDeg:Int = 0;
        var _shadowAsset:BitmapDataAsset;
        var _currentHeadAngleDeg:Int = -1;
        var _angle:Int = -1;
        var _currentHeadAngle:Int = -1;
        var _extraSpritesStartIndex:Int = 2;
        var _additions:Map;
        /** Sources replacing the composed avatar sprite, keyed by private addition id. */
        var _primaryAvatarSpriteSuppressions:ASObject = {};
        var FLOOR_COLOR:Int = -1;
        var _posture:String = "";
        var _postureParameter:String = "";
        var _isTalking:Bool = false;
        var _isSleeping:Bool = false;
        var _isBlinking:Bool = false;
        var _expressionType:Int = 0;
        var _gesture:Int = 0;
        var _danceStyle:Int = 0;
        var _mouseHighlight:Int = 0;
        var _mouseHighlightEnabled:Bool = false;
        var _signType:Int = -1;
        var _effectType:Int = 0;
        var _carryObjectType:Int = 0;
        var _useObjectType:Int = 0;
        var ANIMATION_UPDATE_INTERVAL_MS:Int = 0;
        var SNOWBOARDING_EFFECT:Int = 0;
        var _effectJustApplied:Bool = false;
        var _isSittingManual:Bool = false;
        var _isLaying:Bool = false;
        var _activeAvatarImage:IAvatarImage = null;
        var _habbiconSpinOffset:Int = 0;
        var _layInside:Bool = false;
        var _disposed:Bool = false;

        public function new()
        {
            super();
            this._avatars = new Map();
            this._avatarsOnEffect = new Map();
            this._isAnimating = false;
        }

        override public function dispose()
        {
            var k:IAvatarAddition;
            if (this._avatars != null)
            {
                this._Str_15248();
                this._avatars.dispose();
                this._avatarsOnEffect.dispose();
                this._avatars = null;
            }
            this._visualizationData = null;
            this._shadowAsset = null;
            if (this._additions != null)
            {
                for (_tmp_ in this._additions.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._additions = null;
            }
            this._primaryAvatarSpriteSuppressions = {};
            super.dispose();
            this._disposed = true;
        }

        override public function getSpriteList():Array<ASAny>
        {
            var _local_2:RoomObjectSpriteData = null;
            var _local_4:ISpriteDataContainer;
            var _local_5:IAvatarDataContainer;
            var _local_6:RoomObjectSpriteData;
            var _local_7:IAnimationLayerData;
            var _local_8:Int;
            var _local_9:Int;
            var _local_10:Int;
            var _local_11:Int;
            var _local_12:Int;
            var _local_13:Int;
            var _local_14:Int;
            var _local_15:String;
            var _local_16:BitmapDataAsset;
            var _local_17:Rectangle;
            var _local_18:String;
            var _local_19:RoomObjectSpriteData;
            if (this._activeAvatarImage == null)
            {
                return null;
            }
            var k= getSprite(ADDITION_ID_TYPING_BUBBLE);
            if (k != null)
            {
                _local_2 = new RoomObjectSpriteData();
                _local_2.alpha = k.alpha;
                _local_2.x = k.offsetX;
                _local_2.y = k.offsetY;
                _local_2.name = k.assetName;
                _local_2.width = k.width;
                _local_2.height = k.height;
            }
            var _local_3= this._activeAvatarImage._Str_1009();
            for (_tmp_ in this._activeAvatarImage._Str_754())
            {
_local_4  = _tmp_;
                _local_6 = new RoomObjectSpriteData();
                _local_7 = this._activeAvatarImage.getLayerData(_local_4);
                _local_8 = 0;
                _local_9 = this._activeAvatarImage.getDirection();
                _local_10 = _local_4.getDirectionOffsetX(_local_9);
                _local_11 = _local_4.getDirectionOffsetY(_local_9);
                _local_12 = _local_4.getDirectionOffsetZ(_local_9);
                _local_13 = 0;
                if (_local_4.hasDirections)
                {
                    _local_13 = _local_9;
                }
                if (_local_7 != null)
                {
                    _local_8 = _local_7.animationFrame;
                    _local_10 = (_local_10 + _local_7.dx);
                    _local_11 = (_local_11 + _local_7.dy);
                    _local_13 = (_local_13 + _local_7.dd);
                }
                _local_14 = 64;
                if (_local_14 < 48)
                {
                    _local_10 = Std.int(_local_10 / 2);
                    _local_11 = Std.int(_local_11 / 2);
                }
                if (_local_13 < 0)
                {
                    _local_13 = (_local_13 + 8);
                }
                else
                {
                    if (_local_13 > 7)
                    {
                        _local_13 = (_local_13 - 8);
                    }
                }
                _local_15 = ((((((this._activeAvatarImage.scale() + "_") + _local_4.member) + "_") + _local_13) + "_") + _local_8);
                _local_16 = this._activeAvatarImage.getAsset(_local_15);
                if (_local_16 != null)
                {
                    _local_6.x = Std.int((-_local_16.offset.x - (_local_14 / 2)) + _local_10);
                    _local_6.y = Std.int(-_local_16.offset.y + _local_11);
                    if (_local_4.hasStaticY)
                    {
                        _local_6.y = Std.int(_local_6.y + ((this.SNOWBOARDING_EFFECT * _local_14) / (2 * MAX_AVATARS_WITH_EFFECT)));
                    }
                    if (_local_4.ink == 33)
                    {
                        _local_6.blendMode = "add";
                    }
                    _local_6.name = _local_15;
                    if (this._isSittingManual)
                    {
                        _local_6.z = (AVATAR_SPRITE_LAYING_DEPTH - ((0.001 * spriteCount) * _local_12));
                    }
                    else
                    {
                        _local_6.z = ((-0.001 * spriteCount) * _local_12);
                    }
                    _local_17 = _local_16.rectangle;
                    if (_local_17 == null)
                    {
                        _local_6.width = 60;
                        _local_6.height = 60;
                    }
                    else
                    {
                        _local_6.width = Std.int(_local_17.width);
                        _local_6.height = Std.int(_local_17.height);
                    }
                    _local_3.push(_local_6);
                }
            }
            _local_5 = this._activeAvatarImage.AvatarDataContainer;
            if (((!(_local_5 == null)) && _local_5.paletteIsGrayscale))
            {
                _local_18 = Std.string(_local_5.reds[0]);
                for (_tmp_ in _local_3)
                {
_local_19  = _tmp_;
                    if (((_local_19.name.indexOf("h_std_fx") == -1) && (_local_19.name.indexOf("h_std_sd") == -1)))
                    {
                        _local_19.color = _local_18;
                    }
                }
            }
            if (_local_2 != null)
            {
                _local_3.push(_local_2);
            }
            return _local_3;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var angle(get,never):Int;
function  get_angle():Int
        {
            return this._angle;
        }

        public var habbiconFacingDirection(get,never):Int;
function  get_habbiconFacingDirection():Int
        {
            if (this._activeAvatarImage == null)
            {
                return 0;
            }
            return resolveHabbiconFacingDirection(this._activeAvatarImage.getDirection());
        }

        public var posture(get,never):String;
function  get_posture():String
        {
            return this._posture;
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            this._visualizationData = Std.downcast(k , AvatarVisualizationData);
            createSprites(ADDITION_ID_EXPRESSION);
            return true;
        }

        function updateModel(k:IRoomObjectModel, _arg_2:Float, _arg_3:Bool):Bool
        {
            var _local_4:Bool;
            var _local_5:Bool;
            var _local_6:Int;
            var _local_7:String;
            var _local_8:IAvatarAddition;
            var _local_9:String;
            var _local_10:Int;
            if (k.getUpdateID() != _modelUpdateID)
            {
                _local_4 = false;
                _local_5 = false;
                _local_6 = 0;
                _local_7 = "";
                _local_5 = ((k.getNumber(RoomObjectVariableEnum.FIGURE_TALK) > 0) && _arg_3);
                if (_local_5 != this._isTalking)
                {
                    this._isTalking = _local_5;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION));
                if (_local_6 != this._expressionType)
                {
                    this._expressionType = _local_6;
                    _local_4 = true;
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_SLEEP) > 0);
                if (_local_5 != this._isSleeping)
                {
                    this._isSleeping = _local_5;
                    _local_4 = true;
                }
                _local_5 = ((k.getNumber(RoomObjectVariableEnum.FIGURE_BLINK) > 0) && _arg_3);
                if (_local_5 != this._isBlinking)
                {
                    this._isBlinking = _local_5;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_GESTURE));
                if (_local_6 != this._gesture)
                {
                    this._gesture = _local_6;
                    _local_4 = true;
                }
                _local_7 = k.getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                if (_local_7 != this._posture)
                {
                    this._posture = _local_7;
                    _local_4 = true;
                }
                _local_7 = k.getString(RoomObjectVariableEnum.FIGURE_POSTURE_PARAMETER);
                if (_local_7 != this._postureParameter)
                {
                    this._postureParameter = _local_7;
                    _local_4 = true;
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_CAN_STAND_UP) > 0);
                if (_local_5 != this._effectJustApplied)
                {
                    this._effectJustApplied = _local_5;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_VERTICAL_OFFSET) * MAX_AVATARS_WITH_EFFECT);
                if (_local_6 != this.SNOWBOARDING_EFFECT)
                {
                    this.SNOWBOARDING_EFFECT = _local_6;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_DANCE));
                if (_local_6 != this._danceStyle)
                {
                    this._danceStyle = _local_6;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_EFFECT));
                if (_local_6 != this._effectType)
                {
                    this._effectType = _local_6;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT));
                if (_local_6 != this._carryObjectType)
                {
                    this._carryObjectType = _local_6;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT));
                if (_local_6 != this._useObjectType)
                {
                    this._useObjectType = _local_6;
                    _local_4 = true;
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.HEAD_DIRECTION));
                if (_local_6 != this._currentHeadAngleDeg)
                {
                    this._currentHeadAngleDeg = _local_6;
                    _local_4 = true;
                }
                if (((this._carryObjectType > 0) && (k.getNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT) > 0)))
                {
                    if (this._useObjectType != this._carryObjectType)
                    {
                        this._useObjectType = this._carryObjectType;
                        _local_4 = true;
                    }
                }
                else
                {
                    if (this._useObjectType != 0)
                    {
                        this._useObjectType = 0;
                        _local_4 = true;
                    }
                }
                _local_8 = Std.downcast(this._Str_6142(ADDITION_ID_NUMBER_BUBBLE) , FloatingIdleZ);
                if (this._isSleeping)
                {
                    if (_local_8 == null)
                    {
                        _local_8 = this._Str_8211(new FloatingIdleZ(ADDITION_ID_NUMBER_BUBBLE, this));
                    }
                    _local_4 = true;
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(ADDITION_ID_NUMBER_BUBBLE);
                    }
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_IS_MUTED) > 0);
                _local_8 = Std.downcast(this._Str_6142(_Str_10168) , MutedBubble);
                if (_local_5)
                {
                    if (_local_8 == null)
                    {
                        _local_8 = this._Str_8211(new MutedBubble(_Str_10168, this));
                    }
                    this._Str_5801(ADDITION_ID_GAME_CLICK_TARGET);
                    _local_4 = true;
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(_Str_10168);
                        _local_4 = true;
                    }
                    _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_IS_TYPING) > 0);
                    _local_8 = Std.downcast(this._Str_6142(ADDITION_ID_GAME_CLICK_TARGET) , TypingBubble);
                    if (_local_5)
                    {
                        if (_local_8 == null)
                        {
                            _local_8 = this._Str_8211(new TypingBubble(ADDITION_ID_GAME_CLICK_TARGET, this));
                        }
                        _local_4 = true;
                    }
                    else
                    {
                        if (_local_8 != null)
                        {
                            this._Str_5801(ADDITION_ID_GAME_CLICK_TARGET);
                        }
                    }
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_GUIDE_STATUS));
                if (_local_6 != AvatarGuideStatus.NONE)
                {
                    this._Str_5801(_Str_8837);
                    this._Str_8211(new GuideStatusBubble(_Str_8837, this, _local_6));
                    _local_4 = true;
                }
                else
                {
                    if (Std.downcast(this._Str_6142(_Str_8837) , GuideStatusBubble) != null)
                    {
                        this._Str_5801(_Str_8837);
                        _local_4 = true;
                    }
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME) > 0);
                _local_8 = Std.downcast(this._Str_6142(_Str_11164) , GameClickTarget);
                if (_local_5)
                {
                    if (_local_8 == null)
                    {
                        _local_8 = this._Str_8211(new GameClickTarget(_Str_11164));
                    }
                    _local_4 = true;
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(_Str_11164);
                    }
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_NUMBER_VALUE));
                _local_8 = Std.downcast(this._Str_6142(ADDITION_ID_GUIDE_STATUS_BUBBLE) , NumberBubble);
                if (_local_6 > 0)
                {
                    if (_local_8 == null)
                    {
                        _local_8 = this._Str_8211(new NumberBubble(ADDITION_ID_GUIDE_STATUS_BUBBLE, _local_6, this));
                    }
                    _local_4 = true;
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(ADDITION_ID_GUIDE_STATUS_BUBBLE);
                    }
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION));
                _local_8 = this._Str_6142(ADDITION_ID_MUTED_BUBBLE);
                if (_local_6 > 0)
                {
                    if (_local_8 == null)
                    {
                        _local_8 = ExpressionAdditionFactory.make(ADDITION_ID_MUTED_BUBBLE, _local_6, this);
                        if (_local_8 != null)
                        {
                            this._Str_8211(_local_8);
                        }
                    }
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(ADDITION_ID_MUTED_BUBBLE);
                    }
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_HABBICON));
                _local_10 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_HABBICON_TRIGGER_SEQUENCE));
                _local_8 = Std.downcast(this._Str_6142(ADDITION_ID_HABBICON_BUBBLE) , HabbiconBubble);
                if (_local_6 > 0)
                {
                    if (_local_8 == null || cast(_local_8, HabbiconBubble).habbiconId != _local_6 || cast(_local_8, HabbiconBubble).triggerSequence != _local_10)
                    {
                        if (_local_8 != null)
                        {
                            this._Str_5801(ADDITION_ID_HABBICON_BUBBLE);
                        }
                        _local_8 = this._Str_8211(new HabbiconBubble(ADDITION_ID_HABBICON_BUBBLE, _local_6, _local_10, this));
                    }
                    _local_4 = true;
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this._Str_5801(ADDITION_ID_HABBICON_BUBBLE);
                        _local_4 = true;
                    }
                }
                _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_HABBICON_SPIN_OFFSET));
                if (_local_6 != this._habbiconSpinOffset)
                {
                    this._habbiconSpinOffset = _local_6;
                    _local_4 = true;
                }
                this.validateActions(_arg_2);
                _local_7 = k.getString(RoomObjectVariableEnum.GENDER);
                if (_local_7 != this._gender)
                {
                    this._gender = _local_7;
                    _local_4 = true;
                }
                _local_9 = k.getString(RoomObjectVariableEnum.FIGURE);
                if (this.updateFigure(_local_9))
                {
                    _local_4 = true;
                }
                if (k.hasNumber(RoomObjectVariableEnum.FIGURE_SIGN))
                {
                    _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_SIGN));
                    if (_local_6 != this._signType)
                    {
                        _local_4 = true;
                        this._signType = _local_6;
                    }
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT_ENABLE) > 0);
                if (_local_5 != this._mouseHighlightEnabled)
                {
                    this._mouseHighlightEnabled = _local_5;
                    _local_4 = true;
                }
                if (this._mouseHighlightEnabled)
                {
                    _local_6 = Std.int(k.getNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT));
                    if (_local_6 != this._mouseHighlight)
                    {
                        this._mouseHighlight = _local_6;
                        _local_4 = true;
                    }
                }
                _local_5 = (k.getNumber(RoomObjectVariableEnum.OWN_USER) > 0);
                if (_local_5 != this._layInside)
                {
                    this._layInside = _local_5;
                    _local_4 = true;
                }
                _modelUpdateID = k.getUpdateID();
                return _local_4;
            }
            return false;
        }

        function updateFigure(k:String):Bool
        {
            if (this._figure != k)
            {
                this._figure = k;
                this._Str_15248();
                return true;
            }
            return false;
        }

        function _Str_15248()
        {
            var k:IAvatarImage;
            var _local_2:IRoomObjectSprite;
            for (_tmp_ in this._avatars.getValues())
            {
k  = _tmp_;
                if (k != null)
                {
                    k.dispose();
                }
            }
            for (_tmp_ in this._avatarsOnEffect.getValues())
            {
k  = _tmp_;
                if (k != null)
                {
                    k.dispose();
                }
            }
            this._avatars.reset();
            this._avatarsOnEffect.reset();
            this._activeAvatarImage = null;
            _local_2 = getSprite(ADDITION_ID_IDLE_BUBBLE);
            if (_local_2 != null)
            {
                _local_2.asset = null;
                _local_2.alpha = 0xFF;
            }
        }

        function validateActions(k:Float)
        {
            var _local_2:Int;
            if (k < 48)
            {
                this._isBlinking = false;
            }
            if (((this._posture == "sit") || (this._posture == "lay")))
            {
                this.ANIMATION_UPDATE_INTERVAL_MS = Std.int(k / 2);
            }
            else
            {
                this.ANIMATION_UPDATE_INTERVAL_MS = 0;
            }
            this._isLaying = false;
            this._isSittingManual = false;
            if (this._posture == "lay")
            {
                this._isSittingManual = true;
                _local_2 = ASCompat.toInt(this._postureParameter);
                if (_local_2 < 0)
                {
                    this._isLaying = true;
                }
            }
        }

        function _Str_23124(k:Float, _arg_2:Int):IAvatarImage
        {
            var _local_3:IAvatarImage;
            var _local_5:IAvatarImage;
            var _local_4= ("avatarImage" + Std.string(k));
            if (_arg_2 == 0)
            {
                _local_3 = ASCompat.dynamicAs(this._avatars.getValue(_local_4) , IAvatarImage);
            }
            else
            {
                _local_4 = (_local_4 + ("-" + _arg_2));
                _local_3 = ASCompat.dynamicAs(this._avatarsOnEffect.getValue(_local_4) , IAvatarImage);
                if (_local_3 != null)
                {
                    _local_3._Str_998();
                }
            }
            if (_local_3 == null)
            {
                _local_3 = this._visualizationData._Str_8991(this._figure, k, this._gender, this, this);
                if (_local_3 != null)
                {
                    if (_arg_2 == 0)
                    {
                        this._avatars.add(_local_4, _local_3);
                    }
                    else
                    {
                        if (this._avatarsOnEffect.length >= (INITIAL_RESERVED_SPRITES : UInt))
                        {
                            _local_5 = this._avatarsOnEffect.remove(this._avatarsOnEffect.getKey(0));
                            if (_local_5 != null)
                            {
                                _local_5.dispose();
                            }
                        }
                        this._avatarsOnEffect.add(_local_4, _local_3);
                    }
                }
            }
            return _local_3;
        }

        public function getAvatarRendererAsset(k:String):IAsset
        {
            return (this._visualizationData != null) ? this._visualizationData.getAvatarRendererAsset(k) : null;
        }

        function updateObject(k:IRoomObject, _arg_2:IRoomGeometry, _arg_3:Bool, _arg_4:Bool=false):Bool
        {
            var _local_5:Bool;
            var _local_6:Int;
            var _local_7:Int;
            if (((_arg_4 || (!(_objectUpdateID == k.getUpdateID()))) || (!(this.FLOOR_COLOR == _arg_2.updateId))))
            {
                _local_5 = _arg_3;
                _local_6 = Std.int(k.getDirection().x - _arg_2.direction.x);
                _local_6 = (((_local_6 % 360) + 360) % 360);
                if (((this._posture == "sit") && this._effectJustApplied))
                {
                    _local_6 = (_local_6 - ((_local_6 % 90) - 45));
                }
                _local_7 = this._currentHeadAngleDeg;
                if (this._posture == "float")
                {
                    _local_7 = _local_6;
                }
                else
                {
                    _local_7 = Std.int(_local_7 - _arg_2.direction.x);
                }
                _local_7 = (((_local_7 % 360) + 360) % 360);
                if (((this._posture == "sit") && this._effectJustApplied))
                {
                    _local_7 = (_local_7 - ((_local_7 % 90) - 45));
                }
                if (this._habbiconSpinOffset != 0)
                {
                    _local_6 = normalizeDirectionAngle(_local_6 + this._habbiconSpinOffset);
                    _local_7 = normalizeDirectionAngle(_local_7 + this._habbiconSpinOffset);
                }
                if (((!(_local_6 == this._angle)) || _arg_4))
                {
                    _local_5 = true;
                    this._angle = _local_6;
                    _local_6 = Std.int(_local_6 - (135 - 22.5));
                    _local_6 = ((_local_6 + 360) % 360);
                    this._activeAvatarImage.setDirectionAngle(AvatarSetType.FULL, _local_6);
                }
                if (((!(_local_7 == this._currentHeadAngle)) || _arg_4))
                {
                    _local_5 = true;
                    this._currentHeadAngle = _local_7;
                    if (this._currentHeadAngle != this._angle)
                    {
                        _local_7 = Std.int(_local_7 - (135 - 22.5));
                        _local_7 = ((_local_7 + 360) % 360);
                        this._activeAvatarImage.setDirectionAngle(AvatarSetType.HEAD, _local_7);
                    }
                }
                _objectUpdateID = k.getUpdateID();
                this.FLOOR_COLOR = _arg_2.updateId;
                return _local_5;
            }
            return false;
        }

        function _Str_23519(k:Float)
        {
            var _local_4:Int;
            var _local_5:Int;
            var _local_2= getSprite(ADDITION_ID_TYPING_BUBBLE);
            this._shadowAsset = null;
            var _local_3= (((this._posture == "mv") || (this._posture == "std")) || ((this._posture == "sit") && this._effectJustApplied));
            if (this._effectType == SPRITE_INDEX_SHADOW)
            {
                _local_3 = false;
            }
            if (_local_3)
            {
                _local_2.visible = true;
                if (((this._shadowAsset == null) || (!(k == _currentScale))))
                {
                    _local_4 = 0;
                    _local_5 = 0;
                    if (k < 48)
                    {
                        _local_2.libraryAssetName = "sh_std_sd_1_0_0";
                        this._shadowAsset = this._activeAvatarImage.getAsset(_local_2.libraryAssetName);
                        _local_4 = -8;
                        _local_5 = (this._effectJustApplied ? 6 : -3);
                    }
                    else
                    {
                        _local_2.libraryAssetName = "h_std_sd_1_0_0";
                        this._shadowAsset = this._activeAvatarImage.getAsset(_local_2.libraryAssetName);
                        _local_4 = -17;
                        _local_5 = (this._effectJustApplied ? 10 : -7);
                    }
                    if (this._shadowAsset != null)
                    {
                        _local_2.asset = ASCompat.dynamicAs(this._shadowAsset.content , BitmapData);
                        _local_2.offsetX = _local_4;
                        _local_2.offsetY = _local_5;
                        _local_2.alpha = 50;
                        _local_2.relativeDepth = 1;
                    }
                    else
                    {
                        _local_2.visible = false;
                    }
                }
            }
            else
            {
                this._shadowAsset = null;
                _local_2.visible = false;
            }
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            var _local_14:Int;
            var _local_17:IRoomObjectSprite;
            var _local_18:IAvatarAddition;
            var _local_19:IRoomObjectSprite;
            var _local_20:Array<ASAny>;
            var _local_21:Int;
            var _local_22:Int;
            var _local_23:ISpriteDataContainer;
            var _local_24:Bool;
            var _local_25:BitmapData;
            var _local_26:BitmapFilter;
            var _local_27:IAnimationLayerData;
            var _local_28:Int;
            var _local_29:Int;
            var _local_30:IAnimationLayerData;
            var _local_31:Int;
            var _local_32:Int;
            var _local_33:Int;
            var _local_34:Int;
            var _local_35:Int;
            var _local_36:String;
            var _local_37:BitmapDataAsset;
            var _local_5= object;
            if (_local_5 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (this._visualizationData == null)
            {
                return;
            }
            if (_arg_2 < (this._geometryUpdateId + AvatarVisualization._Str_9654))
            {
                return;
            }
            this._geometryUpdateId = (this._geometryUpdateId + AvatarVisualization._Str_9654);
            if ((this._geometryUpdateId + AvatarVisualization._Str_9654) < _arg_2)
            {
                this._geometryUpdateId = (_arg_2 - AvatarVisualization._Str_9654);
            }
            var _local_6= _local_5.getModel();
            var _local_7= k.scale;
            var _local_8 = false;
            var _local_9 = false;
            var _local_10:Bool;
            var _local_11= this._effectType;
            var _local_12 = false;
            var _local_13= this.updateModel(_local_6, _local_7, _arg_3);
            if (((_local_13 || (!(_local_7 == _currentScale))) || (this._activeAvatarImage == null)))
            {
                if (_local_7 != _currentScale)
                {
                    _local_9 = true;
                    this.validateActions(_local_7);
                }
                if (_local_11 != this._effectType)
                {
                    _local_12 = true;
                }
                if (((_local_9 || (this._activeAvatarImage == null)) || _local_12))
                {
                    this._activeAvatarImage = this._Str_23124(_local_7, this._effectType);
                    if (this._activeAvatarImage == null)
                    {
                        return;
                    }
                    _local_8 = true;
                    _local_17 = getSprite(ADDITION_ID_IDLE_BUBBLE);
                    if ((((_local_17 != null) && (this._activeAvatarImage != null)) && this._activeAvatarImage.isPlaceholder()))
                    {
                        _local_17.alpha = 150;
                    }
                    else
                    {
                        if (_local_17 != null)
                        {
                            _local_17.alpha = 0xFF;
                        }
                    }
                }
                if (this._activeAvatarImage == null)
                {
                    return;
                }
                if ((_local_12 && this._activeAvatarImage._Str_677))
                {
                    this._activeAvatarImage._Str_833();
                }
                this._Str_23519(_local_7);
                _local_10 = this.updateObject(_local_5, k, _arg_3, true);
                this.updateActions(this._activeAvatarImage);
                if (this._additions != null)
                {
                    _local_14 = this._extraSpritesStartIndex;
                    for (_tmp_ in this._additions.getValues())
                    {
_local_18  = _tmp_;
                        _local_18.update(getSprite(_local_14++), _local_7);
                    }
                }
                _currentScale = Std.int(_local_7);
            }
            else
            {
                _local_10 = this.updateObject(_local_5, k, _arg_3);
            }
            if (this._additions != null)
            {
                _local_14 = this._extraSpritesStartIndex;
                for (_tmp_ in this._additions.getValues())
                {
_local_18  = _tmp_;
                    if (_local_18.animate(getSprite(_local_14++)))
                    {
                        increaseUpdateId();
                    }
                }
            }
            var _local_15= ((_local_10 || _local_13) || _local_9);
            var _local_16= ((this._isAnimating || (this._currentAngleDeg > 0)) && _arg_3);
            if (_local_15)
            {
                this._currentAngleDeg = SPRITE_INDEX_AVATAR;
            }
            if ((_local_15 || _local_16))
            {
                increaseUpdateId();
                this._currentAngleDeg--;
                this._headAngle--;
                if (((((this._headAngle <= 0) || _local_9) || _local_13) || _local_8))
                {
                    this._activeAvatarImage._Str_953(1);
                    this._headAngle = SPRITE_INDEX_AVATAR;
                }
                else
                {
                    return;
                }
                _local_20 = this._activeAvatarImage._Str_781();
                if (((_local_20 == null) || (_local_20.length < 3)))
                {
                    _local_20 = _usedTextureNames;
                }
                _local_19 = getSprite(ADDITION_ID_IDLE_BUBBLE);
                if (_local_19 != null)
                {
                    _local_24 = ((_local_6.getNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT_ENABLE) == 1) && (_local_6.getNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT) == 1));
                    _local_25 = this._activeAvatarImage.getImage(AvatarSetType.FULL, _local_24);
                    if (_local_25 != null)
                    {
                        if (_local_24)
                        {
                            _local_26 = new GlowFilter(0xFFFFFF, 1, 6, 6);
                            _local_25.applyFilter(_local_25, _local_25.rect, new Point(0, 0), _local_26);
                        }
                        _local_19.asset = _local_25;
                    }
                    if (_local_19.asset != null)
                    {
                        _local_19.offsetX = ASCompat.toInt(ASCompat.toNumber(((-1 * _local_7) / 2) + _local_20[0]) - ((_local_19.asset.width - _local_7) / 2));
                        _local_19.offsetY = ASCompat.toInt(((-_local_19.asset.height + (_local_7 / 4)) + _local_20[1]) + this.ANIMATION_UPDATE_INTERVAL_MS);
                    }
                    if (this._isSittingManual)
                    {
                        if (this._isLaying)
                        {
                            _local_19.relativeDepth = -0.5;
                        }
                        else
                        {
                            _local_19.relativeDepth = ASCompat.toNumber(AVATAR_SPRITE_LAYING_DEPTH + _local_20[2]);
                        }
                    }
                    else
                    {
                        _local_19.relativeDepth = ASCompat.toNumber(AVATAR_SPRITE_DEFAULT_DEPTH + _local_20[2]);
                    }
                    if (this._layInside)
                    {
                        _local_19.relativeDepth = (_local_19.relativeDepth - AVATAR_OWN_DEPTH_ADJUST);
                        _local_19.spriteType = RoomObjectSpriteType.AVATAR_OWN;
                    }
                    else
                    {
                        _local_19.spriteType = RoomObjectSpriteType.AVATAR;
                    }
                }
                _local_18 = Std.downcast(this._Str_6142(ADDITION_ID_GAME_CLICK_TARGET) , TypingBubble);
                if (_local_18 != null)
                {
                    if (!this._isSittingManual)
                    {
                        cast(_local_18, TypingBubble).relativeDepth = ASCompat.toNumber((AVATAR_SPRITE_DEFAULT_DEPTH - 0.01) + _local_20[2]);
                    }
                    else
                    {
                        cast(_local_18, TypingBubble).relativeDepth = ASCompat.toNumber((AVATAR_SPRITE_LAYING_DEPTH - 0.01) + _local_20[2]);
                    }
                }
                this._isAnimating = this._activeAvatarImage.isAnimating();
                _local_21 = ADDITION_ID_EXPRESSION;
                _local_22 = this._activeAvatarImage.getDirection();
                for (_tmp_ in this._activeAvatarImage._Str_754())
                {
_local_23  = _tmp_;
                    if (_local_23.id == AVATAR)
                    {
                        _local_19 = getSprite(ADDITION_ID_IDLE_BUBBLE);
                        _local_27 = this._activeAvatarImage.getLayerData(_local_23);
                        _local_28 = _local_23.getDirectionOffsetX(_local_22);
                        _local_29 = _local_23.getDirectionOffsetY(_local_22);
                        if (_local_27 != null)
                        {
                            _local_28 = (_local_28 + _local_27.dx);
                            _local_29 = (_local_29 + _local_27.dy);
                        }
                        if (_local_7 < 48)
                        {
                            _local_28 = Std.int(_local_28 / 2);
                            _local_29 = Std.int(_local_29 / 2);
                        }
                        if (!this._effectJustApplied)
                        {
                            _local_19.offsetX = (_local_19.offsetX + _local_28);
                            _local_19.offsetY = (_local_19.offsetY + _local_29);
                        }
                    }
                    else
                    {
                        _local_19 = getSprite(_local_21);
                        if (_local_19 != null)
                        {
                            _local_19.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
                            _local_19.visible = true;
                            _local_30 = this._activeAvatarImage.getLayerData(_local_23);
                            _local_31 = 0;
                            _local_32 = _local_23.getDirectionOffsetX(_local_22);
                            _local_33 = _local_23.getDirectionOffsetY(_local_22);
                            _local_34 = _local_23.getDirectionOffsetZ(_local_22);
                            _local_35 = 0;
                            if (_local_23.hasDirections)
                            {
                                _local_35 = _local_22;
                            }
                            if (_local_30 != null)
                            {
                                _local_31 = _local_30.animationFrame;
                                _local_32 = (_local_32 + _local_30.dx);
                                _local_33 = (_local_33 + _local_30.dy);
                                _local_35 = (_local_35 + _local_30.dd);
                            }
                            if (_local_7 < 48)
                            {
                                _local_32 = Std.int(_local_32 / 2);
                                _local_33 = Std.int(_local_33 / 2);
                            }
                            if (_local_35 < 0)
                            {
                                _local_35 = (_local_35 + 8);
                            }
                            else
                            {
                                if (_local_35 > 7)
                                {
                                    _local_35 = (_local_35 - 8);
                                }
                            }
                            _local_36 = ((((((this._activeAvatarImage.scale() + "_") + _local_23.member) + "_") + _local_35) + "_") + _local_31);
                            _local_37 = this._activeAvatarImage.getAsset(_local_36);
                            if (_local_37 == null) continue;
                            _local_19.asset = ASCompat.dynamicAs(_local_37.content , BitmapData);
                            _local_19.offsetX = Std.int((-_local_37.offset.x - (_local_7 / 2)) + _local_32);
                            _local_19.offsetY = Std.int(-_local_37.offset.y + _local_33);
                            if (_local_23.hasStaticY)
                            {
                                _local_19.offsetY = Std.int(_local_19.offsetY + ((this.SNOWBOARDING_EFFECT * _local_7) / (2 * MAX_AVATARS_WITH_EFFECT)));
                            }
                            else
                            {
                                _local_19.offsetY = (_local_19.offsetY + this.ANIMATION_UPDATE_INTERVAL_MS);
                            }
                            if (this._isSittingManual)
                            {
                                _local_19.relativeDepth = (AVATAR_SPRITE_LAYING_DEPTH - ((0.001 * spriteCount) * _local_34));
                            }
                            else
                            {
                                _local_19.relativeDepth = (AVATAR_SPRITE_DEFAULT_DEPTH - ((0.001 * spriteCount) * _local_34));
                            }
                            if (_local_23.ink == 33)
                            {
                                _local_19.blendMode = BlendMode.ADD;
                            }
                            else
                            {
                                _local_19.blendMode = BlendMode.NORMAL;
                            }
                        }
                        _local_21++;
                    }
                }
            }
        }

        function updateActions(k:IAvatarImage)
        {
            var _local_3:ISpriteDataContainer;
            var _local_4:String;
            var _local_5:IAvatarAddition;
            var _local_6:IRoomObjectSprite;
            if (k == null)
            {
                return;
            }
            k._Str_913();
            k.appendAction(AvatarAction.POSTURE, [this._posture, this._postureParameter]);
            if (this._gesture > 0)
            {
                k.appendAction(AvatarAction.GESTURE, [AvatarAction.getGesture(this._gesture)]);
            }
            if (this._danceStyle > 0)
            {
                k.appendAction(AvatarAction.DANCE, [this._danceStyle]);
            }
            if (this._signType > -1)
            {
                k.appendAction(AvatarAction.SIGN, [this._signType]);
            }
            if (this._carryObjectType > 0)
            {
                k.appendAction(AvatarAction.CARRY_OBJECT, [this._carryObjectType]);
            }
            if (this._useObjectType > 0)
            {
                k.appendAction(AvatarAction.USE_OBJECT, [this._useObjectType]);
            }
            if (this._isTalking)
            {
                k.appendAction(AvatarAction.TALK);
            }
            if ((this._isSleeping || this._isBlinking))
            {
                k.appendAction(AvatarAction.SLEEP);
            }
            if (this._expressionType > 0)
            {
                _local_4 = AvatarAction.getExpression(this._expressionType);
                if (_local_4 != "")
                {
                    switch (_local_4)
                    {
                        case AvatarAction.DANCE:
                            k.appendAction(AvatarAction.DANCE, [2]);
                            
                        case AvatarAction.EXPRESSION_67:
                            k.appendAction(AvatarAction.DANCE, ["sixseven"]);
                            
                        default:
                            k.appendAction(_local_4);
                    }
                }
            }
            if (this._effectType > 0)
            {
                k.appendAction(AvatarAction.EFFECT, [this._effectType]);
            }
            k._Str_962();
            this._isAnimating = k.isAnimating();
            var _local_2= ADDITION_ID_EXPRESSION;
            for (_tmp_ in this._activeAvatarImage._Str_754())
            {
_local_3  = _tmp_;
                if (_local_3.id != AVATAR)
                {
                    _local_2++;
                }
            }
            if (_local_2 != spriteCount)
            {
                createSprites(_local_2);
            }
            this._extraSpritesStartIndex = _local_2;
            if (this._additions != null)
            {
                for (_tmp_ in this._additions.getValues())
                {
_local_5  = _tmp_;
                    _local_6 = addSprite();
                }
            }
        }

        public function avatarImageReady(k:String)
        {
            this._Str_15248();
        }

        public function updateAnimationByFrames(k:Int)
        {
            this._Str_15248();
        }

        var _Str_26131(get,never):Int;
function  get__Str_26131():Int
        {
            return ASCompat.toInt((this._additions != null) ? this._additions.length : 0);
        }

        public function _Str_8211(k:IAvatarAddition):IAvatarAddition
        {
            if (this._additions == null)
            {
                this._additions = new Map();
            }
            if (this._additions.hasKey(k.id))
            {
                throw new ASError((("Avatar addition with index " + k.id) + "already exists!"));
            }
            this._additions.add(k.id, k);
            return k;
        }

        public function _Str_6142(k:Int):IAvatarAddition
        {
            return (this._additions != null) ? this._additions.getValue(k): null;
        }

        public function _Str_5801(k:Int)
        {
            var _local_2= this._Str_6142(k);
            if (_local_2 == null)
            {
                return;
            }
            this._additions.remove(k);
            _local_2.dispose();
        }

        /**
         * Lets a private-room avatar addition replace the composed body without changing its figure.
         * Suppression is source-counted so disposing one addition cannot reveal a body another still
         * owns. The normal hotel avatar never receives such an addition.
         */
        public function setPrimaryAvatarSpriteSuppressed(sourceId:Int, suppressed:Bool)
        {
            if (suppressed)
            {
                this._primaryAvatarSpriteSuppressions[Std.string(sourceId)] = true;
            }
            else
            {
                Reflect.deleteField(this._primaryAvatarSpriteSuppressions, Std.string(sourceId));
            }
            var primary= getSprite(ADDITION_ID_IDLE_BUBBLE);
            if (primary != null)
            {
                var hasSuppression = false;
                for (key in this._primaryAvatarSpriteSuppressions.___keys())
                {
                    hasSuppression = true;
                    break;
                }
                primary.visible = !hasSuppression;
            }
        }
    }

