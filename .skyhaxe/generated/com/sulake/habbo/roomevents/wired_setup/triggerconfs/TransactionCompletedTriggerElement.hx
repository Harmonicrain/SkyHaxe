package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July trigger 25: a selected contract transaction completed. */
     class TransactionCompletedTriggerElement extends DefaultElement
    {
        override public function  get_code():Int { return WiredTriggerType.TRANSACTION_COMPLETED; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.CONTRACTS;
        }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            builder.addElements([manager.createUsageInfoSection(
                "${wiredfurni.params.transaction_complete.usage_info}")]);
        }

	public function new() { super(); }
    }

