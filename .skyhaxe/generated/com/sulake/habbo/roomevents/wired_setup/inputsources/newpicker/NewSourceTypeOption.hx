package com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker
;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

     class NewSourceTypeOption
    {
        var _picker:NewSourceTypePicker;
        var _container:IContainerButtonWindow;
        var _option:Int = 0;
        var _active:Bool = false;
        var _hovered:Bool = false;

        public function new(k:NewSourceTypePicker, _arg_2:IContainerButtonWindow, _arg_3:Int)
        {
            this._picker = k;
            this._container = _arg_2;
            this._option = _arg_3;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this._container.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            var roomEvents= k.roomEvents;
            var sourceName= WiredInputSourcePicker.getTypeNameForSource(_arg_3);
            this._container.toolTipCaption = roomEvents.localization.getLocalization("wiredfurni.params.sourcetype." + sourceName, sourceName);
            this.typeImage.assetUri = "wired_styles_illumina_icon_source_" + sourceName;
            this.typeImage.y = Std.int((this._container.height + 1) / 2 - (this.typeImage.height + 1) / 2);
            this.updateVisuals();
        }

        public function activate()
        {
            this._active = true;
            this.updateVisuals();
        }

        public function deactivate()
        {
            this._active = false;
            this.updateVisuals();
        }

        function updateVisuals()
        {
            this._container.setStateFlag(WindowState.SELECTED, this._active);
            this._container.setStateFlag(WindowState.HOVERING, this._hovered);
            if (!this._active && !this._hovered)
            {
                this._container.color = 0xFFFFFF;
                this._picker.updateColorings();
                return;
            }
            var color:UInt = 0x1D84CD;
            if (this._option == WiredInputSourcePicker.USER_SOURCE)
            {
                color = 0x268E29;
            }
            else if (this._option == WiredInputSourcePicker.FURNI_SOURCE)
            {
                color = 0xBA9D16;
            }
            else if (this._option == VariableExtraSourceTypes.CONTEXT_SOURCE)
            {
                color = 0xB05B1E;
            }
            this._container.color = lightenColor(color, this._hovered && !this._active ? 1.55 : 1.26);
            this._picker.updateColorings();
        }

        static function lightenColor(k:UInt, _arg_2:Float):UInt
        {
            var r= Std.int(Math.min(255, Std.int(((ASCompat.toInt(k )>> 16) & 0xFF) * _arg_2)));
            var g= Std.int(Math.min(255, Std.int(((ASCompat.toInt(k )>> 8) & 0xFF) * _arg_2)));
            var b= Std.int(Math.min(255, Std.int((ASCompat.toInt(k )& 0xFF) * _arg_2)));
            return (r << 16) | (g << 8) | b;
        }

        function onOut(k:WindowMouseEvent)
        {
            if (!this._container.isEnabled())
            {
                return;
            }
            this._hovered = false;
            this.updateVisuals();
        }

        function onOver(k:WindowMouseEvent)
        {
            if (!this._container.isEnabled())
            {
                return;
            }
            this._hovered = true;
            this.updateVisuals();
        }

        function maybeCancelEvent(k:WindowMouseEvent)
        {
            if (k.type == WindowMouseEvent.OUT && this._active)
            {
                k.preventWindowOperation();
            }
            if (k.type == WindowMouseEvent.UP)
            {
                this.onClick(null);
                k.preventWindowOperation();
            }
        }

        function onClick(k:WindowMouseEvent)
        {
            this._picker.onClick(this);
        }

        public var option(get,never):Int;
public function  get_option():Int { return this._option; }
        public var container(get,never):IContainerButtonWindow;
public function  get_container():IContainerButtonWindow { return this._container; }
        public var active(get,never):Bool;
public function  get_active():Bool { return this._active; }
        public var hovered(get,never):Bool;
public function  get_hovered():Bool { return this._hovered; }
        public var color(get,never):UInt;
public function  get_color():UInt { return this._container.color; }

        var typeImage(get,never):IStaticBitmapWrapperWindow;
function  get_typeImage():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._container.findChildByName("type_image") , IStaticBitmapWrapperWindow);
        }

        public function dispose()
        {
            if (this._container != null)
            {
                this._container.dispose();
                this._container = null;
            }
            this._picker = null;
        }
    }

