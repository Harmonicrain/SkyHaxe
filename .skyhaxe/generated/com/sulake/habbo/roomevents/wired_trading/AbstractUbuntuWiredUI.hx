package com.sulake.habbo.roomevents.wired_trading
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;

     class AbstractUbuntuWiredUI implements IDisposable
    {
        var _framePreset:FramePreset;
        var _footerPreset:FooterPreset;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _presetManager:PresetManager;
        var _disposed:Bool = false;
        var _hasLocation:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager)
        {
            this._roomEvents = roomEvents;
            this._presetManager = presetManager;
            this._footerPreset = this.createFooterPreset();
        }

        function createFooterPreset():FooterPreset
        {
            return this._presetManager.createFooterPreset(this.onSaveClicked,
                this.onCloseClicked);
        }
        public var footerPreset(get,never):FooterPreset;
public function  get_footerPreset():FooterPreset { return this._footerPreset; }
        public function onSaveClicked() {}
        public function onCloseClicked() { this.hide(); }
        public function isShowing():Bool
        {
            return this._framePreset != null && this._framePreset.window.parent != null
                && this._framePreset.window.visible;
        }
        public var xOffsetFromCenter(get,never):Int;
public function  get_xOffsetFromCenter():Int { return 0; }
        function showFrame()
        {
var desktop:IDesktopWindow  = null;            if (!this.isShowing())
            {
desktop= this._roomEvents.windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._framePreset.window); }
                if (!this.isRememberLocation || !this._hasLocation)
                {
                    this._framePreset.window.center();
                    this._framePreset.window.x += this.xOffsetFromCenter;
                    this._hasLocation = true;
                }
            }
            this._framePreset.window.activate();
        }
        public var window(get,never):IWindow;
public function  get_window():IWindow { return this._framePreset.window; }
        public function forgetLocation() { this._hasLocation = false; }
        var isRememberLocation(get,never):Bool;
function  get_isRememberLocation():Bool { return false; }
        var isBoundToParentRect(get,never):Bool;
function  get_isBoundToParentRect():Bool { return false; }
        public function hide() { this.hideFrame(); }
        function hideFrame()
        {
var desktop:IDesktopWindow  = null;            if (this.isShowing())
            {
desktop= this._roomEvents.windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._framePreset.window); }
            }
        }
                var framePreset(get,set):FramePreset;
function  set_framePreset(value:FramePreset):FramePreset        {
            this._framePreset = value;
            if (this.isBoundToParentRect) { value.window.setParamFlag(32, true); }
return value;
        }
function  get_framePreset():FramePreset { return this._framePreset; }
        var roomEvents(get,never):HabboUserDefinedRoomEvents;
function  get_roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        var localization(get,never):IHabboLocalizationManager;
function  get_localization():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }
        var presetManager(get,never):PresetManager;
function  get_presetManager():PresetManager { return this._presetManager; }
        public function dispose()
        {
            if (this._disposed) { return; }
            if (this._framePreset != null) { this._framePreset.dispose(); }
            this._framePreset = null;
            this._footerPreset = null;
            this._roomEvents = null;
            this._presetManager = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

