package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.utils.FontEnum;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;

    /**
     * The BattleBall arena window: frame, border chrome, HUD, name tags, pickups, countdown and the
     * board projection.
     *
     * Split out of BattleBallView, which owned every window at once. This owns only the *visual*
     * arena -- BattleBallArena remains the sole owner of the RoomEngine objects, avatar placement,
     * tile furniture and ball additions drawn inside it.
     *
     * Dependencies are deliberately narrow: the shared window host, its own chrome, and function
     * references for the few helpers the lobby also uses. It never calls back into the view, so
     * lifecycle orchestration -- hiding the lobby, ordering windows -- stays in the facade.
     */
     class BattleBallArenaWindow
    {
        /** Mirrors the lobby shell's title height; the arena clamps its drag by the same margin. */
        static inline final LOBBY_TITLE_HEIGHT= 29;
        /** The arena keeps its established projection; the television surround lives outside it. */
        public static inline final ARENA_WIDTH= 760;
        public static inline final ARENA_HEIGHT= 560;
        /**
         * The arena is built as one of the cast's own windows rather than as a picture with a ring drawn
         * round it. Every window in this UI is three bands: a metal title bar, a recessed content well
         * whose bb_clr_ed sides ARE the window's border, and a metal footer. bb_clr_cr/cr2 are not
         * rounded corners -- they are the join between the title bar and the well, and cr5/cr6 with
         * cr3/cr4 are the join between the well and the footer. Offsets below are lifted from
         * bb_glist_window so the joins land exactly as they do there.
         */
        public static inline final WELL_SIDE= 7;
        /** Content top: title bar occupies 0..29 and the well join runs 26..35. */
        public static inline final FRAME_T= 35;
        static final FRAME_L:Int = WELL_SIDE;
        /** Visible board aperture. The HUD used to overlap the canvas here; it now sits in the footer. */
        public static final ARENA_VIEW_H:Int = ARENA_HUD_TOP;
        public static inline final HUD_H= 79;
        public static final FRAME_W:Int = ARENA_WIDTH + WELL_SIDE * 2;
        /** well bottom join (4+3) -> footer rule (2) -> footer face -> bottom rule. */
        public static final FOOTER_T:Int = FRAME_T + ARENA_VIEW_H + 9;
        public static final FRAME_H:Int = FOOTER_T + HUD_H + 3;
        /**
         * Room origin per map, fitted against the decoded arena art so the grid lands exactly on the
         * painted floor. Maps 1-4 fit their artwork to within half a percent; map 5 is derived from its
         * layoutData floor offset plus the constant delta the other four share, as its art did not decode.
         */
        static final OFFSETS:Array<ASAny> = [null, ([338,89] : Array<Dynamic>), ([220,110] : Array<Dynamic>), ([342,78] : Array<Dynamic>), ([286,116] : Array<Dynamic>), ([300,44] : Array<Dynamic>)];
        /**
         * Pixels of vertical lift per unit of map floor height. Map 5's arena is entirely flat.
         *
         * A flat map still needs a screen-to-world scale for the riders: a zero here made rideLift()
         * return 0 and made onBounceFrame early-return, so map 5 riders sat sunk into their balls and
         * never bounced. Floor artwork scaling and avatar bounce scaling are separate concerns, so the
         * flat map keeps its zero floor offset and borrows a standard unit for the rider.
         */
        static final HEIGHT_UNITS:Array<ASAny> = [0, 5, 9, 7, 9, 0];
        /** Fallback lift unit for maps whose floor is flat, so riders still bounce. */
        static inline final FLAT_MAP_HEIGHT_UNIT= 9;
        /** Every BattleBall layoutData declares size="32", so the grid pitch is 32x16, not the 30x15 art size. */
        static inline final TILE_HALF_WIDTH:Float = 16;
        static inline final TILE_HALF_HEIGHT:Float = 8;
        /** Centre of a placed tile relative to the value screenPoint returns. */
        // 30x15 tile art around the (14,6) pivot leaves its visual centre roughly one pixel down/right
        // of the projected cell origin.  This must match drawTiles or clicks select the neighbouring cell.
        static inline final TILE_CENTRE_X:Float = 1;
        static inline final TILE_CENTRE_Y:Float = 1;
        /** Where the HUD strip begins inside the arena canvas. */
        public static inline final ARENA_HUD_TOP= 481;
        var _arena:BattleBallArena;
        var _arenaBorder:IDisplayObjectWrapper;
        var _arenaBorderArt:Sprite;
        var _arenaLayer:Sprite;
        var _arenaPresentation:Bool = false;
        var _arenaTitle:ITextWindow;
        var _assets:BattleBallAssets;
        var _backdrop:IWindow;
        var _chrome:BattleBallChrome;
        var _frame:IWindowContainer;
        var _frameAnchorX:Int = ASCompat.MIN_INT;
        var _frameAnchorY:Int = ASCompat.MIN_INT;
        var _frameMoved:Bool = false;
        var _host:BattleBallWindowHost;
        var _model:BattleBallModel;
        var _panel:Sprite;
        var _plate:IWindow;
        var _windowManager:IHabboWindowManager;
        var _wrapper:IDisplayObjectWrapper;

        var _services:BattleBallViewServices;
        var _hud:BattleBallArenaHud;
        var _overlays:BattleBallArenaOverlays;

        public function new(windowManager:IHabboWindowManager, assets:BattleBallAssets,
                                              componentAssets:IAssetLibrary,
                                              host:BattleBallWindowHost, arena:BattleBallArena,
                                              services:BattleBallViewServices)
        {
            this._windowManager = windowManager; this._assets = assets;
            this._host = host; this._arena = arena;
            this._chrome = new BattleBallChrome(assets);
            this._services = services;
            this._hud = new BattleBallArenaHud(windowManager, assets, componentAssets, this._chrome, services);
            this._overlays = new BattleBallArenaOverlays(windowManager, assets, componentAssets, arena, services);
        }


        public function showError(message:String) { this._hud.showError(message); }
        public function hidePlayerNameTags() { this._overlays.hidePlayerNameTags(); }

        public var frame(get,never):IWindowContainer;
public function  get_frame():IWindowContainer { return this._frame; }
        public var panel(get,never):Sprite;
public function  get_panel():Sprite { return this._panel; }

        public function ensureWindow()
        {
            // Only raise the window when it is first shown. Re-activating on every redraw would keep
            // pulling the arena above alerts and dialogs, leaving them unreachable underneath it.
            if (this._frame != null)
            {
                this._frame.visible = true;
                if (this._backdrop != null) this._backdrop.visible = true;
                return;
            }
            // Reuse the root the lobby already built. Creating a second one here orphaned the lobby
            // window in the first root, where the arena's full-screen backdrop covered it -- which is why
            // the final standings rendered every time and were never visible.
            this._host.ensureRoot();
            this.resizeRoot();
            // Full-screen plate behind the arena. It is transparent and does NOT process input: the
            // player stays in their room while they play, so clicks that miss the arena window have to
            // reach the room underneath and walk their avatar as usual. Taking the input processor off
            // is what lets them through -- the window manager stops at the first window that wants them.
            this._backdrop = this._windowManager.createWindow("battleball_backdrop", "",
                WindowType.WINDOW_TYPE_BACKGROUND, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_NULL, new Rectangle(0,0,10,10));
            this._backdrop.color = 0x00000000;
            this._host.adopt(this._backdrop);
            this._frame = cast(this._windowManager.createWindow("battleball_frame",
                this._services.text("bb_title_bouncingBall"),
                WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_DRAGGABLE_WITH_MOUSE),
                new Rectangle(0,0,ARENA_WIDTH,ARENA_HEIGHT)), IWindowContainer);
            this._frame.color = 0x26374A; this._frame.procedure = this.windowProcedure; this._host.adopt(this._frame);
            // A plain container paints nothing, so the arena sat on whatever was behind it. This plate
            // makes the window opaque and gives the drag handle something to hit.
            this._plate = this._windowManager.createWindow("battleball_plate", "",
                WindowType.WINDOW_TYPE_BACKGROUND, WindowStyle.WINDOW_STYLE_DEFAULT,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TRIGGER),
                new Rectangle(0,0,ARENA_WIDTH,ARENA_HEIGHT));
            this._plate.color = 0x0026374A;
            this._frame.addChild(this._plate);
            this._wrapper = cast(this._windowManager.createWindow("battleball_canvas", "",
                WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR,
                new Rectangle(5,5,ARENA_WIDTH-10,ARENA_HEIGHT-10)), IDisplayObjectWrapper);
            this._frame.addChild(this._wrapper); this._panel = new Sprite(); this._wrapper.setDisplayObject(this._panel);
            this._panel.addEventListener(Event.ENTER_FRAME, (this._overlays.onPickupFrame : ASAny));
            this._panel.addEventListener(MouseEvent.MOUSE_MOVE, (this._overlays.onArenaMouseMove : ASAny));
            this._panel.addEventListener(MouseEvent.ROLL_OUT, (this._overlays.onArenaMouseOut : ASAny));
            // DisplayObjectWrapper does not clip oversized room canvases. Keep every renderer frame inside
            // the fixed arena aperture even if RoomEngine is recovering from an external camera change.
            this._panel.scrollRect = new Rectangle(0, 0, ARENA_WIDTH, ARENA_HEIGHT);
            this._hud.attach(this._frame, this._panel);
            this._overlays.attach(this._frame, this._panel, this._wrapper);
            this.center(); this._frame.activate();
        }
        public function show(model:BattleBallModel)
        {
            this.ensureWindow(); this.setArenaPresentation(true); this.center(); this._model = model; this.clear();
            // The arena artwork is the room object's own visualization now, drawn by the engine at the
            // room origin against the same geometry as the avatars, so nothing is blitted here.
            this.attachArena(model);
            this.drawObjects(model);
            this._hud.drawStartCountdown(model);
            this._overlays.syncPlayerBalls(model);
            this._overlays.syncPlayerNameTags(model);
            this._hud.syncArenaHud(model);
            if (!model.spectator) this._panel.addEventListener(MouseEvent.CLICK, (this.onArenaClick : ASAny));
        }
        /**
         * Per-tick refresh. Only the clock text and the score bars change between server updates -- the
         * engine animates the avatars itself and their positions come from the model -- so this updates
         * the HUD alone. Redrawing the whole arena on every tick was wasted work and tore down whatever
         * else was on screen, which is what wiped the final standings the moment a round ended.
         */
        public function tick(model:BattleBallModel)
        {
            if (model == null || this._frame == null || !this._frame.visible) return;
            this._model = model;
            this._hud.syncArenaHud(model);
            this._hud.drawStartCountdown(model);
            this._overlays.syncPlayerBalls(model);
            this._overlays.syncPlayerNameTags(model);
        }
        /**
         * Builds the arena room on first use and keeps its canvas layered directly above the board, so the
         * engine-rendered avatars sit on the Director artwork. The canvas is offset so the room's own tile
         * (0,0) lands on the origin the board is drawn from.
         */
        function attachArena(model:BattleBallModel)
        {
            if (this._arena == null) return;
            var boardOrigin= this.screenPoint(model.mapId, 0, 0, 0);
            this._arena.build(model, ARENA_WIDTH, ARENA_HEIGHT, this.heightUnitFor(model.mapId), ASCompat.toNumber(boardOrigin[0]), ASCompat.toNumber(boardOrigin[1]));
            this._arena.syncTiles(model);
            this._arena.syncPlayers(model);
            var canvas= this._arena.canvas;
            if (canvas == null) return;
            if (this._arenaLayer == null) this._arenaLayer = new Sprite();
            if (this._arenaLayer.numChildren == 0 || this._arenaLayer.getChildAt(0) != canvas)
            {
                while (this._arenaLayer.numChildren > 0) this._arenaLayer.removeChildAt(0);
                this._arenaLayer.addChild(canvas);
            }
            this._arenaLayer.x = 0;
            this._arenaLayer.y = 0;
            this._panel.addChild(this._arenaLayer);
        }
        function drawObjects(model:BattleBallModel)
        {
var object:ASObject  = null, point:Array<ASAny>  = null, powerNames:Array<ASAny>  = null, powerName:String  = null, pickup:DisplayObject  = null, power:Sprite  = null, pinAsset:DisplayObject  = null, pin:Sprite  = null;            var values:Array<ASAny> = []; final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {object = _tmp_;
values.push(object);
};
            ASCompat.ASArray.sortOn(values, ["y","x"], [ASCompat.ASArray.NUMERIC,ASCompat.ASArray.NUMERIC]);
            if (checkNullIteratee(values)) for (_tmp_ in values)
            {
object = _tmp_;
point= this.boardPoint(model, ASCompat.toInt(object.x), ASCompat.toInt(object.y), this.floorHeightAt(model, ASCompat.toInt(object.x), ASCompat.toInt(object.y)));
                if (object.type == 0)
                {
                    // Players and their native name bubbles are RoomEngine/window objects, not painted
                    // into this sprite layer.
                }
                else if (object.type == 1 && object.holderObjectId < 0)
                {
powerNames= ["lghtbulb","spring","flashlght","cannon","pinbox","harlequin","bomb","drill","qstnmark"];
powerName= object.powerType >= 1 && object.powerType <= powerNames.length
                        ? powerNames[ASCompat.toInt(ASCompat.toNumber(object.powerType) - 1)] : "qstnmark";
pickup= this._assets.display("hh_game_bb_room_s_bb2_pu_" + powerName + "_a_0_1_1_0_0");
                    if (pickup == null) pickup = this._assets.display("hh_game_bb_room_bb2_pickup_0_" + (ASCompat.toNumber(ASCompat.toNumber(object.powerType) - 1) % 8));
                    if (pickup != null) this._overlays.addPickup(pickup, powerName, point);
                    else { power= new Sprite(); power.graphics.beginFill(0xFFD34E); power.graphics.drawCircle(0,-10,7); power.x=ASCompat.toNumber(point[0]); power.y=ASCompat.toNumber(point[1]); this._panel.addChild(power); }
                }
                else if (object.type == 2)
                {
pinAsset= this._assets.display("hh_game_bb_room_s_bb2_pu_pins_a_0_1_1_0_0");
                    if (pinAsset != null) this._overlays.addPickup(pinAsset, "pins", point);
                    else { pin= new Sprite(); pin.graphics.lineStyle(2,0xD9D9D9); pin.graphics.moveTo(-3,0); pin.graphics.lineTo(3,-12);
                        pin.x=ASCompat.toNumber(point[0]); pin.y=ASCompat.toNumber(point[1]); this._panel.addChild(pin); }
                }
            }
        }
        function ensureArenaBorder()
        {
            if (this._arenaBorder != null || this._frame == null) return;
            var w= FRAME_W;
            var h= FRAME_H;
            this._arenaBorder = cast(this._windowManager.createWindow("battleball_arena_border", "",
                WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, w, h)), IDisplayObjectWrapper);
            if (this._arenaBorder == null) return;
            this._frame.addChild(this._arenaBorder);
            this._arenaBorderArt = new Sprite();
            this._arenaBorderArt.mouseEnabled = false;
            this._arenaBorderArt.mouseChildren = false;
            this._arenaBorder.setDisplayObject(this._arenaBorderArt);
            var art= this._arenaBorderArt;

            // Title bar, straight off bb_glist_window.
            this._chrome.pieceInto(art, "bb_mtl_ed", 5, 0, w - 10, 3);
            this._chrome.pieceInto(art, "bb_mtl_el", 0, 5, 3, 21);
            this._chrome.pieceInto(art, "bb_mtl_er", w - 3, 5, 3, 21);
            this._chrome.pieceInto(art, "bb_mtl_pxb", 3, 3, w - 6, 23);
            this._chrome.pieceInto(art, "bb_mtl_bt", 7, 26, w - 14, 3);
            this._chrome.pieceInto(art, "bb_mtl_cr", 1, 1, 4, 4);
            this._chrome.pieceInto(art, "bb_mtl_cr", w - 1, 1, 4, 4, true);
            this._chrome.pieceInto(art, "bb_fl", Std.int(w / 2) - 80, 7, 5, 15);
            this._chrome.pieceInto(art, "bb_fc", Std.int(w / 2) - 75, 6, 150, 17);
            this._chrome.pieceInto(art, "bb_fl", Std.int(w / 2) + 80, 7, 5, 15, true);

            // Title bar -> well join, then the well sides, which are the window's own border.
            this._chrome.pieceInto(art, "bb_clr_cr", 0, 26, WELL_SIDE, 9);
            this._chrome.pieceInto(art, "bb_clr_cr2", w - WELL_SIDE, 26, WELL_SIDE, 9);
            this._chrome.pieceInto(art, "bb_clr_tp", WELL_SIDE, 28, w - WELL_SIDE * 2, 4);
            this._chrome.pieceInto(art, "bb_clr_bt", WELL_SIDE, 32, w - WELL_SIDE * 2, 3);
            this._chrome.pieceInto(art, "bb_clr_ed", 0, FRAME_T, WELL_SIDE, ARENA_VIEW_H);
            this._chrome.pieceInto(art, "bb_clr_ed", w - WELL_SIDE, FRAME_T, WELL_SIDE, ARENA_VIEW_H);

            // Well -> footer join.
            var wellBottom= FRAME_T + ARENA_VIEW_H;
            this._chrome.pieceInto(art, "bb_clr_tp", WELL_SIDE, wellBottom, w - WELL_SIDE * 2, 4);
            this._chrome.pieceInto(art, "bb_clr_cr5", 0, wellBottom, WELL_SIDE, 4);
            this._chrome.pieceInto(art, "bb_clr_cr6", w - WELL_SIDE, wellBottom, WELL_SIDE, 4);
            this._chrome.pieceInto(art, "bb_clr_bt", 3, wellBottom + 4, w - 6, 3);
            this._chrome.pieceInto(art, "bb_clr_cr3", 0, wellBottom + 4, 3, 5);
            this._chrome.pieceInto(art, "bb_clr_cr4", w - 3, wellBottom + 4, 3, 5);

            // Metal footer the HUD sits on.
            this._chrome.pieceInto(art, "bb_mtl_ed", 3, wellBottom + 6, w - 6, 3);
            this._chrome.pieceInto(art, "bb_mtl_el", 0, FOOTER_T, 3, HUD_H);
            this._chrome.pieceInto(art, "bb_mtl_er", w - 3, FOOTER_T, 3, HUD_H);
            this._chrome.pieceInto(art, "bb_mtl_pxb", 3, FOOTER_T, w - 6, HUD_H);
            this._chrome.pieceInto(art, "bb_mtl_bt", 5, h - 3, w - 10, 3);
            this._chrome.pieceInto(art, "bb_mtl_cr2", 1, h - 5, 4, 4);
            this._chrome.pieceInto(art, "bb_mtl_cr2", w - 1, h - 5, 4, 4, true);

            this._arenaTitle = Std.downcast(this._windowManager.createWindow("battleball_arena_title", "",
                WindowType.WINDOW_TYPE_TEXT, HabboWindowStyle.NULL, WindowParam.WINDOW_PARAM_NULL,
                new Rectangle(Std.int(w / 2) - 75, 9, 150, 13)) , ITextWindow);
            this._hud.title = this._arenaTitle;
            if (this._arenaTitle != null)
            {
                this._arenaTitle.fontFace = FontEnum.isEmbeddedFont("Volter Bold") ? "Volter Bold" : "Volter";
                this._arenaTitle.fontSize = 9;
                this._arenaTitle.bold = true;
                this._arenaTitle.textColor = 0xFFD3D3D3;
                this._arenaTitle.embedFonts = true;
                this._arenaTitle.defaultTextFormat = new TextFormat(this._arenaTitle.fontFace, 9, 0xD3D3D3,
                    true, null, null, null, null, "center");
                this._frame.addChild(this._arenaTitle);
            }
        }
        /** Keeps the television treatment out of the lobby and team-selection UI. */
        function setArenaPresentation(value:Bool)
        {
            if (this._frame == null || this._wrapper == null || this._plate == null || this._backdrop == null) return;
            if (this._arenaPresentation == value) return;
            this._arenaPresentation = value;
            if (value)
            {
                this.raiseArenaWindow();
                // Chrome first: it paints the whole footer face, so anything added earlier ends up
                // underneath it. The HUD has to be a later child of the frame to sit on top.
                this.ensureArenaBorder();
                this._hud.ensureArenaHud();
                // No spectator surround and no red hotel backdrop -- both were scaffolding from an
                // earlier pass at hiding the room. The arena wears the windows' own metal frame instead.
                this._frame.width = FRAME_W;
                this._frame.height = FRAME_H;
                this._plate.width = FRAME_W;
                this._plate.height = FRAME_H;
                this._plate.color = 0xFF000000;
                this._wrapper.x = FRAME_L;
                this._wrapper.y = FRAME_T;
                this._wrapper.width = ARENA_WIDTH;
                this._wrapper.height = ARENA_VIEW_H;
                // Clip to the aperture: the wrapper does not clip an oversized room canvas by itself,
                // and the bottom strip used to be hidden behind the HUD rather than cropped.
                if (this._panel != null) this._panel.scrollRect = new Rectangle(0, 0, ARENA_WIDTH, ARENA_VIEW_H);
                // Transparent, not black. The room behind is live and the player is still standing in
                // it, so the arena is a window over it rather than a replacement for it. An opaque plate
                // here is also what made every click outside the arena do nothing.
                this._backdrop.color = 0x00000000;
                if (this._arenaBorder != null) this._arenaBorder.visible = true;
                this._hud.setVisible(true);
            }
            else
            {
                this._frame.width = ARENA_WIDTH;
                this._frame.height = ARENA_HEIGHT;
                this._plate.width = ARENA_WIDTH;
                this._plate.height = ARENA_HEIGHT;
                this._plate.color = 0x0026374A;
                this._wrapper.x = 5;
                this._wrapper.y = 5;
                this._wrapper.width = ARENA_WIDTH - 10;
                this._wrapper.height = ARENA_HEIGHT - 10;
                this._backdrop.color = 0x00000000;
                if (this._arenaBorder != null) this._arenaBorder.visible = false;
                this._hud.setVisible(false);
            }
        }
        /**
         * Lifts the arena above the room's own furniture, including its chat.
         *
         * Chat bubbles live in the room desktop's layout container (ROOM_NEW_CHAT), a sibling of this
         * window rather than a child, so nothing about drawing order is implied by the two being
         * separate. Now that the player stays in the room while playing, their room's chat would
         * otherwise float across the board.
         *
         * Done once per transition into the arena, never per redraw: re-raising continuously would keep
         * pulling this window above alerts and dialogs and leave them unreachable underneath it.
         */
        function raiseArenaWindow()
        {
            this._host.bringHostToFront();
        }
        public function resizeRoot()
        {
            this._host.resize();
            // The host sizes the root only; this window re-lays its own backdrop against the new bounds.
            if (this._backdrop != null)
            {
                this._backdrop.width = this._host.width;
                this._backdrop.height = this._host.height;
            }
        }
        // The frame is the arena itself now that the surround is gone, so centre on those bounds.
        /**
         * Centres the arena, unless the player has dragged it somewhere.
         *
         * showArena() runs on every status packet -- twice a second -- and used to re-centre each time,
         * so the window snapped back out of your hands as soon as you moved it. The frame position is
         * remembered after each centring; if it no longer matches, the drag handler moved it and the
         * player's placement wins from then on. Same approach the lobby window uses.
         */
        function center()
        {
            this.resizeRoot();
            if (this._frame == null) return;
            if (this._frameAnchorX != ASCompat.MIN_INT
                && (this._frame.x != this._frameAnchorX || this._frame.y != this._frameAnchorY))
            {
                this._frameMoved = true;
            }
            if (this._frameMoved)
            {
                this._frame.x = this.clampFrameX(this._frame.x);
                this._frame.y = this.clampFrameY(this._frame.y);
                this._frameAnchorX = this._frame.x;
                this._frameAnchorY = this._frame.y;
                return;
            }
            // Centring a window wider than the screen puts its left edge off it, and the drag clamp then
            // refuses to bring it back, so on a phone the board opened half out of view and could not be
            // recovered. Pinning to the top left when it does not fit makes it read as full screen. The
            // arena keeps its size either way; on a desktop the window always fits, so this is the same
            // arithmetic as before.
            this._frame.x = Std.int(Math.max(0, Std.int((this._host.width - this._frame.width) / 2)));
            this._frame.y = Std.int(Math.max(0, Std.int((this._host.height - this._frame.height) / 2)));
            this._frameAnchorX = this._frame.x;
            this._frameAnchorY = this._frame.y;
        }
        /**
         * Drag limits for the arena window.
         *
         * When the window fits on screen this is the original rule: never off the left or top, and always
         * at least a strip left on the right and bottom, so it cannot be lost. When it does NOT fit -- a
         * phone -- negative positions have to be allowed, otherwise the far side of the board is
         * unreachable: there the window pans instead, between fully-left and fully-right.
         */
        function clampFrameX(value:Int):Int
        {
            if (this._frame.width > this._host.width)
            {
                return Std.int(Math.max(this._host.width - this._frame.width, Math.min(value, 0)));
            }
            return Std.int(Math.max(0, Math.min(value, this._host.width - 40)));
        }
        function clampFrameY(value:Int):Int
        {
            if (this._frame.height > this._host.height)
            {
                return Std.int(Math.max(this._host.height - this._frame.height, Math.min(value, 0)));
            }
            return Std.int(Math.max(0, Math.min(value, this._host.height - LOBBY_TITLE_HEIGHT)));
        }
        function onArenaClick(event:MouseEvent)
        {
var tile:ASObject  = null, point:Array<ASAny>  = null, dx = Math.NaN, dy = Math.NaN, candidate = Math.NaN;            if (this._model == null) return;
            if (OFFSETS[this._model.mapId] == null) return;
            // Tiles sit at different floor heights, so a flat inverse projection would pick the wrong
            // cell over any ramp. Hit-test the drawn diamonds instead and keep the frontmost match.
            // localX/localY are relative to event.target, so read the panel's own mouse coordinates.
            var mouseX= this._panel.mouseX; var mouseY= this._panel.mouseY;
            var hit:ASObject = null; var depth= -ASCompat.MAX_FLOAT;
            final _iter_:ASObject = this._model.tiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tile = _tmp_;
                // Ramps score nothing but are stood on, so they must remain clickable.
                if (tile.colour < -1 && !tile.walkable) continue;
point= this.boardPoint(this._model, ASCompat.toInt(tile.x), ASCompat.toInt(tile.y), ASCompat.toInt(tile.floorHeight));
dx= ASCompat.toNumber(mouseX - ASCompat.toNumber(point[0] + TILE_CENTRE_X));
dy= ASCompat.toNumber(mouseY - ASCompat.toNumber(point[1] + TILE_CENTRE_Y));
                if (Math.abs(dx)/TILE_HALF_WIDTH + Math.abs(dy)/TILE_HALF_HEIGHT > 1) continue;
candidate= ASCompat.toNumber(tile.x + tile.y + ASCompat.toInt(tile.floorHeight) * 1000);
                if (candidate > depth) { depth = candidate; hit = tile; }
            }
            if (hit != null) this._services.emit(BattleBallViewEvent.MOVE, {x:hit.x, y:hit.y});
        }
        function screenPoint(mapId:Int, x:Int, y:Int, floorHeight:Int=0):Array<ASAny>
        {
            var offset:Array<ASAny> = OFFSETS[mapId] == null ? [360,100] : OFFSETS[mapId];
            var lift= ASCompat.toNumber(floorHeight * ASCompat.toNumber(mapId < HEIGHT_UNITS.length ? ASCompat.toNumber(HEIGHT_UNITS[mapId]) : 0));
            return [offset[0] + (x-y)*TILE_HALF_WIDTH, ASCompat.toNumber(offset[1] + (x+y)*TILE_HALF_HEIGHT) - lift];
        }
        function boardPoint(model:BattleBallModel, x:Int, y:Int, floorHeight:Int):Array<ASAny>
        {
            var projected:Point = this._arena == null ? null : this._arena.project(x, y, floorHeight);
            if (projected == null) return this.screenPoint(model.mapId, x, y, floorHeight);
            return [projected.x, projected.y];
        }
        function floorHeightAt(model:BattleBallModel, x:Int, y:Int):Int
        {
            var tile:ASObject = ASCompat.getDynamicProperty(model.tiles, Std.string(x) + ":" + Std.string(y));
            return tile == null ? 0 : ASCompat.toInt(tile.floorHeight);
        }
        /**
         * Pixels of lift per map height level, as fitted against that map's artwork.
         *
         * This value reaches the arena, where it converts the rider's ball lift and bounce from pixels
         * into room z. A flat map has no floor levels but its riders still sit on a ball and bounce, so
         * a zero here is replaced with a standard unit -- otherwise rideLift() returns 0 and the whole
         * bounce loop early-returns. The floor artwork lift at drawTiles keeps the raw table value, so
         * a flat map stays flat.
         */
        function heightUnitFor(mapId:Int):Float
        {
            var unit= mapId >= 0 && mapId < HEIGHT_UNITS.length ? ASCompat.toNumber(HEIGHT_UNITS[mapId]) : 0;
            return unit > 0 ? unit : FLAT_MAP_HEIGHT_UNIT;
        }
        function clear()
        {
            if (this._panel == null) return;
            this._panel.removeEventListener(MouseEvent.CLICK, (this.onArenaClick : ASAny));
            while (this._panel.numChildren > 0) this._panel.removeChildAt(0);
            this._panel.graphics.clear();
            // clear() emptied the panel, so the retained numeral is gone with it.
            this._hud.clearStartCountdown();
            this._overlays.clearPickups();
        }
        /** The arena frame and the sidebar are never on screen together. */
        public function hideArenaFrame()
        {
            if (this._frame != null) this._frame.visible = false;
            if (this._backdrop != null) this._backdrop.visible = false;
        }
        function windowProcedure(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowEvent.WINDOW_EVENT_CLOSE)
            {
                window.visible = false;
                this._services.emit(BattleBallViewEvent.CLOSE);
            }
        }

        public function dispose()
        {
            this._hud.clearStartCountdown();
            if (this._panel != null)
            {
                this._panel.removeEventListener(Event.ENTER_FRAME, (this._overlays.onPickupFrame : ASAny));
                this._panel.removeEventListener(MouseEvent.MOUSE_MOVE, (this._overlays.onArenaMouseMove : ASAny));
                this._panel.removeEventListener(MouseEvent.ROLL_OUT, (this._overlays.onArenaMouseOut : ASAny));
                this._panel.removeEventListener(MouseEvent.CLICK, (this.onArenaClick : ASAny));
            }
            if (this._chrome != null) { this._chrome.dispose(); this._chrome = null; }
            this._frame = null; this._panel = null; this._backdrop = null; this._arena = null;
            this._windowManager = null; this._assets = null; this._host = null; this._model = null;
        }
    }

