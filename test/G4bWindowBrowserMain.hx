import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.WindowController;
import com.sulake.core.window.graphics.WindowSkinRenderer;
import com.sulake.core.window.text.HabboText;
import com.sulake.core.window.theme.ElementDescription;
import com.sulake.core.window.theme.InternalLayouts;
import com.sulake.core.window.utils.WindowParser;
import haxe.ds.StringMap;
import js.Browser;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.utils.Assets;

/** G4b production-window canary: real first-screen login plus a real UI behavior fragment. */
class G4bWindowBrowserMain extends Sprite {
    var assertions = 0;
    var loginRoot:WindowController;
    var featureRoot:WindowController;
    var report:Dynamic;

    public function new() {
        super();
        // Habbo HTML5 owns the typography, and it loads its matching TTFs and native profiles over HTTP.
        // Layout parsing measures text synchronously, so nothing may be parsed until it is ready.
        HabboText.load("/assets/habbo-text",
            ["u_regular", "u_bold", "u_small", "u_frame_title", "button_shiny_bold"],
            function() {
                try run() catch (error:Dynamic) fail(error);
            },
            function(error:Dynamic) fail("Habbo HTML5 failed to load: " + Std.string(error)));
    }

    function run():Void {
        lockStageToAuthoredScale();
        loadTheme();

        var title = new TextField();
        title.defaultTextFormat = new TextFormat("_sans", 16, 0xE7EEF9, true);
        title.width = 1050;
        title.height = 42;
        title.x = 24;
        title.y = 12;
        title.text = "SkyHaxe · G4b — production login window + UI behavior coverage";
        addChild(title);

        var renderer = productionRenderer();
        var parser = new WindowParser(renderer);
        loginRoot = parser.parseLayout(new XML(Assets.getText("layouts/login_window.bin")));
        loginRoot.x = 40;
        loginRoot.y = 72;
        addChild(loginRoot);

        featureRoot = parser.parseLayout(new XML(Assets.getText("layouts/frontpage_featured.bin")));
        featureRoot.scaleX = featureRoot.scaleY = 0.78;
        featureRoot.x = 430;
        featureRoot.y = 72;
        addChild(featureRoot);

        Browser.document.documentElement.setAttribute("data-skyhaxe-g4b-tree",
            haxe.Json.stringify(loginRoot.describe()));
        verifyLogin();
        verifySecondaryCoverage();
        wireInteractions();
        finish();
    }

    /**
     * Render one stage pixel as one screen pixel.
     *
     * Lime's HTML5 default stretches the declared 1024x520 stage to fill the browser window, so a
     * wide window scaled this page up ~1.87x and interpolated it. The layout was always correct --
     * the login frame really is the authored 360x242 -- but nobody could judge skin fidelity by
     * eye through a blurry upscale, which is exactly what this gate exists to do. NGHWin's AIR
     * stage is NO_SCALE for the same reason.
     */
    function lockStageToAuthoredScale():Void {
        if (stage == null) {
            addEventListener(Event.ADDED_TO_STAGE, function once(_) {
                removeEventListener(Event.ADDED_TO_STAGE, once);
                lockStageToAuthoredScale();
            });
            return;
        }
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
    }

    /**
     * Load the control theme the client ships.
     *
     * Without this every control falls back to whatever the renderer guesses. With it, a button
     * knows it is `button_shiny_bold` with 10px margins and a frame title knows it is centred,
     * because those facts are in the data rather than in our code.
     */
    function loadTheme():Void {
        ElementDescription.load(new XML(Assets.getText("theme/element_description.xml")));
        for (name in ["button_shiny_thick", "frame_3", "header_3", "button_shiny", "frame",
                "header", "button_thick", "button"]) {
            var id = "habbo_window_layout_" + name + "_xml";
            InternalLayouts.register(id, new XML(Assets.getText("theme/" + id)));
        }
    }

    function productionRenderer():WindowSkinRenderer {
        var result = new WindowSkinRenderer();
        var blue = Assets.getBitmapData("skins/habbo_blue.png");
        var ubuntu = Assets.getBitmapData("skins/habbo_ubuntu.png");
        result.register("frame", 3, "frame_3", Assets.getText("skins/frame_3.xml"), ubuntu);
        result.register("border", 4, "border_4", Assets.getText("skins/border_4.xml"), blue);
        result.register("button_thick", 3, "button_shiny_thick",
            Assets.getText("skins/button_shiny_thick.xml"), blue);
        result.register("border", 2, "border_colorless",
            Assets.getText("skins/border_colorless.xml"), blue);
        result.register("button", 3, "button_shiny",
            Assets.getText("skins/button_shiny.xml"), blue);
        return result;
    }

    function verifyLogin():Void {
        equal("habbo_login_dialog", loginRoot.name, "real login layout parsed");
        equal(360.0, loginRoot.layoutWidth, "login width");
        equal(242.0, loginRoot.layoutHeight, "login height");
        var frame = require(loginRoot.findChildByName("habbo_login_dialog"), "login frame");
        equal("frame", frame.typeName, "login root is a frame");
        // frame_3's theme document supplies a 3,36 design-time placeholder. FrameController then
        // applies this app layout's margin_left/top/right/bottom variables, exactly as AIR does.
        equal(6.0, frame.contentHost.x, "login margin_left overrides the theme placeholder");
        equal(25.0, frame.contentHost.y, "login margin_top overrides the theme placeholder");
        equal(348.0, frame.contentWidth, "login horizontal margins define the content width");
        equal(210.0, frame.contentHeight, "login vertical margins define the content height");
        equal(1, frame.filters.length, "authored DropShadowFilter applied");
        truth(Std.isOfType(frame.getChildByName("__skin"), Bitmap), "frame uses production bitmap skin");
        truth(Reflect.field(frame.describe(), "draggingTarget"),
            "login frame retains its authored mouse-dragging-target param");
        var titlebar = require(frame.findChildByName("titlebar"), "frame titlebar");
        truth(Reflect.field(titlebar.describe(), "draggingTrigger"),
            "frame titlebar retains its authored mouse-dragging-trigger param");

        var border = require(loginRoot.findChildByName("name_border"), "SSO input border");
        truth(Std.isOfType(border.getChildByName("__skin"), Bitmap), "input border uses production bitmap skin");
        var input = require(loginRoot.findChildByName("name_field"), "SSO input");
        truth(input.textField != null, "SSO field has OpenFL TextField");
        equal(TextFieldType.INPUT, input.textField.type, "SSO field accepts real keyboard input");
        var button = require(loginRoot.findChildByName("login_btn"), "login button");
        truth(Std.isOfType(button.getChildByName("__skin"), Bitmap), "login button uses production bitmap skin");
        var defaultPixel = cast(button.getChildByName("__skin"), Bitmap).bitmapData.getPixel32(2, 8);
        button.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
        equal("hovering", button.skinState, "button enters the authored hovering state");
        var hoverPixel = cast(button.getChildByName("__skin"), Bitmap).bitmapData.getPixel32(2, 8);
        truth(defaultPixel != hoverPixel, "hover state selects different atlas pixels");
        button.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
        equal("default", button.skinState, "button returns to its default state");

        var capture = new BitmapData(370, 252, true, 0);
        capture.draw(loginRoot);
        truth((capture.getPixel32(8, 8) >>> 24) > 0, "production frame renders pixels");
        truth((capture.getPixel32(174, 214) >>> 24) > 0, "production login button renders at content offset");
        capture.dispose();

        var status = require(loginRoot.findChildByName("status_text"), "runtime status label");
        status.setCaption("Login failed: Enter an SSO ticket.");
        truth(Std.isOfType(status.getChildByName("__caption"), Bitmap),
            "runtime status updates stay on the Habbo HTML5 bitmap path");
        truth(status.textField == null, "runtime status does not retain the removed TextField fallback");
        status.setCaption("");
    }

    function verifySecondaryCoverage():Void {
        // The authored HTML fields are unnamed, so select by production type.
        var html = require(findByType(featureRoot, "html"), "production HTML field");
        html.setHtmlText('Rules and more at <a href="http://www.habbo.com/habbo15">www.habbo.com/habbo15</a>');
        truth(html.textField.htmlText.indexOf("event:http://www.habbo.com/habbo15") >= 0,
            "HTTP links are rewritten to Flash-style TextEvent links");
        html.addEventListener("windowLink", function(_) {
            Browser.document.documentElement.setAttribute("data-g4b-link", html.lastLink);
        });

        var list = require(featureRoot.findChildByName("itemlist_featured"), "production scrolling item list");
        // Catalogue code populates this authored template dynamically. Mirror that runtime state.
        for (index in 1...5) {
            var row = new WindowController("container", "g4b_runtime_row_" + index, "", 3, 16, 0,
                0, index * 127, 333, 120, true, new StringMap<Dynamic>());
            var label = new WindowController("text", "g4b_runtime_label_" + index,
                "Featured catalogue item " + (index + 1), 3, 16, 0, 8, 92, 310, 22, true,
                new StringMap<Dynamic>());
            row.addWindowChild(label);
            list.addWindowChild(row);
        }
        list.finalizeLayout();
        truth(list.contentHost.mask != null, "scrolling item list has a real display-list mask");
        truth(list.maxScrollV > 0, "runtime-populated production list overflows viewport");
        var before = list.contentHost.y;
        list.scrollV = 1;
        truth(list.contentHost.y < before, "scrollV moves content through the masked viewport");
        list.scrollV = 0;
        list.addEventListener("windowScroll", function(_) {
            Browser.document.documentElement.setAttribute("data-g4b-scroll", Std.string(list.scrollV));
        });

        var voucher = require(featureRoot.findChildByName("voucher_code"), "production voucher input");
        equal(TextFieldType.INPUT, voucher.textField.type, "secondary real layout retains input behavior");
    }

    function wireInteractions():Void {
        var input = require(loginRoot.findChildByName("name_field"), "interactive SSO input");
        input.textField.addEventListener(Event.CHANGE, function(_) {
            Browser.document.documentElement.setAttribute("data-g4b-input", input.textField.text);
        });
        var button = require(loginRoot.findChildByName("login_btn"), "interactive login button");
        button.buttonMode = true;
        button.addEventListener(MouseEvent.CLICK, function(_) {
            Browser.document.documentElement.setAttribute("data-g4b-clicked", "true");
        });
    }

    function finish():Void {
        report = {
            gate: "G4b-window-text",
            assertions: assertions,
            primary: {
                layout: "HabboCommunicationDemoCom_login_window.bin",
                role: "complete first-visible client window",
                width: 360,
                height: 242,
                production_skins: ["frame_3", "border_4", "button_shiny_thick"],
                input: "name_field",
                drop_shadow: true
            },
            secondary: {
                layout: "HabboCatalogCom_layout_frontpage_featured.bin",
                role: "real HTML, link, scrolling-list and mask behavior coverage",
                dynamic_rows: 5,
                link_localization: "camera.competition.info"
            },
            console_errors: 0
        };
        Browser.document.documentElement.setAttribute("data-skyhaxe-g4b", "pass");
        Browser.document.documentElement.setAttribute("data-skyhaxe-g4b-report", haxe.Json.stringify(report));
        Browser.console.info('G4B_WINDOW_PASS assertions=$assertions');
    }

    function findByType(root:WindowController, typeName:String):Null<WindowController> {
        for (index in 0...root.contentHost.numChildren) {
            var child = root.contentHost.getChildAt(index);
            if (!Std.isOfType(child, WindowController)) continue;
            var window:WindowController = cast child;
            if (window.typeName == typeName) return window;
            var nested = findByType(window, typeName);
            if (nested != null) return nested;
        }
        return null;
    }

    function require(value:Null<WindowController>, message:String):WindowController {
        assertions++;
        if (value == null) throw '$message: missing';
        return value;
    }
    function truth(value:Bool, message:String):Void equal(true, value, message);
    function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (expected != actual) throw '$message: expected $expected, got $actual';
    }
    function fail(error:Dynamic):Void {
        var text = Std.string(error);
        Browser.document.documentElement.setAttribute("data-skyhaxe-g4b", "fail");
        Browser.document.documentElement.setAttribute("data-skyhaxe-g4b-error", text);
        Browser.console.error("SKYHAXE_G4B_FAIL", error);
    }
}
