package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.IconButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.MiniAssetIconButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.AbstractSectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class InputSourceSection extends AbstractSectionPreset implements ISourceTypeListener
    {
        var _preset:WiredUIPreset;
        var _listPreset:SimpleListViewPreset;
        var _textPreset:TextPreset;
        var _picker:WiredInputSourcePicker;
        var _leftButton:IconButtonPreset;
        var _rightButton:IconButtonPreset;
        var _furniPicking1Button:MiniAssetIconButtonPreset;
        var _furniPicking2Button:MiniAssetIconButtonPreset;

        public function new(k:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:Int, _arg_6:Int, _arg_7:Array<ASAny>, _arg_8:Bool = false, _arg_9:Bool = false)
        {
            var param:SectionParam = null;
            super(k, _arg_2, _arg_3);
            this._picker = new WiredInputSourcePicker(k, _arg_5, _arg_6);
            this._leftButton = _arg_2.createIconButtonPreset("left", this.onPrevious);
            this._textPreset = _arg_2.createText("", new TextParam(1, false, 0, false, "center"));
            this._rightButton = _arg_2.createIconButtonPreset("right", this.onNext);
            this._listPreset = _arg_2.createSimpleListView(false, [this._leftButton, this._textPreset, this._rightButton], true);
            this._listPreset.minHeight = _arg_3.inputSourceListMinHeight;
            this._listPreset.spacing = _arg_3.LRContainerSpacing;
            this._preset = _arg_2.createPaddedContainerPreset(this._listPreset, _arg_3.LRContainerMargin, _arg_3.LRContainerTopBottomPadding, _arg_3.LRContainerMargin, _arg_3.LRContainerTopBottomPadding);
            if (_arg_5 == WiredInputSourcePicker.MERGED_SOURCE && !_arg_8)
            {
                param = new SectionParam(new SourceTypeSelectorParam(_arg_7, this));
            }
            if (_arg_9)
            {
                if (param == null)
                {
                    param = new SectionParam();
                }
                this._furniPicking1Button = _arg_2.createMiniAssetIconButtonPreset("furni_picks_1", "${wiredfurni.params.furni_picking.tooltip}", this.onFurniPicks1Clicked);
                this._furniPicking2Button = _arg_2.createMiniAssetIconButtonPreset("furni_picks_2", "${wiredfurni.params.furni_picking.tooltip}", this.onFurniPicks2Clicked);
                param.addHeaderOption(this._furniPicking1Button);
                param.addHeaderOption(this._furniPicking2Button);
            }
            initializeSection(_arg_4, this._preset, param);
        }

        function onFurniPicks1Clicked()
        {
            this._roomEvents.wiredCtrl.activeFurniPicks = 1;
        }

        function onFurniPicks2Clicked()
        {
            this._roomEvents.wiredCtrl.activeFurniPicks = 2;
        }

        public function activeFurniPicksChanged()
        {
            if ((this._furniPicking1Button != null) && this._furniPicking1Button.visible)
            {
                this._furniPicking1Button.selected = this._roomEvents.wiredCtrl.activeFurniPicks == 1;
            }
            else if ((this._furniPicking2Button != null) && this._furniPicking2Button.visible)
            {
                this._furniPicking2Button.selected = this._roomEvents.wiredCtrl.activeFurniPicks == 2;
            }
        }

        function onPrevious()
        {
            this._picker.onChangeInputSource(false);
            this.updateUI();
        }

        function onNext()
        {
            this._picker.onChangeInputSource(true);
            this.updateUI();
        }

        public function refresh(k:Triggerable, _arg_2:IWiredElement)
        {
            this._picker.refreshContainer(k, _arg_2);
            this.updateUI();
        }

        public function updateUI()
        {
            this.disabled = this._picker.disabled;
            this._leftButton.disabled = this._picker.isButtonsDisabled;
            this._rightButton.disabled = this._picker.isButtonsDisabled;
            this._textPreset.text = this._picker.selectedText;
            if ((this._furniPicking1Button != null) && (this._furniPicking2Button != null))
            {
                switch (this._picker.stuffPickingSpecialMode)
                {
                    case WiredInputSourcePicker.STUFF_PICKING_MODE_1:
                        this._furniPicking1Button.visible = true;
                        this._furniPicking2Button.visible = false;
                        this._furniPicking1Button.selected = this._roomEvents.wiredCtrl.activeFurniPicks == 1;
                        
                    case WiredInputSourcePicker.STUFF_PICKING_MODE_2:
                        this._furniPicking1Button.visible = false;
                        this._furniPicking2Button.visible = true;
                        this._furniPicking2Button.selected = this._roomEvents.wiredCtrl.activeFurniPicks == 2;
                        
                    default:
                        this._furniPicking1Button.visible = false;
                        this._furniPicking2Button.visible = false;
                }
            }
            this._section.refreshAlignments();
        }

        public var baseSourceType(get,never):Int;
public function  get_baseSourceType():Int
        {
            return this._picker.sourceType;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._picker.id;
        }

        public var sourceType(never,set):Int;
public function  set_sourceType(k:Int):Int        {
            this._picker.sourceType = k;
            var selector= this.getSourceTypeSelector();
            if (selector != null)
            {
                selector.select(k);
            }
            this.updateUI();
return k;
        }

        override function  get_childPresets():Array<ASAny>
        {
            var presets:Array<ASAny> = [this._preset, this._listPreset, this._textPreset, this._leftButton, this._rightButton];
            if (this._furniPicking1Button != null)
            {
                presets.push(this._furniPicking1Button);
            }
            if (this._furniPicking2Button != null)
            {
                presets.push(this._furniPicking2Button);
            }
            return presets;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._preset = null;
            this._listPreset = null;
            this._textPreset = null;
            this._picker.dispose();
            this._picker = null;
            this._leftButton = null;
            this._rightButton = null;
            this._furniPicking1Button = null;
            this._furniPicking2Button = null;
        }
    }

