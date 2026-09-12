package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class RewardRowPreset extends WiredUIPreset
    {
        var _row:SimpleListViewPreset;
        var _container:IWindowContainer;
        var _badgeCheckbox:ICheckBoxWindow;
        var _codeInput:TextInputPreset;
        var _probabilityInput:TextInputPreset;
        var _rowSpacing:Int = 0;
        var _probabilityEnabled:Bool = true;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                        presetManager:PresetManager,
                                        style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._badgeCheckbox = style.createCheckboxView();
            this._codeInput = presetManager.createTextInput(new TextInputParam(
                "", 100, null, -1, null, true, "Product code or badge code"));
            this._probabilityInput = presetManager.createTextInput(new TextInputParam(
                "", 3, null, 50, "0-9", true,
                "Chance to get this reward. Value should be a number between 1 and 100"));
            this._rowSpacing = style.genericHorizontalSpacing;
            this._probabilityInput.disabled = !this._probabilityEnabled;
            this._row = presetManager.createSimpleListView(false, [
                wrapWindow(this._badgeCheckbox, true),
                this._codeInput,
                this._probabilityInput
            ]);
            this._row.spacing = this._rowSpacing;
            this._container = Std.downcast(presetManager.createLayout("container_view") , IWindowContainer);
            this._container.addChild(this._row.window);
        }

        
        public var code(get,set):String;
public function  get_code():String
        {
            return this._codeInput.text;
        }
public function  set_code(value:String):String        {
            this._codeInput.text = value == null ? "" : value;
return value;
        }

        
        public var probabilityText(get,set):String;
public function  get_probabilityText():String
        {
            return this._probabilityInput.text;
        }
public function  set_probabilityText(value:String):String        {
            this._probabilityInput.text = value == null ? "" : value;
return value;
        }

        
        public var isBadge(get,set):Bool;
public function  get_isBadge():Bool
        {
            return this._badgeCheckbox.Selected;
        }
public function  set_isBadge(value:Bool):Bool        {
            Util.select(this._badgeCheckbox, value);
return value;
        }

        public function clear()
        {
            this.code = "";
            this.probabilityText = "";
            this.isBadge = false;
        }

        public function setProbabilityEnabled(value:Bool)
        {
            this._probabilityEnabled = value;
            this._probabilityInput.disabled = !value;
        }

        override public function resizeToWidth(width:Int)
        {
            super.resizeToWidth(width);
            this._container.width = width;
            this._row.resizeToWidth(width);
            this._container.height = this._row.window.height;
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._row];
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
            this._row = null;
            this._badgeCheckbox = null;
            this._codeInput = null;
            this._probabilityInput = null;
        }
    }

