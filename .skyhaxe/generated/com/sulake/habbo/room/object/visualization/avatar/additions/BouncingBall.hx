package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.room.object._enum.AlphaTolerance;

    /**
     * The ball a BattleBall player rides.
     *
     * The original composited this into the avatar's own figure rather than layering it over the room:
     * hh_game_bb's variable.index lists the parts as
     *
     *   bouncing.human.parts.sh=["bl","li","lh","ls","bd","sh","lg","ch","hd","fc","ey","hr","ri","rh","rs"]
     *
     * with "bl" FIRST, so the ball is drawn before the body and the rider's legs sit in front of it.
     * Drawing it as a sprite above the room canvas put it in front of the Habbo instead, which is why
     * it is an avatar addition here -- additions share the avatar's sprite stack, so relativeDepth can
     * place it behind the body.
     *
     * Bouncing Bodypart Class builds the member as
     *   size_action_part_model_direction_frame
     * with the action pinned to "wlk" and the direction pinned to 1 whichever way the rider faces, so a
     * single greyscale sprite serves all eight directions and is tinted to the team colour at runtime.
     */
     class BouncingBall implements IAvatarAddition
    {
        /** Positive depth puts the ball behind the body; the bubbles use negative to sit in front. */
        static inline final RELATIVE_DEPTH= 0.02;
        /** Frames shipped by the cast. There is no frame 2 -- Director skipped what it could not find. */
        static final FRAMES:Array<ASAny> = [0, 1, 3];
        /**
         * Bouncing Bodypart draws at tY = bufferHeight - regY - 10. The member registers at y=12 and is
         * 17 tall, so the ball's bottom lands 5px above the foot line and overlaps the legs it replaces.
         */
        static inline final FOOT_LIFT= 5;
        /**
         * adjustScreenLoc in Bouncing Human Class: a rider never sits still. Moving uses the deeper
         * seven-step curve, idling the shallower six-step one, scaled by 10.
         *
         * BattleBallArena applies this to the room object's height, so rider and ball move together
         * exactly as pScreenLoc does. It is deliberately NOT written to sprite offsets here:
         * body.offsetY belongs to AvatarVisualization, which rewrites it whenever the seated figure
         * animates, so a bounce written there is raced away and reappears intermittently -- the stutter.
         */
        static final BOUNCE_MOVING:Array<ASAny> = [0, -0.5, -1.0, -1.2, -1.0, -0.5, 0];
        static final BOUNCE_IDLE:Array<ASAny> = [0, -0.3, -0.4, -0.5, -0.4, -0.1];
        static inline final BOUNCE_SCALE:Float = 10;
        static inline final BOUNCE_STEP_MS= 100;

        /**
         * Sprite index of the rider's body, nudged so they bob with the ball.
         *
         * This is 0. AvatarVisualization writes the figure to getSprite(ADDITION_ID_IDLE_BUBBLE), and
         * that constant is 0 -- the decompiled names are misleading. Its own SPRITE_INDEX_AVATAR is 2,
         * which is the initial sprite count and the angle reset value, NOT the body's index; writing
         * there moves a sprite that is not the Habbo, so the rider never bounced.
         */
        static inline final SPRITE_INDEX_BODY= 0;
        /** me.pXFix in Bouncing Bodypart Class is -2 for every direction but the first and last. */
        static inline final BALL_X_FIX= -2;
        /**
         * Pixels the rider is lifted onto the ball by BattleBallArena (BALL_RIDE_PX). The ball is a
         * sprite of the avatar's own room object, so that lift moves the ball too -- it has to be added
         * back here for the ball to stay down on the floor while the rider rises off it.
         */
        static inline final RIDE_LIFT= 12;
        /**
         * Drop on the floor reference. scale/4 is where AvatarVisualization puts the body's feet, but
         * the rider sits down into the ball rather than perched on top of it, so the ball sits lower
         * than that line. Independent of BALL_RIDE_PX: that constant moves the rider, this one the ball.
         */
        static inline final GROUND_DROP= 10;

        var _id:Int = -1;
        var _visualization:AvatarVisualization;
        var _frames:Array<ASAny>;
        var _colour:UInt = 0;
        var _tinted:Array<ASAny>;
        var _frameIndex:Int = -1;
        var _bounceStep:Int = -1;
        /** Render scale from the last update; animate() is not given one. */
        var _scale:Float = 64;
        /**
         * Whether the rider is crossing a tile. This cannot be read from the posture: the rider is held
         * in "sit" for the whole round (pMainAction), so posture == "mv" is never true and the deeper
         * moving curve would never be selected. The game tells us instead.
         */
        var _moving:Bool = false;
        var _disposed:Bool = false;

        /**
         * @param frames the greyscale ball art, in cycle order, supplied by the game because it lives in
         *               the hh_game_bb_ui library rather than the avatar's own.
         */
        public function new(id:Int, visualization:AvatarVisualization, frames:Array<ASAny>, colour:UInt)
        {
            this._id = id;
            this._visualization = visualization;
            this._frames = frames;
            this._colour = colour;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        /** Team changes mid-round, so the tint can be re-pointed without rebuilding the addition. */
        public var colour(never,set):UInt;
public function  set_colour(value:UInt):UInt        {
            if (this._colour == value) return value;
            this._colour = value;
            this.releaseTinted();
return value;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this.releaseTinted();
            this._frames = null;
            this._visualization = null;
            this._disposed = true;
        }

        function releaseTinted()
        {
var bitmap:BitmapData  = null;            if (this._tinted == null) return;
            final _iter_ = this._tinted; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
bitmap = _tmp_;
                if (bitmap != null) bitmap.dispose();
            }
            this._tinted = null;
        }

        /** The art is greyscale precisely so setBallColor could multiply the team colour through it. */
        function tinted(index:Int):BitmapData
        {
            if (this._frames == null || index < 0 || index >= this._frames.length) return null;
            if (this._tinted == null) this._tinted = ASCompat.allocArray(this._frames.length);
            if (this._tinted[index] != null) return ASCompat.dynamicAs(this._tinted[index] , BitmapData);
            var source= ASCompat.dynamicAs(this._frames[index] , BitmapData);
            if (source == null) return null;
            var copy= new BitmapData(source.width, source.height, true, 0);
            copy.copyPixels(source, source.rect, new Point(0, 0), null, null, true);
            copy.colorTransform(copy.rect, new ColorTransform(
                ((ASCompat.toInt(this._colour )>> 16) & 0xFF) / 255,
                ((ASCompat.toInt(this._colour )>> 8) & 0xFF) / 255,
                (ASCompat.toInt(this._colour )& 0xFF) / 255, 1));
            this._tinted[index] = copy;
            return copy;
        }

        /**
         * One phase drives both the squash frame and the bounce height.
         *
         * Director advanced pAnimCounter (the ball art) and pBounceAnimCount (the height) once per tick,
         * so they stayed locked and the squashed frame always landed at the bottom of the bounce. Giving
         * them separate periods -- 450ms of art against a 600/700ms curve -- let them drift through each
         * other continuously, which is what made the cycle look wrong.
         */
        function phase():Float
        {
            var curve= this.bounceCurve();
            var span= curve.length * BOUNCE_STEP_MS;
            return span <= 0 ? 0 : (flash.Lib.getTimer() % span) / BOUNCE_STEP_MS;
        }

        function currentFrame():Int
        {
            if (FRAMES.length == 0) return 0;
            return Std.int(this.phase()) % FRAMES.length;
        }

        /** adjustScreenLoc picks the deeper curve while moving, the shallower one at rest. */
        function bounceCurve():Array<ASAny>
        {
            return this._moving ? BOUNCE_MOVING : BOUNCE_IDLE;
        }

        public var moving(never,set):Bool;
public function  set_moving(value:Bool):Bool        {
            return this._moving = value;
        }

        /**
         * Pixels the rider is lifted right now.
         *
         * The curve is sampled continuously rather than held for a whole step. Director advanced
         * pBounceAnimCount once per engine tick, which at its frame rate read as a smooth bob; holding
         * each entry for a fixed 100ms at 60fps instead means the rider sits still for six frames then
         * jumps several pixels, which is the judder. Interpolating between neighbouring entries gives
         * back the same curve as continuous motion.
         */
        function bounceOffset():Float
        {
            var curve= this.bounceCurve();
            if (curve.length == 0) return 0;
            var position= this.phase();
            var index= Std.int(position);
            var next= (index + 1) % curve.length;
            var blend= position - index;
            var value= (ASCompat.toNumber(curve[index]) * (1 - blend)) + (ASCompat.toNumber(curve[next]) * blend);
            return value * BOUNCE_SCALE;
        }

        /** Whole-pixel lift, which is what actually has to change before a redraw is worth forcing. */
        function bouncePixels():Int
        {
            return Std.int(Math.fround(this.bounceOffset()));
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            if (this._disposed || k == null) return false;
            // The body offset MUST be re-applied every frame, before any early exit. The seated figure
            // animates, so AvatarVisualization rewrites that offset on its own schedule and wipes the
            // bounce; skipping this on frames where the ball's art happens to be unchanged left the
            // rider snapping between bounced and unbounced. The ball never showed it because nothing
            // else writes the ball's offset.
            var moved= false;
            // Returning true makes the visualization redraw, which is what keeps a stationary rider
            // bouncing -- an idle avatar is otherwise only updated when something about it changes.
            if (this.currentFrame() == this._frameIndex && this.bouncePixels() == this._bounceStep) return moved;
            this.apply(k);
            return true;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            if (this._disposed || k == null) return;
            if (_arg_2 > 0) this._scale = _arg_2;
            this.apply(k);
        }

        /**
         * Bobs the rider, matching adjustScreenLoc moving the whole figure rather than the ball alone.
         *
         * The baseline is re-taken only when the offset differs from what this addition last wrote --
         * that is precisely the case where AvatarVisualization has recomputed it. Rebasing on a fixed
         * schedule instead was the bug: the sprite rebuild early-outs when nothing about the avatar has
         * changed, so the field still held the previous bounce, the baseline absorbed it, and the rider
         * drifted by an oscillating amount every cycle -- the stutter, not a clean curve.
         */
        function apply(k:IRoomObjectSprite)
        {
            var index= this.currentFrame();
            var bitmap= this.tinted(index);
            if (bitmap == null)
            {
                k.visible = false;
                return;
            }
            this._frameIndex = index;
            this._bounceStep = this.bouncePixels();
            k.visible = true;
            k.asset = bitmap;
            // Anchor to the rider's own body sprite rather than to the tile. AvatarVisualization
            // recomputes that sprite's offsets every update from the avatar image, so its bottom edge
            // follows the figure through every posture and scale. A fixed offset from the tile point
            // was right only for a standing avatar and left the ball up by the head of a seated one.
            // The ball rests on the floor and the rider is raised onto it (BattleBallArena.BALL_RIDE_PX),
            // so this anchors to the object's own tile point -- offsets are added to that by
            // RoomSpriteCanvas. Anchoring to the body sprite instead dragged the ball up with the rider.
            //
            // Nothing here writes to the body sprite: apply() also runs from animate(), which fires every
            // frame without the visualization having recomputed those offsets, so a read-modify-write
            // there compounds and launches the rider out of the room.
            // Vertical reference, all relative to the object's tile point P:
            //   AvatarVisualization gives the body sprite offsetY = -assetHeight + scale/4 + ..., so an
            //   unlifted avatar's feet -- the floor -- sit at P + scale/4, not at P itself.
            //   The rider is then raised RIDE_LIFT px onto the ball, which moves P up by the same
            //   amount, so the floor is now P + scale/4 + RIDE_LIFT.
            //   The ball's bottom belongs FOOT_LIFT above that floor, per Bouncing Bodypart Class.
            // offsetY grows downward, so GROUND_DROP is ADDED to lower the ball. Subtracting it raised
            // the ball instead, which is the opposite of what it is for.
            var floorY= (this._scale / 4) + RIDE_LIFT + GROUND_DROP;
            k.offsetX = -Std.int(bitmap.width / 2) + BALL_X_FIX;
            k.offsetY = Std.int(floorY) - FOOT_LIFT - bitmap.height;
            k.relativeDepth = RELATIVE_DEPTH;
            k.alphaTolerance = AlphaTolerance.MATCH_ALL_PIXELS;
        }
    }

