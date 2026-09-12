package com.sulake.habbo.communication.demo;

#if html5
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.IWindow;
import com.sulake.core.window.IWindowContainer;
import com.sulake.core.window.components.IBitmapWrapperWindow;
import com.sulake.core.window.components.ITextFieldWindow;
import com.sulake.core.window.events.WindowKeyboardEvent;
import com.sulake.core.window.events.WindowMouseEvent;
import com.sulake.core.window.utils.TextStyleManager;
import com.sulake.core.window.text.TruffleText;
import com.sulake.habbo.localization.HabboLocalizationManager;
import com.sulake.habbo.localization._enum.HabboLocalizationFlags;
import com.sulake.habbo.window.HabboWindowManagerComponent;
import com.sulake.iid.IIDHabboConfigurationManager;
import com.sulake.iid.IIDHabboLocalizationManager;
import com.sulake.iid.IIDHabboWindowManager;
import com.sulake.habbo.communication.connection.Html5HabboConnection;
import com.sulake.habbo.communication.connection.Html5HabboConnection.HabboMessageField;
import com.sulake.habbo.communication.GeneratedHabboMessageRegistry;
import com.sulake.habbo.communication.HabboMessageDispatcher;
import com.sulake.habbo.communication.messages.parser.navigator.NavigatorSettingsMessageParser;
import com.sulake.habbo.communication.SkyConnection;
import com.sulake.habbo.room.RoomEngine;
import com.sulake.habbo.room.events.RoomEngineEvent;
import com.sulake.habbo.room.events.RoomEngineObjectEvent;
import com.sulake.habbo.communication.messages.parser.handshake.UserObjectMessageParser;
import com.sulake.habbo.configuration.ExternalVariables;
import com.sulake.habbo.configuration.ExternalConfigurationManager;
import com.sulake.habbo.avatar.AvatarRoomRenderer;
import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationLoader;
import com.sulake.habbo.room.RoomEngineRuntime;
import com.sulake.habbo.room.RoomEngineContext;
import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
import com.sulake.habbo.room.ConvertedRoomInput;
import js.Browser;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import skyhaxe.PerformanceHud;
import skyhaxe.PerformanceHud.HudRow;
import openfl.events.MouseEvent;
import openfl.text.TextFieldType;
import openfl.ui.Keyboard;
import openfl.utils.Assets;

/**
 * Runnable vertical port of the clean client's first communication screen.
 *
 * It uses the original login XML and theme data. The JS WebSocket object stays behind
 * Html5HabboConnection so this class can converge on generated client APIs without spreading
 * browser-specific code through the client.
 */
class HabboCommunicationDemo extends Sprite {
    static inline var VARIABLES_URL:String = "/ngh/gamedata/external_dev_vars.txt";

    var componentContext:Null<RoomEngineContext>;
    var configuration:Null<ExternalConfigurationManager>;
    var localization:Null<HabboLocalizationManager>;
    var windowManager:Null<HabboWindowManagerComponent>;
    var loginRoot:IWindowContainer;
    var bottomBarRoot:Null<IWindowContainer>;
    var bottomBarBackground:Null<IWindow>;
    var friendBar:Null<IWindowContainer>;
    var chatInput:Null<IWindowContainer>;
    /** RoomChatInputView.as:50 -- the gap kept between the chat row and what flanks it. */
    static inline var CHAT_GAP = 12;
    /** RoomChatInputView.as:621 and :630 -- the row's two authored heights above the desktop. */
    static inline var CHAT_ROW_BOTTOM = 104;
    static inline var CHAT_ROW_BOTTOM_CRAMPED = 160;
    /** BottomBarLeft.as:53-55 -- per-icon width, padding, and the fixed right-hand allowance. */
    static inline var BAR_ICON_WIDTH = 45;
    static inline var BAR_PADDING = 10;
    static inline var BAR_TAIL = 150;
    /** HabboFriendBarView.as:97 */
    static inline var FRIEND_BAR_BOTTOM_OFFSET = 1;
    // The logged-in player's own figure, which the me-menu button draws as a head.
    var ownFigure:String = "";
    var ownGender:String = "M";
    var input:ITextFieldWindow;
    var status:IWindow;
    var loginButton:IWindow;
    var loginBackground:LoginBackgroundView;
    var connection:Null<Html5HabboConnection>;
    var variables:Null<ExternalVariables>;
    var receivedPackets:Array<Dynamic> = [];
    final dispatcher:HabboMessageDispatcher;
    var homeRoomId:Int = 0;
    var roomIdToEnter:Int = 0;
    var activeRoomId:Int = 0;
    var roomRequested:Bool = false;
    var roomViewportWidth:Int = 0;
    var roomViewportHeight:Int = 0;
    /** The generated room engine driven by the live connection. */
    var roomEngine:Null<RoomEngine>;
    var liveRoomUI:Null<com.sulake.habbo.ui.InfostandRoomUI>;
    /** The display object the converted engine draws the room into. */
    var convertedCanvas:Null<openfl.display.DisplayObject>;
    /** RoomEngine keys canvases per room; the client only ever asks for one. */
    static inline var CONVERTED_CANVAS_ID = 1;
    final convertedInput:ConvertedRoomInput;

    public function new() {
        super();
        convertedInput = new ConvertedRoomInput(function() return roomEngine,
            function() return convertedCanvas, function() return activeRoomId,
            CONVERTED_CANVAS_ID);
        dispatcher = new HabboMessageDispatcher();
        // Hotel UI is not converted yet. These two packets feed the temporary home-room launch
        // and the generated me-menu portrait; all room packets belong to RoomMessageHandler.
        dispatcher.register(2875, onNavigatorSettings);
        dispatcher.observe(2725, onUserObject);
        if (stage != null) configureStage();
        else addEventListener(Event.ADDED_TO_STAGE, function once(_) {
            removeEventListener(Event.ADDED_TO_STAGE, once);
            configureStage();
        });
        Browser.document.documentElement.setAttribute("data-skyhaxe-client", "loading");
        skyhaxe.BootMetrics.mark("client-start");
        var fontsReady = false;
        var configReady:ExternalVariables = null;
        var bootFailed = false;
        function joinBootstrap():Void {
            if (!bootFailed && fontsReady && configReady != null) loadVariables(configReady);
        }
        ExternalVariables.load(VARIABLES_URL, function(loaded) {
            configReady = loaded;
            skyhaxe.BootMetrics.mark("variables-ready");
            joinBootstrap();
        }, function(error) { bootFailed = true; fail('Could not load $VARIABLES_URL: $error'); });
        TruffleText.load("/assets/truffle",
            ["u_regular", "u_bold", "u_small", "u_frame_title", "button_shiny_bold"],
            function() {
                fontsReady = true;
                skyhaxe.BootMetrics.mark("fonts-ready");
                joinBootstrap();
            },
            function(error) { bootFailed = true; fail("Text renderer failed to load: " + Std.string(error)); });
    }

    function configureStage():Void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.addEventListener(Event.RESIZE, function(_) {
            centerLogin();
            resizeRoomCanvas();
            centerRoom();
            positionBottomBar();
            resizeLoginBackground();
        });
        // RoomDesktop.mouseEventHandler (:1760) forwards these five straight into RoomEngine.
        for (type in [MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP,
                MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK])
            stage.addEventListener(type, convertedInput.forward);
        stage.doubleClickEnabled = true;
        #if debug
        // Development builds only -- `scripts/build-html5.ps1 -Final` compiles without `debug`,
        // so a release never carries the read-out. F2 hides it when it is in the way.
        PerformanceHud.show(roomHudRows);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent) {
            if (event.keyCode == 113) PerformanceHud.toggle();
        });
        #end
    }

    /**
     * The room's own numbers, for the development read-out.
     *
     * Read through a callback so `PerformanceHud` imports nothing from the port and keeps
     * reporting while the engine is still starting, absent, or disposed.
     */
    function roomHudRows():Array<HudRow> {
        // Reported then reset, so the number is the worst tick since the last HUD paint rather
        // than an all-time high that never decays.
        var worstTick = RoomEngineRuntime.worstTickMs;
        RoomEngineRuntime.clearWorstTickMs();
        var rows:Array<HudRow> = [
            {label: "tick", value: Std.string(RoomEngineRuntime.ticks)},
            {label: "tickMs", value: Std.string(Math.round(worstTick * 10) / 10),
                warn: worstTick > 25}
        ];
        var engine = RoomEngineRuntime.engine;
        if (engine == null || activeRoomId == 0) {
            rows.push({label: "room", value: "-"});
            return rows;
        }
        var room = engine.getRoom(activeRoomId);
        if (room == null) {
            rows.push({label: "room", value: Std.string(activeRoomId) + " (no instance)", warn: true});
            return rows;
        }
        rows.push({label: "room", value: Std.string(activeRoomId)});
        for (entry in [
            {name: "furni", category: RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE},
            {name: "wall", category: RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM},
            {name: "users", category: RoomObjectCategoryEnum.OBJECT_CATEGORY_USER}
        ]) {
            var objects = room.getObjects(entry.category);
            rows.push({label: entry.name, value: Std.string(objects == null ? 0 : objects.length)});
        }
        return rows;
    }

    function loadVariables(loaded:ExternalVariables):Void {
            variables = loaded;
            Browser.document.documentElement.setAttribute("data-skyhaxe-variables", VARIABLES_URL);
            initializeWindowServices(loaded, function() {
                // RoomMessageHandler must register before authentication can deliver one-shot
                // room entry packets, so engine initialization is part of boot rather than a
                // probe. It shares this component context with the original window and
                // localization services.
                startRoomEngine(loaded, buildLogin);
            });
    }

    /** Build the original component services once, before any authored window is parsed. */
    function initializeWindowServices(loaded:ExternalVariables, onReady:Void->Void):Void {
        try {
            var context = new RoomEngineContext(this);
            componentContext = context;
            var configurationService = new ExternalConfigurationManager(context, loaded);
            context.configuration = configurationService;
            configuration = configurationService;
            context.provide(new IIDHabboConfigurationManager(), configurationService);

            var localizationService = new HabboLocalizationManager(context,
                HabboLocalizationFlags._Str_16746);
            localization = localizationService;
            context.provide(new IIDHabboLocalizationManager(), localizationService);

            var records:Dynamic = haxe.Json.parse(Assets.getText("window-service/assets.json"));
            var library = new AssetLibrary("habbo-window-manager");
            library.loadFromManifest(new XML(Assets.getText("window-service/manifest.bin")),
                function(name) {
                    var record:Dynamic = Reflect.field(records, name);
                    if (record == null) return null;
                    return record.image ? cast Assets.getBitmapData(record.id)
                        : cast Assets.getText(record.id);
                });
            var styles = library.getAssetByName("text_styles_css");
            if (styles != null)
                TextStyleManager.setStyles(TextStyleManager.parseCSS(cast styles.content));
            var manager = new HabboWindowManagerComponent(context, 0, library);
            windowManager = manager;
            context.provide(new IIDHabboWindowManager(), manager);
            skyhaxe.BootMetrics.mark("windows-ready");

            // The browser fetch is the platform boundary; every parsed key is registered on the
            // original localization manager, which remains the sole runtime localization owner.
            var textsUrl = PublicRoomVisualizationLoader.assetUrl(
                loaded.get("external.texts.txt"));
            Browser.window.fetch(textsUrl).then(function(response) {
                if (!response.ok) throw 'HTTP ${response.status} for $textsUrl';
                return response.text();
            }).then(function(body) {
                var count = 0;
                for (line in body.split("\n")) {
                    var text = StringTools.rtrim(line);
                    if (text == "" || StringTools.startsWith(text, "#")) continue;
                    var split = text.indexOf("=");
                    if (split <= 0) continue;
                    localizationService.updateLocalization(text.substr(0, split),
                        text.substr(split + 1));
                    count++;
                }
                Browser.console.info('SKYHAXE_TEXTS keys=$count');
                skyhaxe.BootMetrics.mark("localization-ready");
                onReady();
                return null;
            }).catchError(function(error) {
                Browser.console.error("SKYHAXE_TEXTS_FAILED: " + Std.string(error));
                onReady();
            });
        } catch (error:Dynamic) {
            fail("Window services failed to initialize: " + Std.string(error));
        }
    }

    function buildLogin():Void {
        if (windowManager == null) throw "Window manager is not initialized";
        loginRoot = cast windowManager.buildFromXML(
            new XML(Assets.getText("layouts/login_window.bin")));
        input = cast require("name_field");
        status = require("status_text");
        loginButton = require("login_btn");
        loginBackground = new LoginBackgroundView(
            Assets.getBitmapData("login/HabboAir_LoginBackground.png"),
            Assets.getBitmapData("login/HabboAir_LoginForeground.png"));
        addChildAt(loginBackground, 0);
        resizeLoginBackground();
        centerLogin();

        var ticket = fragmentValue("sso", "");
        if (ticket != "") input.text = ticket;
        input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP,
            function(event:WindowKeyboardEvent) {
            if (event.keyCode == Keyboard.ENTER) submit();
        });
        loginButton.addEventListener(WindowMouseEvent.CLICK, function(_) submit());
        // The AIR view leaves status_text empty until an attempt starts or fails.
        setStatus("");
        input.activate();
        input.setSelection(input.text.length, input.text.length);
        Browser.document.documentElement.setAttribute("data-skyhaxe-client", "login-ready");
        Browser.console.info("SKYHAXE_LOGIN_READY");
        skyhaxe.BootMetrics.mark("login-ready");
        if (ticket != "") submit();
    }

    function submit():Void {
        if (connection != null) return;
        setBusy(true);
        setStatus("Connecting...");
        Browser.document.documentElement.setAttribute("data-skyhaxe-client", "connecting");
        connection = new Html5HabboConnection(queryValue("ws", defaultEndpoint()), {
            onStatus: function(message) Browser.console.info("SkyHaxe connection: " + message),
            onPacket: function(header, packet) {
                receivedPackets.push({id: header, name: GeneratedHabboMessageRegistry.incomingName(header)});
                Browser.document.documentElement.setAttribute("data-skyhaxe-packets",
                    haxe.Json.stringify(receivedPackets));
                dispatcher.dispatch(header, packet);
            },
            onAuthenticated: function(username) {
                // HabboCommunicationDemo.onAuthenticationOK closes and disposes the login view.
                loginRoot.visible = false;
                loginBackground.visible = false;
                Browser.document.documentElement.setAttribute("data-skyhaxe-client", "authenticated");
                Browser.document.documentElement.setAttribute("data-skyhaxe-user", username);
                Browser.console.info('SKYHAXE_AUTHENTICATED user=$username');
                skyhaxe.BootMetrics.mark("authenticated");
            },
            onClosed: function(code, clean) {
                if (Browser.document.documentElement.getAttribute("data-skyhaxe-client")
                        == "authenticated") setStatus('Disconnected (code $code).');
                connection = null;
                setBusy(false);
            },
            onError: function(message) {
                setStatus("Login failed: " + message);
                Browser.document.documentElement.setAttribute("data-skyhaxe-client", "login-error");
                connection = null;
                setBusy(false);
                Browser.console.error("SKYHAXE_LOGIN_FAILED: " + message);
            }
        });
        connection.connect(input.text);
    }

    function onNavigatorSettings(wrapper:com.sulake.core.communication.messages.IMessageDataWrapper):Void {
        var parser = new NavigatorSettingsMessageParser();
        if (!parser.parse(wrapper)) return;
        homeRoomId = parser.homeRoomId;
        roomIdToEnter = parser._Str_17213;
        // `#room=<id>` overrides the navigator's home room. The navigator is not ported yet, so
        // without this the only reachable room is whichever one the account happens to start in,
        // and a guest room cannot be opened deliberately at all.
        var requested = Std.parseInt(fragmentValue("room", ""));
        if (requested != null && requested > 0) roomIdToEnter = requested;
        Browser.document.documentElement.setAttribute("data-skyhaxe-home-room", Std.string(homeRoomId));
        Browser.document.documentElement.setAttribute("data-skyhaxe-room-to-enter", Std.string(roomIdToEnter));
        Browser.console.info('SKYHAXE_NAVIGATOR_SETTINGS home=$homeRoomId enter=$roomIdToEnter');
        if (!roomRequested && roomIdToEnter > 0 && connection != null) {
            roomRequested = true;
            // Original session creation emits CREATED; RoomUI constructs the desktop, which
            // starts the session through the original composer and registers its room handlers.
            RoomEngineRuntime.roomSessions.gotoRoom(roomIdToEnter);
            Browser.document.documentElement.setAttribute("data-skyhaxe-room-requested",
                Std.string(roomIdToEnter));
            Browser.console.info('SKYHAXE_ROOM_REQUESTED room=$roomIdToEnter');
        }
    }

    /** Bring up the generated RoomEngine before the connection starts delivering room packets. */
    function startRoomEngine(loaded:ExternalVariables, ?whenReady:Void->Void):Void {
        var engineConnection = new SkyConnection(dispatcher, function() return connection);
        RoomEngineRuntime.ensure(this, loaded.get("flash.dynamic.download.url"),
            loaded.get("flash.client.url"), loaded.get("furnidata.load.url"), function(engine) {
                Browser.document.documentElement.setAttribute(
                    "data-skyhaxe-converted-room-engine", "ready");
                roomEngine = engine;
                var records:Dynamic = haxe.Json.parse(Assets.getText("room-ui/assets.json"));
                var uiAssets = new AssetLibrary("room-ui");
                uiAssets.loadFromManifest(new XML(Assets.getText("room-ui/manifest.bin")), function(name) {
                    var record:Dynamic = Reflect.field(records, name);
                    return record == null ? null : (record.image ? cast Assets.getBitmapData(record.id)
                        : cast Assets.getText(record.id));
                });
                liveRoomUI = new com.sulake.habbo.ui.InfostandRoomUI(componentContext, uiAssets);
                Browser.document.documentElement.setAttribute("data-skyhaxe-infostand", "services-created");
                skyhaxe.BootMetrics.mark("engine-ready");
                Browser.console.info("SKYHAXE_ROOM_ENGINE_PROBE_READY");
                engine.events.addEventListener(RoomEngineEvent.INITIALIZED, function(event) {
                    var initialized:RoomEngineEvent = cast event;
                    onConvertedRoomInitialized(initialized.roomId);
                });
                #if debug
                engine.events.addEventListener(RoomEngineObjectEvent.DESELECTED, function(event) {
                    Browser.console.warn("SKYHAXE_ROOM_DESELECT " + js.Syntax.code("new Error().stack"));
                });
                #end
                Browser.document.documentElement.setAttribute(
                    "data-skyhaxe-room-engine-mode", "generated");
                if (whenReady != null) whenReady();
            }, function(error) {
                Browser.document.documentElement.setAttribute(
                    "data-skyhaxe-converted-room-engine", "error:" + Std.string(error));
                Browser.console.error("SKYHAXE_ROOM_ENGINE_FAILED " + Std.string(error));
            }, engineConnection, componentContext);
    }

    /**
     * A room exists in the converted engine. Give it a canvas and show it.
     *
     * `createRoomCanvas` builds the client's own `RoomSpriteCanvas`, attaches it to the room's
     * renderer and returns the display object to mount. Everything the room contains -- the shell
     * planes, the furniture, the avatars, the tile cursor -- is drawn by that canvas from the
     * room's objects, in one depth order. That is why this replaces the pooled canvas outright
     * rather than sitting beside it: two canvases cannot interleave.
     */
    function onConvertedRoomInitialized(roomId:Int):Void {
        if (roomEngine == null) return;
        activeRoomId = roomId;
        if (liveRoomUI != null) {
            // RoomUI's earlier listener owns the original desktop/canvas and widget creation.
            Browser.document.documentElement.setAttribute("data-skyhaxe-converted-room-canvas", Std.string(roomId));
            Browser.document.documentElement.setAttribute("data-skyhaxe-infostand", "desktop-created");
            return;
        }
        skyhaxe.BootMetrics.mark("room-created");
        // In AIR Room UI owns this hand-off. SkyHaxe currently hosts the engine directly, so it
        // must select the newly-created room before the update clock and camera can target it.
        roomEngine.setActiveRoom(roomId);
        // A room can initialize before the stage has been measured -- a public room reaches this
        // sooner than a guest room, having no furniture to load, and gets there first. The canvas
        // is built once at this size and `stageWidth` is 0 at that moment, so the room was created
        // 0x0 and drew nothing at all. Fall back on a real size rather than trusting a zero.
        roomViewportWidth = stage == null || stage.stageWidth <= 0 ? 1024 : Std.int(stage.stageWidth);
        roomViewportHeight = stage == null || stage.stageHeight <= 0 ? 768 : Std.int(stage.stageHeight);
        var display = roomEngine.createRoomCanvas(roomId, CONVERTED_CANVAS_ID,
            roomViewportWidth, roomViewportHeight, 64);
        if (display == null) {
            Browser.console.error('SKYHAXE_ROOM_CANVAS_FAILED room=$roomId');
            return;
        }
        if (convertedCanvas != null && convertedCanvas.parent == this) removeChild(convertedCanvas);
        convertedCanvas = display;
        addChildAt(display, 0);
        Browser.document.documentElement.setAttribute("data-skyhaxe-converted-room-canvas",
            Std.string(roomId));
        Browser.console.info('SKYHAXE_CONVERTED_ROOM room=$roomId '
            + '${roomViewportWidth}x$roomViewportHeight');
        // The toolbar belongs to the hotel rather than to any one room, so it is built once and
        // left in place across later room changes.
        showBottomBar();
    }


    /** UserObject (HabboMessages.as:1363) carries the logged-in player's own figure. */
    function onUserObject(
            wrapper:com.sulake.core.communication.messages.IMessageDataWrapper):Void {
        var parser = new UserObjectMessageParser();
        if (!parser.parse(wrapper)) return;
        ownFigure = parser.figure;
        ownGender = parser.sex;
        Browser.console.info('SKYHAXE_OWN_USER ${parser.name} gender=$ownGender');
        applyMeMenuHead();
    }

    /**
     * Draw the player's head in the me-menu button.
     *
     * The figure and the bar arrive independently, so whichever lands second does the work.
     */
    function applyMeMenuHead():Void {
        if (bottomBarRoot == null || ownFigure == "" || variables == null) return;
        var root = bottomBarRoot;
        AvatarRoomRenderer.composeHead(ownFigure, ownGender,
            variables.get("flash.client.url"), function(head) {
                if (bottomBarRoot != root) return;
                var target = root.findChildByName("icon_me_menu");
                var placed = target != null && Std.isOfType(target, IBitmapWrapperWindow);
                if (placed) cast(target, IBitmapWrapperWindow).bitmap = head.clone();
                Browser.console.info('SKYHAXE_TOOLBAR_HEAD placed=$placed '
                    + '${head.width}x${head.height}');
            }, function(error) {
                Browser.console.warn("SKYHAXE_TOOLBAR_HEAD_FAILED: " + Std.string(error));
            });
    }

    function setBusy(value:Bool):Void {
        if (value) loginButton.disable(); else loginButton.enable();
        loginButton.alpha = value ? 140 : 255;
        input.editable = !value;
    }

    function setStatus(message:String):Void {
        if (status != null) status.caption = message;
    }

    function centerLogin():Void {
        if (loginRoot == null || stage == null) return;
        loginRoot.x = Math.round((stage.stageWidth - loginRoot.width) / 2);
        loginRoot.y = Math.round((stage.stageHeight - loginRoot.height) / 2);
    }

    function resizeLoginBackground():Void {
        if (loginBackground == null || stage == null) return;
        loginBackground.resizeTo(stage.stageWidth, stage.stageHeight);
        Browser.document.documentElement.setAttribute("data-skyhaxe-login-background",
            haxe.Json.stringify(loginBackground.describe()));
    }

    /**
     * Follow the window with the room canvas.
     *
     * RoomDesktop.onRoomViewResized (:1776) calls `modifyRoomCanvas` whenever the room view
     * changes size. Without it the canvas keeps whatever size it was built with, so a room that
     * initialized before the stage was measured stays that size for the rest of the session.
     */
    function resizeRoomCanvas():Void {
        if (roomEngine == null || stage == null || activeRoomId == 0) return;
        if (stage.stageWidth <= 0 || stage.stageHeight <= 0) return;
        roomViewportWidth = Std.int(stage.stageWidth);
        roomViewportHeight = Std.int(stage.stageHeight);
        roomEngine.modifyRoomCanvas(activeRoomId, CONVERTED_CANVAS_ID, roomViewportWidth,
            roomViewportHeight);
    }

    function centerRoom():Void {
        if (convertedCanvas == null || stage == null) return;
        convertedCanvas.x = Math.round((stage.stageWidth - roomViewportWidth) / 2);
        convertedCanvas.y = Math.round((stage.stageHeight - roomViewportHeight) / 2);
    }

    /** The bar sits against the bottom edge, left-aligned, as the authored layout expects. */
    function positionBottomBar():Void {
        if (stage == null) return;
        if (bottomBarBackground != null) {
            // BottomBackgroundBorder.updatePosition: offset -10, three pixels of overhang.
            bottomBarBackground.width = stage.stageWidth + 20;
            bottomBarBackground.x = -10;
            bottomBarBackground.y = stage.stageHeight - (bottomBarBackground.height - 3);
        }
        // BottomBarLeft.as:193 -- bottom-aligned, and sized to the icons it is showing rather
        // than to the width its layout happens to declare.
        var barAreaWidth = 0.0;
        if (bottomBarRoot != null) {
            var toggles:Array<ASAny> = [];
            bottomBarRoot.groupChildrenWithTag("TOGGLE", toggles, 10);
            var shown = 1;
            for (window in toggles) if (window.visible) shown++;
            bottomBarRoot.width = BAR_ICON_WIDTH * shown + BAR_PADDING + BAR_TAIL;
            bottomBarRoot.x = 0;
            bottomBarRoot.y = stage.stageHeight - bottomBarRoot.height;
            // BottomBarLeft.as:853 -- the toolbar "area" ends at the divider, not at the window
            // edge, and that is what the chat row is kept clear of.
            var divider = bottomBarRoot.findChildByName("line");
            barAreaWidth = divider == null ? bottomBarRoot.width : divider.x + bottomBarRoot.x;
        }
        // HabboFriendBarView.as:498 and :1097 -- right-aligned, one pixel off the bottom.
        var friendBarWidth = 0.0;
        if (friendBar != null) {
            friendBarWidth = friendBar.width;
            friendBar.x = Std.int(stage.stageWidth - friendBarWidth);
            friendBar.y = stage.stageHeight
                - (friendBar.height + FRIEND_BAR_BOTTOM_OFFSET);
        }
        positionChatRow(barAreaWidth, friendBarWidth);
        Browser.document.documentElement.setAttribute("data-skyhaxe-bar-layout",
            haxe.Json.stringify({
                stage: stage.stageWidth,
                background: bottomBarBackground == null ? -1
                    : Std.int(bottomBarBackground.width),
                backgroundX: bottomBarBackground == null ? -1
                    : Std.int(bottomBarBackground.x),
                bar: bottomBarRoot == null ? -1 : Std.int(bottomBarRoot.width),
                barArea: Std.int(barAreaWidth),
                friendBar: Std.int(friendBarWidth),
                friendBarX: friendBar == null ? -1 : Std.int(friendBar.x)
            }));
    }

    /**
     * RoomChatInputView.updatePosition, as written.
     *
     * The window covers the whole desktop; what moves is `bubblecont` -- RoomChatInputView.as:231
     * resolves its `_chatInputContainerWindow` to that, not to `chat_input_container`. That
     * matters: `bubblecont` is the full 471x100 and holds `chat_input_container` 60px down, so
     * `desktop.height - 104` leaves the visible field at `height - 44` -- inside the toolbar row.
     * Moving the inner container instead put the field 60px higher, clear of the bar.
     *
     * The row is centred unless that would run into the friend bar, and is kept clear of the
     * toolbar on the left; when the space between them cannot hold it, it moves to the second
     * authored height rather than being squeezed.
     */
    function positionChatRow(barAreaWidth:Float, friendBarWidth:Float):Void {
        if (chatInput == null || stage == null) return;
        chatInput.width = stage.stageWidth;
        chatInput.height = stage.stageHeight;
        chatInput.x = 0;
        chatInput.y = 0;
        var row = chatInput.findChildByName("bubblecont");
        if (row == null) return;
        var centred = stage.stageWidth / 2 - row.width / 2;
        var leftLimit = 0.0;
        if (stage.stageWidth - barAreaWidth - friendBarWidth > row.width + CHAT_GAP) {
            leftLimit = barAreaWidth + CHAT_GAP;
            row.y = stage.stageHeight - CHAT_ROW_BOTTOM;
            if (centred + row.width > stage.stageWidth - friendBarWidth) centred = 0;
        } else {
            leftLimit = CHAT_GAP;
            row.y = stage.stageHeight - CHAT_ROW_BOTTOM_CRAMPED;
        }
        row.x = Std.int(Math.max(centred, leftLimit));
    }

    function showBottomBar():Void {
        // Temporarily opt-in: construction currently throws after attaching an orphan border.
        // Keep the original layouts available, but do not expose the unfinished toolbar live.
        #if skyhaxe_toolbar_candidate
        if (bottomBarRoot != null || windowManager == null) return;
        try {
            bottomBarBackground = windowManager.buildFromXML(
                new XML(Assets.getText("layouts/bottom_background_border.bin")));
            var backgroundContainer:IWindowContainer = cast bottomBarBackground;
            if (backgroundContainer.numChildren == 1)
                bottomBarBackground = backgroundContainer.getChildAt(0);
            bottomBarRoot = cast windowManager.buildFromXML(
                new XML(Assets.getText("layouts/bottom_bar_left.bin")));
            friendBar = cast windowManager.buildFromXML(
                new XML(Assets.getText("layouts/friend_bar.bin")));
            chatInput = cast windowManager.buildFromXML(
                new XML(Assets.getText("layouts/chat_input.bin")));
            var help = chatInput.findChildByName("helpbutton");
            if (help != null) help.visible = false;
            positionBottomBar();
            applyMeMenuHead();
            Browser.document.documentElement.setAttribute("data-skyhaxe-toolbar",
                haxe.Json.stringify({width: bottomBarRoot.width, height: bottomBarRoot.height,
                    runtime: "original"}));
            Browser.console.info('SKYHAXE_TOOLBAR ${bottomBarRoot.width}x${bottomBarRoot.height} '
                + 'runtime=original');
        } catch (error:Dynamic) {
            var message = Std.string(error);
            Browser.document.documentElement.setAttribute("data-skyhaxe-toolbar-error", message);
            Browser.console.error("SKYHAXE_TOOLBAR_FAILED: " + message);
        }
        #end
    }

    function require(name:String):IWindow {
        var value = loginRoot.findChildByName(name);
        if (value == null) throw 'Login layout is missing $name';
        return value;
    }

    function fail(message:String):Void {
        Browser.document.documentElement.setAttribute("data-skyhaxe-client", "boot-error");
        Browser.document.documentElement.setAttribute("data-skyhaxe-error", message);
        Browser.console.error("SKYHAXE_BOOT_FAILED: " + message);
    }

    static function fragmentValue(name:String, fallback:String):String {
        var fragment = Browser.window.location.hash;
        if (fragment.length > 1) {
            for (part in fragment.substr(1).split("&")) {
                var pair = part.split("=");
                if (pair[0] == name && pair.length > 1)
                    return StringTools.urlDecode(pair.slice(1).join("="));
            }
        }
        return fallback;
    }

    static function queryValue(name:String, fallback:String):String {
        var query = Browser.window.location.search;
        if (query.length > 1) {
            for (part in query.substr(1).split("&")) {
                var pair = part.split("=");
                if (pair[0] == name && pair.length > 1)
                    return StringTools.urlDecode(pair.slice(1).join("="));
            }
        }
        return fallback;
    }

    static function defaultEndpoint():String {
        var scheme = Browser.window.location.protocol == "https:" ? "wss" : "ws";
        return '$scheme://${Browser.window.location.hostname}:2096/';
    }
}
#end
