package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.NeighborhoodFloor;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.SpiralUtils;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.AssetButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.AssetButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.FloorDrawingPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.FloorEditorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;

    /** Shared May 2026 neighbourhood editor for furni and user selectors. */
     class InNeighborhoodSelectorElement extends DefaultElement
    {
        static final DRAW_MODES:Array<ASAny> = ["add_tile", "remove_tile", "set_root_tile"];

        var _drawMode:String = DRAW_MODES[0];
        var _rootTile:Point;
        var _floor:NeighborhoodFloor;
        var _useUserSource:Bool = false;
        var _floorEditorPreset:FloorEditorPreset;
        var _floorDrawingPreset:FloorDrawingPreset;
        var _rootXInput:NamedNumberInputPreset;
        var _rootYInput:NamedNumberInputPreset;
        var _drawButtonsByMode:ASObject;
        var _preferBigMode:Bool = false;
        var _inBigMode:Bool = false;
        var _resolutionButton:AssetButtonPreset;

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function onInit(roomEvents:HabboUserDefinedRoomEvents)
        {
            super.onInit(roomEvents);
            this.setRootTileInternal(0, 0, false);
            this._floor = new NeighborhoodFloor(
                SpiralUtils.parseSpiralVector([], NeighborhoodFloor.RADIUS),
                !this._preferBigMode,
                this.onDrawingChanged);
        }

        override public function onEditStart(triggerable:Triggerable)
        {
            this._inBigMode = this._preferBigMode;
            this._useUserSource = triggerable.intData.length > 0 && triggerable.intData[0] != 0;
            this.setRootTileInternal(
                ASCompat.toInt(triggerable.intData.length > 1 ? ASCompat.toInt(triggerable.intData[1] ): 0),
                ASCompat.toInt(triggerable.intData.length > 2 ? ASCompat.toInt(triggerable.intData[2] ): 0),
                true);
            this.setMode(DRAW_MODES[0]);
            this._floor = new NeighborhoodFloor(
                SpiralUtils.parseSpiralVector(triggerable.intData.slice(3), NeighborhoodFloor.RADIUS),
                !this._inBigMode,
                this.onDrawingChanged);
            if (!this._inBigMode && !this._floor.smallModeAllowed())
            {
                this._floor.smallMode = false;
                this._inBigMode = true;
            }
            if (this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setFloor(this._floor);
                this._floorDrawingPreset.setRootTile(Std.int(this._rootTile.x), Std.int(this._rootTile.y));
                this._floorDrawingPreset.setMode(this._drawMode);
            }
            this.updateResolutionButtonUI();
            this.roomEvents.wiredCtrl.resizeFrame();
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var result:Array<ASAny> = [this._useUserSource ? 1 : 0, Std.int(this._rootTile.x), Std.int(this._rootTile.y)];
            return result.concat(SpiralUtils.createSpiralVector(this._floor.floorPlanCache, NeighborhoodFloor.RADIUS));
        }

        override public function mergedSelections():Array<ASAny>
        {
            return [([0, 0] : Array<Dynamic>)];
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.neighborhood";
        }

        override public function setMergedType(index:Int, sourceType:Int)
        {
            this._useUserSource = sourceType == WiredInputSourcePicker.USER_SOURCE;
        }

        override public function getMergedType(index:Int):Int
        {
            return this._useUserSource ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE;
        }

        override public function  get_forceHidePickFurniInstructions():Bool
        {
            return true;
        }

        override public function advancedAlwaysVisible():Bool
        {
            return true;
        }

        override public function buildInputs(presets:PresetManager, style:WiredStyle, builder:WiredUIBuilder)
        {
var             i = 0;            var buttonConfigs:Array<ASAny> = [
                new AssetButtonParam("add", "", function() { setMode(DRAW_MODES[0]); }),
                new AssetButtonParam("remove", "", function() { setMode(DRAW_MODES[1]); }, true),
                new AssetButtonParam("reference", "", function() { setMode(DRAW_MODES[2]); }),
                new AssetButtonParam("enlarge_image", "", this.toggleScreenSize, false, true)
            ];
            var buttonRow= presets.createAssetButtonRow(buttonConfigs);
            this._floorDrawingPreset = presets.createFloorDrawingPreset(this.onRootTileChangedFromPreset);
            this._floorEditorPreset = presets.createFloorEditorPreset(buttonRow, this._floorDrawingPreset);
            this._resolutionButton = buttonRow.buttons[3];
            if (this._floor != null)
            {
                this._floorDrawingPreset.setFloor(this._floor);
                this._floorDrawingPreset.setRootTile(Std.int(this._rootTile.x), Std.int(this._rootTile.y));
                this._floorDrawingPreset.setMode(this._drawMode);
            }

            this._rootXInput = presets.createNamedNumberInput(new NumberInputParam(0, -64, 64, 20), "x:");
            this._rootYInput = presets.createNamedNumberInput(new NumberInputParam(0, -64, 64, 20), "y:");
            this._rootXInput.onValueChange = this.onRootXChanged;
            this._rootYInput.onValueChange = this.onRootYChanged;
            var xyRow= presets.createSimpleListView(false, [this._rootXInput, this._rootYInput]);
            xyRow.spacing = style.genericHorizontalSpacing;

            this._drawButtonsByMode = {};
            var createdButtons= buttonRow.buttons;
            i= 0;while (i < DRAW_MODES.length && i < createdButtons.length)
            {
                this._drawButtonsByMode[DRAW_MODES[i]] = createdButtons[i];
i++;
            }
            this.setMode(this._drawMode);

            var list= presets.createSimpleListView(true, [this._floorEditorPreset, xyRow.alignRight()]);
            var section= presets.createSection(l("neighborhood_selection"), list);
            builder.addElements([section]);
        }

        override public function  get_widthModifier():Float
        {
            return this._inBigMode ? 1.7 : 1;
        }

        function setMode(mode:String)
        {
var drawMode:String  = null, button:AssetButtonPreset  = null;            this._drawMode = mode;
            if (this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setMode(mode);
            }
            if (this._drawButtonsByMode == null)
            {
                return;
            }
            final _iter_ = DRAW_MODES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
drawMode = _tmp_;
button= ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._drawButtonsByMode, drawMode), AssetButtonPreset);
                if (button != null)
                {
                    button.selected = drawMode == mode;
                }
            }
        }

        function updateResolutionButtonUI()
        {
            if (this._resolutionButton == null || this._floor == null)
            {
                return;
            }
            this._resolutionButton.disabled = !this._floor.smallModeAllowed();
            this._resolutionButton.assetName = this._inBigMode ? "reduce_image" : "enlarge_image";
        }

        function updateRootInputText()
        {
            if (this._rootXInput != null)
            {
                this._rootXInput.value = Std.int(this._rootTile.x);
            }
            if (this._rootYInput != null)
            {
                this._rootYInput.value = Std.int(this._rootTile.y);
            }
        }

        function setRootTileInternal(x:Int, y:Int, updateDrawing:Bool)
        {
            if (this._rootTile == null)
            {
                this._rootTile = new Point(x, y);
            }
            else
            {
                this._rootTile.x = x;
                this._rootTile.y = y;
            }
            this.updateRootInputText();
            if (updateDrawing && this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setRootTile(x, y);
            }
        }

        function onRootXChanged(value:Int)
        {
            this.setRootTileInternal(value, Std.int(this._rootTile.y), true);
        }

        function onRootYChanged(value:Int)
        {
            this.setRootTileInternal(Std.int(this._rootTile.x), value, true);
        }

        function onRootTileChangedFromPreset(x:Int, y:Int)
        {
            this.setRootTileInternal(x, y, false);
        }

        function toggleScreenSize()
        {
            if (this._floor == null || this._floorDrawingPreset == null)
            {
                return;
            }
            this._inBigMode = !this._inBigMode;
            this._preferBigMode = this._inBigMode;
            this._floor.smallMode = !this._inBigMode;
            this._floorDrawingPreset.setFloor(this._floor);
            this.updateResolutionButtonUI();
            this.roomEvents.wiredCtrl.resizeFrame();
        }

        function onDrawingChanged()
        {
            this.updateResolutionButtonUI();
        }

	public function new() { super(); }
    }

