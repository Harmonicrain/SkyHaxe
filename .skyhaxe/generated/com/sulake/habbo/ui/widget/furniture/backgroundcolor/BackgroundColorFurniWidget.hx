package com.sulake.habbo.ui.widget.furniture.backgroundcolor
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FurnitureBackgroundColorWidgetHandler;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.room.utils.ColorConverter;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.SetRoomBackgroundColorDataComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BackgroundColorFurniWidget extends RoomWidgetBase
    {
        static inline final HUE= "hue";
        static inline final SATURATION= "saturation";
        static inline final LIGHTNESS= "lightness";

        var _window:IFrameWindow;
        var _furniId:Int = 0;
        var _sliders:Vector<BackgroundColorWidgetSlider>;
        var _hue:Int = 0;
        var _saturation:Int = 0;
        var _lightness:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            this._sliders = new Vector<BackgroundColorWidgetSlider>();
            super(k, _arg_2, _arg_3, _arg_4);
            this.handler.widget = this;
        }

        public var handler(get,never):FurnitureBackgroundColorWidgetHandler;
public function  get_handler():FurnitureBackgroundColorWidgetHandler
        {
            return Std.downcast(_handler , FurnitureBackgroundColorWidgetHandler);
        }

        override public function dispose()
        {
            this.destroyWindow();
            super.dispose();
        }

        public function open(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this._furniId = k;
            this._hue = Std.int(Math.max(_arg_2, 0));
            this._saturation = Std.int(Math.max(_arg_3, 0));
            this._lightness = Std.int(Math.max(_arg_4, 0));
            this.createWindow();
        }

        public function _Str_25701(k:String, _arg_2:Int)
        {
            switch (k)
            {
                case HUE:
                    this._hue = _arg_2;
                    
                case SATURATION:
                    this._saturation = _arg_2;
                    
                case LIGHTNESS:
                    this._lightness = _arg_2;
                    
            }
            this._Str_23042();
        }

        function createWindow()
        {
            if (this._window == null)
            {
                this._window = cast(windowManager.buildFromXML(((assets.getAssetByName("background_color_ui_xml").content : com.sulake.core.utils.xml.XML) )), IFrameWindow);
                this._window.procedure = this.windowProcedure;
                this._window.center();
                this._sliders.push(new BackgroundColorWidgetSlider(this, HUE, cast(this._window.findChildByName("hue_container"), IWindowContainer), this._hue));
                this._sliders.push(new BackgroundColorWidgetSlider(this, SATURATION, cast(this._window.findChildByName("saturation_container"), IWindowContainer), this._saturation));
                this._sliders.push(new BackgroundColorWidgetSlider(this, LIGHTNESS, cast(this._window.findChildByName("lightness_container"), IWindowContainer), this._lightness));
            }
        }

        function destroyWindow()
        {
            var k:BackgroundColorWidgetSlider = null;
            final _iter_ = this._sliders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._sliders = new Vector<BackgroundColorWidgetSlider>();
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_23042()
        {
            if (this._window == null)
            {
                return;
            }
            var k= cast(this._window.findChildByName("color_preview_bitmap"), IBitmapWrapperWindow);
            var _local_2= new BitmapData(k.width, k.height, false);
            var _local_3:UInt = ColorConverter.hslToRGB(((((this._hue & 0xFF) << 16) + ((this._saturation & 0xFF) << 8)) + (this._lightness & 0xFF)));
            _local_2.fillRect(_local_2.rect, _local_3);
            k.bitmap = _local_2;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(_arg_2 == null)) && (k.type == WindowMouseEvent.CLICK)))
            {
                switch (_arg_2.name)
                {
                    case "apply_button":
                        this.handler.container.connection.send(new SetRoomBackgroundColorDataComposer(this._furniId, this._hue, this._saturation, this._lightness));
                        return;
                    case "on_off_button":
                        this.handler.container.connection.send(new UseFurnitureMessageComposer(this._furniId));
                        return;
                    case "header_button_close":
                        this.destroyWindow();
                        return;
                }
            }
        }
    }

