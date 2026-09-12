package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.InteractiveController;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class AssetButtonPreset extends WiredUIPreset
    {
        var _container:IContainerButtonWindow;
        var _onClick:ASFunction;
        var _selected:Bool = false;
        var _hovered:Bool = false;
        var _pressed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, assetName:String, tooltip:String, onClick:ASFunction)
        {
            super(roomEvents, presets, style);
            this._onClick = onClick;
            this._container = style.createAssetButton();
            this.staticBitmap.assetUri = resolveAssetFullName(assetName);
            this._container.toolTipCaption = tooltip;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this._container.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.DOWN, this.onDown);
        }

        public var assetName(never,set):String;
public function  set_assetName(value:String):String{ this.staticBitmap.assetUri = resolveAssetFullName(value); return value;
}
        override public function  get_window():IWindow { return this._container; }

        function onOut(event:WindowMouseEvent)
        {
            if (!this._container.isEnabled()) return;
            this._hovered = false;
            this.updateVisuals();
        }

        function onOver(event:WindowMouseEvent)
        {
            if (!this._container.isEnabled()) return;
            this._hovered = true;
            this.updateVisuals();
        }

        function onButtonClicked(event:WindowMouseEvent)
        {
            if (this._onClick != null) this._onClick();
        }

        function maybeCancelEvent(event:WindowMouseEvent)
        {
            if (event.type == WindowMouseEvent.OUT && this._selected) event.preventWindowOperation();
            if (event.type == WindowMouseEvent.UP)
            {
                this._pressed = false;
                if (this._selected)
                {
                    this.onButtonClicked(null);
                    event.preventWindowOperation();
                }
            }
        }

        function onDown(event:WindowMouseEvent) { this._pressed = false; }

        function updateVisuals()
        {
            var controller= cast(this._container, InteractiveController);
            if (_style.isVolter)
            {
                controller.setStateFlag(16, this._pressed);
                controller.setStateFlag(4, this._hovered || this._selected);
            }
            else
            {
                controller.setStateFlag(16, this._selected);
                controller.setStateFlag(4, this._hovered);
            }
        }

                public var selected(get,set):Bool;
public function  get_selected():Bool { return this._selected; }
public function  set_selected(value:Bool):Bool{ this._selected = value; this.updateVisuals(); return value;
}
        override public function hasStaticWidth():Bool { return true; }
        override public function  get_staticWidth():Int { return this._container.width; }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._onClick = null;
        }

        var staticBitmap(get,never):IStaticBitmapWrapperWindow;
function  get_staticBitmap():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._container.findChildByName("asset") , IStaticBitmapWrapperWindow);
        }
    }

