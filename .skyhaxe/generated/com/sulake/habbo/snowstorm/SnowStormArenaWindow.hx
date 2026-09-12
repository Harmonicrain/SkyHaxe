package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.utils.FontEnum;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.ui.MouseCursorData;

    /** Native draggable SnowStorm arena frame with the original HUD embedded in its footer. */
     final class SnowStormArenaWindow
    {
        static inline final FRAME_WIDTH= 760;
        static inline final FRAME_HEIGHT= 566;
        static inline final TITLE_HEIGHT= 29;
        static inline final CANVAS_WIDTH= 746;
        static inline final CANVAS_HEIGHT= 464;
        static inline final CANVAS_X= 7;
        static inline final CANVAS_Y= 35;
        static final FOOTER_Y:Int = CANVAS_Y + CANVAS_HEIGHT + 9;
        static final FOOTER_HEIGHT:Int = FRAME_HEIGHT - FOOTER_Y;
        static inline final FOOTER_ACTION_OFFSET_Y= 20;
        static inline final FOOTER_STATUS_OFFSET_Y= 21;
        static inline final HOLD_THROW_MS= 1000;
        static inline final TARGET_CURSOR_NAME= "snowstorm_crosshair";
        static inline final TARGET_CURSOR_ASSET= "hh_game_snowwar_room_sw_crosshair";
        static final TARGET_COLOURS:Array<ASAny> = [0xFF5136, 0x29C2FF, 0xFFDD36, 0xED28FF];

        var _windowManager:IHabboWindowManager;
        var _host:SnowStormWindowHost;
        var _arena:SnowStormArena;
        var _assets:SnowStormAssets;
        var _hud:SnowStormArenaHud;
        var _scores:SnowStormScoreWindows;
        var _surface:SnowStormWindowSurface;
        var _emit:ASFunction;
        var _text:ASFunction;
        var _frame:IWindowContainer;
        var _plate:IWindow;
        var _titleChrome:IWindowContainer;
        var _wellChrome:IWindowContainer;
        var _footerChrome:IWindowContainer;
        var _leaveLayer:IWindowContainer;
        var _title:ITextWindow;
        var _status:ITextWindow;
        var _overlay:ITextWindow;
        var _toggle:ITextWindow;
        var _leave:IWindow;
        var _countdown:SnowStormCountdownWindow;
        var _wrapper:IDisplayObjectWrapper;
        var _panel:Sprite;
        var _targetLabel:TextField;
        var _targetCursorBitmap:BitmapData;
        var _targetCursorRegistered:Bool = false;
        var _hoveredPlayerId:Int = -1;
        var _hoverPoint:Point;
        var _model:SnowStormModel;
        var _mouseDownAt:Int = 0;
        var _mouseDownPoint:Point;
        var _mouseShift:Bool = false;
        var _mouseAlt:Bool = false;
        var _shrunk:Bool = false;
        var _statusMessage:String = "";
        var _statusMessageUntil:Int = 0;
        var _lastStatusCaption:String;
        var _lastStatusColour:UInt = 0xFFFFFFFF;
        var _spectatingCaption:String;
        var _lastState:Int = -1;
        var _ticketCost:Int = 2;
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager,
                                             componentAssets:IAssetLibrary,
                                             assets:SnowStormAssets,
                                             avatars:IAvatarRenderManager,
                                             figure:String,
                                             gender:String,
                                             host:SnowStormWindowHost,
                                             arena:SnowStormArena,
                                             emit:ASFunction,
                                             text:ASFunction)
        {
            this._windowManager = windowManager;
            this._host = host;
            this._arena = arena;
            this._assets = assets;
            this._emit = emit;
            this._text = text;
            this._surface = new SnowStormWindowSurface(windowManager, assets);
            this._hud = new SnowStormArenaHud(windowManager, componentAssets, assets,
                avatars, figure, gender, this.makeSnowball);
            this._scores = new SnowStormScoreWindows(windowManager, componentAssets, assets, text);
            this._countdown = new SnowStormCountdownWindow(windowManager, componentAssets, assets,
                text, this.leaveCountdown);
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool { return this._frame != null && this._frame.visible; }

        public function show(model:SnowStormModel, ticketCost:Int=2)
        {
            if (this._disposed || model == null) return;
            this._ticketCost = Std.int(Math.max(0, ticketCost));
            this.ensureWindow();
            this._model = model;
            this._frame.visible = true;
            this._host.bringToFront(this._frame);
            this._host.bringHostToFront();
            this.attachCanvas();
            this.update(model);
        }

        public function update(model:SnowStormModel)
        {
            if (this._disposed || model == null || this._frame == null || !this._frame.visible) return;
            this._model = model;
            this.attachCanvas();
            this._arena.sync(model);
            var local:ASObject = model.localPlayer();
            if (local != null) this._hud.setFigure(ASCompat.toString(local.figure));
            this._hud.setState(local == null ? 0 : ASCompat.toInt(local.health),
                local == null ? 0 : ASCompat.toInt(local.snowballs),
                local == null ? SnowStormArenaHud.ACTIVITY_NORMAL : ASCompat.toInt(local.activity),
                model.spectator, model.state != SnowStormProtocol.STATE_RUNNING);
            this._hud.tick();
            if (this._title != null) this._title.caption = this.mapName(model.mapId);
            this.refreshStatus(flash.Lib.getTimer());
            if (this._scores != null) this._scores.update(model, !this._shrunk);
            this.updateOverlay(model);
            if (this._countdown != null) this._countdown.update(model, this._ticketCost, true);
            if (this._lastState == SnowStormProtocol.STATE_COUNTDOWN &&
                model.state == SnowStormProtocol.STATE_RUNNING && this._assets != null)
                this._assets.play("hh_game_snowwar_LS_C64_draw_1");
            this._lastState = model.state;
        }

        /** Non-modal feedback in the arena footer, matching the in-window BattleBall treatment. */
        public function showMessage(message:String)
        {
            if (!this.visible || message == null || message == "") return;
            this._statusMessage = message;
            this._statusMessageUntil = flash.Lib.getTimer() + 3500;
            this.refreshStatus(flash.Lib.getTimer());
        }

        public function hide(release:Bool=false)
        {
            this.clearAvatarHover();
            this._hoverPoint = null;
            if (this._frame != null) this._frame.visible = false;
            if (this._countdown != null) this._countdown.hide();
            if (this._scores != null) this._scores.hide();
            if (this._arena != null) this._arena.hideTileCursor();
            if (release && this._arena != null) this._arena.release();
            this._model = null;
            this._statusMessage = "";
            this._statusMessageUntil = 0;
            this._lastStatusCaption = null;
            this._lastStatusColour = 0xFFFFFFFF;
            this._lastState = -1;
            this.clearMouseDown();
        }

        function ensureWindow()
        {
            if (this._frame != null) return;
            this._host.ensureRoot();
            this._host.resize();
            this._frame = Std.downcast(this._windowManager.createWindow("snowstorm_arena_frame", "",
                WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_DRAGGABLE_WITH_MOUSE),
                new Rectangle(0, 0, FRAME_WIDTH, FRAME_HEIGHT)) , IWindowContainer);
            this._frame.color = 0x26374A;
            this._host.adopt(this._frame);
            this._plate = this._windowManager.createWindow("snowstorm_arena_plate", "",
                WindowType.WINDOW_TYPE_BACKGROUND, WindowStyle.WINDOW_STYLE_DEFAULT,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TRIGGER),
                new Rectangle(0, 0, FRAME_WIDTH, FRAME_HEIGHT));
            this._plate.color = 0xFF000000;
            this._frame.addChild(this._plate);
            this._surface.bind(this._frame);
            this.buildChrome();
            this._wrapper = Std.downcast(this._windowManager.createWindow("snowstorm_arena_canvas", "",
                WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR,
                new Rectangle(CANVAS_X, CANVAS_Y, CANVAS_WIDTH, CANVAS_HEIGHT)) , IDisplayObjectWrapper);
            this._frame.addChild(this._wrapper);
            this._panel = new Sprite();
            this._panel.scrollRect = new Rectangle(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
            this._wrapper.setDisplayObject(this._panel);
            this._panel.addEventListener(MouseEvent.MOUSE_DOWN, (this.onArenaMouseDown : ASAny));
            this._panel.addEventListener(MouseEvent.MOUSE_UP, (this.onArenaMouseUp : ASAny));
            this._panel.addEventListener(MouseEvent.MOUSE_MOVE, (this.onArenaMouseMove : ASAny));
            this._panel.addEventListener(MouseEvent.ROLL_OUT, (this.onArenaMouseOut : ASAny));
            this._panel.addEventListener(Event.ENTER_FRAME, (this.onFrame : ASAny));
            this.createTargetLabel();
            // Reconstruct Shockwave's complete blue-grey 960 px bottom bar first. Every label and
            // control is then added above it, avoiding the flat-grey fragments and hidden button art
            // caused by layering a cropped HUD over independently drawn footer controls.
            this._hud.attach(this._frame, 3, FOOTER_Y - 15);
            // The original Score Class hosted time, personal score and team score as independent
            // arena overlays. They are converted XML windows, not replacement footer labels.
            if (this._scores != null)
                this._scores.attach(this._frame, CANVAS_X, CANVAS_Y, CANVAS_WIDTH);
            // Match BattleBall's arena hierarchy: the title bar identifies only the selected field;
            // all live state and actions sit in the recovered SnowStorm footer below the arena.
            this._title = this.makeText("snowstorm_arena_title", Std.int(FRAME_WIDTH / 2) - 75, 9,
                150, 13, this.text("sw_title"), 0xD3D3D3);
            if (this._title != null && this._surface != null)
                this._surface.formatText(this._title, this._title.caption, 0xD3D3D3, true, "center");
            this._status = this.makeText("snowstorm_arena_status", 14,
                FOOTER_Y + FOOTER_STATUS_OFFSET_Y,
                210, 16, "", 0xFFFFFF);
            this._toggle = this.makeText("snowstorm_arena_toggle", 648,
                FOOTER_Y + FOOTER_ACTION_OFFSET_Y,
                20, 19, "−", 0xFFFFFF, true);
            this._toggle.color = 0x00606F76;
            this._toggle.addEventListener(WindowMouseEvent.CLICK, this.onToggle);
            // REGION containers do not retain bitmap children reliably in this AIR window stack.
            // BattleBall avoids that by keeping authored art in a native control layer and placing
            // a transparent input region above it; use the same hierarchy here.
            this._leaveLayer = this.chromeContainer("snowstorm_leave_button",
                new Rectangle(674, FOOTER_Y + FOOTER_ACTION_OFFSET_Y, 72, 19));
            this._surface.buttonInto(this._leaveLayer, this.text("sw_leave_game"));
            this._leave = this._surface.hotspotInto(this._leaveLayer, 0, 0, 72, 19);
            if (this._leave != null)
                this._leave.addEventListener(WindowMouseEvent.CLICK, this.onLeave);
            this._overlay = this.makeText("snowstorm_arena_overlay", 260, 210, 240, 58, "", 0xFFFFFF);
            this._overlay.color = 0xCC26374A;
            this._overlay.fontSize = 18;
            this._overlay.visible = false;
            if (this._countdown != null)
                this._countdown.attach(this._frame, Std.int((FRAME_WIDTH - 189) / 2),
                    CANVAS_Y + Std.int((CANVAS_HEIGHT - 120) / 2));
            this.center();
            this._frame.activate();
        }

        /** Builds the arena from the same converted SnowStorm window pieces as the lobby. */
        function buildChrome()
        {
            if (this._surface == null || this._frame == null) return;
            this._titleChrome = this.chromeContainer("snowstorm_arena_title_chrome",
                new Rectangle(0, 0, FRAME_WIDTH, TITLE_HEIGHT));
            this._wellChrome = this.chromeContainer("snowstorm_arena_well_chrome",
                new Rectangle(0, 0, FRAME_WIDTH, FOOTER_Y));
            this._footerChrome = this.chromeContainer("snowstorm_arena_footer_chrome",
                new Rectangle(0, FOOTER_Y, FRAME_WIDTH, FOOTER_HEIGHT));

            var w= FRAME_WIDTH;
            this._surface.pieceInto(this._titleChrome, "sw_mtl_ed", 5, 0, w - 10, 3);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_el", 0, 5, 3, 21);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_er", w - 3, 5, 3, 21);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_pxb", 3, 3, w - 6, 23);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_bt", 7, 26, w - 14, 3);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_cr", 1, 1, 4, 4);
            this._surface.pieceInto(this._titleChrome, "sw_mtl_cr", w - 5, 1, 4, 4, true);
            // The authored SnowStorm title tab is the same three-piece treatment used by the lobby
            // and by BattleBall's arena, rather than loose text over the full-width metal bar.
            this._surface.pieceInto(this._titleChrome, "sw_fl", Std.int(w / 2) - 80, 7, 5, 15);
            this._surface.pieceInto(this._titleChrome, "sw_fc", Std.int(w / 2) - 75, 6, 150, 17);
            this._surface.pieceInto(this._titleChrome, "sw_fl", Std.int(w / 2) + 75, 7, 5, 15, true);

            this._surface.pieceInto(this._wellChrome, "sw_clr_cr", 0, 26, 7, 9);
            this._surface.pieceInto(this._wellChrome, "sw_clr_cr2", w - 7, 26, 7, 9);
            this._surface.pieceInto(this._wellChrome, "sw_clr_tp", 7, 28, w - 14, 4);
            this._surface.pieceInto(this._wellChrome, "sw_clr_bt", 7, 32, w - 14, 3);
            this._surface.pieceInto(this._wellChrome, "sw_clr_ed", 0, CANVAS_Y, 7, CANVAS_HEIGHT);
            this._surface.pieceInto(this._wellChrome, "sw_clr_ed", w - 7, CANVAS_Y, 7, CANVAS_HEIGHT);
            var wellBottom= CANVAS_Y + CANVAS_HEIGHT;
            this._surface.pieceInto(this._wellChrome, "sw_clr_tp", 7, wellBottom, w - 14, 4);
            this._surface.pieceInto(this._wellChrome, "sw_clr_cr5", 0, wellBottom, 7, 4);
            this._surface.pieceInto(this._wellChrome, "sw_clr_cr6", w - 7, wellBottom, 7, 4);
            this._surface.pieceInto(this._wellChrome, "sw_clr_bt", 3, wellBottom + 4, w - 6, 3);
            this._surface.pieceInto(this._wellChrome, "sw_clr_cr3", 0, wellBottom + 4, 3, 5);
            this._surface.pieceInto(this._wellChrome, "sw_clr_cr4", w - 3, wellBottom + 4, 3, 5);

            this._surface.pieceInto(this._footerChrome, "sw_mtl_ed", 3, 0, w - 6, 3);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_el", 0, 3, 3, FOOTER_HEIGHT - 6);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_er", w - 3, 3, 3, FOOTER_HEIGHT - 6);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_pxb", 3, 3, w - 6, FOOTER_HEIGHT - 6);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_bt", 5, FOOTER_HEIGHT - 3, w - 10, 3);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_cr2", 1, FOOTER_HEIGHT - 5, 4, 4);
            this._surface.pieceInto(this._footerChrome, "sw_mtl_cr2", w - 5, FOOTER_HEIGHT - 5, 4, 4, true);
        }

        function chromeContainer(name:String, rectangle:Rectangle):IWindowContainer
        {
            var result= Std.downcast(this._windowManager.createWindow(name, "",
                WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_NULL, rectangle) , IWindowContainer);
            if (result != null) this._frame.addChild(result);
            return result;
        }

        function attachCanvas()
        {
            if (this._arena == null || this._model == null || this._panel == null) return;
            this._arena.build(this._model, CANVAS_WIDTH, CANVAS_HEIGHT);
            var canvas= this._arena.canvas;
            if (canvas == null) return;
            if ((canvas.parent : ASAny) != (this._panel : ASAny))
            {
                if (canvas.parent != null) canvas.parent.removeChild(canvas);
                this._panel.addChildAt(canvas, 0);
            }
            canvas.x = 0; canvas.y = 0;
        }

        function onArenaMouseDown(event:MouseEvent)
        {
            if (!this.canAct()) return;
            var point= this.arenaPoint(event);
            if (point == null) return;
            this._hoverPoint = point;
            this.refreshArenaPointer(point);
            this._mouseDownAt = flash.Lib.getTimer();
            this._mouseDownPoint = point;
            this._mouseShift = event.shiftKey;
            this._mouseAlt = event.altKey;
        }

        function onArenaMouseMove(event:MouseEvent)
        {
            var point= this.arenaPoint(event);
            this._hoverPoint = point;
            if (point == null) { this.clearArenaPointer(); return; }
            this.refreshArenaPointer(point);
        }

        function onArenaMouseUp(event:MouseEvent)
        {
var tile:Point  = null, worldX = 0, worldY = 0;            if (!this.canAct() || this._mouseDownPoint == null) { this.clearMouseDown(); return; }
            var held= flash.Lib.getTimer() - this._mouseDownAt;
            var shifted= this._mouseShift || event.shiftKey;
            var longThrow= this._mouseAlt || event.altKey || (shifted && held >= HOLD_THROW_MS);
            var shortThrow= !longThrow && shifted;
            var trajectory= longThrow ? SnowStormProtocol.TRAJECTORY_LONG_LOB
                : (shortThrow ? SnowStormProtocol.TRAJECTORY_SHORT_LOB
                    : SnowStormProtocol.TRAJECTORY_QUICK);
            var point= this.arenaPoint(event);
            if (point == null) { this.clearMouseDown(); return; }
            this._hoverPoint = point;
            this.refreshArenaPointer(point);
            var localId= this._model.playerObjectId;
            // The RoomEngine bounding rectangle includes the floor diamond beneath an avatar.
            // Self-selection therefore stole adjacent walk clicks and submitted MAKE_SNOWBALL.
            // Making is already an explicit HUD action, so exclude the local avatar here.
            var targetId= this._hoveredPlayerId == localId ? -1 : this._hoveredPlayerId;
            if (targetId > 0 && this.canThrow())
                // Shockwave uses a quick throw for a plain avatar click and a long lob whenever
                // Shift or Option/Alt is held; short lob applies only to empty field locations.
                this.send(SnowStormViewEvent.THROW_PLAYER,
                    {objectId:targetId, trajectory:(longThrow || shortThrow)
                        ? SnowStormProtocol.TRAJECTORY_LONG_LOB
                        : SnowStormProtocol.TRAJECTORY_QUICK});
            else
            {
tile= this._arena.screenToTile(point.x, point.y);
                if (tile != null)
                {
worldX= SnowStormMapCatalog.toWorldX(this._model.map, Std.int(tile.x));
worldY= SnowStormMapCatalog.toWorldY(this._model.map, Std.int(tile.y));
                    if ((longThrow || shortThrow) && this.canThrow())
                        this.send(SnowStormViewEvent.THROW_LOCATION,
                            {x:worldX, y:worldY, trajectory:trajectory});
                    else if (SnowStormMapCatalog.isWalkable(this._model.map, Std.int(tile.x), Std.int(tile.y)))
                        this.send(SnowStormViewEvent.WALK, {x:worldX, y:worldY});
                }
            }
            this.clearMouseDown();
        }

        /** MouseEvent.localX/localY belong to the deepest room-engine child under the pointer. */
        function arenaPoint(event:MouseEvent):Point
        {
            return event == null || this._panel == null
                ? null : this._panel.globalToLocal(new Point(event.stageX, event.stageY));
        }

        function onArenaMouseOut(event:MouseEvent)
        {
            this._hoverPoint = null;
            this.clearArenaPointer();
            if (event.buttonDown) return;
            this.clearMouseDown();
        }

        function onFrame(event:Event)
        {
            var now= flash.Lib.getTimer();
            if (this._arena != null) this._arena.tick(now);
            if (this._model != null && this._model.advancePlayback(now))
                this.update(this._model);
            if (this._hud != null) this._hud.tick();
            if (this._scores != null && this._model != null)
                this._scores.update(this._model, !this._shrunk);
            if (this._countdown != null && (this._model == null ||
                this._model.state == SnowStormProtocol.STATE_COUNTDOWN
                || this._countdown.visible))
                this._countdown.update(this._model, this._ticketCost, false);
            if (this._hoverPoint != null && !this._shrunk && this.visible)
                this.refreshArenaPointer(this._hoverPoint);
            this.refreshStatus(now);
        }

        /** Recreates r26's avatar rollover: team diamond, name/score and native crosshair. */
        function refreshArenaPointer(point:Point)
        {
            if (this._arena == null || this._model == null || point == null || this._shrunk)
            {
                this.clearArenaPointer();
                return;
            }
            var targetId= this._arena.playerAt(point.x, point.y);
            var target:ASObject = this.playerObject(targetId);
            var local:ASObject = this._model.localPlayer();
            // Do not advertise targets the authoritative simulation cannot accept.
            if (target != null && (targetId == this._model.playerObjectId ||
                ASCompat.toInt(target.activity) == SnowStormProtocol.ACTIVITY_STUNNED ||
                ASCompat.toInt(target.health) <= 0 ||
                (this._model.teamCount > 1 && local != null &&
                    ASCompat.toInt(target.teamId) == ASCompat.toInt(local.teamId))))
                target = null;
            if (target != null)
            {
                this._hoveredPlayerId = targetId;
                this._arena.hideTileCursor();
                this._arena.setPlayerHighlight(targetId, ASCompat.toInt(target.teamId));
                this.updateTargetLabel(target);
                this.setTargetCursor(!this._model.spectator &&
                    this._model.state == SnowStormProtocol.STATE_RUNNING);
                return;
            }
            this.clearAvatarHover();
            if (!this.canAct())
            {
                this._arena.hideTileCursor();
                return;
            }
            var tile= this._arena.screenToTile(point.x, point.y);
            if (tile != null && SnowStormMapCatalog.isWalkable(
                this._model.map, Std.int(tile.x), Std.int(tile.y)))
                this._arena.setTileCursor(Std.int(tile.x), Std.int(tile.y), true);
            else
                this._arena.hideTileCursor();
        }

        function playerObject(objectId:Int):ASObject
        {
            if (this._model == null || objectId <= 0) return null;
            var object:ASObject = this._model.objects[Std.string(objectId)];
            return object != null && ASCompat.toInt(object.type) == SnowStormProtocol.OBJECT_AVATAR
                ? object : null;
        }

        function createTargetLabel()
        {
            if (this._panel == null || this._targetLabel != null) return;
            var face= FontEnum.isEmbeddedFont("Volter Bold") ? "Volter Bold" : "Volter";
            this._targetLabel = new TextField();
            this._targetLabel.autoSize = TextFieldAutoSize.LEFT;
            this._targetLabel.multiline = true;
            this._targetLabel.selectable = false;
            this._targetLabel.mouseEnabled = false;
            this._targetLabel.embedFonts = FontEnum.isEmbeddedFont(face);
            this._targetLabel.antiAliasType = AntiAliasType.ADVANCED;
            this._targetLabel.defaultTextFormat = new TextFormat(
                face, 9, ASCompat.toInt(TARGET_COLOURS[0]), true, null, null, null, null, TextFormatAlign.CENTER);
            this._targetLabel.visible = false;
            this._panel.addChild(this._targetLabel);
        }

        function updateTargetLabel(target:ASObject)
        {
            if (target == null || this._targetLabel == null || this._arena == null) return;
            var anchor= this._arena.playerAnchor(ASCompat.toInt(target.objectId));
            if (anchor == null)
            {
                this._targetLabel.visible = false;
                return;
            }
            var teamId= Std.int(Math.max(0, Math.min(3, ASCompat.toInt(target.teamId))));
            var format= this._targetLabel.defaultTextFormat;
            format.color = TARGET_COLOURS[teamId];
            format.align = TextFormatAlign.CENTER;
            this._targetLabel.defaultTextFormat = format;
            this._targetLabel.text = ASCompat.toString(target.name) + "\n" + Std.string(ASCompat.toInt(target.score)) + "p";
            this._targetLabel.setTextFormat(format);
            this._targetLabel.x = Math.fround(anchor.x - this._targetLabel.width / 2);
            this._targetLabel.y = Math.fround(anchor.y + 10);
            this._targetLabel.visible = true;
            if ((this._targetLabel.parent : ASAny) == (this._panel : ASAny))
                this._panel.setChildIndex(this._targetLabel, this._panel.numChildren - 1);
        }

        function setTargetCursor(active:Bool)
        {
            if (active && this.ensureTargetCursor())
                Mouse.cursor = TARGET_CURSOR_NAME;
            else if (Mouse.cursor == TARGET_CURSOR_NAME)
                Mouse.cursor = MouseCursor.AUTO;
        }

        function ensureTargetCursor():Bool
        {
            if (this._targetCursorRegistered) return true;
            if (this._assets == null) return false;
            this._targetCursorBitmap = this._assets.cloneBitmapData(TARGET_CURSOR_ASSET);
            if (this._targetCursorBitmap == null) return false;
            var frames= new Vector<BitmapData>();
            frames.push(this._targetCursorBitmap);
            var cursor= new MouseCursorData();
            cursor.data = frames;
            cursor.hotSpot = new Point(6, 6);
            cursor.frameRate = 1;
            try
            {
                Mouse.registerCursor(TARGET_CURSOR_NAME, cursor);
                this._targetCursorRegistered = true;
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                if (this._targetCursorBitmap != null) this._targetCursorBitmap.dispose();
                this._targetCursorBitmap = null;
            }
 }            return this._targetCursorRegistered;
        }

        function clearAvatarHover()
        {
            this._hoveredPlayerId = -1;
            if (this._targetLabel != null) this._targetLabel.visible = false;
            if (this._arena != null) this._arena.clearPlayerHighlight();
            this.setTargetCursor(false);
        }

        function clearArenaPointer()
        {
            this.clearAvatarHover();
            if (this._arena != null) this._arena.hideTileCursor();
        }

        function refreshStatus(now:Int)
        {
            if (this._model == null || this._status == null) return;
            var suffix:String = null;
            var colour:UInt = 0;
            if (this._statusMessage != "" && now < this._statusMessageUntil)
            {
                suffix = this._statusMessage;
                colour = 0xFFE7A8;
            }
            else
            {
                this._statusMessage = "";
                if (this._model.spectator)
                {
                    if (this._spectatingCaption == null)
                        this._spectatingCaption = this.text("sw_spectating");
                    suffix = this._spectatingCaption;
                }
                else suffix = "";
                colour = 0xFFFFFF;
            }
            if (suffix != this._lastStatusCaption)
            {
                this._status.caption = suffix;
                this._lastStatusCaption = suffix;
            }
            if (colour != this._lastStatusColour)
            {
                this._status.textColor = colour;
                this._lastStatusColour = colour;
            }
        }

        function makeSnowball()
        {
            if (this.canAct()) this.send(SnowStormViewEvent.MAKE_SNOWBALL);
        }

        function onLeave(event:WindowMouseEvent)
        {
            this.leaveCountdown();
        }

        function leaveCountdown()
        {
            if (this._model != null && this._model.instanceId > 0)
                this.send(SnowStormViewEvent.LEAVE, {instanceId:this._model.instanceId});
        }

        function onToggle(event:WindowMouseEvent)
        {
            this._shrunk = !this._shrunk;
            if (this._toggle != null) this._toggle.caption = this._shrunk ? "+" : "−";
            if (this._wrapper != null) this._wrapper.visible = !this._shrunk;
            if (this._wellChrome != null) this._wellChrome.visible = !this._shrunk;
            if (this._footerChrome != null) this._footerChrome.y = this._shrunk ? TITLE_HEIGHT : FOOTER_Y;
            if (this._overlay != null) this._overlay.visible = !this._shrunk && this._overlay.caption != "";
            if (this._countdown != null)
            {
                if (this._shrunk) this._countdown.hide();
                else if (this._model != null)
                    this._countdown.update(this._model, this._ticketCost, true);
            }
            if (this._shrunk)
            {
                this._hoverPoint = null;
                this.clearArenaPointer();
            }
            if (this._scores != null)
            {
                if (this._shrunk) this._scores.hide();
                else if (this._model != null) this._scores.update(this._model, true);
            }
            var footerTop= this._shrunk ? TITLE_HEIGHT : FOOTER_Y;
            if (this._status != null) this._status.y = footerTop + FOOTER_STATUS_OFFSET_Y;
            if (this._toggle != null) this._toggle.y = footerTop + FOOTER_ACTION_OFFSET_Y;
            if (this._leaveLayer != null) this._leaveLayer.y = footerTop + FOOTER_ACTION_OFFSET_Y;
            if (this._frame != null) this._frame.height = this._shrunk ? TITLE_HEIGHT + FOOTER_HEIGHT : FRAME_HEIGHT;
            if (this._plate != null) this._plate.height = this._frame.height;
        }

        function updateOverlay(model:SnowStormModel)
        {
            if (this._overlay == null) return;
            var value= "";
            if (model.state == SnowStormProtocol.STATE_ENDING)
                value = this.text("sw_game_over");
            this._overlay.caption = value;
            this._overlay.visible = !this._shrunk && value != "";
        }

        function canAct():Bool
        {
            if (this._model == null || this._model.spectator ||
                this._model.state != SnowStormProtocol.STATE_RUNNING) return false;
            var local:ASObject = this._model.localPlayer();
            return local != null && ASCompat.toInt(local.activity) != SnowStormArenaHud.ACTIVITY_STUNNED;
        }

        function canThrow():Bool
        {
            if (!this.canAct()) return false;
            var local:ASObject = this._model.localPlayer();
            // r26 getStateAllowsMoving permits throws while the pck creation timer is active;
            // the accepted throw replaces the visible pose without cancelling that timer.
            return ASCompat.toInt(local.snowballs) > 0 && (ASCompat.toInt(local.activity) == SnowStormArenaHud.ACTIVITY_NORMAL ||
                ASCompat.toInt(local.activity) == SnowStormArenaHud.ACTIVITY_CREATING ||
                ASCompat.toInt(local.activity) == SnowStormArenaHud.ACTIVITY_INVINCIBLE);
        }

        function send(type:String, data:ASObject=null)
        {
            if (this._emit != null) this._emit(type, data);
        }

        function clearMouseDown()
        {
            this._mouseDownAt = 0; this._mouseDownPoint = null;
            this._mouseShift = false; this._mouseAlt = false;
        }

        function makeText(name:String, x:Int, y:Int, width:Int, height:Int,
                                  value:String, colour:UInt, interactive:Bool=false):ITextWindow
        {
            var result= Std.downcast(this._windowManager.createWindow(name, value,
                WindowType.WINDOW_TYPE_TEXT, HabboWindowStyle.NULL,
                interactive ? WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR : WindowParam.WINDOW_PARAM_NULL,
                new Rectangle(x, y, width, height)) , ITextWindow);
            if (result == null) return null;
            this._frame.addChild(result);
            if (this._surface != null) this._surface.formatText(result, value, colour, false, "center");
            else { result.textColor = colour; result.fontSize = 9; }
            return result;
        }

        function center()
        {
            this._host.resize();
            this._frame.x = Std.int(Math.max(0, Std.int((this._host.width - FRAME_WIDTH) / 2)));
            this._frame.y = Std.int(Math.max(0, Std.int((this._host.height - FRAME_HEIGHT) / 2)));
        }

        function mapName(mapId:Int):String
        {
            var key= "sw_fieldname_" + Std.string(Math.max(1, mapId));
            return this.text(key);
        }

        function text(key:String):String
        {
            if (this._text == null) return key;
            var value= ASCompat.toString(this._text(key));
            return value == null || value == "" ? key : value;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            this.clearArenaPointer();
            if (this._leave != null) this._leave.removeEventListener(WindowMouseEvent.CLICK, this.onLeave);
            if (this._toggle != null) this._toggle.removeEventListener(WindowMouseEvent.CLICK, this.onToggle);
            if (this._panel != null)
            {
                this._panel.removeEventListener(MouseEvent.MOUSE_DOWN, (this.onArenaMouseDown : ASAny));
                this._panel.removeEventListener(MouseEvent.MOUSE_UP, (this.onArenaMouseUp : ASAny));
                this._panel.removeEventListener(MouseEvent.MOUSE_MOVE, (this.onArenaMouseMove : ASAny));
                this._panel.removeEventListener(MouseEvent.ROLL_OUT, (this.onArenaMouseOut : ASAny));
                this._panel.removeEventListener(Event.ENTER_FRAME, (this.onFrame : ASAny));
            }
            if (this._arena != null) this._arena.hideTileCursor();
            if (this._targetCursorRegistered)
            {
                Mouse.unregisterCursor(TARGET_CURSOR_NAME);
                this._targetCursorRegistered = false;
            }
            if (this._targetCursorBitmap != null) this._targetCursorBitmap.dispose();
            if (this._countdown != null) this._countdown.dispose();
            if (this._hud != null) this._hud.dispose();
            if (this._scores != null) this._scores.dispose();
            if (this._surface != null) this._surface.dispose();
            if (this._frame != null) this._frame.dispose();
            this._frame = null; this._plate = null; this._title = null; this._status = null;
            this._titleChrome = null; this._wellChrome = null; this._footerChrome = null;
            this._leaveLayer = null; this._countdown = null;
            this._overlay = null; this._toggle = null;
            this._leave = null; this._wrapper = null; this._panel = null; this._model = null;
            this._targetLabel = null; this._targetCursorBitmap = null; this._hoverPoint = null;
            this._surface = null; this._hud = null; this._scores = null;
            this._arena = null; this._assets = null;
            this._host = null; this._windowManager = null;
            this._emit = null; this._text = null;
        }
    }

