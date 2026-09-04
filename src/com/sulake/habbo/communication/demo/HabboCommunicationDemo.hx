package com.sulake.habbo.communication.demo;

#if html5
import com.sulake.core.localization.Localization;
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.WindowController;
import com.sulake.core.window.graphics.WindowSkinRenderer;
import com.sulake.core.window.text.TruffleText;
import com.sulake.core.window.theme.ElementDescription;
import com.sulake.core.window.theme.InternalLayouts;
import com.sulake.core.window.utils.WindowParser;
import com.sulake.habbo.communication.connection.Html5HabboConnection;
import com.sulake.habbo.communication.connection.Html5HabboConnection.HabboMessageField;
import com.sulake.habbo.communication.GeneratedHabboMessageRegistry;
import com.sulake.habbo.communication.HabboMessageDispatcher;
import com.sulake.habbo.communication.messages.parser.navigator.NavigatorSettingsMessageParser;
import com.sulake.habbo.communication.SkyConnection;
import com.sulake.habbo.room.RoomEngine;
import com.sulake.habbo.room.events.RoomEngineEvent;
import com.sulake.habbo.communication.messages.parser.handshake.UserObjectMessageParser;
import com.sulake.habbo.configuration.ExternalVariables;
import com.sulake.habbo.avatar.AvatarRoomRenderer;
import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationLoader;
import com.sulake.habbo.toolbar.BottomBarView;
import com.sulake.habbo.room.RoomEngineRuntime;
import com.sulake.habbo.room.ConvertedRoomInput;
import js.Browser;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
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

    var loginRoot:WindowController;
    var skinRenderer:Null<WindowSkinRenderer>;
    var bottomBar:Null<openfl.display.Sprite>;
    var bottomBarRoot:Null<WindowController>;
    var bottomBarBackground:Null<WindowController>;
    var friendBar:Null<WindowController>;
    var chatInput:Null<WindowController>;
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
    var input:WindowController;
    var status:WindowController;
    var loginButton:WindowController;
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
        TruffleText.load("/assets/truffle",
            ["u_regular", "u_bold", "u_small", "u_frame_title", "button_shiny_bold"],
            loadVariables,
            function(error) fail("Text renderer failed to load: " + Std.string(error)));
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
    }

    function loadVariables():Void {
        ExternalVariables.load(VARIABLES_URL, function(loaded) {
            variables = loaded;
            Browser.document.documentElement.setAttribute("data-skyhaxe-variables", VARIABLES_URL);
            var loadTextsAndLogin = function() {
                // Every window caption is a ${key} against this table, so it has to be in place
                // before any layout is parsed. A missing table leaves the tokens visible rather
                // than blanking the UI, so a failure here is reported and the client still starts.
                var textsUrl = PublicRoomVisualizationLoader.assetUrl(
                    loaded.get("external.texts.txt"));
                Localization.load(textsUrl, function() {
                    Browser.console.info('SKYHAXE_TEXTS keys=${Localization.size}');
                    buildLogin();
                }, function(error) {
                    Browser.console.error("SKYHAXE_TEXTS_FAILED: " + Std.string(error));
                    buildLogin();
                });
            };
            // RoomMessageHandler must register before authentication can deliver one-shot room
            // entry packets, so engine initialization is part of boot rather than a probe.
            startRoomEngine(loaded, loadTextsAndLogin);
        }, function(error) fail('Could not load $VARIABLES_URL: $error'));
    }

    function buildLogin():Void {
        ElementDescription.load(new XML(Assets.getText("theme/element_description.xml")));
        for (name in ["button_shiny_thick", "frame_3", "header_3", "button_shiny", "frame",
                "header", "button_thick", "button"]) {
            InternalLayouts.register("habbo_window_layout_" + name + "_xml",
                new XML(Assets.getText("theme/habbo_window_layout_" + name + "_xml")));
        }

        // Kept on the instance: the toolbar is built from the same registered skins.
        skinRenderer = new WindowSkinRenderer();
        var renderer = skinRenderer;
        var blue = Assets.getBitmapData("skins/habbo_blue.png");
        var ubuntu = Assets.getBitmapData("skins/habbo_ubuntu.png");
        renderer.register("frame", 3, "frame_3", Assets.getText("skins/frame_3.xml"), ubuntu);
        renderer.register("border", 4, "border_4", Assets.getText("skins/border_4.xml"), blue);
        renderer.register("button_thick", 3, "button_shiny_thick",
            Assets.getText("skins/button_shiny_thick.xml"), blue);
        renderer.register("border", 2, "border_colorless",
            Assets.getText("skins/border_colorless.xml"), blue);
        renderer.register("button", 3, "button_shiny", Assets.getText("skins/button_shiny.xml"), blue);
        // The toolbar's background border. habbo_skin_border_9_xml names its own atlas
        // (`skin_ubuntu_bg_9`) rather than sharing the blue or ubuntu sheet.
        renderer.register("border", 9, "border_9", Assets.getText("skins/border_9.xml"),
            Assets.getBitmapData("skins/ubuntu_bg_9.png"));
        // The friend bar and the chat input, resolved from habbo_element_description_xml:
        // border 6 and 8 and the help button all draw from the ubuntu sheet; icons have their own.
        var icons = Assets.getBitmapData("skins/habbo_icons.png");
        renderer.register("border", 6, "border_6", Assets.getText("skins/border_6.xml"), ubuntu);
        renderer.register("border", 8, "border_8", Assets.getText("skins/border_8.xml"), ubuntu);
        renderer.register("closebutton", 4, "button_help_3",
            Assets.getText("skins/button_help_3.xml"), ubuntu);
        renderer.register("container_button", 3, "button_shiny_thick",
            Assets.getText("skins/button_shiny_thick.xml"), blue);
        for (style in [2, 3, 4, 5, 7])
            renderer.register("icon", style, "icon_set", Assets.getText("skins/icon_set.xml"),
                icons);

        loginRoot = new WindowParser(renderer).parseLayout(
            new XML(Assets.getText("layouts/login_window.bin")));
        input = require("name_field");
        status = require("status_text");
        loginButton = require("login_btn");
        loginBackground = new LoginBackgroundView(
            Assets.getBitmapData("login/HabboAir_LoginBackground.png"),
            Assets.getBitmapData("login/HabboAir_LoginForeground.png"));
        addChildAt(loginBackground, 0);
        resizeLoginBackground();
        addChild(loginRoot);
        centerLogin();

        var ticket = fragmentValue("sso", "");
        if (ticket != "") input.textField.text = ticket;
        input.textField.addEventListener(KeyboardEvent.KEY_UP, function(event:KeyboardEvent) {
            if (event.keyCode == Keyboard.ENTER) submit();
        });
        loginButton.buttonMode = true;
        loginButton.mouseChildren = false;
        loginButton.addEventListener("windowSkinState", function(_) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-login-button-state",
                loginButton.skinState);
        });
        loginButton.addEventListener(MouseEvent.CLICK, function(_) submit());
        var loginFrame = require("habbo_login_dialog");
        loginFrame.addEventListener("windowDragStart", function(_) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-login-drag", "started");
        });
        loginFrame.addEventListener("windowDrag", function(_) {
            Browser.document.documentElement.setAttribute("data-skyhaxe-login-drag",
                '${Math.round(loginFrame.x)},${Math.round(loginFrame.y)}');
        });
        // The AIR view leaves status_text empty until an attempt starts or fails.
        setStatus("");
        input.textField.stage.focus = input.textField;
        input.textField.setSelection(input.textField.text.length, input.textField.text.length);
        Browser.document.documentElement.setAttribute("data-skyhaxe-client", "login-ready");
        Browser.console.info("SKYHAXE_LOGIN_READY");
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
        connection.connect(input.textField.text);
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
            // OpenFlatConnectionMessageComposer(roomId, password="", worldId=-1).
            connection.sendMessage(2312, [Int32(roomIdToEnter), String16(""), Int32(-1)]);
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
                Browser.console.info("SKYHAXE_ROOM_ENGINE_PROBE_READY");
                engine.events.addEventListener(RoomEngineEvent.INITIALIZED, function(event) {
                    var initialized:RoomEngineEvent = cast event;
                    onConvertedRoomInitialized(initialized.roomId);
                });
                Browser.document.documentElement.setAttribute(
                    "data-skyhaxe-room-engine-mode", "generated");
                if (whenReady != null) whenReady();
            }, function(error) {
                Browser.document.documentElement.setAttribute(
                    "data-skyhaxe-converted-room-engine", "error:" + Std.string(error));
                Browser.console.error("SKYHAXE_ROOM_ENGINE_FAILED " + Std.string(error));
            }, engineConnection);
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
                var placed = BottomBarView.setMeMenuHead(root, head);
                Browser.console.info('SKYHAXE_TOOLBAR_HEAD placed=$placed '
                    + '${head.width}x${head.height}');
            }, function(error) {
                Browser.console.warn("SKYHAXE_TOOLBAR_HEAD_FAILED: " + Std.string(error));
            });
    }

    function setBusy(value:Bool):Void {
        loginButton.mouseEnabled = !value;
        loginButton.alpha = value ? 0.55 : 1;
        input.textField.type = value ? TextFieldType.DYNAMIC : TextFieldType.INPUT;
    }

    function setStatus(message:String):Void {
        if (status != null) status.setCaption(message);
    }

    function centerLogin():Void {
        if (loginRoot == null || stage == null) return;
        loginRoot.x = Math.round((stage.stageWidth - loginRoot.layoutWidth) / 2);
        loginRoot.y = Math.round((stage.stageHeight - loginRoot.layoutHeight) / 2);
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
            bottomBarBackground.resizeTo(stage.stageWidth + 20,
                bottomBarBackground.layoutHeight);
            bottomBarBackground.x = -10;
            bottomBarBackground.y = stage.stageHeight - (bottomBarBackground.layoutHeight - 3);
        }
        // BottomBarLeft.as:193 -- bottom-aligned, and sized to the icons it is showing rather
        // than to the width its layout happens to declare.
        var barAreaWidth = 0.0;
        if (bottomBarRoot != null && bottomBar != null) {
            var toggles = bottomBarRoot.childrenWithTag("TOGGLE");
            var shown = 1;
            for (window in toggles) if (window.visible) shown++;
            bottomBarRoot.resizeTo(BAR_ICON_WIDTH * shown + BAR_PADDING + BAR_TAIL,
                bottomBarRoot.layoutHeight);
            bottomBar.x = 0;
            bottomBar.y = stage.stageHeight - bottomBarRoot.layoutHeight;
            // BottomBarLeft.as:853 -- the toolbar "area" ends at the divider, not at the window
            // edge, and that is what the chat row is kept clear of.
            var divider = bottomBarRoot.findChildByName("line");
            barAreaWidth = divider == null ? bottomBarRoot.layoutWidth : divider.x + bottomBar.x;
        }
        // HabboFriendBarView.as:498 and :1097 -- right-aligned, one pixel off the bottom.
        var friendBarWidth = 0.0;
        if (friendBar != null) {
            friendBarWidth = friendBar.layoutWidth;
            friendBar.x = stage.stageWidth - friendBarWidth;
            friendBar.y = stage.stageHeight
                - (friendBar.layoutHeight + FRIEND_BAR_BOTTOM_OFFSET);
        }
        positionChatRow(barAreaWidth, friendBarWidth);
        Browser.document.documentElement.setAttribute("data-skyhaxe-bar-layout",
            haxe.Json.stringify({
                stage: stage.stageWidth,
                background: bottomBarBackground == null ? -1
                    : Std.int(bottomBarBackground.layoutWidth),
                backgroundX: bottomBarBackground == null ? -1
                    : Std.int(bottomBarBackground.x),
                backgroundSkin: bottomBarBackground == null ? -1
                    : bottomBarBackground.renderedSkinWidth(),
                barSkin: bottomBarRoot == null ? -1 : bottomBarRoot.renderedSkinWidth(),
                bar: bottomBarRoot == null ? -1 : Std.int(bottomBarRoot.layoutWidth),
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
        chatInput.resizeTo(stage.stageWidth, stage.stageHeight);
        chatInput.x = 0;
        chatInput.y = 0;
        var row = chatInput.findChildByName("bubblecont");
        if (row == null) return;
        var centred = stage.stageWidth / 2 - row.layoutWidth / 2;
        var leftLimit = 0.0;
        if (stage.stageWidth - barAreaWidth - friendBarWidth > row.layoutWidth + CHAT_GAP) {
            leftLimit = barAreaWidth + CHAT_GAP;
            row.y = stage.stageHeight - CHAT_ROW_BOTTOM;
            if (centred + row.layoutWidth > stage.stageWidth - friendBarWidth) centred = 0;
        } else {
            leftLimit = CHAT_GAP;
            row.y = stage.stageHeight - CHAT_ROW_BOTTOM_CRAMPED;
        }
        row.x = Math.max(centred, leftLimit);
    }

    function showBottomBar():Void {
        if (bottomBar != null || skinRenderer == null) return;
        try {
            // Behind the bar, and full width: BottomBackgroundBorder is a separate layout.
            bottomBarBackground = BottomBarView.buildBackground(skinRenderer,
                stage == null ? 1024 : stage.stageWidth);
            addChild(bottomBarBackground);
            var built = BottomBarView.build(skinRenderer);
            bottomBar = built.view;
            bottomBarRoot = built.root;
            addChild(built.view);
            friendBar = BottomBarView.buildFriendBar(skinRenderer);
            addChild(friendBar);
            chatInput = BottomBarView.buildChatInput(skinRenderer);
            addChild(chatInput);
            positionBottomBar();
            applyMeMenuHead();
            Browser.document.documentElement.setAttribute("data-skyhaxe-toolbar",
                haxe.Json.stringify(built.report));
            Browser.console.info('SKYHAXE_TOOLBAR ${built.report.width}x${built.report.height} '
                + 'icons=${built.report.icons} missing=${built.report.missingAssets.join(",")}');
        } catch (error:Dynamic) {
            var message = Std.string(error);
            Browser.document.documentElement.setAttribute("data-skyhaxe-toolbar-error", message);
            Browser.console.error("SKYHAXE_TOOLBAR_FAILED: " + message);
        }
    }

    function require(name:String):WindowController {
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
