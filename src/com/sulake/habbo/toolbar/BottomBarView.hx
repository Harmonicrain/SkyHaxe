package com.sulake.habbo.toolbar;

#if html5
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.WindowController;
import com.sulake.core.window.graphics.WindowSkinRenderer;
import com.sulake.core.window.utils.WindowParser;
import haxe.ds.StringMap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.utils.Assets;

typedef BottomBarReport = {
    var width:Int;
    var height:Int;
    var icons:Int;
    /** Asset names the layout referenced that this build does not ship. */
    var missingAssets:Array<String>;
}

/**
 * The hotel's bottom toolbar, built from the client's own layout.
 *
 * `HabboToolbar` is an `IHabboComponent` and `ToolbarView` reaches, through imports alone, 269
 * files and 21k lines -- the IID dependency-injection graph, the catalogue, the session manager
 * and localization. None of that is needed to put the bar on screen: the layout XML already
 * describes every window, and the window stack that renders the login screen renders this one
 * unchanged.
 *
 * So this is the same seam the login screen uses -- parse the authored layout, supply the
 * artwork, position the result -- and the component lifecycle stays unconverted until something
 * actually needs it.
 */
class BottomBarView {
    /** HabboToolbarCom_bottom_bar_left_xml: the authored bar is 623x46. */
    public static inline var LAYOUT = "layouts/bottom_bar_left.bin";

    /**
     * ToolbarView.as:493 -- the head goes on `icon_me_menu` and nowhere else.
     *
     * The MEMENU region stacks three windows: `bottom_bar_memenu_bg` behind, this bare `bitmap`
     * in the middle, and `bottom_bar_memenu_circle` (the ring) on top. Overriding the ring's
     * asset with the portrait -- which is what this did first -- deletes the ring and draws the
     * head at the ring's 45x45 over everything else.
     */
    static inline var ME_MENU_ICON = "icon_me_menu";

    static var icons = new StringMap<Null<BitmapData>>();
    static var missing:Array<String> = [];

    public static function build(skinRenderer:WindowSkinRenderer):{
            view:Sprite, root:WindowController, report:BottomBarReport} {
        missing = [];
        // The layout names its artwork; the window layer asks for it by name.
        WindowController.bitmapProvider = icon;

        var root = new WindowParser(skinRenderer).parseLayout(
            new XML(Assets.getText(LAYOUT)));
        var loaded = 0;
        for (name in icons.keys()) if (icons.get(name) != null) loaded++;
        return {
            view: root,
            root: root,
            report: {
                width: Std.int(root.layoutWidth),
                height: Std.int(root.layoutHeight),
                icons: loaded,
                missingAssets: missing.copy()
            }
        };
    }

    /**
     * The friend bar -- the friends list and messenger buttons that sit at the bar's right end.
     *
     * A separate component in the client (`HabboFriendBarCom_bar_xml`, 420x48) and a separate
     * layout here for the same reason: it is not part of the toolbar's own document.
     */
    public static function buildFriendBar(skinRenderer:WindowSkinRenderer):WindowController {
        return new WindowParser(skinRenderer).parseLayout(
            new XML(Assets.getText("layouts/friend_bar.bin")));
    }

    /**
     * The room chat input (`HabboRoomUICom_chatinput_window_new`, 471x100).
     *
     * It belongs to the room UI rather than the toolbar, and sits above the bar.
     */
    public static function buildChatInput(skinRenderer:WindowSkinRenderer):WindowController {
        var root = new WindowParser(skinRenderer).parseLayout(
            new XML(Assets.getText("layouts/chat_input.bin")));
        // RoomChatInputView.as:269 hides the help button on init and shows it only while the
        // pointer is over the input (:1087). It is a sibling of `chat_input_container` rather
        // than a child, so left visible it stays at its authored spot in a window that has been
        // stretched to the desktop -- a "?" floating near the top of the screen.
        var help = root.findChildByName("helpbutton");
        if (help != null) help.visible = false;
        return root;
    }

    /**
     * The bar's background border.
     *
     * BottomBackgroundBorder.as builds `bottom_background_border_xml` separately from the bar and
     * stretches it across the whole desktop: `position (-10, height - (h - 3))`, `width =
     * desktop.width + 20`. The bar's own `main_toolbar` container is `renderer="null"` in the
     * theme, so without this there is simply nothing behind the icons.
     */
    public static function buildBackground(skinRenderer:WindowSkinRenderer,
            stageWidth:Int):WindowController {
        // The border itself, not the <layout> wrapper the parser returns: resizing the wrapper
        // leaves the border at its authored 293px and the bar stops a third of the way across.
        var root = new WindowParser(skinRenderer).parseLayout(
            new XML(Assets.getText("layouts/bottom_background_border.bin"))).layoutWindow();
        root.resizeTo(stageWidth + 20, root.layoutHeight);
        return root;
    }

    /**
     * Put the player's own head in the me-menu button.
     *
     * The portrait arrives already cropped to 44x41 and circle-masked by MeMenuNewIconLoader's
     * pipeline, so it is set on the window as-is.
     */
    public static function setMeMenuHead(root:WindowController, head:BitmapData):Bool {
        var target = root.findChildByName(ME_MENU_ICON);
        if (target == null) return false;
        // BottomBarLeft._Str_17734 clones the portrait straight in; the shadow belongs to the
        // older ToolbarView path and is not part of this one.
        target.setAssetBitmap(head);
        return true;
    }


    /**
     * Resolve one `asset_uri`.
     *
     * The toolbar's icons ship in the window manager's library rather than the toolbar's own --
     * `HabboWindowManagerCom_bottom_bar_home.png`, not `HabboToolbarCom_*` -- which is the kind of
     * per-component split that returns a silent null if you assume the obvious library. A name
     * with no asset is recorded and drawn as nothing, so a missing icon costs its own square and
     * not the bar.
     */
    static function icon(name:String):Null<BitmapData> {
        if (icons.exists(name)) return icons.get(name);
        var pixels:Null<BitmapData> = null;
        var path = 'toolbar/$name.png';
        if (Assets.exists(path)) pixels = Assets.getBitmapData(path);
        if (pixels == null && missing.indexOf(name) < 0) missing.push(name);
        icons.set(name, pixels);
        return pixels;
    }
}
#end
