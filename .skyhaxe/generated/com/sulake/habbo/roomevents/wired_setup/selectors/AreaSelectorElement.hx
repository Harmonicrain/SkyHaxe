package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.room.IRoomAreaSelectionManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class AreaSelectorElement extends DefaultElement
    {
        var _code:Int = 0;
        var _areaSelectionManager:IRoomAreaSelectionManager;
        var _x:Int = 0;
        var _y:Int = 0;
        var _width:Int = 0;
        var _height:Int = 0;
        var _active:Bool = false;
        var _selectButton:ButtonPreset;
        var _clearButton:ButtonPreset;
        var _selectWindow:IButtonWindow;
        var _clearWindow:IButtonWindow;

        public function new(k:Int)
        {
            super();
            this._code = k;
        }

        static function enableButton(k:IButtonWindow, _arg_2:Bool)
        {
            if (k == null)
            {
                return;
            }
            if (_arg_2)
            {
                k.enable();
            }
            else
            {
                k.disable();
            }
        }

        override public function  get_code():Int
        {
            return this._code;
        }

        override public function onInit(k:HabboUserDefinedRoomEvents)
        {
            super.onInit(k);
            this._areaSelectionManager = k.roomEngine.areaSelectionManager;
        }

        override public function onEditStart(k:Triggerable)
        {
            if ((!this._active) && (this._areaSelectionManager != null))
            {
                this._active = this._areaSelectionManager.activate(this.onAreaSelected, "highlight_brighten");
            }
            this._x = ASCompat.toInt((k.intData.length > 0) ? ASCompat.toInt(k.intData[0] ): 0);
            this._y = ASCompat.toInt((k.intData.length > 1) ? ASCompat.toInt(k.intData[1] ): 0);
            this._width = ASCompat.toInt((k.intData.length > 2) ? ASCompat.toInt(k.intData[2] ): 0);
            this._height = ASCompat.toInt((k.intData.length > 3) ? ASCompat.toInt(k.intData[3] ): 0);
            if (this._active)
            {
                this._areaSelectionManager.setHighlight(this._x, this._y, this._width, this._height);
                enableButton(this._selectWindow, true);
                enableButton(this._clearWindow, true);
            }
            else
            {
                enableButton(this._selectWindow, false);
                enableButton(this._clearWindow, false);
            }
        }

        override public function onEditEnd()
        {
            super.onEditEnd();
            if (this._active && (this._areaSelectionManager != null))
            {
                this._areaSelectionManager.deactivate();
                this._active = false;
            }
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._x, this._y, this._width, this._height];
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(k:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            var _local_4= new TextParam(1);
            _local_4.textColor = _arg_2.softTextColor;
            var _local_5= k.createText(l("area_selection.info"), _local_4);
            this._selectButton = k.createButton(l("area_selection.select"), this.onSelect);
            this._clearButton = k.createButton(l("area_selection.clear"), this.onClear);
            var _local_6= k.createButtonRow([this._selectButton, this._clearButton]);
            var _local_7= k.createSection(l("area_selection"), k.createSimpleListView(true, [_local_5, _local_6]));
            _arg_3.addElements([_local_7]);
            this._selectWindow = Std.downcast(this._selectButton.window , IButtonWindow);
            this._clearWindow = Std.downcast(this._clearButton.window , IButtonWindow);
        }

        function onSelect()
        {
            enableButton(this._selectWindow, false);
            if (this._areaSelectionManager != null)
            {
                this._areaSelectionManager.startSelecting();
            }
        }

        function onClear()
        {
            if (this._areaSelectionManager != null)
            {
                this._areaSelectionManager.clearHighlight();
            }
        }

        function onAreaSelected(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            enableButton(this._selectWindow, true);
            this._x = k;
            this._y = _arg_2;
            this._width = _arg_3;
            this._height = _arg_4;
        }
    }

