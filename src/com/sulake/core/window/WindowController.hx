package com.sulake.core.window;

import com.sulake.core.window.enums.WindowParam;
import com.sulake.core.window.graphics.WindowSkinRenderer;
import com.sulake.core.window.text.HabboText;
import haxe.ds.StringMap;
import com.sulake.core.window.theme.ElementDescription;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/** OpenFL implementation of the production window subset exercised by G4b. */
class WindowController extends Sprite implements IWindow {
    /**
     * IWindow.as extends IDisposable, so every window carries these two.
     *
     * The client's own dispose tears down the whole component graph a window belongs to; there is
     * no such graph here, so this releases what this class actually owns -- its children -- and
     * records that it is gone. `disposed` is the half that is read: Motion checks it before
     * animating a window that may have been torn down mid-tween.
     */
    public var disposed(get, never):Bool;

    var _disposed:Bool = false;

    inline function get_disposed():Bool return _disposed;

    public function dispose():Void {
        if (_disposed) return;
        _disposed = true;
        for (child in childWindows()) child.dispose();
        while (numChildren > 0) removeChildAt(numChildren - 1);
    }

    public var typeName(default, null):String;
    public var caption(default, null):String;
    public var style(default, null):Int;
    public var param(default, null):Int;
    public var windowId(default, null):Int;
    public var layoutWidth(default, null):Float;
    public var layoutHeight(default, null):Float;
    public var minWidth(default, null):Null<Float>;
    public var maxWidth(default, null):Null<Float>;
    public var minHeight(default, null):Null<Float>;
    public var maxHeight(default, null):Null<Float>;
    public var properties(default, null):StringMap<Dynamic>;
    public var textField(default, null):Null<TextField>;
    public var lastLink(default, null):Null<String>;
    public var scrollV(default, set):Float = 0;
    public var maxScrollV(default, null):Float = 0;
    public var contentHost(default, null):Sprite;

    /** Usable area inside the window, after margins. Zero until `configureContentHost` runs. */
    public var contentWidth(default, null):Float = 0;
    public var contentHeight(default, null):Float = 0;
    public var color(default, null):Int;
    public var background(default, null):Bool;
    public var skinState(default, null):String = "default";

    /** Tags from the layout, e.g. `_CONTENT`, `_TITLE`, `_EXCLUDE`, `_INTERNAL`. */
    public var tags(default, null):Array<String>;

    /** Child windows supplied by the theme's internal layout rather than by the app layout. */
    public var internalChildren(default, null):Array<WindowController> = [];

    /**
     * Builds a control's internal children from the theme. Installed by `WindowParser` so the
     * controller can resolve its own structure without depending on the parser.
     */
    public static var internalBuilder:Null<(String, Int) -> Array<WindowController>>;

    /**
     * Resolves a layout's `asset_uri` to pixels.
     *
     * Layout XML names its artwork rather than embedding it -- `<static_bitmap>` carries
     * `<var key="asset_uri" value="bottom_bar_home"/>` and the AS3 window manager looks that up in
     * the owning component's asset library. The parser is deliberately structural, so the lookup
     * is injected the same way `internalBuilder` is, and a window whose asset is absent simply
     * draws nothing.
     */
    public static var bitmapProvider:Null<String -> Null<openfl.display.BitmapData>>;

    final skinRenderer:Null<WindowSkinRenderer>;
    var scrollMask:Null<Shape>;
    var normalContentY:Float = 0;
    var dragTarget:Null<WindowController>;
    var dragOffset:Point;

    public function new(typeName:String, name:String, caption:String, style:Int, param:Int,
        windowId:Int, x:Float, y:Float, width:Float, height:Float, visible:Bool,
        properties:StringMap<Dynamic>, ?minWidth:Null<Float>, ?maxWidth:Null<Float>,
        ?minHeight:Null<Float>, ?maxHeight:Null<Float>, ?skinRenderer:WindowSkinRenderer,
        color:Int = 0xFFFFFF, background:Bool = false) {
        super();
        this.typeName = typeName;
        this.name = name;
        this.caption = caption;
        this.style = style;
        // `ButtonController.as:26` ORs this in for every button it constructs, regardless of
        // what the layout declared, which is what makes buttons caption-sized.
        this.param = (typeName == "button" || typeName == "button_thick")
            ? param | WindowParam.EXPAND_TO_ACCOMMODATE_CHILDREN : param;
        this.windowId = windowId;
        this.x = x;
        this.y = y;
        this.visible = visible;
        this.layoutWidth = width;
        this.layoutHeight = height;
        this.properties = properties;
        this.minWidth = minWidth;
        this.maxWidth = maxWidth;
        this.minHeight = minHeight;
        this.maxHeight = maxHeight;
        this.skinRenderer = skinRenderer;
        this.color = color;
        this.background = background;
        tags = parseTags(properties);
        contentHost = new Sprite();
        contentHost.name = "__content";
        buildInternalChildren();
        resolveIntrinsicSize();
        accommodateChildren();
        drawSkin();
        addChild(contentHost);
        configureContentHost();
        attachInternalChildren();
        drawText();
        attachParamBehaviors();
    }

    static function parseTags(properties:StringMap<Dynamic>):Array<String> {
        var raw:Dynamic = properties.get("__tags");
        if (raw == null) return [];
        var result = [];
        for (tag in Std.string(raw).split(",")) {
            var trimmed = StringTools.trim(tag);
            if (trimmed != "") result.push(trimmed);
        }
        return result;
    }

    public inline function hasTag(tag:String):Bool return tags.indexOf(tag) >= 0;

    inline function hasParam(flag:Int):Bool return (param & flag) != 0;

    /**
     * Execute the mouse-dragging relationship declared by the production window params.
     *
     * A frame is normally the `mouse_dragging_target`; its internal titlebar is the
     * `mouse_dragging_trigger`. This mirrors WindowController + WindowMouseDragger in the AS3
     * client and therefore applies to every generated window using those flags, not just login.
     */
    function attachParamBehaviors():Void {
        if (hasParam(WindowParam.MOUSE_DRAGGING_TRIGGER)) {
            addEventListener(MouseEvent.MOUSE_DOWN, beginParamDrag);
        }
        if (isButton()) {
            addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
            addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
            addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
        }
    }

    function onButtonRollOver(event:MouseEvent):Void {
        if (skinState != "pressed") setSkinState("hovering");
    }

    function onButtonRollOut(event:MouseEvent):Void {
        if (skinState != "pressed") setSkinState("default");
    }

    function onButtonMouseDown(event:MouseEvent):Void {
        setSkinState("pressed");
        if (stage != null) stage.addEventListener(MouseEvent.MOUSE_UP, onButtonStageMouseUp);
    }

    function onButtonStageMouseUp(event:MouseEvent):Void {
        if (stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonStageMouseUp);
        setSkinState(hitTestPoint(event.stageX, event.stageY, true) ? "hovering" : "default");
    }

    public function setSkinState(value:String):Void {
        if (value == skinState) return;
        skinState = value;
        redrawSkin();
        dispatchEvent(new Event("windowSkinState"));
    }

    function beginParamDrag(event:MouseEvent):Void {
        if (stage == null) return;
        var candidate:DisplayObject = this;
        dragTarget = null;
        while (candidate != null) {
            if (Std.isOfType(candidate, WindowController)) {
                var window:WindowController = cast candidate;
                if (window.hasParam(WindowParam.MOUSE_DRAGGING_TARGET)) {
                    dragTarget = window;
                    break;
                }
            }
            candidate = candidate.parent;
        }
        if (dragTarget == null || dragTarget.parent == null) return;
        var mouse = dragTarget.parent.globalToLocal(new Point(event.stageX, event.stageY));
        dragOffset = new Point(mouse.x - dragTarget.x, mouse.y - dragTarget.y);
        dragTarget.dispatchEvent(new Event("windowDragStart"));
        stage.addEventListener(MouseEvent.MOUSE_MOVE, continueParamDrag);
        stage.addEventListener(MouseEvent.MOUSE_UP, endParamDrag);
    }

    function continueParamDrag(event:MouseEvent):Void {
        if (dragTarget == null || dragOffset == null || dragTarget.parent == null) {
            endParamDrag(event);
            return;
        }
        var mouse = dragTarget.parent.globalToLocal(new Point(event.stageX, event.stageY));
        dragTarget.x = mouse.x - dragOffset.x;
        dragTarget.y = mouse.y - dragOffset.y;
        dragTarget.dispatchEvent(new Event("windowDrag"));
        event.updateAfterEvent();
    }

    function endParamDrag(event:MouseEvent):Void {
        if (stage != null) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, continueParamDrag);
            stage.removeEventListener(MouseEvent.MOUSE_UP, endParamDrag);
        }
        dragTarget = null;
        dragOffset = null;
    }

    /**
     * Ask the theme for this control's own child windows.
     *
     * This is what makes a button bold and a frame title centred without either fact appearing in
     * this file: `button_shiny_thick`'s internal layout declares a `_BTN_TEXT` label with
     * `text_style="button_shiny_bold"` and 10px side margins, and `header_3`'s declares a centred
     * `_TITLE` label. Children marked `inherit_caption` take this window's caption and render it
     * in their own style.
     */
    function buildInternalChildren():Void {
        if (internalBuilder == null) return;
        internalChildren = internalBuilder(typeName, style);
        for (child in childWindows()) {
            if (child.hasParam(WindowParam.INHERIT_CAPTION)) child.inheritCaption(caption);
        }
        // FrameController.as:48 sets the frame's help page on construction, and its setter
        // (:236) makes `header_button_help` visible only when that page is non-empty. Nothing in
        // the port assigns help pages, so the button stays hidden -- which is what the AS3 does
        // too. Without this the login dialog grew a "?" the moment the closebutton skin was
        // registered for the toolbar.
        var help = findChildByName("header_button_help");
        if (help != null) help.visible = false;
    }

    /**
     * Take a caption from the parent window and re-render.
     *
     * The chain runs deeper than one level: a frame hands its caption to the `titlebar` header,
     * which hands it to `header_container`, which hands it to the `_TITLE` label that finally
     * draws it. Every link is marked `inherit_caption` in the theme, so the propagation follows
     * the data rather than a hardcoded frame/header relationship.
     */
    function inheritCaption(value:String):Void {
        if (value == caption) return;
        caption = value;
        for (child in childWindows()) {
            if (child.hasParam(WindowParam.INHERIT_CAPTION)) child.inheritCaption(value);
        }
        resolveIntrinsicSize();
        textField = null;
        while (numChildren > 0) removeChildAt(numChildren - 1);
        drawSkin();
        addChild(contentHost);
        attachInternalChildren();
        drawText();
    }

    /**
     * Runtime equivalent of the clean client's writable `IWindow.caption` property.
     * Route updates through the same invalidation path as inherited captions so labels are
     * re-rasterised by HabboText instead of mutating an obsolete TextField fallback.
     */
    public function setCaption(value:String):Void {
        inheritCaption(value == null ? "" : value);
    }

    /**
     * Size a caption-bearing window to its own text plus its authored margins.
     *
     * The margins are a `Map` variable in the internal layout -- `left`/`top`/`right`/`bottom` --
     * and they are why the login button ends up the width it does: `_BTN_TEXT` declares 10 either
     * side, and the button then expands to fit that child.
     */
    function resolveIntrinsicSize():Void {
        if (caption == "" || !isTextual()) return;
        if (!hasParam(WindowParam.INHERIT_CAPTION)) return;
        var renderer = HabboText.instance;
        if (renderer == null) return;
        var style = captionStyle();
        layoutWidth = renderer.measureWidth(caption, style) + margin("left") + margin("right");
        layoutHeight = Math.max(layoutHeight,
            renderer.measureHeight(caption, style) + margin("top") + margin("bottom"));
    }

    function margin(edge:String):Float {
        var raw:Dynamic = properties.get("margin_" + edge);
        if (raw == null) return 0;
        var value = Std.parseFloat(Std.string(raw));
        return Math.isNaN(value) ? 0 : value;
    }

    /**
     * Grow to the bounding box of the children, then realign.
     *
     * `WindowController.as:1671` resolves EXPAND_TO_ACCOMMODATE_CHILDREN to
     * `max(child.x + child.width)`, and `setRectangle` (`:776-806`) shifts a window that resized
     * without moving according to its own align params. `ButtonController` forces the expand flag
     * on every button, which is why the authored `width="120"` never survives to the screen.
     */
    function accommodateChildren():Void {
        if (!hasParam(WindowParam.EXPAND_TO_ACCOMMODATE_CHILDREN)) return;
        if (internalChildren.length == 0) return;
        var extent = 0.0;
        var vertical = 0.0;
        for (child in internalChildren) {
            extent = Math.max(extent, child.x + child.layoutWidth);
            vertical = Math.max(vertical, child.y + child.layoutHeight);
        }
        if (minWidth != null) extent = Math.max(minWidth, extent);
        if (extent != layoutWidth) {
            switch (param & WindowParam.ON_RESIZE_ALIGN_HORIZONTAL) {
                case WindowParam.ON_RESIZE_ALIGN_CENTER: x -= (extent - layoutWidth) / 2;
                case WindowParam.ON_RESIZE_ALIGN_RIGHT: x -= extent - layoutWidth;
                default:
            }
            layoutWidth = extent;
        }
        if (minHeight != null) vertical = Math.max(minHeight, vertical);
        if (vertical > layoutHeight) layoutHeight = vertical;
    }

    /** Add internal children above the skin, then position everything by its scale params. */
    function attachInternalChildren():Void {
        for (child in internalChildren) {
            // `_CONTENT` marks where application children go. It contributes geometry only --
            // adding it to the display list would paint an empty container over the window.
            if (child.hasTag("_CONTENT")) continue;
            addChild(child);
        }
        applyScaleParams();
    }

    /**
     * Position child windows according to their relative-scale params.
     *
     * Applied to every child, not only the theme's own: the frame title is a `_TITLE` label living
     * in `header_container`'s `<children>`, so it arrives as an ordinary child even though it came
     * from an internal layout. Restricting this to internal children is what left the title
     * pinned at its authored x=4 instead of centred across the title bar.
     */
    function applyScaleParams():Void {
        for (child in childWindows()) {
            if (child.hasTag("_CONTENT")) continue;
            switch (child.param & WindowParam.RELATIVE_HORIZONTAL_SCALE_MASK) {
                case WindowParam.RELATIVE_HORIZONTAL_SCALE_CENTER:
                    child.x = Math.round((layoutWidth - child.layoutWidth) / 2);
                case WindowParam.RELATIVE_HORIZONTAL_SCALE_STRETCH:
                    child.stretchTo(layoutWidth - child.x * 2);
                default:
            }
            if ((child.param & WindowParam.RELATIVE_VERTICAL_SCALE_MASK)
                == WindowParam.RELATIVE_VERTICAL_SCALE_CENTER) {
                child.y = Math.round((layoutHeight - child.layoutHeight) / 2);
            }
        }
    }

    function stretchTo(width:Float):Void {
        if (width <= 0 || width == layoutWidth) return;
        layoutWidth = width;
        while (numChildren > 0) removeChildAt(numChildren - 1);
        drawSkin();
        addChild(contentHost);
        attachInternalChildren();
        drawText();
    }

    /**
     * Every child window, whichever side of the theme boundary it came from.
     *
     * `inherit_caption` does not care about that distinction, and neither does the AS3: the
     * header's internal layout declares `header_container` with a `<children>` block holding the
     * `_TITLE` label, so the caption has to cross from an internal child into an ordinary one to
     * reach the window that finally draws it.
     */
    /**
     * The single window a `<layout>` document wraps.
     *
     * The AS3 window manager's buildFromXML hands back the window itself; this parser keeps the
     * layout element as a root above it. Callers that reposition or resize a built layout -- the
     * toolbar's background border stretches to the desktop -- need the window, not the wrapper,
     * or they move a container whose child keeps its authored size.
     */
    public function layoutWindow():WindowController {
        if (typeName != "layout") return this;
        var children = childWindows();
        return children.length == 1 ? children[0] : this;
    }

    function childWindows():Array<WindowController> {
        var result = internalChildren.copy();
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            if (Std.isOfType(child, WindowController)) result.push(cast child);
        }
        return result;
    }

    /** True when a child inherits and renders this window's caption. */
    function delegatesCaption():Bool {
        for (child in childWindows()) {
            if (child.hasParam(WindowParam.INHERIT_CAPTION)) return true;
        }
        return false;
    }

    inline function isTextual():Bool {
        return typeName == "text" || typeName == "label" || typeName == "header"
            || typeName == "html" || typeName == "formatted_text" || isButton();
    }

    public function addWindowChild(child:WindowController):WindowController {
        contentHost.addChild(child);
        if (child.hasParam(WindowParam.INHERIT_CAPTION) && caption != "") {
            child.inheritCaption(caption);
            // The caption moved to the child; stop painting our own copy of it.
            var own = getChildByName("__caption");
            if (own != null) removeChild(own);
        }
        return child;
    }

    public function finalizeLayout():Void {
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            if (Std.isOfType(child, WindowController)) cast(child, WindowController).finalizeLayout();
        }
        // App children are added after construction, so their scale params are resolved here
        // rather than at build time.
        applyScaleParams();
        if (isScrollable()) updateScrollBounds();
    }

    /**
     * Every window beneath this one carrying `tag`, in tree order.
     *
     * BottomBarLeft sizes the bar from `groupChildrenWithTag("TOGGLE", ...)`, counting the ones
     * that are visible. The same traversal answers that question here.
     */
    public function childrenWithTag(tag:String, ?into:Array<WindowController>):Array<WindowController> {
        var found = into == null ? [] : into;
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            if (!Std.isOfType(child, WindowController)) continue;
            var window:WindowController = cast child;
            if (window.hasTag(tag)) found.push(window);
            window.childrenWithTag(tag, found);
        }
        return found;
    }

    public function findChildByName(name:String):Null<WindowController> {
        for (window in internalChildren) {
            if (window.name == name) return window;
            var nested = window.findChildByName(name);
            if (nested != null) return nested;
        }
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            if (Std.isOfType(child, WindowController)) {
                var window:WindowController = cast child;
                if (window.name == name) return window;
                var nested = window.findChildByName(name);
                if (nested != null) return nested;
            }
        }
        return null;
    }

    public inline function displayObject():DisplayObject return this;

    /**
     * A structural dump of this window and everything the theme built beneath it.
     *
     * Worth having permanently rather than as a debug aid: when a control renders wrongly the
     * first question is always whether the theme resolved the child it should have, and reading
     * that off a tree is far quicker than inferring it from a screenshot.
     */
    public function describe():Dynamic {
        var internals = [for (child in internalChildren) child.describe()];
        var appChildren = [];
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            if (Std.isOfType(child, WindowController)) {
                appChildren.push(cast(child, WindowController).describe());
            }
        }
        return {
            type: typeName, name: name, style: style, caption: caption,
            x: x, y: y, w: layoutWidth, h: layoutHeight,
            tags: tags, textStyle: properties.get("text_style"),
            inheritsCaption: hasParam(WindowParam.INHERIT_CAPTION),
            draggingTrigger: hasParam(WindowParam.MOUSE_DRAGGING_TRIGGER),
            draggingTarget: hasParam(WindowParam.MOUSE_DRAGGING_TARGET),
            skinState: skinState,
            hasCaptionBitmap: getChildByName("__caption") != null,
            internal: internals, children: appChildren
        };
    }

    public function setHtmlText(value:String):Void {
        if (textField != null) textField.htmlText = rewriteLinks(value);
    }

    inline function isButton():Bool {
        return typeName == "button" || typeName == "button_thick";
    }

    /** Built once so measuring and drawing cannot drift apart. */
    function captionFormat():TextFormat {
        var button = isButton();
        var frameTitle = typeName == "frame";
        var configuredSize:Dynamic = properties.get("font_size");
        var size = configuredSize == null ? (frameTitle ? 13 : button ? 12 : 11) : Std.int(configuredSize);
        // Buttons are black, not white. The AS3 client never guesses this: `ButtonController`
        // only overrides the label colour when a TEXT_COLOR property is present
        // (`ButtonController.as:152`), and otherwise the label keeps its registered text style.
        // Every style in `HabboWindowManagerCom_text_styles_css.bin` declares font, size and
        // kerning but **no colour**, so the value falls through to `TextStyleManager`'s default
        // of `textStyle.color = 0`. The frame title is the genuine exception and stays white.
        var color = frameTitle ? 0xFFFFFF : 0x000000;
        var configuredColor:Dynamic = properties.get("text_color");
        if (configuredColor != null) color = Std.int(configuredColor);
        return new TextFormat("_sans", size, color, button || frameTitle);
    }

    /**
     * Draw the caption with HabboText when it is available, returning true if it handled it.
     *
     * `input` and `html` deliberately stay on `TextField`: one needs a live caret and selection,
     * the other needs `htmlText` link events. Everything else is static glyphs, and rasterising
     * those through HabboText is the only way to get Ubuntu with Flash's `advanced` anti-aliasing,
     * sharpness and thickness -- which is what makes the text look like the client rather than
     * like a browser.
     */
    function drawHabboTextCaption():Bool {
        var renderer = HabboText.instance;
        if (renderer == null || caption == "") return false;
        if (typeName == "input" || typeName == "html" || typeName == "formatted_text") return false;

        var pixels = renderer.render(caption, captionStyle(), captionLayoutOptions());
        if (pixels == null) return false;

        var display = new Bitmap(pixels);
        display.name = "__caption";
        var frameTitle = typeName == "frame";
        // Position comes from the window's own authored margins. Centring, when a control wants
        // it, is expressed as a scale param on the internal child and applied in
        // `attachInternalChildren` -- not decided here per control type.
        display.x = margin("left");
        display.y = margin("top");
        addChild(display);
        return true;
    }

    /**
     * HabboText names its styles exactly as `HabboWindowManagerCom_text_styles_css.bin` does, so a
     * layout's `text_style` maps straight through with no translation table.
     */
    function captionStyle():Dynamic {
        var name:Dynamic = properties.get("text_style");
        // Defaults come from the skins' own internal layouts, not from taste. The button's
        // `_BTN_TEXT` label declares `text_style = button_shiny_bold`
        // (`habbo_window_layout_button_shiny_thick_xml.bin`) -- Ubuntu **bold** 12 -- and the
        // frame's `header_title_text` label declares `u_frame_title` with `text_color = 0xffffff`
        // (`habbo_window_layout_header_3_xml.bin`).
        // No per-control defaults here on purpose: `text_style` arrives from the theme's
        // internal layout (`button_shiny_bold`, `u_frame_title`, ...). u_regular is only the
        // fallback for a window the theme says nothing about.
        var styleName = name == null ? "u_regular" : Std.string(name);
        var color = 0x000000;
        var configuredColor:Dynamic = properties.get("text_color");
        if (configuredColor != null) color = Std.int(configuredColor);
        var configuredSize:Dynamic = properties.get("font_size");
        return HabboText.style(styleName, color,
            configuredSize == null ? null : Std.int(configuredSize));
    }

    function captionLayoutOptions():Dynamic {
        if (isButton() || typeName == "frame") return null;
        return {
            wordWrap: boolProperty("word_wrap", false),
            width: layoutWidth,
        };
    }

    /**
     * Draw the artwork a layout named, if any.
     *
     * `pivot_point="center"` is the one placement variable the toolbar layouts use: the icon is
     * centred in its declared box rather than pinned to the top-left.
     */
    function drawNamedBitmap():Bool {
        var provider = bitmapProvider;
        if (provider == null) return false;
        var uri:Dynamic = properties.get("asset_uri");
        if (uri == null || uri == "") return false;
        var pixels = provider(Std.string(uri));
        if (pixels == null) return false;
        var display = new Bitmap(pixels);
        display.name = "__asset";
        if (Std.string(properties.get("pivot_point")) == "center") {
            display.x = (layoutWidth - pixels.width) / 2;
            display.y = (layoutHeight - pixels.height) / 2;
        }
        addChild(display);
        return true;
    }

    /**
     * Replace the artwork this window draws, after the layout has already been built.
     *
     * The me-menu button's asset is the player's own head, which is not known when the layout is
     * parsed -- it needs the figure from the server and a compositor pass. Swapping the existing
     * bitmap keeps the window's position and children intact.
     */
    public function setAssetBitmap(pixels:BitmapData):Void {
        var existing = getChildByName("__asset");
        if (existing != null && Std.isOfType(existing, Bitmap)) {
            var bitmap:Bitmap = cast existing;
            bitmap.bitmapData = pixels;
        } else {
            var display = new Bitmap(pixels);
            display.name = "__asset";
            addChild(display);
            existing = display;
        }
        if (Std.string(properties.get("pivot_point")) == "center") {
            existing.x = (layoutWidth - pixels.width) / 2;
            existing.y = (layoutHeight - pixels.height) / 2;
        }
    }

    function drawSkin():Void {
        if (drawNamedBitmap()) return;
        var pixels = skinRenderer == null ? null : skinRenderer.render(typeName, style,
            Std.int(layoutWidth), Std.int(layoutHeight), skinState, color, background);
        if (pixels != null) {
            var display = new Bitmap(pixels);
            display.name = "__skin";
            addChild(display);
        } else if (!hasTag("_INTERNAL") && !themeSaysInvisible()) {
            // The placeholder skin is a development aid for app windows with no registered skin.
            // Theme scaffolding -- scalers, control containers -- must stay invisible when its
            // skin is absent rather than painting boxes over the window it belongs to.
            drawDiagnosticSkin();
        }
    }

    /** Replace only the bitmap skin so interactive state changes do not rebuild child controls. */
    /**
     * Resize a parsed window and re-render its skin at the new size.
     *
     * A layout's dimensions are authored, but a few windows are stretched to the desktop at
     * runtime -- the toolbar's background border spans the full width regardless of the 293px it
     * declares. The 9-slice skin renderer already takes a size, so this only has to update the
     * layout box and ask it again.
     */
    public function resizeTo(width:Float, height:Float):Void {
        layoutWidth = width;
        layoutHeight = height;
        redrawSkin();
    }

    /** Width of the skin bitmap actually on screen, or -1 when none was drawn. */
    public function renderedSkinWidth():Int {
        var skin = getChildByName("__skin");
        if (skin == null || !Std.isOfType(skin, Bitmap)) return -1;
        var bitmap:Bitmap = cast skin;
        return bitmap.bitmapData == null ? -1 : bitmap.bitmapData.width;
    }

    function redrawSkin():Void {
        var old = getChildByName("__skin");
        var pixels = skinRenderer == null ? null : skinRenderer.render(typeName, style,
            Std.int(layoutWidth), Std.int(layoutHeight), skinState, color, background);
        if (pixels == null) return;
        if (Std.isOfType(old, Bitmap)) {
            // Keep the display object stable. Removing/re-adding it invalidates the shared
            // HTML5 render subtree and made the rest of a composed window disappear until a
            // later full redraw. BitmapData assignment is also what the AS3 skin renderer does.
            var bitmap:Bitmap = cast old;
            var previous = bitmap.bitmapData;
            bitmap.bitmapData = pixels;
            if (previous != null) previous.dispose();
            return;
        }
        var display = new Bitmap(pixels);
        display.name = "__skin";
        addChildAt(display, 0);
    }

    /**
     * Place the container application children live in.
     *
     * Two sources, and the order matters. A window's own `margin_*` variables win, because
     * `FrameController` treats its margins *as* the content container's edges -- it assigns
     * `margins.left/top` directly and `margins.right = width - value`,
     * `margins.bottom = height - value` (`FrameController.as:74, 210-219`). The login frame
     * declares 6/25/6/7, so its content is `(6, 25)` sized `348 x 210`.
     *
     * The `_CONTENT` child in the theme's internal layout carries only **design-time placeholder**
     * geometry -- `content_area` is authored at `3,36` and `58x25` -- which the runtime overwrites.
     * Reading the placeholder instead of the margins put every child 3px left and 11px low, and
     * left the Login button crowding the bottom edge.
     */
    function configureContentHost():Void {
        var left = margin("left");
        var top = margin("top");
        var hasMargins = properties.exists("margin_left") || properties.exists("margin_top");

        if (hasMargins) {
            contentHost.x = left;
            contentHost.y = top;
            normalContentY = top;
            contentWidth = layoutWidth - left - margin("right");
            contentHeight = layoutHeight - top - margin("bottom");
        } else {
            for (child in internalChildren) {
                if (!child.hasTag("_CONTENT")) continue;
                contentHost.x = child.x;
                contentHost.y = child.y;
                normalContentY = child.y;
                contentWidth = child.layoutWidth;
                contentHeight = child.layoutHeight;
                break;
            }
        }
        if (isScrollable()) {
            scrollMask = new Shape();
            scrollMask.name = "__scroll_mask";
            scrollMask.graphics.beginFill(0xFFFFFF);
            scrollMask.graphics.drawRect(0, 0, Math.max(0, layoutWidth - 17), layoutHeight);
            scrollMask.graphics.endFill();
            addChild(scrollMask);
            contentHost.mask = scrollMask;
            addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        }
    }

    function drawText():Void {
        var textual = typeName == "text" || typeName == "label" || typeName == "input"
            || typeName == "html" || typeName == "formatted_text" || typeName == "button"
            || typeName == "button_thick" || typeName == "header";
        if (!textual && !(typeName == "frame" && caption != "")) return;
        // A control whose theme gives it a caption-bearing child must not paint the caption
        // itself, or the text renders twice -- once in this window's own style and once in the
        // child's. The child is the authority: it carries the real text style and margins.
        if (delegatesCaption()) return;
        if (drawHabboTextCaption()) return;
        var field = new TextField();
        field.name = "__caption";
        var button = isButton();
        var frameTitle = typeName == "frame";
        var format = captionFormat();
        if (button) format.align = TextFormatAlign.CENTER;
        field.defaultTextFormat = format;
        field.selectable = typeName == "input" || boolProperty("selectable", false);
        field.type = typeName == "input" ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
        field.multiline = boolProperty("multiline", false);
        field.wordWrap = boolProperty("word_wrap", false);
        field.mouseWheelEnabled = boolProperty("mouse_wheel_enabled", false);
        var maxChars:Dynamic = properties.get("max_chars");
        if (maxChars != null) field.maxChars = Std.int(maxChars);
        field.width = frameTitle ? layoutWidth - 20 : layoutWidth;
        field.height = frameTitle ? 24 : layoutHeight;
        field.x = frameTitle ? 10 : (button ? 0 : typeName == "input" ? 0 : 2);
        field.y = frameTitle ? 6 : (button ? 2 : 0);
        field.mouseEnabled = typeName == "input" || typeName == "html";
        if (typeName == "html") {
            field.htmlText = rewriteLinks(caption);
            field.addEventListener(TextEvent.LINK, onTextLink);
        } else field.text = caption;
        textField = field;
        addChild(field);
    }

    function onTextLink(event:TextEvent):Void {
        lastLink = event.text;
        dispatchEvent(new Event("windowLink"));
    }

    /**
     * Horizontal padding either side of a button caption.
     *
     * In the AS3 client this is not a constant -- it falls out of where `ButtonController` places
     * its `_BTN_TEXT` child, and the button then expands to that child's bounding box. Until the
     * caption is measured in the real face (see the HabboText work), the exact inset cannot be
     * derived from the layout alone, so it is named here to be tuned against the AIR reference
     * rather than buried in an expression.
     */


    static function rewriteLinks(value:String):String {
        var pattern = ~/href\s*=\s*(["'])(https?:\/\/[^"']+)\1/gi;
        return pattern.replace(value, 'href="event:$2"');
    }

    function updateScrollBounds():Void {
        var bottom = 0.0;
        for (index in 0...contentHost.numChildren) {
            var child = contentHost.getChildAt(index);
            bottom = Math.max(bottom, child.y + child.height);
        }
        maxScrollV = Math.max(0, bottom - layoutHeight);
        set_scrollV(scrollV);
    }

    function onMouseWheel(event:MouseEvent):Void {
        if (maxScrollV > 0) {
            scrollV -= event.delta / 10;
            dispatchEvent(new Event("windowScroll"));
        }
    }

    function set_scrollV(value:Float):Float {
        scrollV = Math.max(0, Math.min(1, value));
        if (isScrollable()) contentHost.y = normalContentY - scrollV * maxScrollV;
        return scrollV;
    }

    inline function isScrollable():Bool return typeName == "scrollable_itemlist_vertical";

    function boolProperty(key:String, fallback:Bool):Bool {
        var value:Dynamic = properties.get(key);
        return value == null ? fallback : value == true;
    }

    /**
     * Whether the theme states this window draws nothing.
     *
     * `habbo_element_description_xml` gives a container `renderer="null"`, and `find` already
     * falls back to a type's default entry, so an unlisted style answers with its type's intent.
     * `region` is not described at all, which is the same answer -- nothing to draw.
     *
     * Without asking, the development placeholder paints a bordered box over every container,
     * region and boxsizer in an application layout -- which is what the toolbar's icon slots
     * looked like: fourteen dev boxes rather than the bar's own artwork.
     */
    function themeSaysInvisible():Bool {
        var entry = ElementDescription.find(typeName, style);
        // No entry at all is the same answer as `renderer="null"`: the window manager has no skin
        // to draw for this type. Only a type the theme says *is* skinned, whose skin this build
        // has not registered, is worth flagging with the placeholder.
        return entry == null || entry.renderer == null || entry.renderer == "null";
    }

    function drawDiagnosticSkin():Void {
        if (typeName == "layout" || typeName == "text" || typeName == "label" || typeName == "html"
            || typeName == "formatted_text" || typeName == "input" || typeName == "static_bitmap") return;
        var fill = switch (typeName) {
            case "button", "button_thick": 0x3A8EDB;
            case "border": 0x26364A;
            default: 0x172132;
        };
        graphics.lineStyle(1, (typeName == "button" || typeName == "button_thick") ? 0x78BFFF : 0x60748F, 0.8);
        graphics.beginFill(fill, typeName == "border" ? 0.22 : 0.35);
        if (typeName == "button" || typeName == "button_thick") graphics.drawRoundRect(0, 0, layoutWidth, layoutHeight, 6, 6);
        else graphics.drawRect(0, 0, layoutWidth, layoutHeight);
        graphics.endFill();
    }
}
