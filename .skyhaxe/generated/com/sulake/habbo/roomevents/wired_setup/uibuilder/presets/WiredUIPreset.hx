package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.IWiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Abstract base for builder presets (May WiredUIPreset). Universal constructor
     * prefix (roomEvents, presetManager, style) is shared by every concrete preset.
     */
     class WiredUIPreset implements IWiredUIPreset
    {
        var _disposing:Bool = false;
        var _isDisposed:Bool = false;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _presetManager:PresetManager;
        var _style:WiredStyle;
        var _blendSpacer:SpacerPreset;
        var _blendingBackgroundColor:Int = 0;
        var _cacheWidth:Int = -1;
        var _isDisabled:Bool = false;
        var _invisibilityListener:WiredUIPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle)
        {
            this._roomEvents = _arg_1;
            this._presetManager = _arg_2;
            this._style = _arg_3;
        }

        static function toArray(_arg_1:ASAny):Array<ASAny>
        {
var _local_3:ASAny  = null;            var _local_2:Array<ASAny> = [];
            if (checkNullIteratee(_arg_1)) for (_tmp_ in _arg_1)
            {
_local_3 = _tmp_;
                _local_2.push(_local_3);
            }
            return _local_2;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return null;
        }

        public function resizeToWidth(_arg_1:Int)
        {
            this._cacheWidth = _arg_1;
        }

        public function resize()
        {
            if (this._cacheWidth != -1)
            {
                this.resizeToWidth(this._cacheWidth);
            }
        }

        public function hasStaticWidth():Bool
        {
            return false;
        }

        public var staticWidth(get,never):Int;
public function  get_staticWidth():Int
        {
            return -1;
        }

        public function alignRight():WiredUIPreset
        {
            return new AlignRightWrapperPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function alignCenter():WiredUIPreset
        {
            return new AlignCenterWrapperPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function staticHeight(_arg_1:Int):WiredUIPreset
        {
            return new StaticHeightPreset(this._roomEvents, this._presetManager, this._style, this, _arg_1);
        }

        public function floatVertically():WiredUIPreset
        {
            return new FloatVerticallyPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function wrapWindow(_arg_1:IWindow, _arg_2:Bool = false):WiredUIPreset
        {
            return new WindowWrapperPreset(this._roomEvents, this._presetManager, this._style, _arg_1, _arg_2);
        }

        public function noDisable():WiredUIPreset
        {
            window.tags.push("DO_NOT_DISABLE");
            return this;
        }

        public function halfBlend():WiredUIPreset
        {
            window.blend = 0.5;
            window.tags.push("HALF_BLEND");
            return this;
        }

        
        public var disabled(get,set):Bool;
public function  set_disabled(_arg_1:Bool):Bool        {
            if (this._isDisabled == _arg_1)
            {
                return _arg_1;
            }
            this._isDisabled = _arg_1;
            this.updateDisabledState();
return _arg_1;
        }

        public function updateDisabledState()
        {
var _local_1:WiredUIPreset  = null;            Util.disableSection(window, this._isDisabled);
            if (!this._isDisabled)
            {
                final _iter_ = this.childPresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_1 = _tmp_;
                    _local_1.updateDisabledState();
                }
            }
        }

        var childPresets(get,never):Array<ASAny>;
function  get_childPresets():Array<ASAny>
        {
            return [];
        }
public function  get_disabled():Bool
        {
            return this._isDisabled;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(_arg_1:Bool):Bool        {
            if (window.visible != _arg_1)
            {
                window.visible = _arg_1;
                if (this._invisibilityListener != null)
                {
                    this._invisibilityListener.onInvisibilityChanged(this, _arg_1);
                }
            }
return _arg_1;
        }
public function  get_visible():Bool
        {
            return window.visible;
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets) var invisibilityListener(never,set):WiredUIPreset;
function  set_invisibilityListener(_arg_1:WiredUIPreset):WiredUIPreset        {
            return this._invisibilityListener = _arg_1;
        }

        function onInvisibilityChanged(_arg_1:WiredUIPreset, _arg_2:Bool)
        {
        }

        function loc(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization(_arg_1, _arg_1);
        }

        function l(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization("wiredfurni.params." + _arg_1, _arg_1);
        }

        var localizations(get,never):IHabboLocalizationManager;
function  get_localizations():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }

        var disposing(get,never):Bool;
function  get_disposing():Bool
        {
            return this._disposing;
        }

        public function dispose()
        {
var _local_1:WiredUIPreset  = null;            this._disposing = true;
            if (this._isDisposed)
            {
                return;
            }
            this._blendSpacer = null;
            this._roomEvents = null;
            this._style = null;
            this._presetManager = null;
            this._invisibilityListener = null;
            final _iter_ = this.childPresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_1 = _tmp_;
                _local_1.dispose();
            }
            this._isDisposed = true;
        }

        public var blendSpacer(never,set):SpacerPreset;
public function  set_blendSpacer(_arg_1:SpacerPreset):SpacerPreset        {
            this._blendSpacer = _arg_1;
            this.updateBackgroundColorBlending();
return _arg_1;
        }

        var blendingBackgroundColor(never,set):Int;
function  set_blendingBackgroundColor(_arg_1:Int):Int        {
            this._blendingBackgroundColor = _arg_1;
            this.updateBackgroundColorBlending();
return _arg_1;
        }

        function updateBackgroundColorBlending()
        {
            var _local_1 = false;
            if (this._blendSpacer != null)
            {
                _local_1 = (this._blendingBackgroundColor != 0);
                this._blendSpacer.backgroundEnabled = _local_1;
                if (_local_1)
                {
                    this._blendSpacer.backgroundColor = this._blendingBackgroundColor;
                }
            }
        }

        function resolveAssetFullName(_arg_1:String):String
        {
            var _local_2= ("wired_styles_" + this._style.name + "_" + _arg_1);
            if (this._roomEvents.windowManager.assets.getAssetByName(_local_2) != null)
            {
                return _local_2;
            }
            return ("wired_" + _arg_1);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }
    }

