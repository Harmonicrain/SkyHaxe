package com.sulake.habbo.snowstorm
;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.room.IRoomCreator;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.RoomEngine;
    import com.sulake.habbo.room.messages.RoomObjectTileCursorUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.additions.SnowStormUniform;
    import com.sulake.habbo.room.object.visualization.avatar.additions.SnowStormTargetHighlight;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.RoomGeometry;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Point;

    /**
     * Private RoomEngine room used exclusively by the original Shockwave SnowStorm port.
     * Static scenery, players, machines and projectiles are all real room objects, so the normal
     * renderer owns isometric projection and depth sorting.
     */
     final class SnowStormArena
    {
        static inline final ROOM_ID= 0x7B412;
        static inline final CANVAS_ID= 48;
        static inline final GEOMETRY_SCALE= 32;
        static inline final WORLD_PREFIX= "snowwar_arena_";
        static inline final STATIC_BASE= 0x6C000000;
        static inline final MACHINE_BASE= 0x6D000000;
        static inline final PROJECTILE_BASE= 0x6E000000;
        static inline final IMPACT_BASE= 0x6F000000;
        static inline final IMPACT_DURATION_MS= 500;
        static inline final UNIFORM_ADDITION_ID= 65;
        static inline final TARGET_HIGHLIGHT_ADDITION_ID= 66;
        // The recovered snowwar_arena room artwork was authored against Shockwave's aperture,
        // whose visible origin sits 20 px left and 7 px above RoomEngine's centred canvas origin.
        // Keep the complete room (background, scenery, avatars and cursor) on that origin and let
        // SnowStormArenaWindow's scrollRect clip anything which belongs offscreen.
        static inline final AUTHORED_SCREEN_OFFSET_X= -20;
        static inline final AUTHORED_SCREEN_OFFSET_Y= -7;

        var _roomEngine:IRoomEngine;
        var _avatars:IAvatarRenderManager;
        var _assets:SnowStormAssets;
        var _canvas:DisplayObject;
        var _roomInitialized:Bool = false;
        var _instanceId:Int = -1;
        var _mapId:Int = -1;
        var _map:ASObject;
        var _canvasWidth:Int = 0;
        var _canvasHeight:Int = 0;
        var _staticIds:ASObject = {};
        var _pendingStatic:Array<ASAny> = [];
        var _players:ASObject = {};
        var _figures:ASObject = {};
        var _positions:ASObject = {};
        var _directions:ASObject = {};
        var _machines:ASObject = {};
        var _machineStates:ASObject = {};
        var _projectiles:ASObject = {};
        var _impacts:ASObject = {};
        var _nextImpactId:Int = 1;
        var _highlightedPlayerId:Int = -1;
        var _splashUpdatesRegistered:Bool = false;
        var _disposed:Bool = false;

        public function new(roomEngine:IRoomEngine, avatars:IAvatarRenderManager,
                                       assets:SnowStormAssets)
        {
            this._roomEngine = roomEngine;
            this._avatars = avatars;
            this._assets = assets;
        }

        public var canvas(get,never):DisplayObject;
public function  get_canvas():DisplayObject { return this._canvas; }
        public var ready(get,never):Bool;
public function  get_ready():Bool { return this._canvas != null; }

        public function build(model:SnowStormModel, width:Int, height:Int)
        {
var staticItem:ASObject  = null, mapWidth = 0, mapHeight = 0, y = 0, x = 0;            if (this._disposed || this._roomEngine == null || model == null || model.map == null) return;
            if (!this._splashUpdatesRegistered)
            {
                this._roomEngine.addObjectUpdateCategory(RoomObjectCategoryEnum.SNOW_SPLASH);
                this._splashUpdatesRegistered = true;
            }
            if (this._instanceId == model.instanceId && this._mapId == model.mapId && this._canvas != null)
            {
                this.restoreCanvas(width, height);
                return;
            }
            this.releaseRoom();
            this._instanceId = model.instanceId;
            this._mapId = model.mapId;
            this._map = model.map;
            this._pendingStatic = [];
            var staticIndex= 0;
            final _iter_:ASAny = this._map.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{staticItem = _tmp_;
                this._pendingStatic.push({id:STATIC_BASE + staticIndex++, item:staticItem});
};
            var parser= new RoomPlaneParser();
            try
            {
mapWidth= ASCompat.toInt(this._map.width);
mapHeight= ASCompat.toInt(this._map.height);
                parser.initializeTileMap(mapWidth, mapHeight);
                for (_tmp_ in 0...mapHeight)
{y= _tmp_;
                    for (_tmp_ in 0...mapWidth)
{x= _tmp_;
                        parser._Str_3982(x, y, SnowStormMapCatalog.isFloor(this._map, x, y)
                            ? 0 : RoomPlaneParser.TILE_HOLE);
};
};
                parser.initializeFromTileData();
                cast(this._roomEngine, IRoomCreator).setWorldType(ROOM_ID, WORLD_PREFIX + Std.string(model.mapId), true);
                this._roomEngine.initializeRoom(ROOM_ID, parser.getXML());
                this._roomInitialized = true;
            }
            catch (_m2_finally_error:ASAny)
            {
                parser.dispose();

                throw _m2_finally_error;
            }
                parser.dispose();

            cast(this._roomEngine, IRoomCreator).updateObjectRoomVisibilities(ROOM_ID, false, false);
            this._canvasWidth = width;
            this._canvasHeight = height;
            this._canvas = this._roomEngine.createRoomCanvas(ROOM_ID, CANVAS_ID, width, height, GEOMETRY_SCALE);
            this.configureCamera();
            this.addStaticScenery();
        }

        public function sync(model:SnowStormModel)
        {
            if (this._disposed || this._canvas == null || model == null) return;
            this.addStaticScenery();
            this.syncPlayers(model);
            this.syncMachines(model);
            this.syncProjectiles(model);
        }

        public function playerAt(x:Float, y:Float, ignoreObjectId:Int=-1):Int
        {
            var engine= Std.downcast(this._roomEngine , RoomEngine);
            if (engine == null) return -1;
            var canvas= engine.getRoomCanvas(ROOM_ID, CANVAS_ID);
            if (canvas == null) return -1;
            var object= canvas.getRoomObjectAt(Std.int(x), Std.int(y));
            if (object == null || object.getId() == ignoreObjectId ||
                this._players[Std.string(object.getId())] == null) return -1;
            return object.getId();
        }

        /** Smooth RoomEngine anchor used by the r26 name/score rollover label. */
        public function playerAnchor(objectId:Int):Point
        {
            if (this._roomEngine == null || this._players[Std.string(objectId)] == null) return null;
            var roomObject= this._roomEngine.getRoomObject(
                ROOM_ID, objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if (roomObject == null || roomObject.getLocation() == null) return null;
            var location= roomObject.getLocation();
            return this.project(location.x, location.y, location.z);
        }

        /** Attaches the original team diamond to the avatar sprite stack so it depth-sorts correctly. */
        public function setPlayerHighlight(objectId:Int, teamId:Int)
        {
            if (objectId <= 0 || this._players[Std.string(objectId)] == null)
            {
                this.clearPlayerHighlight();
                return;
            }
            if (this._highlightedPlayerId != objectId) this.clearPlayerHighlight();
            var roomObject= this._roomEngine.getRoomObject(
                ROOM_ID, objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var visualization:AvatarVisualization = roomObject == null ? null
                : Std.downcast(roomObject.getVisualization() , AvatarVisualization);
            if (visualization == null) return;
            var highlight= Std.downcast(visualization._Str_6142(
                TARGET_HIGHLIGHT_ADDITION_ID) , SnowStormTargetHighlight);
            if (highlight == null)
            {
                highlight = new SnowStormTargetHighlight(
                    TARGET_HIGHLIGHT_ADDITION_ID, this._assets, teamId);
                visualization._Str_8211(highlight);
            }
            else
                highlight.teamId = teamId;
            this._highlightedPlayerId = objectId;
            visualization.updateAnimationByFrames(1);
        }

        public function clearPlayerHighlight()
        {
            if (this._highlightedPlayerId <= 0 || this._roomEngine == null)
            {
                this._highlightedPlayerId = -1;
                return;
            }
            var roomObject= this._roomEngine.getRoomObject(
                ROOM_ID, this._highlightedPlayerId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var visualization:AvatarVisualization = roomObject == null ? null
                : Std.downcast(roomObject.getVisualization() , AvatarVisualization);
            if (visualization != null)
            {
                visualization._Str_5801(TARGET_HIGHLIGHT_ADDITION_ID);
                visualization.updateAnimationByFrames(1);
            }
            this._highlightedPlayerId = -1;
        }

        public function screenToTile(x:Float, y:Float):Point
        {
            var origin= this.project(0, 0, 0);
            var basisX= this.project(1, 0, 0);
            var basisY= this.project(0, 1, 0);
            if (origin == null || basisX == null || basisY == null) return null;
            var ax= basisX.x - origin.x;
            var ay= basisX.y - origin.y;
            var bx= basisY.x - origin.x;
            var by= basisY.y - origin.y;
            var determinant= ax * by - ay * bx;
            if (Math.abs(determinant) < 0.001) return null;
            var dx= x - origin.x;
            var dy= y - origin.y;
            var tileX= Std.int(Math.ffloor(((dx * by - dy * bx) / determinant) + 0.5));
            var tileY= Std.int(Math.ffloor(((ax * dy - ay * dx) / determinant) + 0.5));
            return SnowStormMapCatalog.contains(this._map, tileX, tileY)
                ? new Point(tileX, tileY) : null;
        }

        /** Uses the normal RoomEngine floor cursor so it depth-sorts beneath arena objects. */
        public function setTileCursor(tileX:Int, tileY:Int, visible:Bool)
        {
            var engine= Std.downcast(this._roomEngine , RoomEngine);
            if (engine == null || !this._roomInitialized) return;
            var cursor= engine.getTileCursor(ROOM_ID);
            if (cursor == null || cursor.getEventHandler() == null) return;
            var location:Vector3d = visible ? new Vector3d(tileX, tileY, 0) : null;
            cursor.getEventHandler().processUpdateMessage(new RoomObjectTileCursorUpdateMessage(
                location, 0, visible, "snowstorm:" + Std.string(tileX) + ":" + Std.string(tileY) + ":" + Std.string(visible)));
        }

        public function hideTileCursor()
        {
            this.setTileCursor(-1, -1, false);
        }

        public function release()
        {
            this.releaseDynamicObjects();
        }

        /** Presents the server-confirmed r26 hit1/hit2/hit3 effect at the impact point. */
        public function playHit(worldX:Int, worldY:Int, worldZ:Int)
        {
            if (this._disposed || this._roomEngine == null || this._canvas == null || this._map == null) return;
            var id= IMPACT_BASE + this._nextImpactId++;
            if (this._roomEngine.createShockwaveSnowSplash(
                ROOM_ID, id, this.worldLocation(worldX, worldY, worldZ)))
                this._impacts[Std.string(id)] = flash.Lib.getTimer();
        }

        public function tick(now:Int)
        {
var key:String  = null;            if (this._roomEngine == null) return;
            final _iter_:ASObject = this._impacts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                if (now - ASCompat.toInt(ASCompat.getDynamicProperty(this._impacts, key)) >= IMPACT_DURATION_MS)
                {
                    this._roomEngine.disposeGameObject(
                        ROOM_ID, ASCompat.toInt(key), RoomObjectCategoryEnum.SNOW_SPLASH);
                    Reflect.deleteField(this._impacts, key);
                };
}
        }

        function restoreCanvas(width:Int, height:Int)
        {
            if (this._canvas == null) return;
            this._canvas.x = 0; this._canvas.y = 0;
            this._canvas.scaleX = 1; this._canvas.scaleY = 1;
            if (width != this._canvasWidth || height != this._canvasHeight)
                this._roomEngine.modifyRoomCanvas(ROOM_ID, CANVAS_ID, width, height);
            this._canvasWidth = width; this._canvasHeight = height;
            this.configureCamera();
        }

        function configureCamera()
        {
            var geometry= Std.downcast(this._roomEngine.getRoomCanvasGeometry(ROOM_ID, CANVAS_ID) , RoomGeometry);
            if (geometry == null || this._map == null) return;
            var centerX= (ASCompat.toInt(this._map.width) - 1) / 2;
            var centerY= (ASCompat.toInt(this._map.height) - 1) / 2;
            var pullback:Float = 20;
            var cameraZ= Math.sqrt(pullback * pullback * 2) * Math.tan(Math.PI / 6);
            geometry.location = new Vector3d(centerX + pullback - 1, centerY + pullback - 1, cameraZ);
            this._roomEngine.setRoomCanvasScale(ROOM_ID, CANVAS_ID, 1);
            this._roomEngine.setRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID,
                new Point(AUTHORED_SCREEN_OFFSET_X, AUTHORED_SCREEN_OFFSET_Y));
        }

        function project(x:Float, y:Float, z:Float):Point
        {
            var geometry= this._roomEngine.getRoomCanvasGeometry(ROOM_ID, CANVAS_ID);
            if (geometry == null) return null;
            var point= geometry.getScreenPoint(new Vector3d(x, y, z));
            if (point == null) return null;
            var scale= this._roomEngine.getRoomCanvasScale(ROOM_ID, CANVAS_ID);
            if (Math.isNaN(scale) || scale <= 0) scale = 1;
            var offset= this._roomEngine.getRoomCanvasScreenOffset(ROOM_ID, CANVAS_ID);
            return new Point(point.x * scale + this._canvasWidth / 2 + (offset == null ? 0 : offset.x),
                point.y * scale + this._canvasHeight / 2 + (offset == null ? 0 : offset.y));
        }

        function addStaticScenery()
        {
var pending:ASObject  = null, id = 0, item:ASObject  = null, location:Vector3d  = null, angle = Math.NaN;            if (this._map == null || this._pendingStatic.length == 0) return;
            var creator= ASCompat.reinterpretAs(this._roomEngine , IRoomCreator);
            if (creator == null) return;
            var remaining:Array<ASAny> = [];
            final _iter_ = this._pendingStatic; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
pending = _tmp_;
id= ASCompat.toInt(pending.id);
                if (this._staticIds[Std.string(id)] != null) continue;
item= pending.item;
location= new Vector3d(ASCompat.toNumber(item.worldX) / ASCompat.toInt(this._map.worldUnitsPerTile),
                    ASCompat.toNumber(item.worldY) / ASCompat.toInt(this._map.worldUnitsPerTile),
                    ASCompat.toNumber(item.worldZ) / ASCompat.toInt(this._map.worldUnitsPerTile));
angle= (ASCompat.toInt(item.direction) & 7) * 45;
                creator.addObjectFurnitureByName(ROOM_ID, id, ASCompat.toString(item.member), location,
                    new Vector3d(angle, 0, 0), 0, null);
                if (this._roomEngine.getRoomObject(ROOM_ID, id,
                    RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) != null)
                    this._staticIds[Std.string(id)] = true;
                else
                    remaining.push(pending);
            }
            this._pendingStatic = remaining;
        }

        function syncPlayers(model:SnowStormModel)
        {
var object:ASObject  = null, id = 0, key:String  = null;            var seen:ASObject = {};
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (ASCompat.toInt(object.type) != SnowStormProtocol.OBJECT_AVATAR) continue;
id= ASCompat.toInt(object.objectId);
                seen[Std.string(id)] = true;
                this.placePlayer(model, object, id);
            }
            final _iter_:ASObject = this._players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                if (seen[Std.string(ASCompat.toInt(key))] == null) this.removePlayer(ASCompat.toInt(key));
};
        }

        function placePlayer(model:SnowStormModel, object:ASObject, id:Int)
        {
var current:String  = null, roomObject:IRoomObject  = null, from:IVector3d  = null;            var location= this.worldLocation(ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), 0);
            var direction= ASCompat.toInt(object.direction) & 7;
            var angle:Float = direction * 45;
            var heading= new Vector3d(angle, 0, 0);
            var figure= ASCompat.toString(object.figure);
            if (this._players[Std.string(id)] != null && this._figures[Std.string(id)] != figure) this.removePlayer(id);
            if (this._players[Std.string(id)] == null)
            {
                if (!this._roomEngine.addObjectUser(ROOM_ID, id, location, heading, angle, 1, figure)) return;
                this._roomEngine.updateObjectUserAction(ROOM_ID, id,
                    RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME, 1);
                this._players[Std.string(id)] = true;
                this._figures[Std.string(id)] = figure;
                this._positions[Std.string(id)] = Std.string(ASCompat.toInt(object.worldX)) + ":" + Std.string(ASCompat.toInt(object.worldY));
                this._directions[Std.string(id)] = direction;
            }
            else
            {
current= Std.string(ASCompat.toInt(object.worldX)) + ":" + Std.string(ASCompat.toInt(object.worldY));
                if (this._positions[Std.string(id)] != current)
                {
roomObject= this._roomEngine.getRoomObject(
                        ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
from= roomObject == null ? location : roomObject.getLocation();
                    // The authoritative playback advances one 640-unit movement slice every 60 ms.
                    // Match that cadence here: restarting a 300 ms interpolation for every slice
                    // leaves the rendered avatar nearly one tile behind its logical position.
                    // updateObjectUser argument 9 is the interpolation duration; argument 11 is
                    // jumpingPower, so keep the duration in argument 9 to avoid a jump arc.
                    // Shockwave stopMovement settles a stunned avatar immediately before ff1/fb1;
                    // do not let a prior room-engine walk interpolation slide the prone body.
                    this._roomEngine.updateObjectUser(ROOM_ID, id, from, location, false, 0,
                        heading, angle, ASCompat.toInt(object.activity) == SnowStormProtocol.ACTIVITY_STUNNED
                            ? 0 : SnowStormMath.SUBTURN_MS);
                    this._positions[Std.string(id)] = current;
                }
                else if (this._directions[Std.string(id)] != direction)
                    this._roomEngine.updateObjectUserDir(ROOM_ID, id, heading, angle);
                this._directions[Std.string(id)] = direction;
            }
            this.syncUniform(model, object, id);
        }

        function syncUniform(model:SnowStormModel, object:ASObject, id:Int)
        {
            var roomObject= this._roomEngine.getRoomObject(
                ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if (roomObject == null) return;
            var visualization= Std.downcast(roomObject.getVisualization() , AvatarVisualization);
            if (visualization == null) return;
            var uniform= Std.downcast(visualization._Str_6142(UNIFORM_ADDITION_ID) , SnowStormUniform);
            var colour= SnowStormUniformFigure.colour(this._avatars, ASCompat.toString(object.figure),
                model.teamCount, ASCompat.toInt(object.teamId));
            if (uniform == null)
            {
                uniform = new SnowStormUniform(UNIFORM_ADDITION_ID, visualization, this._assets,
                    this._avatars, ASCompat.toString(object.figure), colour);
                visualization._Str_8211(uniform);
            }
            var action= this.playerAction(object, id);
            uniform.setState(action, ASCompat.toInt(object.direction), ASCompat.toInt(object.presentationSerial),
                colour, ASCompat.toInt(object.activity) == SnowStormProtocol.ACTIVITY_INVINCIBLE);
        }

        /** Captures the exact in-arena SnowStorm figure for the final-score winner panel. */
        public function playerImage(model:SnowStormModel, userId:Int):BitmapData
        {
var player:ASObject  = null, roomObject:IRoomObject  = null, visualization:AvatarVisualization  = null, uniform:SnowStormUniform  = null;            if (model == null || userId <= 0 || this._roomEngine == null) return null;
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
player = _tmp_;
                if (ASCompat.toInt(player.type) != SnowStormProtocol.OBJECT_AVATAR ||
                    ASCompat.toInt(player.userId) != userId) continue;
roomObject= this._roomEngine.getRoomObject(ROOM_ID,
                    ASCompat.toInt(player.objectId), RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
visualization= roomObject == null ? null
                    : Std.downcast(roomObject.getVisualization() , AvatarVisualization);
uniform= visualization == null ? null
                    : Std.downcast(visualization._Str_6142(UNIFORM_ADDITION_ID) , SnowStormUniform);
                return uniform == null ? null : uniform.snapshot();
            }
            return null;
        }

        function playerAction(object:ASObject, id:Int):String
        {
var target:Vector3d  = null;            if (object.presentationAction != null && ASCompat.toString(object.presentationAction) != "")
                return ASCompat.toString(object.presentationAction);
            if (ASCompat.toInt(object.activity) == SnowStormProtocol.ACTIVITY_CREATING) return "pck";
            if (ASCompat.toInt(object.activity) == SnowStormProtocol.ACTIVITY_STUNNED) return "fb1";
            var roomObject= this._roomEngine.getRoomObject(
                ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if (roomObject != null && roomObject.getLocation() != null)
            {
target= this.worldLocation(ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), 0);
                if (Math.abs(roomObject.getLocation().x - target.x) > 0.01 ||
                    Math.abs(roomObject.getLocation().y - target.y) > 0.01) return "wlk";
            }
            return "std";
        }

        function removePlayer(id:Int)
        {
            var object= this._roomEngine.getRoomObject(
                ROOM_ID, id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var visualization:AvatarVisualization = object == null ? null
                : Std.downcast(object.getVisualization() , AvatarVisualization);
            if (visualization != null)
            {
                visualization._Str_5801(UNIFORM_ADDITION_ID);
                visualization._Str_5801(TARGET_HIGHLIGHT_ADDITION_ID);
            }
            if (this._highlightedPlayerId == id) this._highlightedPlayerId = -1;
            this._roomEngine.disposeObjectUser(ROOM_ID, id);
            Reflect.deleteField(this._players, Std.string(id)); Reflect.deleteField(this._figures, Std.string(id));
            Reflect.deleteField(this._positions, Std.string(id)); Reflect.deleteField(this._directions, Std.string(id));
        }

        function syncMachines(model:SnowStormModel)
        {
var object:ASObject  = null, objectId = 0, id = 0, state = 0, location:Vector3d  = null, engine:RoomEngine  = null, key:String  = null;            var seen:ASObject = {};
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (ASCompat.toInt(object.type) != SnowStormProtocol.OBJECT_MACHINE) continue;
objectId= ASCompat.toInt(object.objectId);
id= MACHINE_BASE + objectId;
                seen[Std.string(id)] = true;
state= Std.int(Math.max(0,
                    Math.min(SnowStormProtocol.MAX_AMMO, ASCompat.toInt(object.snowballs))));
                if (this.machineCollecting(model, object) &&
                    state < SnowStormProtocol.MAX_AMMO) state += 6;
location= this.worldLocation(ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), 0);
                if (this._machines[Std.string(id)] == null)
                {
                    cast(this._roomEngine, IRoomCreator).addObjectFurnitureByName(ROOM_ID, id,
                        "s_snowball_machine", location, new Vector3d(0, 0, 0), state, null);
                    if (this._roomEngine.getRoomObject(ROOM_ID, id,
                        RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) != null)
                    {
                        this._machines[Std.string(id)] = true;
                        this._machineStates[Std.string(id)] = state;
                    }
                }
                else if (this._machineStates[Std.string(id)] != state)
                {
engine= Std.downcast(this._roomEngine , RoomEngine);
                    if (engine != null) engine.updateObjectFurniture(ROOM_ID, id, location,
                        new Vector3d(0, 0, 0), state, null);
                    this._machineStates[Std.string(id)] = state;
                }
            }
            final _iter_:ASObject = this._machines; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                if (seen[Std.string(ASCompat.toInt(key))] == null)
                {
                    this._roomEngine.disposeObjectFurniture(ROOM_ID, ASCompat.toInt(key));
                    Reflect.deleteField(this._machines, key); Reflect.deleteField(this._machineStates, key);
                };
}
        }

        function machineCollecting(model:SnowStormModel, machine:ASObject):Bool
        {
var candidate:ASObject  = null, object:ASObject  = null, tile:ASObject  = null;            if (this._map == null || this._map.machines == null) return false;
            var definition:ASObject = null;
            final _iter_:ASAny = this._map.machines; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{candidate = _tmp_;
                if (ASCompat.toInt(candidate.worldX) == ASCompat.toInt(machine.worldX) &&
                    ASCompat.toInt(candidate.worldY) == ASCompat.toInt(machine.worldY))
                { definition = candidate; break; };
}
            if (definition == null) return false;
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (ASCompat.toInt(object.type) != SnowStormProtocol.OBJECT_AVATAR ||
                    ASCompat.toInt(object.activity) == SnowStormProtocol.ACTIVITY_STUNNED) continue;
tile= SnowStormMapCatalog.toTile(this._map,
                    ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY));
                if (tile != null && ASCompat.toInt(tile.x) == ASCompat.toInt(definition.collectionTileX) &&
                    ASCompat.toInt(tile.y) == ASCompat.toInt(definition.collectionTileY)) return true;
            }
            return false;
        }

        function syncProjectiles(model:SnowStormModel)
        {
var object:ASObject  = null, objectId = 0, id = 0, ball:Vector3d  = null, key:String  = null;            var seen:ASObject = {};
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (ASCompat.toInt(object.type) != SnowStormProtocol.OBJECT_SNOWBALL) continue;
objectId= ASCompat.toInt(object.objectId);
id= PROJECTILE_BASE + objectId;
                seen[Std.string(id)] = true;
ball= this.worldLocation(ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY),
                    ASCompat.toInt(object.height));
                if (this._projectiles[Std.string(id)] == null)
                {
                    if (this._roomEngine.createShockwaveSnowball(ROOM_ID, id, ball))
                        this._projectiles[Std.string(id)] = true;
                }
                else this._roomEngine._SafeStr_7817(
                    ROOM_ID, id, ball, RoomObjectCategoryEnum.SNOWBALL);
            }
            final _iter_:ASObject = this._projectiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                if (seen[Std.string(ASCompat.toInt(key))] == null)
                {
                    this._roomEngine.disposeGameObject(
                        ROOM_ID, ASCompat.toInt(key), RoomObjectCategoryEnum.SNOWBALL);
                    Reflect.deleteField(this._projectiles, key);
                };
}
        }

        function worldLocation(worldX:Int, worldY:Int, height:Int):Vector3d
        {
            var pitch:Float = ASCompat.toInt(this._map.worldUnitsPerTile);
            return new Vector3d((worldX - ASCompat.toNumber(this._map.worldOrigin.x)) / pitch + ASCompat.toInt(this._map.tileOrigin.x),
                (worldY - ASCompat.toNumber(this._map.worldOrigin.y)) / pitch + ASCompat.toInt(this._map.tileOrigin.y),
                height / pitch);
        }

        function releaseDynamicObjects()
        {
var key:String  = null;            if (this._roomEngine == null) return;
            this.clearPlayerHighlight();
            var key:String = null;
            final _iter_:ASObject = this._players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {key = _tmp_;
this.removePlayer(ASCompat.toInt(key));
};
            final _iter_:ASObject = this._machines; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {key = _tmp_;
this._roomEngine.disposeObjectFurniture(ROOM_ID, ASCompat.toInt(key));
};
            final _iter_:ASObject = this._projectiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                this._roomEngine.disposeGameObject(
                    ROOM_ID, ASCompat.toInt(key), RoomObjectCategoryEnum.SNOWBALL);
};
            final _iter_:ASObject = this._impacts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                this._roomEngine.disposeGameObject(
                    ROOM_ID, ASCompat.toInt(key), RoomObjectCategoryEnum.SNOW_SPLASH);
};
            this._players = {}; this._figures = {}; this._positions = {}; this._directions = {};
            this._machines = {}; this._machineStates = {}; this._projectiles = {}; this._impacts = {};
            this._highlightedPlayerId = -1;
        }

        function releaseRoom()
        {
var key:String  = null;            if (this._roomEngine == null) return;
            this.hideTileCursor();
            this.releaseDynamicObjects();
            final _iter_:ASObject = this._staticIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{key = _tmp_;
                this._roomEngine.disposeObjectFurniture(ROOM_ID, ASCompat.toInt(key));
};
            this._staticIds = {};
            this._pendingStatic = [];
            this._canvas = null;
            if (this._roomInitialized)
            {
                this._roomEngine.disposeRoom(ROOM_ID);
                this._roomInitialized = false;
            }
            this._instanceId = -1; this._mapId = -1; this._map = null;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this.releaseRoom();
            if (this._roomEngine != null && this._splashUpdatesRegistered)
            {
                this._roomEngine.removeObjectUpdateCategory(RoomObjectCategoryEnum.SNOW_SPLASH);
                this._splashUpdatesRegistered = false;
            }
            this._roomEngine = null; this._avatars = null; this._assets = null;
            this._disposed = true;
        }
    }

