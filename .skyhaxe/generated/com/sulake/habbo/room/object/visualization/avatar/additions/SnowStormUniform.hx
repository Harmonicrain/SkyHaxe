package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.habbo.snowstorm.SnowStormAssets;
    import com.sulake.habbo.snowstorm.SnowStormUniformFigure;
    import com.sulake.habbo.snowstorm.data.SnowStormUniformAssetData;
    import com.sulake.room.object._enum.AlphaTolerance;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Replaces one private arena avatar's body sprite with its normal head and the converted r26 coat.
     * The hotel/account figure remains the immutable source string and is never rewritten.
     */
     final class SnowStormUniform implements IAvatarAddition
    {
        // Shockwave's prone ff/fb members extend as far as 55 px from the
        // avatar origin. A 32 px standing canvas clipped them in half and left
        // the separately rendered upright head floating above the fragments.
        static inline final RENDER_WIDTH= 96;
        static inline final LEGACY_ANCHOR_X= 16;
        static inline final ANCHOR_X= 48;
        static final DRAW_X_SHIFT:Int = ANCHOR_X - LEGACY_ANCHOR_X;
        static inline final STANDING_HEIGHT= 62;
        static inline final RENDER_HEIGHT= 80;
        static inline final BODY_Y_FIX= -3;
        static inline final HEAD_Y_FIX= 5;
        static inline final RELATIVE_DEPTH= -0.001;
        static inline final HEAD_FRAME_MS= 250;
        static inline final THROW_FIRST_POSE_MS= 100;
        static inline final THROW_TOTAL_MS= 400;
        static inline final FALL_FIRST_POSE_MS= 80;

        var _id:Int = 0;
        var _visualization:AvatarVisualization;
        var _assets:SnowStormAssets;
        var _head:IAvatarImage;
        var _action:String = "std";
        var _direction:Int = 2;
        var _frame:Int = 0;
        var _actionStartedAt:Int = 0;
        var _colour:UInt = 0;
        var _invincible:Bool = false;
        var _rendered:BitmapData;
        var _renderKey:String = "";
        var _disposed:Bool = false;

        public function new(id:Int, visualization:AvatarVisualization,
                                         assets:SnowStormAssets, avatars:IAvatarRenderManager,
                                         baseFigure:String, colour:UInt)
        {
            this._id = id;
            this._visualization = visualization;
            this._assets = assets;
            this._colour = colour;
            if (avatars != null && baseFigure != null && baseFigure != "")
                this._head = avatars.createAvatarImage(baseFigure, AvatarScaleType.SMALL);
        }

        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }

        public function setState(action:String, direction:Int, frame:Int,
                                 colour:UInt, invincible:Bool)
        {
            action = normalizeAction(action);
            direction = ((direction % 8) + 8) % 8;
            frame = Std.int(Math.max(0, frame));
            if (this._action != action || this._direction != direction || this._frame != frame ||
                this._colour != colour)
            {
                if (this._action != action || this._frame != frame) this._actionStartedAt = flash.Lib.getTimer();
                this._action = action;
                this._direction = direction;
                this._frame = frame;
                this._colour = colour;
                this._renderKey = "";
            }
            this._invincible = invincible;
        }

        public function update(sprite:IRoomObjectSprite, scale:Float)
        {
            this.apply(sprite, scale);
        }

        public function animate(sprite:IRoomObjectSprite):Bool
        {
            if (this._disposed || sprite == null) return false;
            var before= this._renderKey;
            var alphaBefore= sprite.alpha;
            this.apply(sprite, 32);
            return before != this._renderKey || alphaBefore != sprite.alpha;
        }

        /** Immutable copy used by Shockwave's final-score best-player portrait. */
        public function snapshot():BitmapData
        { return this._rendered == null ? null : this._rendered.clone(); }

        function apply(sprite:IRoomObjectSprite, scale:Float)
        {
            if (this._disposed || sprite == null || this._visualization == null) return;
            this._visualization.setPrimaryAvatarSpriteSuppressed(this._id, true);
            var now= flash.Lib.getTimer();
            var displayAction= this.displayAction(now);
            var headFrame= Std.int(now / HEAD_FRAME_MS);
            var walkFrame= displayAction == "wlk" ? Std.int(now / 100) % 4 : this._frame;
            var key= displayAction + ":" + Std.string(this._direction) + ":" + Std.string(walkFrame) + ":" +
                Std.string(this._colour) + ":" + Std.string(headFrame);
            if (key != this._renderKey)
            {
                this.render(displayAction, walkFrame);
                this._renderKey = key;
            }
            sprite.visible = this._rendered != null;
            sprite.asset = this._rendered;
            sprite.offsetX = -ANCHOR_X;
            // The converted Shockwave registration data composes every standing body/shoe member
            // to a Y=62 foot line. The RoomEngine tile cursor's visible centre sits two pixels below
            // its object anchor, so apply the same fixed visual correction to the complete uniform.
            // AIR's normal avatar bitmap contains transparent space beneath its feet and therefore
            // needs its own scale/4 canvas correction; this tightly cropped replacement does not.
            sprite.offsetY = -STANDING_HEIGHT + 2;
            sprite.relativeDepth = RELATIVE_DEPTH;
            sprite.alpha = this._invincible && (Std.int(now / 180) % 2 == 0) ? 51 : 255;
            // Prone frames require a padded bitmap, but its transparent area must not enlarge the
            // normal game-avatar rollover target.
            sprite.alphaTolerance = AlphaTolerance.MATCH_OPAQUE_PIXELS;
        }

        function render(action:String, actionFrame:Int)
        {
var headDirection = 0, headBitmap:BitmapData  = null, headX = 0, headY = 0, sourceX = 0, sourceY = 0, sourceWidth = 0, sourceHeight = 0;            if (this._rendered != null) this._rendered.dispose();
            // Keep the 62 px Shockwave standing baseline for placement, but do not use it as
            // the bitmap boundary: fb/ff members reach roughly 70 px after their registration
            // offsets are applied. The old boundary cropped their lower coat/boots.
            this._rendered = new BitmapData(RENDER_WIDTH, RENDER_HEIGHT, true, 0);

            // Ask AIR for its HEAD avatar set explicitly. A figure string containing only head parts
            // still receives mandatory fallback body parts when FULL is rendered, which leaks the
            // hotel torso through the converted coat. The small downward correction joins the AIR
            // head to the Shockwave body without reintroducing those hidden body parts.
            var fallen= action == "ff1" || action == "ff2" ||
                action == "fb1" || action == "fb2";
            // Shockwave's prone ff/fb members already contain the complete downed silhouette.
            // Compositing AIR's upright HEAD set over those members leaves the player's hair and
            // face standing above the buried head, so the separate hotel head is standing-only.
            // Resolve this once for both layers. In particular, pck only has direction 0 and 2
            // source art; directions 4 and 6 mirror those members and their registration fixes.
            var direction:ASObject = sourceDirection(this._direction, action);
            if (this._head != null && !fallen)
            {
headDirection= this._direction;
                if (action == "pck") headDirection -= headDirection % 2;
                this._head.setDirection(AvatarSetType.HEAD, headDirection);
                this._head._Str_953(1);
headBitmap= this._head.getImage(AvatarSetType.HEAD, false);
                if (headBitmap != null)
                {
headX= 0;
headY= HEAD_Y_FIX;
                    if (action == "pck")
                    {
                        // arrangeParts_Pick moves the non-action parts relative to the pck collar.
                        // Preserve that relationship after source-member mirroring: direction 2 is
                        // +3 px, its direction-4 mirror is -3 px, while the 0/6 pair has no X shift.
                        headX = ASCompat.toInt(direction.value) == 2 ? (ASCompat.toBool(direction.flip) ? -3 : 3) : 0;
                        headY += ASCompat.toInt(direction.value) == 2 ? 5 : 3;
                    }
sourceX= Std.int(Math.max(0,
                        Std.int((headBitmap.width - (LEGACY_ANCHOR_X * 2)) / 2)));
sourceY= Std.int(Math.max(0, headBitmap.height - STANDING_HEIGHT));
sourceWidth= Std.int(Math.min(LEGACY_ANCHOR_X * 2,
                        headBitmap.width - sourceX));
sourceHeight= Std.int(Math.min(STANDING_HEIGHT, headBitmap.height - sourceY));
                    this._rendered.copyPixels(headBitmap,
                        new Rectangle(sourceX, sourceY, sourceWidth, sourceHeight),
                        new Point(DRAW_X_SHIFT + headX, headY), null, null, true);
                }
            }

            var frame= action == "wlk" ? actionFrame : 0;
            this.drawPart(action, "bd", ASCompat.toInt(direction.value), frame, ASCompat.toBool(direction.flip),
                SnowStormUniformFigure.FALLBACK_COLOUR);
            this.drawPart(action, "sh", ASCompat.toInt(direction.value), frame, ASCompat.toBool(direction.flip), this._colour);
        }

        function drawPart(action:String, part:String, direction:Int, frame:Int,
                                  flip:Bool, colour:UInt)
        {
            var info= SnowStormUniformAssetData.get(action, part, direction, frame);
            if (info == null && frame != 0)
                info = SnowStormUniformAssetData.get(action, part, direction, 0);
            if (info == null || this._assets == null) return;
            var source= this._assets.bitmapData(ASCompat.toString(info[0]));
            if (source == null) return;
            var x= -ASCompat.toInt(info[1]);
            var y= STANDING_HEIGHT - ASCompat.toInt(info[2]) + BODY_Y_FIX;
            var matrix= new Matrix();
            if (flip)
            {
                matrix.a = -1;
                // Mirror around the original 16 px composition origin, then
                // translate that origin into the padded bitmap. This retains
                // the entire 55 px prone member on either side of the avatar.
                matrix.tx = ANCHOR_X + LEGACY_ANCHOR_X - x;
            }
            else
            {
                matrix.tx = DRAW_X_SHIFT + x;
            }
            matrix.ty = y;
            var transform= new ColorTransform(
                ((ASCompat.toInt(colour )>> 16) & 0xFF) / 255,
                ((ASCompat.toInt(colour )>> 8) & 0xFF) / 255,
                (ASCompat.toInt(colour )& 0xFF) / 255,
                1);
            this._rendered.draw(source, matrix, transform, null, null, false);
        }

        static function sourceDirection(direction:Int, action:String):ASObject
        {
            if (action == "pck" || action.indexOf("ff") == 0 || action.indexOf("fb") == 0)
                direction -= direction % 2;
            if (direction == 4) return {value: 2, flip: true};
            if (direction == 5) return {value: 1, flip: true};
            if (direction == 6) return {value: 0, flip: true};
            return {value: direction, flip: false};
        }

        function displayAction(now:Int):String
        {
            var elapsed= now - this._actionStartedAt;
            if (this._action == "tr1")
            {
                if (elapsed < THROW_FIRST_POSE_MS) return "tr1";
                if (elapsed < THROW_TOTAL_MS) return "tr2";
                return "std";
            }
            if (this._action == "ff1" && elapsed >= FALL_FIRST_POSE_MS) return "ff2";
            if (this._action == "fb1" && elapsed >= FALL_FIRST_POSE_MS) return "fb2";
            return this._action;
        }

        static function normalizeAction(value:String):String
        {
            switch (value)
            {
                case "std"    | "wlk"    | "pck"    | "tr1"    | "tr2"
                   | "ff1"    | "ff2"    | "fb1"    | "fb2":
                    return value;
                default:
                    return "std";
            }
        }

        public function dispose()
        {
            if (this._disposed) return;
            if (this._visualization != null)
                this._visualization.setPrimaryAvatarSpriteSuppressed(this._id, false);
            if (this._head != null) this._head.dispose();
            if (this._rendered != null) this._rendered.dispose();
            this._head = null;
            this._rendered = null;
            this._assets = null;
            this._visualization = null;
            this._disposed = true;
        }
    }

