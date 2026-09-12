package com.sulake.habbo.room;

#if html5
import com.sulake.habbo.communication.messages.outgoing.room.engine.MoveAvatarMessageComposer;
import com.sulake.habbo.room.messages.RoomObjectTileCursorUpdateMessage;
import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
import com.sulake.room.renderer.IRoomRenderingCanvas;
import com.sulake.room.renderer.RoomSpriteCanvas;
import com.sulake.room.utils.Vector3d;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.geom.Point;

private typedef ConvertedRoomTile = {
    var x:Int;
    var y:Int;
    var z:Float;
}

/**
 * HTML5 pointer bridge for the converted room engine.
 *
 * AIR's RoomDesktop normally translates stage coordinates into room-canvas coordinates before
 * handing events to RoomEngine. Public-room layout sprites also omit the `plane.floor@N` tags
 * guest-room floor planes expose, so RoomDesktop supplies the final public-room tile lookup.
 * SkyHaxe has no RoomDesktop yet; this host adapter owns only those two browser/UI operations.
 * The generated RoomEngine still owns hit testing, its tile-cursor object and the walk composer.
 */
class ConvertedRoomInput {
    final engineProvider:Void->Null<RoomEngine>;
    final displayProvider:Void->Null<DisplayObject>;
    final roomIdProvider:Void->Int;
    final canvasId:Int;
    var pendingHover:MouseEvent;
    var hoverTick:Int = -1;
    var hoverStage:openfl.display.Stage;

    public function new(engineProvider:Void->Null<RoomEngine>,
            displayProvider:Void->Null<DisplayObject>, roomIdProvider:Void->Int, canvasId:Int) {
        this.engineProvider = engineProvider;
        this.displayProvider = displayProvider;
        this.roomIdProvider = roomIdProvider;
        this.canvasId = canvasId;
    }

    /** Hand one stage pointer event to RoomEngine in room-canvas coordinates. */
    public function forward(event:MouseEvent):Void {
        var engine = engineProvider();
        var display = displayProvider();
        var roomId = roomIdProvider();
        if (engine == null || roomId == 0) return;
        var desktopOwned = display == null;
        if (desktopOwned) {
            // Original RoomUI owns the canvas now; the legacy host field is intentionally null.
            // Keep only the public layout tile bridge, not a second desktop event dispatcher.
            if (!engine.isPublicRoom(roomId)) return;
            var canvas = engine.getRoomCanvas(roomId, canvasId);
            if (canvas == null) return;
            display = canvas.displayObject;
        }
        if (display == null) return;

        // Dragging changes the display object's position. Recomputing this for every event keeps
        // the pointer anchored to the room instead of allowing the canvas to drift beneath it.
        var local = display.globalToLocal(new Point(event.stageX, event.stageY));
        #if debug
        {
            var map = engine.getFurniStackingHeightMap(roomId);
            js.Browser.document.documentElement.setAttribute("data-skyhaxe-pointer", haxe.Json.stringify({
                type:event.type, room:roomId, publicRoom:engine.isPublicRoom(roomId), x:local.x, y:local.y,
                held:event.buttonDown, cursor:engine.getTileCursor(roomId) != null,
                map:map == null ? "absent" : map.width + "x" + map.height,
                legacy:engine.getLegacyGeometry(roomId) != null
            }));
        }
        #end
        engine.setActiveRoom(roomId);
        if (!desktopOwned)
            engine.handleRoomCanvasMouseEvent(canvasId, Std.int(local.x), Std.int(local.y), event.type,
                event.altKey, event.ctrlKey, event.shiftKey, event.buttonDown);

        if (engine.isPublicRoom(roomId) && !event.buttonDown) {
            if (desktopOwned && (event.type == MouseEvent.MOUSE_MOVE || event.type == MouseEvent.MOUSE_UP)) {
                // Original desktop consumes its mouse queue during the engine frame. Apply the
                // public layout lookup afterwards, not before its floor-out cursor update.
                pendingHover = cast event.clone();
                @:privateAccess pendingHover.stageX = event.stageX;
                @:privateAccess pendingHover.stageY = event.stageY;
                hoverTick = RoomEngineRuntime.ticks;
                if (hoverStage != display.stage) {
                    if (hoverStage != null) hoverStage.removeEventListener(openfl.events.Event.ENTER_FRAME, flushHover);
                    hoverStage = display.stage;
                    if (hoverStage != null) hoverStage.addEventListener(openfl.events.Event.ENTER_FRAME, flushHover);
                }
            } else handlePublicRoomPointer(engine, roomId, event, local);
        }
    }

    function flushHover(_:openfl.events.Event):Void {
        if (pendingHover == null || RoomEngineRuntime.ticks <= hoverTick) return;
        var event = pendingHover;
        pendingHover = null;
        var engine = engineProvider();
        var roomId = roomIdProvider();
        if (engine == null || !engine.isPublicRoom(roomId)) return;
        var canvas = engine.getRoomCanvas(roomId, canvasId);
        if (canvas == null || canvas.displayObject == null) return;
        var local = canvas.displayObject.globalToLocal(new Point(event.stageX, event.stageY));
        handlePublicRoomPointer(engine, roomId, event, local);
    }

    function handlePublicRoomPointer(engine:RoomEngine, roomId:Int, event:MouseEvent,
            local:Point):Void {
        var canvas = engine.getRoomCanvas(roomId, canvasId);
        if (canvas == null) return;
        var spriteCanvas = Std.downcast(canvas, RoomSpriteCanvas);
        var hit = spriteCanvas == null ? null
            : spriteCanvas.getRoomObjectAt(Std.int(local.x), Std.int(local.y));
        if (hit != null && engine.getRoomObjectCategory(hit.getType())
                != RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM)
            return;

        var tile = publicRoomTile(engine, roomId, local, canvas);
        if (event.type == MouseEvent.MOUSE_MOVE || event.type == MouseEvent.MOUSE_UP) {
            var cursor = engine.getTileCursor(roomId);
            if (cursor != null && cursor.getEventHandler() != null) {
                var location = tile == null ? null : new Vector3d(tile.x, tile.y, tile.z);
                cursor.getEventHandler().processUpdateMessage(
                    new RoomObjectTileCursorUpdateMessage(location, 0, tile != null, null));
            }
        } else if (event.type == MouseEvent.CLICK && tile != null && engine.connection != null) {
            engine.connection.send(new MoveAvatarMessageComposer(tile.x, tile.y));
        }
    }

    function publicRoomTile(engine:RoomEngine, roomId:Int, local:Point,
            canvas:IRoomRenderingCanvas):Null<ConvertedRoomTile> {
        var map = engine.getFurniStackingHeightMap(roomId);
        var legacy = engine.getLegacyGeometry(roomId);
        var geometry = canvas.geometry;
        if (map == null || legacy == null || geometry == null) return null;

        var scale = geometry.scale;
        var canvasScale = canvas.scale;
        var screenX = (local.x - canvas.screenOffsetX) / canvasScale
            - canvas.width / canvasScale / 2;
        var screenY = (local.y - canvas.screenOffsetY) / canvasScale
            - canvas.height / canvasScale / 2;
        var halfWidth = scale / 2;
        var halfHeight = scale / 4;
        var best:Null<ConvertedRoomTile> = null;
        var bestDistance = Math.POSITIVE_INFINITY;

        for (y in 0...map.height) for (x in 0...map.width) {
            var z = legacy.getTileHeight(x, y);
            if (z < 0) continue;
            var point = geometry.getScreenPosition(new Vector3d(x, y, z));
            if (point == null) continue;
            var distance = Math.abs(screenX - point.x) / halfWidth
                + Math.abs(screenY - point.y) / halfHeight;
            if (distance <= 1 && distance < bestDistance) {
                bestDistance = distance;
                best = {x: x, y: y, z: z};
            }
        }
        return best;
    }
}
#end
