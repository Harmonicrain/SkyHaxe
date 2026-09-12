package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /**
     * Wired 2.0 visual style base (May WiredStyle). Layout metrics return defaults;
     * concrete styles override them and provide the XML style template whose named
     * children are cloned out by the create* factories.
     */
     class WiredStyle
    {
        var _roomEvents:HabboUserDefinedRoomEvents;

        public function new(_arg_1:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_1;
        }

        var styleTemplate(get,never):IWindowContainer;
function  get_styleTemplate():IWindowContainer
        {
            return null;
        }

        public var radioButtonSpacing(get,never):Int;
public function  get_radioButtonSpacing():Int { return 0; }
        public var checkboxSpacing(get,never):Int;
public function  get_checkboxSpacing():Int { return 0; }
        public var checkboxYOffset(get,never):Int;
public function  get_checkboxYOffset():Int { return 0; }
        public var radioButtonYOffset(get,never):Int;
public function  get_radioButtonYOffset():Int { return 0; }
        public var namedTextYOffset(get,never):Int;
public function  get_namedTextYOffset():Int { return 0; }
        public var namedInputOffset(get,never):Int;
public function  get_namedInputOffset():Int { return 0; }
        public var namedDropdownOffset(get,never):Int;
public function  get_namedDropdownOffset():Int { return 0; }
        public var genericHorizontalSpacing(get,never):Int;
public function  get_genericHorizontalSpacing():Int { return 0; }
        public var genericVerticalSpacing(get,never):Int;
public function  get_genericVerticalSpacing():Int { return 0; }
        public var sectionSpacing(get,never):Int;
public function  get_sectionSpacing():Int { return 0; }
        public var sectionLeftRightMargin(get,never):Int;
public function  get_sectionLeftRightMargin():Int { return 0; }
        public var headerMargin(get,never):Int;
public function  get_headerMargin():Int { return 0; }
        public var headerBottomMarginWithLink(get,never):Int;
public function  get_headerBottomMarginWithLink():Int { return 0; }
        public var headerNameFontSize(get,never):Int;
public function  get_headerNameFontSize():Int { return 0; }
        public var frameColor(get,never):UInt;
public function  get_frameColor():UInt { return 0; }
        public var backgroundColor(get,never):UInt;
public function  get_backgroundColor():UInt { return 0; }
        public var advancedBackgroundColor(get,never):UInt;
public function  get_advancedBackgroundColor():UInt { return 0; }
        public var yellowTextColor(get,never):UInt;
public function  get_yellowTextColor():UInt { return 0; }
        public var softTextColor(get,never):UInt;
public function  get_softTextColor():UInt { return 0; }
        public var redTextColor(get,never):UInt;
public function  get_redTextColor():UInt { return 0; }
        public var minimumOptionHeight(get,never):Int;
public function  get_minimumOptionHeight():Int { return 0; }
        public var minimumOptionSpacing(get,never):Int;
public function  get_minimumOptionSpacing():Int { return 0; }
        public var optionExtraUnderSpacing(get,never):Int;
public function  get_optionExtraUnderSpacing():Int { return 0; }
        public var optionExtraUnderLeftMargin(get,never):Int;
public function  get_optionExtraUnderLeftMargin():Int { return 0; }
        public var LRContainerMargin(get,never):Int;
public function  get_LRContainerMargin():Int { return 0; }
        public var LRContainerSpacing(get,never):Int;
public function  get_LRContainerSpacing():Int { return 0; }
        public var LRContainerTopBottomPadding(get,never):Int;
public function  get_LRContainerTopBottomPadding():Int { return 0; }
        public var inputSourceListMinHeight(get,never):Int;
public function  get_inputSourceListMinHeight():Int { return 0; }
        public var buttonRowSpacing(get,never):Int;
public function  get_buttonRowSpacing():Int { return 0; }
        public var menuRightOffset(get,never):Int;
public function  get_menuRightOffset():Int { return 0; }
        public var verticalSplitterColor(get,never):UInt;
public function  get_verticalSplitterColor():UInt { return 0; }
        public var name(get,never):String;
public function  get_name():String { return ""; }
        public var isVolter(get,never):Bool;
public function  get_isVolter():Bool { return false; }
        public var useInnerBorder(get,never):Bool;
public function  get_useInnerBorder():Bool { return false; }
        public var containerButtonPaddingTop(get,never):Int;
public function  get_containerButtonPaddingTop():Int { return 0; }
        public var containerButtonPaddingLeft(get,never):Int;
public function  get_containerButtonPaddingLeft():Int { return 0; }
        public var paddedSectionTop(get,never):Int;
public function  get_paddedSectionTop():Int { return 0; }
        public var paddedSectionLeft(get,never):Int;
public function  get_paddedSectionLeft():Int { return 0; }

        public function createSplitterView():IWindowContainer
        {
            return Std.downcast(this.recreateElement("ruler_view") , IWindowContainer);
        }

        public function createSplitterVerticalView():IWindowContainer
        {
            return Std.downcast(this.recreateElement("ruler_view_vertical") , IWindowContainer);
        }

        public function createTextView(_arg_1:Bool = true):ITextWindow
        {
            return Std.downcast(this.recreateElement(_arg_1 ? "text_bold_view" : "text_view") , ITextWindow);
        }

        public function createHtmlView():IHTMLTextWindow
        {
            return Std.downcast(this.recreateElement("text_html") , IHTMLTextWindow);
        }

        public function createTextInputView():IWindow
        {
            return this.recreateElement("input_template");
        }

        public function createCheckboxView():ICheckBoxWindow
        {
            return Std.downcast(this.recreateElement("checkbox_view") , ICheckBoxWindow);
        }

        public function createRadioButtonView():IRadioButtonWindow
        {
            return Std.downcast(this.recreateElement("radiobutton_view") , IRadioButtonWindow);
        }

        public function createExpandCollapseSectionRegion():IRegionWindow
        {
            return Std.downcast(this.recreateElement("expand_collapse_region") , IRegionWindow);
        }

        public function createSourceTypeSelector():IItemListWindow
        {
            return Std.downcast(this.recreateElement("sourcetype_selector_view") , IItemListWindow);
        }

        public function createDropdown():IDropMenuWindow
        {
            return Std.downcast(this.recreateElement("dropdown_view") , IDropMenuWindow);
        }

        public function createSlider():IWindowContainer
        {
            return Std.downcast(this.recreateElement("slider") , IWindowContainer);
        }

        public function createButton():IButtonWindow
        {
            return Std.downcast(this.recreateElement("button") , IButtonWindow);
        }

        public function createAssetButton():IContainerButtonWindow
        {
            return Std.downcast(this.recreateElement("asset_button") , IContainerButtonWindow);
        }

        public function createIconButton(_arg_1:String):IWindow
        {
            return this.recreateElement("iconbutton_" + _arg_1);
        }

        public function createMiniButton():IWindow
        {
            return this.recreateElement("mini_button_view");
        }

        public function createFrame():IFrameWindow
        {
            return Std.downcast(this.recreateElement("frame") , IFrameWindow);
        }

        public function createQuickMenu():IWindowContainer
        {
            return Std.downcast(this.recreateElement("quick_menu") , IWindowContainer);
        }

        public function createInnerBorder():IBorderWindow
        {
            return Std.downcast(this.recreateElement("inner_border") , IBorderWindow);
        }

        public function createBorder():IBorderWindow
        {
            return Std.downcast(this.recreateElement("border") , IBorderWindow);
        }

        public function createContainerButton():IContainerButtonWindow
        {
            return Std.downcast(this.recreateElement("container_button") , IContainerButtonWindow);
        }

        public function createTradeRequirementRule():IBorderWindow
        {
            return Std.downcast(this.recreateElement("requirement_rule") , IBorderWindow);
        }

        public function createProductIconPreviewer():IBorderWindow
        {
            return Std.downcast(this.recreateElement("product_icon_previewer") , IBorderWindow);
        }

        function recreateElement(_arg_1:String):IWindow
        {
            var _local_2= this.styleTemplate.findChildByName(_arg_1);
            _local_2 = _local_2.clone();
            _local_2.visible = true;
            return _local_2;
        }
    }

