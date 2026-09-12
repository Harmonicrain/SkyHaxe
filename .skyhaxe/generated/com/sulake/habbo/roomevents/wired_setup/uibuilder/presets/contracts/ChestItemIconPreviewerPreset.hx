package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

     class ChestItemIconPreviewerPreset extends WiredUIPreset
    {
        var _window:IWindowContainer;
        var _item:ChestItemType;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._window = style.createProductIconPreviewer();
            Std.downcast(this.widgetWindow.widget , IProductIconWidget).unknownImageUri = "";
        }

        
        public var item(get,set):ChestItemType;
public function  set_item(value:ChestItemType):ChestItemType        {
            this._item = value;
            Std.downcast(this.widgetWindow.widget , IProductIconWidget).productInfo =
                value == null ? null : new ChestItemTypeRenderableWrapper(value);
return value;
        }
public function  get_item():ChestItemType { return this._item; }
        override public function  get_window():IWindow { return this._window; }
        override public function hasStaticWidth():Bool { return true; }
        override public function  get_staticWidth():Int { return this._window.width; }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._item = null;
        }

        var widgetWindow(get,never):IWidgetWindow;
function  get_widgetWindow():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("icon_preview") , IWidgetWindow);
        }
    }

