package com.sulake.habbo.snowstorm
;
    import com.sulake.core.utils.FontEnum;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.PivotPoint;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;

    /** Native WindowManager surface backed only by the converted r26 SnowStorm UI library. */
     final class SnowStormWindowSurface
    {
        static inline final PREFIX= "hh_game_snowwar_ui_";
        var _windowManager:IHabboWindowManager;
        var _assets:SnowStormAssets;
        var _target:IWindowContainer;
        var _buttonSkins:ASObject = {};
        var _serial:UInt = 0;

        public function new(windowManager:IHabboWindowManager, assets:SnowStormAssets)
        { this._windowManager = windowManager; this._assets = assets; }
        public function bind(target:IWindowContainer)
        { this._target = target; this._buttonSkins = {}; this._serial = 0; }

        public function assignBitmap(window:IBitmapWrapperWindow, member:String, flipH:Bool=false)
        {
            if (member == null || member == "") return;
            // Director member names may contain several dots (for example
            // sw_arrowbutton.left.active). String.replace only changes the first occurrence when
            // passed a String, so normalize every separator to match the generated SWF symbols.
            this.assignBitmapAsset(window, PREFIX + member.split(".").join("_"), flipH);
        }

        /** Assigns an exact symbol from any one of the four owned SnowStorm casts. */
        function assignBitmapAsset(window:IBitmapWrapperWindow, assetName:String,
                                           flipH:Bool=false)
        {
            if (window == null || this._assets == null || assetName == null || assetName == "") return;
            var data= this._assets.bitmapData(assetName.split(".").join("_"));
            if (data == null) return;
            var width= window.width; var height= window.height;
            var container= ASCompat.reinterpretAs(window , IBitmapDataContainer);
            if (container != null)
            {
                container.stretchedX = true; container.stretchedY = true;
                container.pivotPoint = PivotPoint.TOP_LEFT;
                container.zoomX = flipH ? -1 : 1; container.zoomY = 1;
            }
            window.disposesBitmap = false; window.bitmap = data;
            window.width = width; window.height = height; window.color = 0xFFFFFF; window.invalidate();
        }

        /** Uses the shared r26 radio ring and reproduces its original selected centre exactly. */
        public function assignRadio(window:IBitmapWrapperWindow, selected:Bool)
        {
            if (window == null || this._assets == null) return;
            var data= this._assets.cloneBitmapData(PREFIX + "button_radio_off");
            if (data == null) return;
            if (selected)
            {
                data.fillRect(new Rectangle(4, 3, 4, 1), 0xFF000000);
                data.fillRect(new Rectangle(3, 4, 6, 4), 0xFF000000);
                data.fillRect(new Rectangle(4, 8, 4, 1), 0xFF000000);
            }
            this.assignOwnedBitmap(window, data);
        }

        /** Small native drop-menu indicator used by the recovered creation form. */
        public function dropArrowInto(target:IWindowContainer, x:Int, y:Int):IBitmapWrapperWindow
        {
var row = 0;            var arrow= new BitmapData(7, 4, true, 0);
            for (_tmp_ in 0...4)
{row= _tmp_;
                arrow.fillRect(new Rectangle(row, row, 7 - row * 2, 1), 0xFF1E2A2B);
};
            var window= this.pieceInto(target, "", x, y, 7, 4);
            if (window == null) { arrow.dispose(); return null; }
            this.assignOwnedBitmap(window, arrow);
            return window;
        }

        public function formatText(field:ITextWindow, value:String, colour:UInt, bold:Bool,
                                   align:String="left", underline:Bool=false)
        {
            if (field == null) return;
            var face= bold ? "Volter Bold" : "Volter";
            if (!FontEnum.isEmbeddedFont(face) && FontEnum.isEmbeddedFont("Volter")) face = "Volter";
            field.fontFace = face; field.fontSize = 9; field.textColor = colour;
            field.bold = bold; field.underline = underline; field.embedFonts = FontEnum.isEmbeddedFont(face);
            field.defaultTextFormat = new TextFormat(face, 9, ASCompat.toInt(colour), bold, null, underline,
                null, null, align);
            field.text = value == null ? "" : value;
        }

        public function pieceInto(target:IWindowContainer, member:String, x:Int, y:Int,
                                  width:Int, height:Int, flipH:Bool=false):IBitmapWrapperWindow
        {
            if (target == null || this._windowManager == null || width <= 0 || height <= 0) return null;
            var window= Std.downcast(this._windowManager.createWindow(this.name("piece"), "",
                WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, width, height)) , IBitmapWrapperWindow);
            if (window == null) return null;
            target.addChild(window); this.assignBitmap(window, member, flipH); return window;
        }

        public function textInto(target:IWindowContainer, value:String, x:Int, y:Int, width:Int,
                                 height:Int, colour:UInt=0, bold:Bool=false,
                                 align:String="left", underline:Bool=false):ITextWindow
        {
            if (target == null || this._windowManager == null) return null;
            var field= Std.downcast(this._windowManager.createWindow(this.name("text"), value,
                WindowType.WINDOW_TYPE_FORMATTED_TEXT, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, width, height)) , ITextWindow);
            if (field == null) return null;
            target.addChild(field); this.formatText(field, value, colour, bold, align, underline); return field;
        }

        public function hotspotInto(target:IWindowContainer, x:Int, y:Int, width:Int, height:Int):IWindow
        {
            if (target == null || this._windowManager == null) return null;
            var region= this._windowManager.createWindow(this.name("hotspot"), "",
                WindowType.WINDOW_TYPE_REGION, HabboWindowStyle.NULL,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )|
                ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT),
                new Rectangle(x, y, width, height));
            if (region != null) { region.mouseThreshold = 0; target.addChild(region); }
            return region;
        }

        public function buttonInto(target:IWindowContainer, caption:String)
        {
            if (target == null) return;
            var left= this.pieceInto(target, "b10_button_left_active", 0, 0, 6, target.height);
            var middle= this.pieceInto(target, "b10_button_middle_active", 6, 0,
                target.width - 12, target.height);
            var right= this.pieceInto(target, "b10_button_right_active",
                target.width - 6, 0, 6, target.height);
            var label= this.textInto(target, caption, 0,
                Std.int((target.height - 13) / 2), target.width, 13,
                0, true, "center");
            this.bindSkin(target, [left,middle,right],
                ["b10_button_left_active","b10_button_middle_active","b10_button_right_active"],
                ["b10_button_left_pressed","b10_button_middle_pressed","b10_button_right_pressed"]);
        }

        /** Creates the same self-contained three-slice control used by BattleBall's arena HUD. */
        public function button(caption:String, x:Int, y:Int, width:Int, height:Int):IWindowContainer
        {
            if (this._target == null || this._windowManager == null) return null;
            var control= Std.downcast(this._windowManager.createWindow(this.name("button"), "",
                WindowType.WINDOW_TYPE_REGION, HabboWindowStyle.NULL,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )|
                ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT),
                new Rectangle(x, y, width, height)) , IWindowContainer);
            if (control == null) return null;
            control.mouseThreshold = 0;
            this._target.addChild(control);
            this.buttonInto(control, caption);
            return control;
        }

        /**
         * Draws a native button on the bound root surface while retaining the recovered XML region
         * as its input target. SnowStorm's creation controls sit in REGION containers; putting their
         * skins inside those containers makes AIR share an invalid local graphic context and the
         * controls appear only after hover. Root-surface art follows the same reliable path as the
         * lobby's generated rows and page controls.
         */
        public function buttonAt(control:IWindow, caption:String, x:Int, y:Int,
                                 width:Int, height:Int)
        {
            if (control == null || this._target == null) return;
            var left= this.pieceInto(this._target,
                "b10_button_left_active", x, y, 6, height);
            var middle= this.pieceInto(this._target,
                "b10_button_middle_active", x + 6, y, width - 12, height);
            var right= this.pieceInto(this._target,
                "b10_button_right_active", x + width - 6, y, 6, height);
            this.textInto(this._target, caption, x, y + Std.int((height - 13) / 2),
                width, 13, 0, true, "center");
            this.bindSkin(control, [left,middle,right],
                ["b10_button_left_active","b10_button_middle_active","b10_button_right_active"],
                ["b10_button_left_pressed","b10_button_middle_pressed","b10_button_right_pressed"]);
        }

        /** Draws a creation radio last on the root surface so panel redraws cannot erase it. */
        public function radioAt(x:Int, y:Int, width:Int, height:Int,
                                selected:Bool):IBitmapWrapperWindow
        {
            var window= this.pieceInto(this._target, "", x, y, width, height);
            this.assignRadio(window, selected);
            return window;
        }

        public function bindBitmapPressed(control:IWindow, bitmap:IBitmapWrapperWindow, active:String)
        {
            var pressed= active.indexOf(".active") >= 0
                ? ASCompat.stringReplace(active, ".active", ".pressed") : ASCompat.stringReplace(active, "_active", "_pressed");
            this.bindSkin(control, [bitmap], [active], [pressed]);
        }

        function bindSkin(control:IWindow, windows:Array<ASAny>, active:Array<ASAny>, pressed:Array<ASAny>)
        {
            if (control == null) return;
ASCompat.setDynamicProperty(            this._buttonSkins, control.name, {windows:windows, active:active, pressed:pressed});
            control.addEventListener(WindowMouseEvent.DOWN, this.onButtonState);
            control.addEventListener(WindowMouseEvent.UP, this.onButtonState);
            control.addEventListener(WindowMouseEvent.UP_OUTSIDE, this.onButtonState);
            control.addEventListener(WindowMouseEvent.OUT, this.onButtonState);
        }

        function onButtonState(event:WindowEvent)
        {
var             index = 0;            if (event == null || event.window == null) return;
            var skin:ASObject = ASCompat.getDynamicProperty(this._buttonSkins, event.window.name); if (skin == null) return;
            var members:Array<ASAny> = event.type == WindowMouseEvent.DOWN ? skin.pressed : skin.active;
            index= 0;while (index < skin.windows.length)
                {this.assignBitmap(ASCompat.dynamicAs(skin.windows[index] , IBitmapWrapperWindow), ASCompat.toString(members[index]));
index++;
};
        }

        function name(prefix:String):String
        { return "ss_native_" + prefix + "_" + Std.string(++this._serial); }

        function assignOwnedBitmap(window:IBitmapWrapperWindow, data:BitmapData)
        {
            if (window == null || data == null) return;
            var width= window.width; var height= window.height;
            var container= ASCompat.reinterpretAs(window , IBitmapDataContainer);
            if (container != null)
            {
                container.stretchedX = true; container.stretchedY = true;
                container.pivotPoint = PivotPoint.TOP_LEFT;
                container.zoomX = 1; container.zoomY = 1;
            }
            window.disposesBitmap = true; window.bitmap = data;
            window.width = width; window.height = height; window.color = 0xFFFFFF; window.invalidate();
        }

        public function dispose()
        { this._target = null; this._buttonSkins = {}; this._assets = null; this._windowManager = null; }
    }

