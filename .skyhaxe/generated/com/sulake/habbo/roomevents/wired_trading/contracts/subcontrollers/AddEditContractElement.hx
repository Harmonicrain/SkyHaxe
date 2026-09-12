package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleEditorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ItemTypeSelectionSection;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.session.furniture.IFurnitureData;

     class AddEditContractElement extends AbstractUbuntuWiredUI
    {
        public static inline final MAX_COINS= 100000;
        public static inline final MAX_FURNI= 500;

        var _parent:WiredContractController;
        var _type:RadioGroupPreset;
        var _amount:NumberInputPreset;
        var _itemSelection:ItemTypeSelectionSection;
        var _isEditMode:Bool = false;
        var _editor:TradeRuleEditorPreset;
        var _uniqueId:Int = -1;

        public function new(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
            this._type = presetManager.createRadioGroup([
                new RadioButtonParam(0, "${wiredcontracts.element.type.0}"),
                new RadioButtonParam(1, "${wiredcontracts.element.type.1}")
            ], this.onElementTypeChange);
            var typeSection= presetManager.createSection(
                "${wiredcontracts.element.type}", this._type);
            this._amount = presetManager.createNumberInput(
                new NumberInputParam(1, 1, MAX_COINS, 80));
            var amountSection= presetManager.createSection(
                "${wiredcontracts.element.amount}", this._amount);
            var header=
                presetManager.createHorizontalSectionListPreset(
                    [typeSection, amountSection]);
            this._itemSelection = presetManager.createItemTypeSelectionSection();
            this.framePreset = presetManager.createFramePreset(
                [header, this._itemSelection, this.footerPreset],
                this.onCloseClicked);
            this.framePreset.resizeToWidth(420);
        }

        override function  get_isRememberLocation():Bool { return true; }
        override function  get_isBoundToParentRect():Bool { return true; }
        override public function  get_xOffsetFromCenter():Int { return 375; }

        function onElementTypeChange(value:Int)
        {
            this._itemSelection.disabled = value != TradeRequirementNode.TYPE_FURNI;
        }

        public var isEditMode(never,set):Bool;
public function  set_isEditMode(value:Bool):Bool        {
            this._isEditMode = value;
            this.framePreset.title = value
                ? "${wiredcontracts.edit_element.title}"
                : "${wiredcontracts.add_element.title}";
return value;
        }

        public function onEdit(editor:TradeRuleEditorPreset, uniqueId:Int,
            node:TradeRequirementNode)
        {
            this.isEditMode = true;
            this._editor = editor;
            this._uniqueId = uniqueId;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
            this._itemSelection.resetInteractions();
            this._itemSelection.selectedItem = node.itemType;
            this._type.selected = node.type;
            this._amount.value = node.amount;
            this.onElementTypeChange(node.type);
            this.showFrame();
        }

        public function onAdd(editor:TradeRuleEditorPreset)
        {
            this.isEditMode = false;
            this._editor = editor;
            this._uniqueId = -1;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
            this._itemSelection.resetInteractions();
            this._itemSelection.selectedItem = null;
            this._type.selected = TradeRequirementNode.TYPE_COIN;
            this._amount.value = 1;
            this.onElementTypeChange(TradeRequirementNode.TYPE_COIN);
            this.showFrame();
        }

        function createNode():TradeRequirementNode
        {
            return new TradeRequirementNode(this._type.selected, this._amount.value,
                this._type.selected == TradeRequirementNode.TYPE_FURNI
                    ? this._itemSelection.selectedItem : null);
        }

        override public function onSaveClicked()
        {
            var error= this.validate();
            if (error != null)
            {
                this.roomEvents.windowManager.alert(
                    "${wiredfurni.error.title}", error, 0, null);
                return;
            }
            if (this._isEditMode)
                this._editor.updateNode(this._uniqueId, this.createNode());
            else
                this._editor.addNode(this.createNode());
            this._editor = null;
            this._uniqueId = -1;
            this.hideFrame();
        }

        function validate():String
        {
var data:IFurnitureData  = null;            if (this._type.selected == TradeRequirementNode.TYPE_FURNI &&
                this._amount.value > MAX_FURNI)
            {
                return this.localization.getLocalizationWithParams(
                    "wiredcontracts.element.too_many_items", "",
                    ["amount", MAX_FURNI]);
            }
            if (this._type.selected == TradeRequirementNode.TYPE_FURNI)
            {
data=
                    this._itemSelection.furniDataForSelectedItem;
                if (data == null || !data.tradeable)
                    return "${wiredcontracts.element.item_not_allowed}";
            }
            return null;
        }

        override public function dispose()
        {
            if (disposed) return;
            this._type = null;
            this._amount = null;
            this._itemSelection = null;
            this._editor = null;
            this._parent = null;
            super.dispose();
        }
    }

