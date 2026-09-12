package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class MiniAssetIconButtonPreset extends WiredUIPreset
    {
        static inline final COLOR_BLUE_CLICKED:UInt = 4409728;
        static inline final COLOR_YELLOW_CLICKED:UInt = 6975025;
        static final YELLOW_ASSETS:Array<ASAny> = ["furni_picks_1"];
        static final BLUE_ASSETS:Array<ASAny> = ["furni_picks_2"];

        var _container:IWindowContainer;
        var _selected:Bool = false;
        var _hovered:Bool = false;
        var _assetName:String;
        var _onClick:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:String, _arg_6:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._assetName = _arg_4;
            this._container = Std.downcast(_arg_3.createMiniButton() , IWindowContainer);
            this._onClick = _arg_6;
            this.iconWrapper.assetUri = resolveAssetFullName(_arg_4);
            this.clickArea.addEventListener(WindowMouseEvent.OVER, this.onHoverStart);
            this.clickArea.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.clickArea.addEventListener(WindowMouseEvent.CLICK, this.iconClicked);
            this.clickArea.toolTipCaption = _arg_5;
            this.updateUI();
        }

        function onHoverEnd(_arg_1:WindowMouseEvent)
        {
            this._hovered = false;
            this.updateUI();
        }

        function onHoverStart(_arg_1:WindowMouseEvent)
        {
            this._hovered = true;
            this.updateUI();
        }

        
        public var selected(get,set):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }
public function  set_selected(_arg_1:Bool):Bool        {
            this._selected = _arg_1;
            this.updateUI();
return _arg_1;
        }

        var selectedColor(get,never):UInt;
function  get_selectedColor():UInt
        {
            if (YELLOW_ASSETS.indexOf(this._assetName) != -1)
            {
                return COLOR_YELLOW_CLICKED;
            }
            if (BLUE_ASSETS.indexOf(this._assetName) != -1)
            {
                return COLOR_BLUE_CLICKED;
            }
            return 0xFFFFFF;
        }

        function updateUI()
        {
        }

        function iconClicked(_arg_1:WindowMouseEvent)
        {
            if ((this._onClick != null) && !this._selected)
            {
                this._onClick();
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
        }

        override public function hasStaticWidth():Bool
        {
            return true;
        }

        override public function  get_staticWidth():Int
        {
            return this._container.width;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._assetName = null;
            this._onClick = null;
        }

        var clickArea(get,never):IInteractiveWindow;
function  get_clickArea():IInteractiveWindow
        {
            return Std.downcast(this._container.findChildByName("mini_button_click") , IInteractiveWindow);
        }

        var iconWrapper(get,never):IStaticBitmapWrapperWindow;
function  get_iconWrapper():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._container.findChildByName("mini_button_icon") , IStaticBitmapWrapperWindow);
        }
    }

