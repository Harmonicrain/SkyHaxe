package com.sulake.habbo.battleball
;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IRoomCreator;
    import com.sulake.habbo.room.RoomEngine;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.RoomGeometry;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectController;
    import flash.events.Event;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.additions.BouncingBall;
    import com.sulake.room.renderer.IRoomRenderingCanvas;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Hosts the BattleBall players inside a private RoomEngine instance so they render as real avatars,
     * with the original team effects, walk animation and depth sorting, rather than as flat sprites.
     *
     * The room's own planes are switched off: the arena floor stays the converted Director artwork that
     * BattleBallView draws underneath, and this canvas only ever contributes the avatars on top of it.
     */
     final class BattleBallArena
    {
        /** Private room id for the arena; kept clear of any real room the engine is showing. */
        static inline final ROOM_ID= 0x7B411;
        // RoomDesktop and the normal hotel room both reserve canvas 1. A private game canvas using that
        // id can inherit desktop zoom/resize camera operations whenever active-room state changes.
        static inline final CANVAS_ID= 47;
        /** Private object-id range for client-only tile appearances inside the private arena room. */
        static inline final TILE_OBJECT_ID_BASE= 0x6B000000;
        /** Matches the 32-wide BattleBall grid, so the engine also picks SMALL avatars. */
        static inline final GEOMETRY_SCALE= 32;
        /**
         * World name per arena. RoomContentLoader registers one world per layoutData entry in the cast's
         * visualization XML, so the world type is the layout's own name and the library it lives in
         * (hh_room_bb_arena) is resolved from that. The XML also carries size and heightScale per layout,
         * which is where the grid pitch and the per-map elevation come from.
         */
        static inline final ARENA_WORLD_PREFIX= "bb_arena_";
        /**
         * Team disc effects, in the order the protocol numbers the teams: red, blue, yellow, green.
         * These are the Battle Banzai set (BBRed/BBblue/BByellow/BBgreen), which is the only family with
         * all four colours. The SnowWar pair used previously only covers red and blue, so a three- or
         * four-team game gave two pairs of teams the same marker.
         */
        /** Height a sitting avatar expects its seat to be at. */
        /**
         * How far above the floor the rider sits, in pixels.
         *
         * Bouncing Bodypart Class draws the ball into the avatar's own 62px buffer (getPicture builds
         * image(32, 62, 32)) at tY = bufferHeight - regY - 10 = 62 - 12 - 10 = 40. The ball is 17 tall,
         * so it occupies 40..57: resting on the floor line with its top 22px up, and the seated body
         * sits on that top edge. The ball therefore belongs on the floor and the rider above it.
         *
         * 22 is the buffer figure; the sit pose already carries some of that height itself, so the lift
         * needed on top of it is smaller. Keep BouncingBall.RIDE_LIFT equal to this value -- the ball
         * cancels the lift out to stay on the floor while the rider rises off it.
         */
        static inline final BALL_RIDE_PX:Float = 12;
        static final BOUNCE_IDLE:Array<ASAny> = [0, -0.3, -0.4, -0.5, -0.4, -0.1];
        static inline final BOUNCE_SCALE:Float = 10;
        static inline final BOUNCE_STEP_MS= 100;
        /** Clear of the bubble/expression addition ids the visualization already uses (0-8). */
        static inline final BALL_ADDITION_ID= 64;
        /**
         * Effect id whose only job is to pose the rider's arms.
         *
         * Bouncing Human Class puts the arms in a different action from the rest of the figure:
         *   call(#defineActMultiple, me.pPartList, "sit", ["bd", "lg", "sh"])
         *   call(#defineActMultiple, me.pPartList, "crr", ["lh", "rh", "ls", "rs"])
         * so body, legs and shoes sit while the hands and sleeves take the carry pose to grip the ball.
         *
         * This client expresses that with a bodypart animation -- the same mechanism the built-in
         * dance.sixseven uses -- registered as fx.900 in battleball_ride_animation. Giving the avatar a
         * real carry item instead is wrong: AvatarLogic runs an automatic sip timer on anything held, so
         * after five seconds the rider keeps raising it to their face, which Shockwave never did.
         *
         * 900 is deliberately absent from effectmap.xml. EffectAssetDownloadManager reports an unknown
         * id as ready and downloads nothing, so no library is needed, and Sit's prevents list stops at
         * fx.195 so the effect survives the seated posture.
         */
        static inline final BALL_ARM_EFFECT= 900;

        var _roomEngine:IRoomEngine;
        var _canvas:DisplayObject;
        var _roomInitialized:Bool = false;
        var _mapId:Int = -1;
        var _instanceId:Int = -1;
        var _width:Int = 0;
        var _height:Int = 0;
        var _added:ASObject = {};
        var _figures:ASObject = {};
        var _positions:ASObject = {};
        var _effects:ASObject = {};
        var _tileStates:ASObject = {};
        var _directions:ASObject = {};
        var _moveUntil:ASObject = {};
        var _disposed:Bool = false;
        var _pixelsPerLevel:Float = 0;
        /** Height each rider would sit at with no bounce, keyed by object id. */
        var _restZ:ASObject = {};
        var _canvasWidth:Int = 0;
        var _canvasHeight:Int = 0;
        var _tileDiagnostic:String = "";

        public function new(roomEngine:IRoomEngine)
        {
            this._roomEngine = roomEngine;
        }

        public var canvas(get,never):DisplayObject;
public function  get_canvas():DisplayObject { return this._canvas; }
        public var ready(get,never):Bool;
public function  get_ready():Bool { return this._canvas != null; }

        /** Canvas-local avatar bounds used to anchor the client's native name bubble. */
        /**
         * Attaches the rider's ball to the avatar itself rather than to a layer over the room. The ball
         * is an avatar addition so it shares the avatar's sprite stack and can be depth-sorted behind
         * the body, which is where the cast's part order puts it. The frames come from the caller
         * because they live in the game's own library, not the avatar's.
         *
         * The visualization allocates a sprite per registered addition on its next update, so nothing
         * in AvatarVisualization needs changing to make room for this one.
         */
        public function setPlayerBall(objectId:Int, frames:Array<ASAny>, colour:UInt)
        {
            if (this._roomEngine == null || frames == null || frames.length == 0) return;
            var object= this._roomEngine.getRoomObject(
                ROOM_ID, objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if (object == null) return;
            var visualization= Std.downcast(object.getVisualization() , AvatarVisualization);
            if (visualization == null) return;
            var moving= ASCompat.toInt(this._moveUntil[Std.string(objectId)]) > 0;
            var existing= Std.downcast(visualization._Str_6142(BALL_ADDITION_ID) , BouncingBall);
            if (existing != null)
            {
                // Team switches mid-round, so re-point the tint rather than rebuilding the addition.
                existing.colour = colour;
                existing.moving = moving;
                return;
            }
            var ball= new BouncingBall(BALL_ADDITION_ID, visualization, frames, colour);
            ball.moving = moving;
            visualization._Str_8211(ball);
        }

        public function getPlayerBounds(objectId:Int):Rectangle
        {
            if (this._roomEngine == null || this._canvas == null) return null;
            return this._roomEngine.getRoomObjectBoundingRectangle(
                ROOM_ID, objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, CANVAS_ID);
        }

        /** Canvas-local avatar origin used to centre the client's native name bubble. */
        public function getPlayerScreenLocation(objectId:Int):Point
        {
            if (this._roomEngine == null || this._canvas == null) return null;
            return this._roomEngine.getRoomObjectScreenLocation(
                ROOM_ID, objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, CANVAS_ID);
        }

        /**
         * Builds the room from the authoritative tile set. Every cell carries the map floor height so the
         * engine places avatars at the right level and sorts them against each other correctly.
         */
        public function build(model:BattleBallModel, canvasWidth:Int, canvasHeight:Int, pixelsPerLevel:Float, boardOriginX:Float, boardOriginY:Float)
        {
var                 y = 0,                     x = 0, tile:ASObject  = null, standable = false;            if (this._disposed || this._roomEngine == null) return;
            if (this._mapId == model.mapId && this._instanceId == model.instanceId && this._canvas != null)
            {
                this.restoreCanvasSize(canvasWidth, canvasHeight, pixelsPerLevel, boardOriginX, boardOriginY);
                return;
            }
            this.releaseRoom();

            this._mapId = model.mapId;
            this._instanceId = model.instanceId;
            this._width = Std.int(Math.max(1, model.width));
            this._height = Std.int(Math.max(1, model.height));

            var parser= new RoomPlaneParser();
            try
            {
                parser.initializeTileMap(this._width, this._height);
                y= 0;while (y < this._height)
                {
                    x= 0;while (x < this._width)
                    {
tile= ASCompat.getDynamicProperty(model.tiles, Std.string(x) + ":" + Std.string(y));
standable= tile != null && (tile.colour >= -1 || ASCompat.toBool(tile.walkable));
                        parser._Str_3982(x, y, standable ? ASCompat.toInt(tile.floorHeight)
                            : RoomPlaneParser.TILE_HOLE);
x++;
                    }
y++;
                }
                parser.initializeFromTileData();
                // Declare the arena as a public room before it is built, exactly as a real public room does.
                cast(this._roomEngine, IRoomCreator).setWorldType(ROOM_ID, ARENA_WORLD_PREFIX + Std.string(model.mapId), true);
                this._roomEngine.initializeRoom(ROOM_ID, parser.getXML());
                this._roomInitialized = true;
            }
            catch (_m2_finally_error:ASAny)
            {
                parser.dispose();

                throw _m2_finally_error;
            }
                parser.dispose();

            // initializeRoom reads the world type back out and creates the room object from the matching
            // cast, so the engine draws the arena artwork itself, at the room's own origin, against the
            // same geometry it walks avatars on. That is why netcafe never has to position its backdrop,
            // and it removes the whole business of computing where the art goes.

            // Both planes off: neutral tiles and arena scenery are the public-room visualization. Changed
            // cells are separate private bb_tile objects layered into the same RoomEngine canvas.
            cast(this._roomEngine, IRoomCreator).updateObjectRoomVisibilities(ROOM_ID, false, false);
            this._canvasWidth = canvasWidth; this._canvasHeight = canvasHeight;
            this._canvas = this._roomEngine.createRoomCanvas(ROOM_ID, CANVAS_ID, canvasWidth, canvasHeight, GEOMETRY_SCALE);
            this.calibrate(pixelsPerLevel, boardOriginX, boardOriginY);
        }

        /**
         * RoomDesktop can resize canvas id 1 while the private arena is briefly active during a mouse
         * event. That changes the renderer's centre even though our display wrapper remains 760x560,
         * leaving the arena shifted and clipped after an AIR window resize. Detect the actual renderer
         * dimensions and restore this canvas on the next BattleBall refresh.
         */
        function restoreCanvasSize(canvasWidth:Int, canvasHeight:Int, pixelsPerLevel:Float,
                                           boardOriginX:Float, boardOriginY:Float)
        {
            // DisplayObjectWrapper does not clip its child. RoomDesktop may move or scale this object
            // directly while the private room is briefly active, which is why a resized client could
            // leave the arena shifted outside the television even when the renderer dimensions matched.
            this._canvas.x = 0;
            this._canvas.y = 0;
            this._canvas.scaleX = 1;
            this._canvas.scaleY = 1;
            var engine= Std.downcast(this._roomEngine , RoomEngine);
            var roomCanvas:IRoomRenderingCanvas = engine == null ? null : engine.getRoomCanvas(ROOM_ID, CANVAS_ID);
            if (roomCanvas == null) return;
            var resized= roomCanvas.width != canvasWidth || roomCanvas.height != canvasHeight;
            if (resized && !this._roomEngine.modifyRoomCanvas(ROOM_ID, CANVAS_ID, canvasWidth, canvasHeight)) return;
            var scale= this._roomEngine.getRoomCanvasScale(ROOM_ID, CANVAS_ID);
            var offset= this._roomEngine.getRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID);
            if (!Math.isNaN(scale) && scale != 1) this._roomEngine.setRoomCanvasScale(ROOM_ID, CANVAS_ID, 1);
            this._canvasWidth = canvasWidth;
            this._canvasHeight = canvasHeight;
            // Camera location can be changed independently of scale, size and screen offset. Reassert it
            // on every arena refresh so joining or resizing cannot leave an apparently valid canvas with
            // its scene centred hundreds of pixels below the television.
            this.calibrate(pixelsPerLevel, boardOriginX, boardOriginY);
        }

        /**
         * Points the camera the way RoomDesktop does for a real room, then matches the engine's vertical
         * scale to the artwork. The Director arenas were each drawn with their own elevation by eye, so a
         * default 3D z projection cannot line up with them; z_scale is measured and corrected rather than
         * assumed, which is what kept avatars and tiles disagreeing across height levels.
         */
        function calibrate(pixelsPerLevel:Float, boardOriginX:Float, boardOriginY:Float)
        {
            this._pixelsPerLevel = pixelsPerLevel;
            if (this._canvas != null)
            {
                this._canvas.removeEventListener(Event.ENTER_FRAME, (this.onBounceFrame : ASAny));
                this._canvas.addEventListener(Event.ENTER_FRAME, (this.onBounceFrame : ASAny));
            }
            var geometry= Std.downcast(this._roomEngine.getRoomCanvasGeometry(ROOM_ID, CANVAS_ID) , RoomGeometry);
            if (geometry == null) return;

            var midX= (this._width - 1) / 2;
            var midY= (this._height - 1) / 2;
            var pullback:Float = 20;
            midX += pullback - 1;
            midY += pullback - 1;
            var cameraZ= Math.sqrt(pullback * pullback + pullback * pullback) * Math.tan((30 / 180) * Math.PI);
            geometry.location = new Vector3d(midX, midY, cameraZ);

            // No z_scale override here any more: each layoutData carries its own heightScale, which the
            // content loader registers per world, so the engine already elevates the arena correctly.
            this._roomEngine.setRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID, new Point(0, 0));
        }

        /**
         * Where the engine currently projects world (0,0,0) inside the canvas. The view subtracts this from
         * the board origin so engine avatars land on exactly the cells the Director tiles are drawn on,
         * rather than relying on a hand-tuned constant.
         */
        public var tileOriginOffset(get,never):Point;
public function  get_tileOriginOffset():Point
        {
            if (this._roomEngine == null) return new Point(0, 0);
            var geometry= this._roomEngine.getRoomCanvasGeometry(ROOM_ID, CANVAS_ID);
            if (geometry == null) return new Point(0, 0);
            var point= geometry.getScreenPoint(new Vector3d(0, 0, 0));
            if (point == null) return new Point(0, 0);
            var offset= this._roomEngine.getRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID);
            if (offset == null) return point;
            return new Point(point.x + offset.x, point.y + offset.y);
        }

        /**
         * Projects a board cell through the engine's own geometry. Tiles, pickups and nametags are drawn
         * from this so they share one projection with the avatars the engine places, instead of a parallel
         * hand-fitted one that could never agree with it across height levels.
         */
        /**
         * Raw canvas-local projection of a board cell, exactly as the engine renders it. No screen offset is
         * folded in: that shifts what this reports without moving what the canvas draws, which is what left
         * the tiles sitting on the artwork while the engine drew its floor and avatars somewhere else.
         * The view positions the canvas itself and adds the same offset to whatever it draws.
         */
        public function project(x:Float, y:Float, z:Float):Point
        {
            if (this._roomEngine == null) return null;
            var geometry= this._roomEngine.getRoomCanvasGeometry(ROOM_ID, CANVAS_ID);
            if (geometry == null) return null;
            var point= geometry.getScreenPoint(new Vector3d(x, y, z));
            if (point == null) return null;
            // Same arithmetic getRoomObjectScreenLocation uses to place a room object. The geometry point
            // alone is not a canvas position: it still needs the canvas scale and the half-canvas centring,
            // which is why everything drawn from the bare projection sat offset and undersized.
            var scale= this._roomEngine.getRoomCanvasScale(ROOM_ID, CANVAS_ID);
            if (Math.isNaN(scale) || scale <= 0) scale = 1;
            var offset= this._roomEngine.getRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID);
            var offsetX= offset == null ? 0 : offset.x;
            var offsetY= offset == null ? 0 : offset.y;
            return new Point(point.x * scale + (this._canvasWidth / 2) + offsetX,
                             point.y * scale + (this._canvasHeight / 2) + offsetY);
        }


        /**
         * Installs changed tile appearances as private, client-only room objects. hh_room_bb_arena embeds
         * one multistate bb_tile whose state is team * 4 + strength: 1-4 red, 5-8 blue, 9-12 yellow and
         * 13-16 green. It is not a furnidata-backed hotel item. Keeping it in RoomEngine gives it the
         * cast's exact bitmap pivot and the same height/depth sorting as players, so a colour replaces its
         * grey cell instead of drifting beside it or covering an avatar.
         */
        public function syncTiles(model:BattleBallModel)
        {
var staleKey:String  = null, staleParts:Array<ASAny>  = null, staleId = 0, tile:ASObject  = null, key:String  = null, assetIndex = 0, existing:IRoomObject  = null, location:Vector3d  = null, tileDirection:Vector3d  = null, parts:Array<ASAny>  = null;            if (this._disposed || this._canvas == null) return;
            var creator= cast(this._roomEngine, IRoomCreator);
            var worldType= ARENA_WORLD_PREFIX + Std.string(model.mapId);
            var contentType= creator.getPublicRoomContentType(worldType);
            // Until the public-room cast has finished loading, the loader can only echo the world name.
            // Creating a child object at that point permanently gives it PlaceHolderFurniture graphics.
            if (contentType == null || contentType == "" || contentType == worldType)
            {
                this.logTileDiagnostic("content unresolved world=" + worldType + " content=" + contentType);
                return;
            }
            var type= contentType + "_bb_tile";
            // PublicRoomData is registered immediately before its child collections are extracted. Gate
            // on the exact tile collection as well: otherwise RoomManager creates PlaceHolderFurniture
            // during that small window and our state cache prevents the real visualization being retried.
            if (!creator.isRoomObjectContentAvailable(type))
            {
                this.logTileDiagnostic("content unavailable world=" + worldType + " type=" + type);
                final _iter_:ASObject = this._tileStates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                {
staleKey = _tmp_;
staleParts= (cast staleKey.split(":"));
staleId= TILE_OBJECT_ID_BASE + ASCompat.toInt(staleParts[1]) * this._width + ASCompat.toInt(staleParts[0]);
                    this._roomEngine.disposeObjectFurniture(ROOM_ID, staleId);
                }
                this._tileStates = {};
                return;
            }
            var coloured= 0;
            var seen:ASObject = {};
            var id = 0;
            final _iter_:ASObject = model.tiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tile = _tmp_;
                if (ASCompat.toInt(tile.colour) < 0 || ASCompat.toInt(tile.state) <= 0) continue;
                coloured++;
key= Std.string(ASCompat.toInt(tile.x)) + ":" + Std.string(ASCompat.toInt(tile.y));
assetIndex= Std.int(ASCompat.toInt(tile.colour) * 4 + Math.min(4, ASCompat.toInt(tile.state)));
                id = TILE_OBJECT_ID_BASE + ASCompat.toInt(tile.y) * this._width + ASCompat.toInt(tile.x);
ASCompat.setDynamicProperty(                seen, key, true);
existing= this._roomEngine.getRoomObject(
                    ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                // addObjectFurnitureByName queues FurnitureData and historically we cached success before
                // RoomEngine had materialised it. Never let a missing queued object become a permanent hit.
                if (ASCompat.getDynamicProperty(this._tileStates, key)== assetIndex && existing != null) continue;
                if (existing == null) Reflect.deleteField(this._tileStates, key);
location= new Vector3d(ASCompat.toInt(tile.x), ASCompat.toInt(tile.y), ASCompat.toInt(tile.floorHeight));
tileDirection= new Vector3d(0, 0, 0);
                if (ASCompat.getDynamicProperty(this._tileStates, key)== null)
                {
                    creator.addObjectFurnitureByName(
                        ROOM_ID, id, type, location, tileDirection, assetIndex, null);
                    // getRoomObject drains this id's queued FurnitureData synchronously. Besides removing
                    // the race, this tells diagnostics whether creation or visualization is the failing step.
                    existing = this._roomEngine.getRoomObject(
                        ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                }
                else
                {
                    creator.updateObjectFurniture(
                        ROOM_ID, id, location, tileDirection, assetIndex, null);
                }
                if (existing != null)
                {
ASCompat.setDynamicProperty(                    this._tileStates, key, assetIndex);
                    this.logTileDiagnostic("created type=" + existing.getType() + " state=" +
                        Std.string(existing.getState(0)) + " visual=" + Std.string(existing.getVisualization() != null) +
                        " coloured=" + Std.string(coloured));
                }
                else
                {
                    this.logTileDiagnostic("creation failed type=" + type + " state=" + Std.string(assetIndex) +
                        " coloured=" + Std.string(coloured));
                }
            }

            if (coloured == 0) this.logTileDiagnostic("content ready type=" + type + " coloured=0");

            final _iter_:ASObject = this._tileStates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
                if (ASCompat.getDynamicProperty(seen, key)!= null) continue;
parts= (cast key.split(":"));
                id = TILE_OBJECT_ID_BASE + ASCompat.toInt(parts[1]) * this._width + ASCompat.toInt(parts[0]);
                this._roomEngine.disposeObjectFurniture(ROOM_ID, id);
                Reflect.deleteField(this._tileStates, key);
            }
        }

        function logTileDiagnostic(value:String)
        {
            if (value == this._tileDiagnostic) return;
            this._tileDiagnostic = value;
            HabboWebTools.airDebug("BB TILE: " + value);
        }

        /** Adds or moves every player object, and drops any that left the game. */
        public function syncPlayers(model:BattleBallModel)
        {
var object:ASObject  = null, id = 0, key:String  = null;            if (this._disposed || this._canvas == null) return;
            var seen:ASObject = {};
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (object.type != 0) continue;
id= ASCompat.toInt(object.objectId);
                seen[Std.string(id)] = true;
                this.place(model, object, id);
            }
            final _iter_:ASObject = this._added; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
                if (seen[Std.string(ASCompat.toInt(key))] == null)
                {
                    this._roomEngine.disposeObjectUser(ROOM_ID, ASCompat.toInt(key));
                    Reflect.deleteField(this._added, key); Reflect.deleteField(this._figures, key);
                    Reflect.deleteField(this._positions, key); Reflect.deleteField(this._effects, key);
                    Reflect.deleteField(this._directions, key); Reflect.deleteField(this._moveUntil, key);
                }
            }
        }

        /** Drives the bounce off the renderer's own frame loop rather than the game's 250ms clock. */
        function onBounceFrame(event:Event)
        {
var key:String  = null, id = 0, object:IRoomObject  = null, controller:IRoomObjectController  = null;            if (this._disposed || this._roomEngine == null || this._pixelsPerLevel <= 0) return;
            var curve:Array<ASAny> = null;
            var lift = Math.NaN;
            final _iter_:ASObject = this._restZ; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
id= ASCompat.toInt(key);
object= this._roomEngine.getRoomObject(
                    ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
controller= Std.downcast(object , IRoomObjectController);
                if (controller == null || object.getLocation() == null) continue;
                // While walking the engine owns the location, so leave it alone -- the walk carries its
                // own motion. Only a rider at rest is moved here.
                //
                // Compare against the clock rather than testing the flag: _moveUntil is not zeroed until
                // the next model sync, up to 250ms after the walk has actually finished, which left the
                // rider sitting dead still before the idle bounce started.
                if (flash.Lib.getTimer() < ASCompat.toInt(this._moveUntil[Std.string(id)])) continue;
                curve = BOUNCE_IDLE;
                lift = this.bounceLift(curve);
                // The curve is negative for "up" because it moves a SCREEN y. Room z runs the other
                // way -- higher z is higher up -- so it is subtracted, or the rider sinks into the floor
                // for most of the cycle instead of lifting off it.
                controller.setLocation(new Vector3d(object.getLocation().x, object.getLocation().y,
                    ASCompat.toNumber(this._restZ[Std.string(id)]) - (lift / this._pixelsPerLevel)));
            }
        }

        /** Pixels of lift due now, interpolated between curve entries so it reads as motion. */
        function bounceLift(curve:Array<ASAny>):Float
        {
            if (curve == null || curve.length == 0) return 0;
            var position= (flash.Lib.getTimer() % (curve.length * BOUNCE_STEP_MS)) / BOUNCE_STEP_MS;
            var index= Std.int(position);
            var next= (index + 1) % curve.length;
            var blend= position - index;
            return ((ASCompat.toNumber(curve[index]) * (1 - blend)) + (ASCompat.toNumber(curve[next]) * blend)) * BOUNCE_SCALE;
        }

        /** BALL_RIDE_PX expressed in the map's own height units, since z is scaled by pixelsPerLevel. */
        function rideLift():Float
        {
            return this._pixelsPerLevel > 0 ? (BALL_RIDE_PX / this._pixelsPerLevel) : 0;
        }

        function place(model:BattleBallModel, object:ASObject, id:Int)
        {
var previous:String  = null, current:String  = null, parts:Array<ASAny>  = null, fromTile:ASObject  = null, from:IVector3d  = null, roomObject:IRoomObject  = null;            var tile:ASObject = ASCompat.getDynamicProperty(model.tiles, object.x + ":" + object.y);
            // A seated avatar is drawn as though its seat were half a tile up, which furniture normally
            // supplies. Nothing does here, so the rider sank below the tile they were scoring. Give the
            // ball that height back.
            var z= (tile == null ? 0 : ASCompat.toInt(tile.floorHeight)) + this.rideLift();
            this._restZ[Std.string(id)] = z;
            var direction:Float = (ASCompat.toInt(object.direction) % 8) * 45;
            var heading= new Vector3d(direction, 0, 0);
            var target= new Vector3d(ASCompat.toNumber(object.x), ASCompat.toNumber(object.y), z);
            var figure= ASCompat.toString(object.figure);

            // Object ids are scoped to a game and are reused by later matches. The private arena room is
            // retained between matches, so an id can already refer to a previous player's RoomEngine
            // avatar. Recreate that object when its authoritative figure changes; otherwise the new name
            // bubble is paired with the old player's clothes until the entire client is restarted.
            if (this._added[Std.string(id)] != null && this._figures[Std.string(id)] != figure)
            {
                this._roomEngine.disposeObjectUser(ROOM_ID, id);
                Reflect.deleteField(this._added, Std.string(id)); Reflect.deleteField(this._figures, Std.string(id));
                Reflect.deleteField(this._positions, Std.string(id)); Reflect.deleteField(this._effects, Std.string(id));
                Reflect.deleteField(this._directions, Std.string(id)); Reflect.deleteField(this._moveUntil, Std.string(id));
            }

            if (this._added[Std.string(id)] == null)
            {
                // Cache only once the engine confirms the avatar exists. Setting _added regardless meant
                // one transient failure was remembered as a success and the guard above blocked every
                // retry, so that player and their ball stayed invisible for the whole match.
                if (!this._roomEngine.addObjectUser(ROOM_ID, id, target, heading, direction, 1, figure)) return;
                this._roomEngine.updateObjectUserAction(ROOM_ID, id, RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME, 1);
                this._roomEngine.updateObjectUserEffect(ROOM_ID, id, BALL_ARM_EFFECT);
                this._added[Std.string(id)] = true;
                this._figures[Std.string(id)] = figure;
                this._positions[Std.string(id)] = object.x + ":" + object.y;
                this._directions[Std.string(id)] = ASCompat.toInt(object.direction);
                this._moveUntil[Std.string(id)] = 0;
                // Bouncing Human Class sets pMainAction = "sit" and forces body, legs and shoes to the
                // sit action for the whole round -- the player rides the ball rather than standing on
                // it, and never switches to a walk cycle. The ball part animates instead.
                this._roomEngine.updateObjectUserPosture(ROOM_ID, id, "sit");
            }
            else
            {
previous= ASCompat.toString(this._positions[Std.string(id)]);
current= object.x + ":" + object.y;
                if (previous != current)
                {
parts= (cast previous.split(":"));
fromTile= ASCompat.getDynamicProperty(model.tiles, previous);
from= new Vector3d(ASCompat.toInt(parts[0]), ASCompat.toInt(parts[1]),
                        fromTile == null ? z : ASCompat.toInt(fromTile.floorHeight) + this.rideLift());
roomObject= this._roomEngine.getRoomObject(
                        ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    if (roomObject != null && roomObject.getLocation() != null) from = roomObject.getLocation();
                    this._roomEngine.updateObjectUser(
                        ROOM_ID, id, from, target, false, 0, heading, direction, Math.NaN, false, 500);
                    // No "mv" here: the rider stays seated while the ball carries them across.
                    this._positions[Std.string(id)] = current;
                    this._directions[Std.string(id)] = ASCompat.toInt(object.direction);
                    this._moveUntil[Std.string(id)] = flash.Lib.getTimer() + 550;
                }
                else
                {
                    // Do not send target->target here. showArena is also called by the 250 ms HUD clock,
                    // and that zero-length update used to cancel the engine's 500 ms interpolation at
                    // its midpoint, producing the BattleBall-only walk stutter.
                    if (this._directions[Std.string(id)] != ASCompat.toInt(object.direction))
                    {
                        this._roomEngine.updateObjectUserDir(ROOM_ID, id, heading, direction);
                        this._directions[Std.string(id)] = ASCompat.toInt(object.direction);
                    }
                    if (ASCompat.toInt(this._moveUntil[Std.string(id)]) > 0 && flash.Lib.getTimer() >= ASCompat.toInt(this._moveUntil[Std.string(id)]))
                    {
                        this._roomEngine.updateObjectUserPosture(ROOM_ID, id, "sit");
                        this._moveUntil[Std.string(id)] = 0;
                    }
                }
            }

            // No avatar effect. The original never used one: BBRed/BBblue/BByellow/BBgreen are Battle
            // Banzai floor markers (a single aliased tile glow, empty new XML("<sprite id=\"avatar\"/>")), whereas
            // BattleBall composited a tinted ball body part into the figure. The ball is drawn by the
            // view instead, so applying a marker here would just add a glow the original never had.
        }

        /**
         * Tear the arena room down completely.
         *
         * Public because leaving has to do it too. Without it the room objects survived a spectator
         * closing the arena, so re-entering handed the engine new positions for avatars it still held
         * at their old ones -- and it walked them across the board to catch up instead of drawing them
         * where they actually were.
         */
        /**
         * Drop the avatars and their cached state, keeping the room itself.
         *
         * This is what leaving needs. Disposing the room here instead blacked the whole screen: the
         * arena room is the engine's active room while it is on display, so tearing it down leaves the
         * engine pointing at a room that no longer exists. Only a full teardown -- a different arena,
         * or disposal -- may take the room with it.
         */
        public function release()
        {
            this.releaseObjects();
        }

        function releaseObjects()
        {
var key:String  = null;            if (this._roomEngine == null) return;
            final _iter_:ASObject = this._added; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {key = _tmp_;
this._roomEngine.disposeObjectUser(ROOM_ID, ASCompat.toInt(key));
};
            this.disposeTileObjects();
            this._added = {}; this._figures = {}; this._positions = {}; this._effects = {};
            this._directions = {}; this._moveUntil = {};
            // Per-player bounce baselines belong to the objects that just went with them.
            this._restZ = {};
        }

        function disposeTileObjects()
        {
var key:String  = null, parts:Array<ASAny>  = null, id = 0;            final _iter_:ASObject = this._tileStates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
parts= (cast key.split(":"));
id= TILE_OBJECT_ID_BASE + ASCompat.toInt(parts[1]) * this._width + ASCompat.toInt(parts[0]);
                this._roomEngine.disposeObjectFurniture(ROOM_ID, id);
            }
            this._tileStates = {};
        }

        function releaseRoom()
        {
            if (this._roomEngine == null) return;
            this.releaseObjects();
            if (this._canvas != null)
            {
                this._canvas.removeEventListener(Event.ENTER_FRAME, (this.onBounceFrame : ASAny));
                this._canvas = null;
            }
            if (this._roomInitialized)
            {
                this._roomEngine.disposeRoom(ROOM_ID);
                this._roomInitialized = false;
            }
            this._mapId = -1;
            this._instanceId = -1;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this.releaseRoom();
            this._roomEngine = null;
            this._disposed = true;
        }
    }

