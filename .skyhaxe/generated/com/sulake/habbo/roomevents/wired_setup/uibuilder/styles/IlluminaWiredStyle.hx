package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

     class IlluminaWiredStyle extends WiredStyle
    {
        public static inline final NAME= "illumina";

        var _styleTemplate:IWindowContainer;

        public function new(_arg_1:HabboUserDefinedRoomEvents)
        {
            super(_arg_1);
            this._styleTemplate = cast(_arg_1.getXmlWindow("wired_style_illumina"), IWindowContainer);
            if (this._styleTemplate != null && this._styleTemplate.parent != null)
            {
                this._styleTemplate.parent = null;
            }
        }

        override function  get_styleTemplate():IWindowContainer
        {
            return this._styleTemplate;
        }

        override public function  get_radioButtonSpacing():Int { return 3; }
        override public function  get_checkboxSpacing():Int { return 3; }
        override public function  get_checkboxYOffset():Int { return 2; }
        override public function  get_namedInputOffset():Int { return 2; }
        override public function  get_namedDropdownOffset():Int { return 2; }
        override public function  get_radioButtonYOffset():Int { return 0; }
        override public function  get_namedTextYOffset():Int { return 0; }
        override public function  get_genericHorizontalSpacing():Int { return 5; }
        override public function  get_genericVerticalSpacing():Int { return 5; }
        override public function  get_sectionSpacing():Int { return 5; }
        override public function  get_sectionLeftRightMargin():Int { return 5; }
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
        override public function  get_verticalSplitterColor():UInt { return 0xFFAAAAAA; }
        override public function  get_frameColor():UInt { return 0xE2E2E2; }
        override public function  get_backgroundColor():UInt { return frameColor; }
        override public function  get_advancedBackgroundColor():UInt { return 0xCCCCCC; }
        override public function  get_yellowTextColor():UInt { return 0x727514; }
        override public function  get_softTextColor():UInt { return 0x444444; }
        override public function  get_redTextColor():UInt { return 0xED3033; }
        override public function  get_name():String { return NAME; }
    }

