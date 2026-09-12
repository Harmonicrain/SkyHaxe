package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.ExpandedVariablePickerView;

     class TabButtonView implements IDisposable
    {
        static inline final SELECTED_BG:UInt = 0xE0E0E0;
        static inline final SELECTED_SHADOW:UInt = 0xFFA9AAAA;
        static inline final HOVER_BG:UInt = 0xEFEFEF;
        static inline final HOVER_SHADOW:UInt = 0xFFCCCCCC;
        static inline final NONE_BG:UInt = 0xFAFAFA;
        static inline final NONE_SHADOW:UInt = 0xFFDDDDDD;

        var _parent:ExpandedVariablePickerView;
        var _window:IRegionWindow;
        var _tabConfig:TabButtonConfig;
        var _disposed:Bool = false;
        var _active:Bool = false;
        var _hover:Bool = false;

        public function new(parent:ExpandedVariablePickerView, config:TabButtonConfig, width:Int)
        {
            this._parent = parent;
            this._tabConfig = config;
            this._window = Std.downcast(parent.tabButtonTemplate.clone() , IRegionWindow);
            this._window.width = width;
            this._window.toolTipCaption = parent.roomEvents.localization.getLocalization(config.tooltipCaption, config.tooltipCaption);
            this.image.assetUri = config.assetUri;
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this.updateColoring();
        }

        public var active(never,set):Bool;
public function  set_active(value:Bool):Bool{ this._active = value; this.updateColoring(); return value;
}
        public var tabConfig(get,never):TabButtonConfig;
public function  get_tabConfig():TabButtonConfig { return this._tabConfig; }
        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }

        function onClick(event:WindowMouseEvent) { this._parent.selectTab(this); }
        function onOver(event:WindowMouseEvent) { this._hover = true; this.updateColoring(); }
        function onOut(event:WindowMouseEvent) { this._hover = false; this.updateColoring(); }

        function updateColoring()
        {
            this.buttonBorder.color = this._active ? SELECTED_BG : (this._hover ? HOVER_BG : NONE_BG);
            this.buttonShadow.color = this._active ? SELECTED_SHADOW : (this._hover ? HOVER_SHADOW : NONE_SHADOW);
            this.image.blend = this._active ? 0.6 : (this._hover ? 0.5 : 0.4);
        }

        var buttonBorder(get,never):IBorderWindow;
function  get_buttonBorder():IBorderWindow { return Std.downcast(this._window.findChildByName("button_border") , IBorderWindow); }
        var buttonShadow(get,never):IWindowContainer;
function  get_buttonShadow():IWindowContainer { return Std.downcast(this._window.findChildByName("button_shadow") , IWindowContainer); }
        var image(get,never):IStaticBitmapWrapperWindow;
function  get_image():IStaticBitmapWrapperWindow { return Std.downcast(this._window.findChildByName("button_img") , IStaticBitmapWrapperWindow); }

        public function dispose()
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._parent = null;
            this._tabConfig = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

