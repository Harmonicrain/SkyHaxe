package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class HabbiconBubble implements IAvatarAddition
    {
        static inline final DEFAULT_VISIBLE_DURATION_MS= 3000;
        static inline final INTRO_DURATION_MS= 180;
        static inline final INTRO_START_OFFSET_Y= 12;
        static inline final FADE_IN_DURATION_MS= 150;
        static inline final FADE_OUT_DURATION_MS= 350;
        static inline final BACKGROUND_VISIBLE_DURATION_MS= 3350;
        static inline final BACKGROUND_FADE_OUT_DURATION_MS= 530;
        static inline final ROOM_LARGE_OFFSET_X= -20;
        static inline final ROOM_LARGE_OFFSET_Y= -126;
        static inline final ROOM_SMALL_OFFSET_X= -10;
        static inline final ROOM_SMALL_OFFSET_Y= -65;
        static inline final DEFAULT_RELATIVE_DEPTH= -0.2;
        static inline final OUTLINE_SIZE= 2;
        static inline final OUTLINE_COLOR:UInt = 0xFFFFFFFF;
        static inline final BACKGROUND_SHADOW_PADDING= 5;
        static inline final BACKGROUND_CONTENT_INSET= 7;
        static inline final BACKGROUND_SHADOW_OFFSET_X= 1.5;
        static inline final BACKGROUND_SHADOW_OFFSET_Y:Float = 2;
        static inline final BACKGROUND_SHADOW_BLUR= 6;
        static inline final BACKGROUND_SHADOW_ALPHA= 0.55;
        static inline final BACKGROUND_SHADOW_QUALITY= 2;
        static inline final BACKGROUND_SHADOW_COLOR:UInt = 0;

        static final _outlineCache:ASObject = {};
        static final _mirrorCache:ASObject = {};
        static final _shadowCache:ASObject = {};

        var _id:Int = -1;
        var _habbiconId:Int = 0;
        var _triggerSequence:Int = 0;
        var _avatar:AvatarVisualization;
        var _scale:Float = 64;
        var _startTime:Int = 0;
        var _sourceFadeStart:Int = 0;
        var _sourceHiddenAt:Int = 0;
        var _backgroundFadeStart:Int = 0;
        var _backgroundHiddenAt:Int = 0;
        var _hideAt:Int = 0;
        var _runtimeAsset:ASObject;
        var _animated:Bool = false;
        var _currentFrameIndex:Int = -1;
        var _bitmap:BitmapData;
        var _bitmapShared:Bool = false;
        var _bitmapHasSource:Bool = false;
        var _bitmapBaseDimension:Int = 0;
        var _lastSourceAlpha:Int = -1;
        var _lastBackgroundAlpha:Int = -1;
        var _mirroringResolved:Bool = false;
        var _mirror:Bool = false;
        var _initialized:Bool = false;
        var _hidden:Bool = false;
        var _relativeDepth:Float = DEFAULT_RELATIVE_DEPTH;

        public function new(id:Int, habbiconId:Int, triggerSequence:Int, avatar:AvatarVisualization)
        {
            this._id = id;
            this._habbiconId = habbiconId;
            this._triggerSequence = triggerSequence;
            this._avatar = avatar;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var habbiconId(get,never):Int;
function  get_habbiconId():Int
        {
            return this._habbiconId;
        }

        public var triggerSequence(get,never):Int;
function  get_triggerSequence():Int
        {
            return this._triggerSequence;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._avatar == null;
        }

        public var relativeDepth(never,set):Float;
function  set_relativeDepth(value:Float):Float        {
            return this._relativeDepth = value;
        }

        public function dispose()
        {
            if (this._bitmap != null && !this._bitmapShared)
            {
                this._bitmap.dispose();
            }
            this._bitmap = null;
            this._runtimeAsset = null;
            this._avatar = null;
            this._bitmapShared = false;
            this._bitmapHasSource = false;
            this._initialized = false;
            this._hidden = false;
        }

        public function update(sprite:IRoomObjectSprite, scale:Float)
        {
            var firstUpdate:Bool;
            var elapsed:Int;
            var baseSize:Int;

            if (sprite == null)
            {
                return;
            }

            if (this._hidden || (this._hideAt > 0 && flash.Lib.getTimer() >= this._hideAt))
            {
                this._hidden = true;
                sprite.alpha = 0;
                sprite.visible = false;
                return;
            }

            this._scale = scale;
            firstUpdate = !this._initialized;
            if (firstUpdate)
            {
                this._runtimeAsset = HabbiconAssetManager.getRuntimeAsset(this._habbiconId);
                this._animated = this._runtimeAsset != null && ASCompat.toBool(this._runtimeAsset.animated);
                this._startTime = flash.Lib.getTimer();
                this._currentFrameIndex = this.resolveFrameIndex(0);
                this.configureTiming();
                this.applyFrame(this.resolveBitmap(scale, this.resolveSourceAlpha(this._startTime), this.resolveBackgroundAlpha(this._startTime)));
                this._initialized = true;
            }

            elapsed = flash.Lib.getTimer() - this._startTime;
            baseSize = scale < 48 ? 32 : 64;
            sprite.asset = this._bitmap;
            sprite.offsetX = (scale < 48 ? ROOM_SMALL_OFFSET_X : ROOM_LARGE_OFFSET_X) + this.resolveFrameAnchorCompensationX();
            sprite.offsetY = (scale < 48 ? ROOM_SMALL_OFFSET_Y : ROOM_LARGE_OFFSET_Y) + this.getIntroOffsetY(elapsed) + this.resolveFrameAnchorCompensationY();

            if (this._avatar != null)
            {
                if (this._avatar.posture == "sit")
                {
                    sprite.offsetY += Std.int(baseSize / 2);
                }
                else if (this._avatar.posture == "lay")
                {
                    sprite.offsetY += baseSize;
                }
            }

            sprite.relativeDepth = this._relativeDepth;
            if (firstUpdate)
            {
                sprite.visible = true;
                sprite.alpha = 255;
            }
        }

        public function animate(sprite:IRoomObjectSprite):Bool
        {
            var previousAsset:ASObject;
            var now:Int;
            var elapsed:Int;
            var frameIndex:Int;
            var sourceAlpha:Int;
            var backgroundAlpha:Int;
            var dirty= false;
            var baseSize= 64;
            var maxAlpha:Int;

            if (sprite == null)
            {
                return false;
            }

            now = flash.Lib.getTimer();
            elapsed = now - this._startTime;
            previousAsset = this._runtimeAsset;
            this._runtimeAsset = HabbiconAssetManager.getRuntimeAsset(this._habbiconId);
            if (this._runtimeAsset != previousAsset)
            {
                this._animated = this._runtimeAsset != null && ASCompat.toBool(this._runtimeAsset.animated);
                this.configureTiming();
                dirty = true;
            }

            frameIndex = this.resolveFrameIndex(elapsed);
            if (this._runtimeAsset != null && frameIndex != this._currentFrameIndex)
            {
                this._currentFrameIndex = frameIndex;
                dirty = true;
            }

            sourceAlpha = this.resolveSourceAlpha(now);
            backgroundAlpha = this.resolveBackgroundAlpha(now);
            if (sourceAlpha != this._lastSourceAlpha || backgroundAlpha != this._lastBackgroundAlpha)
            {
                dirty = true;
            }

            if (dirty)
            {
                this.applyFrame(this.resolveBitmap(this._scale, sourceAlpha, backgroundAlpha));
            }

            if (this._bitmap != null)
            {
                sprite.asset = this._bitmap;
            }

            baseSize = this._scale < 48 ? 32 : 64;
            sprite.relativeDepth = this._relativeDepth;
            sprite.offsetX = (this._scale < 48 ? ROOM_SMALL_OFFSET_X : ROOM_LARGE_OFFSET_X) + this.resolveFrameAnchorCompensationX();
            sprite.offsetY = (this._scale < 48 ? ROOM_SMALL_OFFSET_Y : ROOM_LARGE_OFFSET_Y) + this.getIntroOffsetY(elapsed) + this.resolveFrameAnchorCompensationY();
            if (this._avatar != null)
            {
                if (this._avatar.posture == "sit")
                {
                    sprite.offsetY += Std.int(baseSize / 2);
                }
                else if (this._avatar.posture == "lay")
                {
                    sprite.offsetY += baseSize;
                }
            }

            if (now >= this._hideAt)
            {
                this._hidden = true;
                sprite.alpha = 0;
                sprite.visible = false;
                return true;
            }

            maxAlpha = Std.int(Math.max(sourceAlpha, backgroundAlpha));
            sprite.alpha = 255;
            sprite.visible = maxAlpha > 0;
            return true;
        }

        static function getOutlineBitmap(source:BitmapData, key:String):BitmapData
        {
            var bitmap= ASCompat.dynamicAs(_outlineCache[key] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createOutlineBitmap(source);
            _outlineCache[key] = bitmap;
            return bitmap;
        }

        static function createOutlineBitmap(source:BitmapData):BitmapData
        {
            var dx:Int;
            var dy:Int;
            var result= new BitmapData(source.width + OUTLINE_SIZE * 2, source.height + OUTLINE_SIZE * 2, true, 0);
            var mask= new BitmapData(source.width, source.height, true, OUTLINE_COLOR);
            var point= new Point();
            mask.copyChannel(source, source.rect, point, 8, 8);
            for (_tmp_ in -OUTLINE_SIZE...OUTLINE_SIZE + 1)
            {
dy = _tmp_;
                for (_tmp_ in -OUTLINE_SIZE...OUTLINE_SIZE + 1)
                {
dx = _tmp_;
                    if (dx != 0 || dy != 0)
                    {
                        point.x = OUTLINE_SIZE + dx;
                        point.y = OUTLINE_SIZE + dy;
                        result.copyPixels(mask, mask.rect, point, null, null, true);
                    }
                }
            }
            mask.dispose();
            return result;
        }

        static function getMirroredBitmap(source:BitmapData, key:String):BitmapData
        {
            var bitmap= ASCompat.dynamicAs(_mirrorCache[key] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createMirroredBitmap(source);
            _mirrorCache[key] = bitmap;
            return bitmap;
        }

        static function createMirroredBitmap(source:BitmapData):BitmapData
        {
            var bitmap= new BitmapData(source.width, source.height, true, 0);
            var matrix= new Matrix();
            matrix.scale(-1, 1);
            matrix.translate(source.width, 0);
            bitmap.draw(source, matrix, null, null, null, false);
            return bitmap;
        }

        static function getBackgroundShadowBitmap(outline:BitmapData, key:String):BitmapData
        {
            var bitmap= ASCompat.dynamicAs(_shadowCache[key] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createBackgroundShadowBitmap(outline);
            _shadowCache[key] = bitmap;
            return bitmap;
        }

        static function createBackgroundShadowBitmap(outline:BitmapData):BitmapData
        {
            var result= new BitmapData(outline.width + BACKGROUND_SHADOW_PADDING * 2, outline.height + BACKGROUND_SHADOW_PADDING * 2, true, 0);
            var shadowLayer= new BitmapData(result.width, result.height, true, 0);
            var alphaMask= new BitmapData(outline.width, outline.height, true, 0xFF000000 | BACKGROUND_SHADOW_COLOR);
            var filter= new BlurFilter(BACKGROUND_SHADOW_BLUR, BACKGROUND_SHADOW_BLUR, BACKGROUND_SHADOW_QUALITY);
            alphaMask.copyChannel(outline, outline.rect, new Point(), 8, 8);
            shadowLayer.copyPixels(alphaMask, alphaMask.rect, new Point(BACKGROUND_SHADOW_PADDING + BACKGROUND_SHADOW_OFFSET_X, BACKGROUND_SHADOW_PADDING + BACKGROUND_SHADOW_OFFSET_Y), null, null, true);
            shadowLayer.colorTransform(shadowLayer.rect, new ColorTransform(1, 1, 1, BACKGROUND_SHADOW_ALPHA));
            result.applyFilter(shadowLayer, shadowLayer.rect, new Point(), filter);
            alphaMask.dispose();
            shadowLayer.dispose();
            return result;
        }

        static function drawBitmapLayer(target:BitmapData, source:BitmapData, x:Int, y:Int, alpha:Int)
        {
            var matrix:Matrix;
            if (alpha <= 0)
            {
                return;
            }
            if (alpha >= 255)
            {
                target.copyPixels(source, source.rect, new Point(x, y), null, null, true);
                return;
            }
            matrix = new Matrix();
            matrix.translate(x, y);
            target.draw(source, matrix, new ColorTransform(1, 1, 1, alpha / 255));
        }

        function configureTiming()
        {
            this._sourceHiddenAt = this._startTime + DEFAULT_VISIBLE_DURATION_MS;
            this._sourceFadeStart = this._sourceHiddenAt - FADE_OUT_DURATION_MS;
            this._backgroundHiddenAt = this._startTime + BACKGROUND_VISIBLE_DURATION_MS;
            this._backgroundFadeStart = this._backgroundHiddenAt - BACKGROUND_FADE_OUT_DURATION_MS;
            this._hideAt = Std.int(Math.max(this._sourceHiddenAt, this._backgroundHiddenAt));
        }

        function resolveFrameIndex(elapsed:Int):Int
        {
            var step:ASObject = this.getCurrentStep(elapsed);
            if (this._runtimeAsset == null || this._runtimeAsset.frames == null || this._runtimeAsset.frames.length == 0 || step == null)
            {
                return 0;
            }
            return Std.int(Math.max(0, Math.min(ASCompat.toInt(step.sourceFrame), ASCompat.toNumber(ASCompat.toNumber(this._runtimeAsset.frames.length) - 1))));
        }

        function getCurrentStep(elapsed:Int):ASObject
        {
            var steps:Array<ASAny>;
            var total= 0;
            var step:ASObject;
            var cursor= 0;
            if (this._runtimeAsset == null || !Std.is(this._runtimeAsset.steps , Array) || this._runtimeAsset.steps.length == 0)
            {
                return null;
            }
            steps = ASCompat.dynamicAs(this._runtimeAsset.steps , Array);
            if (steps.length == 1)
            {
                return steps[0];
            }
            for (_tmp_ in steps)
            {
step  = _tmp_;
                total += Std.int(Math.max(1, ASCompat.toInt(step.durationMs)));
            }
            if (total <= 0)
            {
                return steps[0];
            }
            if (this._animated)
            {
                elapsed %= total;
            }
            else if (elapsed >= total)
            {
                return steps[steps.length - 1];
            }
            for (_tmp_ in steps)
            {
step  = _tmp_;
                cursor += Std.int(Math.max(1, ASCompat.toInt(step.durationMs)));
                if (elapsed < cursor)
                {
                    return step;
                }
            }
            return steps[steps.length - 1];
        }

        function getIntroOffsetY(elapsed:Int):Int
        {
            var progress= Math.min(1, Math.max(0, elapsed / INTRO_DURATION_MS));
            return Std.int(Math.fround((1 - progress) * INTRO_START_OFFSET_Y));
        }

        function resolveSourceAlpha(now:Int):Int
        {
            var fadeIn= Math.min(1, Math.max(0, (now - this._startTime) / FADE_IN_DURATION_MS));
            var fadeOut= now < this._sourceFadeStart ? 1 : 1 - Math.min(1, Math.max(0, (now - this._sourceFadeStart) / FADE_OUT_DURATION_MS));
            if (this._sourceHiddenAt > 0 && now >= this._sourceHiddenAt)
            {
                return 0;
            }
            return Std.int(Math.fround(255 * Math.min(fadeIn, fadeOut)));
        }

        function resolveBackgroundAlpha(now:Int):Int
        {
            var fadeIn= Math.min(1, Math.max(0, (now - this._startTime) / FADE_IN_DURATION_MS));
            var fadeOut= now < this._backgroundFadeStart ? 1 : 1 - Math.min(1, Math.max(0, (now - this._backgroundFadeStart) / BACKGROUND_FADE_OUT_DURATION_MS));
            return Std.int(Math.fround(255 * Math.min(fadeIn, fadeOut)));
        }

        function resolveBitmap(scale:Float, sourceAlpha:Int = -1, backgroundAlpha:Int = -1):BitmapData
        {
            var source:BitmapData;
            var frames:Array<ASAny>;
            var cacheKey:String;
            var outline:BitmapData;
            var frame:ASObject;
            var baseDimension= scale < 48 ? 20 : 40;
            var small= scale < 48;
            if (sourceAlpha < 0)
            {
                sourceAlpha = this.resolveSourceAlpha(flash.Lib.getTimer());
            }
            if (backgroundAlpha < 0)
            {
                backgroundAlpha = this.resolveBackgroundAlpha(flash.Lib.getTimer());
            }
            this._bitmapShared = false;
            this._bitmapHasSource = false;
            this._bitmapBaseDimension = baseDimension;
            if (this._runtimeAsset != null && Std.is(this._runtimeAsset.frames , Array) && this._runtimeAsset.frames.length > 0)
            {
                frames = ASCompat.dynamicAs(this._runtimeAsset.frames , Array);
                if (this._currentFrameIndex < 0 || this._currentFrameIndex >= frames.length)
                {
                    this._currentFrameIndex = 0;
                }
                frame = frames[this._currentFrameIndex];
                source = small ? ASCompat.dynamicAs(frame.smallBitmap , BitmapData) : ASCompat.dynamicAs(frame.bitmap , BitmapData);
            }
            else
            {
                source = HabbiconAssetManager.getPreviewBitmap(this._habbiconId, small);
            }
            if (source != null)
            {
                this._bitmapHasSource = true;
                this._bitmapBaseDimension = source.width + OUTLINE_SIZE * 2 + BACKGROUND_SHADOW_PADDING * 2;
                this._lastSourceAlpha = sourceAlpha;
                this._lastBackgroundAlpha = backgroundAlpha;
                cacheKey = this.createOutlineBitmapCacheKey(small);
                if (this.shouldMirrorHabbicon())
                {
                    cacheKey += ":mirrored";
                    source = getMirroredBitmap(source, cacheKey);
                }
                outline = getOutlineBitmap(source, cacheKey);
                return this.composeBitmap(source, outline, getBackgroundShadowBitmap(outline, cacheKey), this._bitmap, sourceAlpha, backgroundAlpha);
            }
            if (this._bitmap != null && !this._bitmapShared && this._bitmapBaseDimension == baseDimension)
            {
                return this._bitmap;
            }
            return this.createFallbackBitmap(baseDimension, this.seededColor(this._habbiconId * 37));
        }

        function applyFrame(bitmap:BitmapData)
        {
            this.setBitmap(bitmap, this._bitmapShared, this._bitmapBaseDimension, this._bitmapHasSource);
        }

        function setBitmap(bitmap:BitmapData, shared:Bool, baseDimension:Int, hasSource:Bool)
        {
            if (this._bitmap == bitmap)
            {
                this._bitmapShared = shared;
                this._bitmapBaseDimension = baseDimension;
                this._bitmapHasSource = hasSource;
                return;
            }
            if (this._bitmap != null && !this._bitmapShared)
            {
                this._bitmap.dispose();
            }
            this._bitmap = bitmap;
            this._bitmapShared = shared;
            this._bitmapBaseDimension = baseDimension;
            this._bitmapHasSource = hasSource;
        }

        function resolveFrameAnchorCompensationX():Int
        {
            var baseWidth:Int;
            if (this._bitmap == null)
            {
                return 0;
            }
            if (this._runtimeAsset == null)
            {
                return this._bitmapHasSource ? -BACKGROUND_CONTENT_INSET : 0;
            }
            baseWidth = this.resolveBaseDimension("baseWidth");
            return Std.int(Math.fround((baseWidth - this._bitmap.width) * 0.5));
        }

        function resolveFrameAnchorCompensationY():Int
        {
            var baseHeight:Int;
            if (this._bitmap == null)
            {
                return 0;
            }
            if (this._runtimeAsset == null)
            {
                return this._bitmapHasSource ? -BACKGROUND_CONTENT_INSET : 0;
            }
            baseHeight = this.resolveBaseDimension("baseHeight");
            return baseHeight - this._bitmap.height + (this._bitmapHasSource ? BACKGROUND_CONTENT_INSET : 0);
        }

        function resolveBaseDimension(propertyName:String):Int
        {
            var value= ASCompat.toInt(this._runtimeAsset[propertyName]);
            if (this._scale < 48)
            {
                return Std.int(Math.max(1, Std.int(Math.fround(value * 0.5))));
            }
            return Std.int(Math.max(1, value));
        }

        function createFallbackBitmap(size:Int, color:UInt):BitmapData
        {
            var bitmap= new BitmapData(size, size, true, 0);
            var outer= Std.int(Math.max(2, size / 8));
            var inner= Std.int(Math.max(1, size / 4));
            bitmap.fillRect(bitmap.rect, 0);
            bitmap.fillRect(new Rectangle(outer, outer, size - outer * 2, size - outer * 2), 0xFF000000 | color);
            bitmap.fillRect(new Rectangle(inner, inner, size - inner * 2, size - inner * 2), OUTLINE_COLOR);
            return bitmap;
        }

        function createOutlineBitmapCacheKey(small:Bool):String
        {
            var hasRuntime= this._runtimeAsset != null && Std.is(this._runtimeAsset.frames , Array) && this._runtimeAsset.frames.length > 0;
            var sourceType= hasRuntime ? (this._runtimeAsset.animated ? "animated" : "runtime") : "preview";
            return this._habbiconId + ":" + sourceType + ":" + (small ? "small" : "large") + ":" + this._currentFrameIndex;
        }

        function shouldMirrorHabbicon():Bool
        {
            var avatarDirection:Int;
            var habbiconDirection:Int;
            if (!this._mirroringResolved)
            {
                avatarDirection = this._avatar != null ? this._avatar.habbiconFacingDirection : 0;
                habbiconDirection = HabbiconAssetManager.getDirection(this._habbiconId);
                this._mirror = avatarDirection != 0 && habbiconDirection != 0 && avatarDirection != habbiconDirection;
                this._mirroringResolved = true;
            }
            return this._mirror;
        }

        function composeBitmap(source:BitmapData, outline:BitmapData, shadow:BitmapData, reuse:BitmapData, sourceAlpha:Int, backgroundAlpha:Int):BitmapData
        {
            var result:BitmapData;
            if (reuse != null && !this._bitmapShared && reuse.width == shadow.width && reuse.height == shadow.height)
            {
                result = reuse;
                result.fillRect(result.rect, 0);
            }
            else
            {
                result = new BitmapData(shadow.width, shadow.height, true, 0);
            }
            drawBitmapLayer(result, shadow, 0, 0, backgroundAlpha);
            drawBitmapLayer(result, outline, BACKGROUND_SHADOW_PADDING, BACKGROUND_SHADOW_PADDING, backgroundAlpha);
            drawBitmapLayer(result, source, BACKGROUND_CONTENT_INSET, BACKGROUND_CONTENT_INSET, sourceAlpha);
            return result;
        }

        function seededColor(value:Int):UInt
        {
            switch (value % 6)
            {
                case 0:
                    return 0xF9C92F;
                case 1:
                    return 0xF39E2F;
                case 2:
                    return 0xEF822F;
                case 3:
                    return 0x8EDBFF;
                case 4:
                    return 0x4DC5A8;
                default:
                    return 0xC37DF5;
            }
        }
    }

