package com.sulake.habbo.battleball
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

    /**
     * Native WindowManager drawing primitives for BattleBall's Director artwork.
     *
     * Artwork remains pixel-identical because it still comes from hh_game_bb_ui.swf. The important
     * difference from BattleBallChrome is the surface: each image is an IBitmapWrapperWindow in the
     * parent's graphic context, so native text, focus, input and mouse events share the same z-order.
     */
     final class BattleBallWindowSurface
    {
        var _actions:ASFunction;
        var _assets:BattleBallAssets;
        var _buttonSkins:ASObject = {};
        var _serial:UInt = 0;
        var _target:IWindowContainer;
        var _windowManager:IHabboWindowManager;

        public function new(windowManager:IHabboWindowManager,
                                                assets:BattleBallAssets,
                                                registerAction:ASFunction)
        {
            this._windowManager = windowManager;
            this._assets = assets;
            this._actions = registerAction;
        }

        public function bind(target:IWindowContainer)
        {
            this._target = target;
            this._serial = 0;
            this._buttonSkins = {};
        }

        public function dispose()
        {
            this._target = null;
            this._actions = null;
            this._assets = null;
            this._buttonSkins = {};
            this._windowManager = null;
        }

        public function assignBitmap(window:IBitmapWrapperWindow, member:String,
                                     flipH:Bool=false)
        {
            if (window == null || this._assets == null) return;
            var data= this._assets.bitmapData("hh_game_bb_ui_" + member);
            var width= window.width;
            var height= window.height;
            var container= ASCompat.reinterpretAs(window , IBitmapDataContainer);
            if (container != null)
            {
                container.stretchedX = true;
                container.stretchedY = true;
                container.pivotPoint = PivotPoint.TOP_LEFT;
                container.zoomX = flipH ? -1 : 1;
                container.zoomY = 1;
            }
            window.disposesBitmap = false;
            window.bitmap = data;
            // BitmapWrapperController.fitSize() runs on assignment. Preserve the Director layout rect;
            // one-pixel stretch assets such as bb_bg_px must not collapse back to their source size.
            window.width = width;
            window.height = height;
            window.color = 0xFFFFFF;
            window.invalidate();
        }

        public function piece(member:String, x:Int, y:Int, width:Int, height:Int,
                              flipH:Bool=false):IBitmapWrapperWindow
        {
            return this.pieceInto(this._target, member, x, y, width, height, flipH);
        }

        public function pieceInto(target:IWindowContainer, member:String, x:Int, y:Int,
                                  width:Int, height:Int, flipH:Bool=false):IBitmapWrapperWindow
        {
            if (target == null || width <= 0 || height <= 0 || this._windowManager == null) return null;
            if (flipH) x -= width;
            var window= Std.downcast(this._windowManager.createWindow(this.name("bitmap"), "",
                WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, width, height)) , IBitmapWrapperWindow);
            if (window == null) return null;
            target.addChild(window);
            this.assignBitmap(window, member, flipH);
            return window;
        }

        public function text(value:String, x:Int, y:Int, width:Int, height:Int, colour:UInt,
                             bold:Bool=false, align:String="center", underline:Bool=false):ITextWindow
        {
            return this.textInto(this._target, value, x, y, width, height, colour, bold, align, underline);
        }

        public function textInto(target:IWindowContainer, value:String, x:Int, y:Int, width:Int,
                                 height:Int, colour:UInt, bold:Bool=false, align:String="center",
                                 underline:Bool=false):ITextWindow
        {
            if (target == null || this._windowManager == null) return null;
            var field= Std.downcast(this._windowManager.createWindow(this.name("text"), value,
                WindowType.WINDOW_TYPE_FORMATTED_TEXT, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, width, height)) , ITextWindow);
            if (field == null) return null;
            target.addChild(field);
            this.formatText(field, value, colour, bold, align, underline);
            return field;
        }

        public function formatText(field:ITextWindow, value:String, colour:UInt, bold:Bool,
                                   align:String, underline:Bool=false)
        {
            if (field == null) return;
            var face= bold ? "Volter Bold" : "Volter";
            if (!FontEnum.isEmbeddedFont(face) && FontEnum.isEmbeddedFont("Volter")) face = "Volter";
            field.fontFace = face;
            field.fontSize = 9;
            field.textColor = colour;
            field.bold = bold;
            field.underline = underline;
            field.embedFonts = FontEnum.isEmbeddedFont(face);
            field.defaultTextFormat = new TextFormat(face, 9, ASCompat.toInt(colour), bold, null, underline,
                null, null, align);
            field.text = value == null ? "" : value;
        }

        public function button(id:String, caption:String, x:Int, y:Int, width:Int, height:Int,
                               action:ASFunction, data:ASObject=null)
        {
            if (this._target == null || this._windowManager == null) return;
            var control= Std.downcast(this._windowManager.createWindow(this.name(id), "",
                WindowType.WINDOW_TYPE_REGION, HabboWindowStyle.NULL,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )|
                ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT),
                new Rectangle(x, y, width, height)) , IWindowContainer);
            if (control == null) return;
            control.mouseThreshold = 0;
            this._target.addChild(control);
            this.buttonInto(control, caption);
            if (this._actions != null) this._actions(control, action, data);
        }

        public function buttonInto(target:IWindowContainer, caption:String)
        {
            if (target == null) return;
            var skin:ASObject = this.buttonArtInto(target, caption, 0, 0, target.width, target.height);
            this.bindPressedSkin(target, skin);
        }

        function buttonArtInto(target:IWindowContainer, caption:String, x:Int, y:Int,
                                       width:Int, height:Int):ASObject
        {
            var left= this.pieceInto(target,
                "b10_button_left_active", x, y, 6, height);
            var middle= this.pieceInto(target,
                "b10_button_middle_active", x + 6, y, width - 12, height);
            var right= this.pieceInto(target,
                "b10_button_right_active", x + width - 6, y, 6, height);
            this.textInto(target, caption, x, y + Std.int((height - 13) / 2), width, 13,
                0x000000, true, "center");
            return {windows:([left, middle, right] : Array<Dynamic>),
                active:(["b10_button_left_active", "b10_button_middle_active", "b10_button_right_active"] : Array<Dynamic>),
                pressed:(["b10_button_left_pressed", "b10_button_middle_pressed", "b10_button_right_pressed"] : Array<Dynamic>)};
        }

        public function hotspot(id:String, x:Int, y:Int, width:Int, height:Int,
                                action:ASFunction, data:ASObject=null):IWindow
        {
            if (this._target == null || action == null || this._windowManager == null) return null;
            var region= this._windowManager.createWindow(this.name(id), "",
                WindowType.WINDOW_TYPE_REGION, HabboWindowStyle.NULL,
                ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )|
                ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT),
                new Rectangle(x, y, width, height));
            if (region == null) return null;
            region.mouseThreshold = 0;
            this._target.addChild(region);
            if (this._actions != null) this._actions(region, action, data);
            return region;
        }

        /** Uses a native XML control's pressed state to swap its authored Director bitmap. */
        public function bindBitmapPressed(control:IWindow, bitmap:IBitmapWrapperWindow,
                                          activeMember:String)
        {
            if (control == null || bitmap == null) return;
            this.bindPressedSkin(control, {windows:([bitmap] : Array<Dynamic>), active:([activeMember] : Array<Dynamic>),
                pressed:([ASCompat.stringReplace(activeMember, "_active", "_pressed")] : Array<Dynamic>)});
        }

        function bindPressedSkin(window:IWindow, skin:ASObject)
        {
            if (window == null || skin == null) return;
ASCompat.setDynamicProperty(            this._buttonSkins, window.name, skin);
            window.addEventListener(WindowMouseEvent.DOWN, this.onButtonState);
            window.addEventListener(WindowMouseEvent.UP, this.onButtonState);
            window.addEventListener(WindowMouseEvent.UP_OUTSIDE, this.onButtonState);
            window.addEventListener(WindowMouseEvent.OUT, this.onButtonState);
        }

        function onButtonState(event:WindowEvent)
        {
var             index = 0;            if (event == null || event.window == null) return;
            var skin:ASObject = ASCompat.getDynamicProperty(this._buttonSkins, event.window.name);
            if (skin == null) return;
            var members:Array<ASAny> = event.type == WindowMouseEvent.DOWN ? skin.pressed : skin.active;
            var windows:Array<ASAny> = ASCompat.dynamicAs(skin.windows , Array);
            index= 0;while (index < windows.length && index < members.length)
                {this.assignBitmap(ASCompat.dynamicAs(windows[index] , IBitmapWrapperWindow), ASCompat.toString(members[index]));
index++;
};
        }

        public function radio(name:String, rect:ASObject, selected:Bool, value:Int,
                              action:ASFunction)
        {
            this.piece(selected ? "button_radio_on" : "button_radio_off",
                ASCompat.toInt(rect.x), ASCompat.toInt(rect.y), ASCompat.toInt(rect.w), ASCompat.toInt(rect.h));
            this.hotspot(name, ASCompat.toInt(rect.x) - 4, ASCompat.toInt(rect.y) - 3,
                ASCompat.toInt(rect.w) + 8, ASCompat.toInt(rect.h) + 6, action, value);
        }

        public function arrow(x:Int, y:Int, colour:UInt)
        {
            this.drawArrow(x, y, colour, false);
        }

        public function dropArrow(x:Int, y:Int)
        {
            this.drawArrow(x, y, 0x1E2A2B, true);
        }

        function drawArrow(x:Int, y:Int, colour:UInt, down:Bool)
        {
            if (this._target == null || this._windowManager == null) return;
            var data= new BitmapData(7, down ? 4 : 7, true, 0);
            var row = 0;
            if (down)
            {
                for (_tmp_ in 0...4)
{row = _tmp_;
                    data.fillRect(new Rectangle(row, row, 7 - row * 2, 1), ASCompat.toInt(0xFF000000 )| ASCompat.toInt(colour));
};
            }
            else
            {
                for (_tmp_ in 0...7)
{row = _tmp_;
                    data.fillRect(new Rectangle(0, row, row <= 3 ? row + 1 : 7 - row, 1),
                        ASCompat.toInt(0xFF000000 )| ASCompat.toInt(colour));
};
            }
            var window= Std.downcast(this._windowManager.createWindow(this.name("arrow"), "",
                WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, data.width, data.height)) , IBitmapWrapperWindow);
            if (window == null) { data.dispose(); return; }
            window.disposesBitmap = true;
            window.bitmap = data;
            this._target.addChild(window);
        }

        function name(prefix:String):String
        {
            this._serial++;
            return "bb_native_" + prefix + "_" + Std.string(this._serial);
        }
    }

