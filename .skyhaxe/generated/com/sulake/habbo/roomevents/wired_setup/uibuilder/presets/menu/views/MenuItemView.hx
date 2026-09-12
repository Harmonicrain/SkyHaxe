package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.views
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.MenuPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuItem;

     class MenuItemView implements IDisposable
    {
        var _disposed:Bool = false;
        var _window:IRegionWindow;
        var _menu:MenuPreset;
        var _item:MenuItem;
        var _hovered:Bool = false;
        var _checkboxHovered:Bool = false;
        var _disabled:Bool = false;
        var _ignoreEvents:Bool = false;

        public function new(menu:MenuPreset, item:MenuItem)
        {
            this._menu = menu;
            this._item = item;
            this._window = Std.downcast(menu.menuItemTemplate.clone() , IRegionWindow);
            this.textWindow.text = item.name;
            this.checkboxWindow.visible = item.hasCheckbox;
            if (item.tooltip != null && item.tooltip.length > 0)
            {
                this._window.toolTipCaption = item.tooltip;
            }
            this._window.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this.checkboxWindow.addEventListener(WindowMouseEvent.OVER, this.onCheckboxHover);
            this.checkboxWindow.addEventListener(WindowMouseEvent.OUT, this.onCheckboxHoverEnd);
            this.checkboxWindow.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectedChange);
            this.checkboxWindow.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSelectedChange);
            this.updateUI();
        }

        function onSelectedChange(event:WindowEvent)
        {
            if (!this._ignoreEvents && this._item.selectedChange != null)
            {
                this._item.selectedChange(this.checkboxWindow.Selected);
            }
        }

        function onClick(event:WindowMouseEvent)
        {
            if (this._disabled) { return; }
            if (this._item.hasCheckbox) { this.selected = !this.selected; }
            if (this._item.onClick != null) { this._item.onClick(); }
            if (!this._item.hasCheckbox) { this._menu.requestClose(); }
        }

        function onHover(event:WindowMouseEvent) { this._hovered = true; this.updateUI(); }
        function onHoverEnd(event:WindowMouseEvent) { this._hovered = false; this.updateUI(); }
        function onCheckboxHover(event:WindowMouseEvent) { this._checkboxHovered = true; this.updateUI(); }
        function onCheckboxHoverEnd(event:WindowMouseEvent) { this._checkboxHovered = false; this.updateUI(); }

        function updateUI()
        {
            this._window.background = (this._hovered || this._checkboxHovered) && !this._disabled;
            Util.disableSection(this._window, this._disabled);
        }

        
        public var selected(get,set):Bool;
public function  get_selected():Bool
        {
            return this._item.hasCheckbox && this.checkboxWindow.Selected;
        }
public function  set_selected(value:Bool):Bool        {
            if (!this._item.hasCheckbox || this.checkboxWindow.Selected == value) { return value; }
            this._ignoreEvents = true;
            if (value) { this.checkboxWindow.select(); } else { this.checkboxWindow.unselect(); }
            this._ignoreEvents = false;
            if (this._item.selectedChange != null) { this._item.selectedChange(value); }
return value;
        }

                public var disabled(get,set):Bool;
public function  get_disabled():Bool { return this._disabled; }
public function  set_disabled(value:Bool):Bool{ this._disabled = value; this.updateUI(); return value;
}
        public var requestedMinWidth(get,never):Int;
public function  get_requestedMinWidth():Int { return this.textWindow.x + this.textWindow.width; }
        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }

        var textWindow(get,never):ITextWindow;
function  get_textWindow():ITextWindow { return Std.downcast(this._window.findChildByName("text") , ITextWindow); }
        var checkboxWindow(get,never):ICheckBoxWindow;
function  get_checkboxWindow():ICheckBoxWindow { return Std.downcast(this._window.findChildByName("checkbox") , ICheckBoxWindow); }

        public function dispose()
        {
            if (this._disposed) { return; }
            this._window = null;
            this._menu = null;
            this._item = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

