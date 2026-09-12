package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class CollapseExpandSectionButtonPreset extends WiredUIPreset
    {
        var _region:IRegionWindow;
        var _callback:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:ASFunction, _arg_5:Bool)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._callback = _arg_4;
            this._region = _arg_3.createExpandCollapseSectionRegion();
            this.upArrow.visible = _arg_5;
            this.downArrow.visible = !_arg_5;
            this._region.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
        }

        override public function  get_window():IWindow
        {
            return this._region;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
        }

        override public function hasStaticWidth():Bool
        {
            return true;
        }

        override public function  get_staticWidth():Int
        {
            return this._region.width;
        }

        public var isExpanded(get,never):Bool;
public function  get_isExpanded():Bool
        {
            return this.upArrow.visible;
        }

        function onButtonClicked(_arg_1:WindowMouseEvent)
        {
            var _local_2= !this.isExpanded;
            this.upArrow.visible = _local_2;
            this.downArrow.visible = !_local_2;
            if (this._callback != null)
            {
                this._callback(_local_2);
            }
        }

        var upArrow(get,never):IStaticBitmapWrapperWindow;
function  get_upArrow():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._region.findChildByName("up_arrow") , IStaticBitmapWrapperWindow);
        }

        var downArrow(get,never):IStaticBitmapWrapperWindow;
function  get_downArrow():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._region.findChildByName("down_arrow") , IStaticBitmapWrapperWindow);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._region.dispose();
            this._region = null;
            this._callback = null;
        }
    }

