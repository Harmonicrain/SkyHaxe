package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.ChestItemIconPreviewerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.ItemTypeSelectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.session.furniture.IFurnitureData;

     class ItemTypeSelectionSection extends AbstractSectionPreset
    {
        var _selection:ItemTypeSelectionPreset;
        var _preview:ChestItemIconPreviewerPreset;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._selection = presetManager.createItemTypeSelectionPreset();
            this._preview = presetManager.createChestItemIconPreviewerPreset();
            var params= new SectionParam();
            params.addHeaderOption(this._preview.floatVertically());
            this.initializeSection("${wiredcontracts.element.itemtype.selection}",
                this._selection, params);
            this._selection.addListener(this.onChangeItemType);
        }

        function onChangeItemType(value:ChestItemType)
        {
            this._preview.item = value;
        }

                public var selectedItem(get,set):ChestItemType;
public function  get_selectedItem():ChestItemType { return this._selection.selectedItem; }
        public var furniDataForSelectedItem(get,never):IFurnitureData;
public function  get_furniDataForSelectedItem():IFurnitureData { return this._selection.furniDataForSelectedItem; }
        public function resetInteractions() { this._selection.resetInteractions(); }
public function  set_selectedItem(value:ChestItemType):ChestItemType{ return this._selection.selectedItem = value; }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._selection = null;
            this._preview = null;
        }
    }

