package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /** July's dedicated style for Wired trading, contracts and reward dialogs. */
     class UbuntuWiredStyle extends WiredStyle
    {
        public static inline final NAME= "ubuntu";

        var _template:IWindowContainer;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            super(roomEvents);
            this._template = Std.downcast(roomEvents.getXmlWindow("wired_style_ubuntu") , IWindowContainer);
            if (this._template != null && this._template.parent != null)
            {
                this._template.parent = null;
            }
        }

        override function  get_styleTemplate():IWindowContainer { return this._template; }
        override public function  get_radioButtonSpacing():Int { return 3; }
        override public function  get_checkboxSpacing():Int { return 3; }
        override public function  get_checkboxYOffset():Int { return -1; }
        override public function  get_radioButtonYOffset():Int { return -1; }
        override public function  get_namedTextYOffset():Int { return 2; }
        override public function  get_genericHorizontalSpacing():Int { return 5; }
        override public function  get_genericVerticalSpacing():Int { return 5; }
        override public function  get_sectionSpacing():Int { return 7; }
        override public function  get_sectionLeftRightMargin():Int { return 7; }
        override public function  get_headerMargin():Int { return 5; }
        override public function  get_headerBottomMarginWithLink():Int { return 1; }
        override public function  get_headerNameFontSize():Int { return 12; }
        override public function  get_minimumOptionHeight():Int { return 20; }
        override public function  get_minimumOptionSpacing():Int { return 4; }
        override public function  get_optionExtraUnderSpacing():Int { return 3; }
        override public function  get_optionExtraUnderLeftMargin():Int { return 25; }
        override public function  get_LRContainerMargin():Int { return 9; }
        override public function  get_LRContainerSpacing():Int { return 6; }
        override public function  get_LRContainerTopBottomPadding():Int { return 4; }
        override public function  get_inputSourceListMinHeight():Int { return 23; }
        override public function  get_buttonRowSpacing():Int { return 12; }
        override public function  get_menuRightOffset():Int { return 12; }
        override public function  get_frameColor():UInt { return 4296112; }
        override public function  get_backgroundColor():UInt { return 15329761; }
        override public function  get_advancedBackgroundColor():UInt { return 14277073; }
        override public function  get_yellowTextColor():UInt { return 8685354; }
        override public function  get_softTextColor():UInt { return 3355443; }
        override public function  get_redTextColor():UInt { return 16069173; }
        override public function  get_containerButtonPaddingLeft():Int { return 10; }
        override public function  get_containerButtonPaddingTop():Int { return 5; }
        override public function  get_paddedSectionTop():Int { return 10; }
        override public function  get_paddedSectionLeft():Int { return 5; }
        override public function  get_name():String { return NAME; }
    }

