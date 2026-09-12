package com.sulake.habbo.ui.widget.furniture.areahide
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.SaveAreaHideMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.ToggleAreaHideMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomAreaSelectionManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureAreaHideWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;

     class AreaHideFurniWidget extends RoomWidgetBase
    {
        static inline final AUTO_SAVE= true;
        static final TEXT_NAMES:Array<ASAny> = ["hidearea_info", "areaselection_title", "areaselection_info", "options_title", "invisibility_txt", "invisibility_info", "wallitems_txt", "invert_txt", "invert_info"];

        var _selection:IRoomAreaSelectionManager;
        var _window:IFrameWindow;
        var _furniId:Int = -1;
        var _on:Bool = false;
        var _rootX:Int = 0;
        var _rootY:Int = 0;
        var _width:Int = 0;
        var _length:Int = 0;
        var _changed:Bool = false;
        var _selecting:Bool = false;
        var _selectionActive:Bool = false;

        public function new(k:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary, localizations:IHabboLocalizationManager, roomEngine:IRoomEngine)
        {
            super(k, windowManager, assets, localizations);
            this.handler.widget = this;
            this._selection = roomEngine.areaSelectionManager;
        }

        public var handler(get,never):FurnitureAreaHideWidgetHandler;
public function  get_handler():FurnitureAreaHideWidgetHandler
        {
            return Std.downcast(_handler , FurnitureAreaHideWidgetHandler);
        }

        override public function dispose()
        {
            this.destroyWindow();
            super.dispose();
        }

        public function open(k:Int, on:Bool, rootX:Int, rootY:Int, width:Int, length:Int, invisibility:Bool, wallItems:Bool, invert:Bool)
        {
            this._furniId = k;
            this._on = on;
            this._rootX = rootX;
            this._rootY = rootY;
            this._width = width;
            this._length = length;
            this.createWindow();
            this.invisibilityCheckbox.Selected = invisibility;
            this.wallItemsCheckbox.Selected = wallItems;
            this.invertCheckbox.Selected = invert;
            this._changed = false;
            this._selecting = false;
            this.updateAreaSelecting();
            this.refreshUI();
        }

        public function updateStatus(k:Int, on:Bool)
        {
            if (((this._window != null) && this._window.visible && (k == this._furniId) && (on != this._on)))
            {
                this._on = on;
                this.updateAreaSelecting();
                this.refreshUI();
            }
        }

        function createWindow()
        {
            if (this._window == null)
            {
                this._window = cast(windowManager.buildFromXML((assets.getAssetByName("area_hide_ui_xml").content : com.sulake.core.utils.xml.XML) ), IFrameWindow);
                this._window.procedure = this.windowProcedure;
                this.invisibilityCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.invisibilityCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.wallItemsCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.wallItemsCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.invertCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.invertCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.applyButton.visible = !AUTO_SAVE;
                this._window.center();
            }
            else
            {
                this._window.visible = true;
            }
        }

        function hideWindow()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
            if (this._selectionActive)
            {
                this._selection.deactivate();
                this._selectionActive = false;
            }
            this._furniId = -1;
        }

        function destroyWindow()
        {
            this.hideWindow();
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function updateAreaSelecting()
        {
            if (!this._on)
            {
                if (!this._selectionActive)
                {
                    this._selectionActive = this._selection.activate(this.onAreaSelected, "highlight_darken");
                }
                if (this._selectionActive)
                {
                    this._selection.setHighlight(this._rootX, this._rootY, this._width, this._length);
                }
            }
            else if (this._selectionActive)
            {
                this._selection.deactivate();
                this._selectionActive = false;
            }
        }

        function refreshUI()
        {
            if (this._on)
            {
                this.onOffButton.caption = localizations.getLocalization("widget.areahide.button.off");
                this.disableContents(true);
            }
            else
            {
                this.onOffButton.caption = localizations.getLocalization("widget.areahide.button.on");
                this.disableContents(false);
                this.setDisabled(!this._changed, this.applyButton);
                this.setDisabled((this._selecting || !this._selectionActive), this.selectButton);
                this.setDisabled(!this._selectionActive, this.clearButton);
            }
        }

        function disableContents(k:Bool)
        {
var name:String  = null;            this.setDisabled(k, this.selectButton);
            this.setDisabled(k, this.clearButton);
            this.setDisabled(k, this.applyButton);
            this.setDisabled(k, this.invisibilityCheckbox);
            this.setDisabled(k, this.wallItemsCheckbox);
            this.setDisabled(k, this.invertCheckbox);
            this.invisibilityCheckbox.blend = (k ? 0.5 : 1);
            this.wallItemsCheckbox.blend = (k ? 0.5 : 1);
            this.invertCheckbox.blend = (k ? 0.5 : 1);
            final _iter_ = TEXT_NAMES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
name = _tmp_;
                cast(this._window.findChildByName(name), ITextWindow).blend = (k ? 0.5 : 1);
            }
        }

        function setDisabled(k:Bool, window:IWindow)
        {
            if (k)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }

        function onAreaSelected(k:Int, y:Int, width:Int, length:Int)
        {
            this._rootX = k;
            this._rootY = y;
            this._width = width;
            this._length = length;
            this._selecting = false;
            this.onSettingsChanged(null);
        }

        function onSettingsChanged(k:WindowEvent)
        {
            this._changed = true;
            if (AUTO_SAVE)
            {
                this.updateData();
            }
            this.refreshUI();
        }

        function updateData()
        {
            this.handler.container.connection.send(new SaveAreaHideMessageComposer(this._furniId, this._rootX, this._rootY, this._width, this._length, this.invisibilityCheckbox.Selected, this.wallItemsCheckbox.Selected, this.invertCheckbox.Selected));
            this._changed = false;
        }

        function windowProcedure(k:WindowEvent, window:IWindow)
        {
            if (((window != null) && (k.type == WindowMouseEvent.CLICK)))
            {
                switch (window.name)
                {
                    case "apply_button":
                        if (this._changed && !AUTO_SAVE)
                        {
                            this.updateData();
                        }
                        return;
                    case "on_off_button":
                        this.handler.container.connection.send(new ToggleAreaHideMessageComposer(this._furniId));
                        return;
                    case "select_button":
                        this._selecting = true;
                        this._selection.startSelecting();
                        this.refreshUI();
                        return;
                    case "clear_button":
                        this._selection.clearHighlight();
                        return;
                    case "header_button_close":
                        this.hideWindow();
                        return;
                }
            }
        }

        var selectButton(get,never):IButtonWindow;
function  get_selectButton():IButtonWindow { return Std.downcast(this._window.findChildByName("select_button") , IButtonWindow); }
        var clearButton(get,never):IButtonWindow;
function  get_clearButton():IButtonWindow { return Std.downcast(this._window.findChildByName("clear_button") , IButtonWindow); }
        var applyButton(get,never):IButtonWindow;
function  get_applyButton():IButtonWindow { return Std.downcast(this._window.findChildByName("apply_button") , IButtonWindow); }
        var onOffButton(get,never):IButtonWindow;
function  get_onOffButton():IButtonWindow { return Std.downcast(this._window.findChildByName("on_off_button") , IButtonWindow); }
        var invisibilityCheckbox(get,never):ICheckBoxWindow;
function  get_invisibilityCheckbox():ICheckBoxWindow { return Std.downcast(this._window.findChildByName("invisiblity_checkbox") , ICheckBoxWindow); }
        var wallItemsCheckbox(get,never):ICheckBoxWindow;
function  get_wallItemsCheckbox():ICheckBoxWindow { return Std.downcast(this._window.findChildByName("wallitems_checkbox") , ICheckBoxWindow); }
        var invertCheckbox(get,never):ICheckBoxWindow;
function  get_invertCheckbox():ICheckBoxWindow { return Std.downcast(this._window.findChildByName("invert_checkbox") , ICheckBoxWindow); }
    }

