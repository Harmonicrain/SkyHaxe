package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.MenuPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuItem;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * The real builder layout engine (May FramePreset): frame window, sticky
     * header/footer list composition, resize guard, fixHeight and close button.
     * The quick menu is attached to the clean frame's tagged header button while
     * save and close remain available through the footer and close control.
     */
     class FramePreset extends WiredUIPreset
    {
        var _frame:IFrameWindow;
        var _headerPreset:HeaderPreset;
        var _listPreset:IListPreset;
        var _onClose:ASFunction;
        var _holderKey:String;
        var _code:Int = 0;
        var _leftRightMargin:Int = 0;
        var _topBottomMargin:Int = 0;
        var _ignoreEvents:Bool = false;
        var _scrollParams:ListScrollParams;
        var _menu:MenuPreset;
        var _menuButton:IWindow;

        static inline final MENU_COPY= 0;
        static inline final MENU_PASTE= 1;
        static inline final MENU_COPY_INTO= 2;
        static inline final MENU_CLEAR_PICKS= 3;
        static inline final MENU_RESET= 4;
        static inline final MENU_OPEN_WIRED_MENU= 5;
        static inline final MENU_SAVE= 6;
        static inline final MENU_CLOSE= 7;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>, _arg_5:ASFunction, _arg_6:String, _arg_7:Int, _arg_8:Bool = false, _arg_9:Bool = false, _arg_10:ListScrollParams = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClose = _arg_5;
            this._holderKey = _arg_6;
            this._code = _arg_7;
            this._scrollParams = _arg_10;
            this._frame = _arg_3.createFrame();
            this._leftRightMargin = ((this._frame.width - this._frame.margins.right) + this._frame.margins.left);
            this._topBottomMargin = ((this._frame.height - this._frame.margins.bottom) + this._frame.margins.top);
            this.createListView(_arg_4);
            this._listPreset.window.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onContentsResized);
            this._frame.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseClicked);
            this._frame.content.addChild(this._listPreset.window);
            this._frame.color = _style.frameColor;
            if (_arg_8)
            {
                this._frame.setParamFlag(65536, true);
                this._frame.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onFrameResized);
            }
            if (_arg_9)
            {
                this._menuButton = this._frame.findChildByName("header_button_menu");
                if (this._menuButton != null)
                {
                    this._menuButton.visible = true;
                    this._menuButton.addEventListener(WindowMouseEvent.CLICK, this.onMenuButtonClick);
                    this.createMenuPreset();
                }
            }
        }

        function createListView(_arg_1:Array<ASAny>)
        {
            var _local_16:SpacerPreset = null;
            var _local_8 = 0;
            var _local_17:WiredUIPreset = null;
            var _local_2 = 0;
            var _local_13:SpacerPreset = null;
            var _local_4:SpacerPreset = null;
            var _local_11 = 0;
            var _local_3 = 0;
            var _local_5:ListScrollParams = null;
            var _local_15:IListPreset = null;
            var _local_6:Array<ASAny> = null;
            var _local_12= _style.sectionSpacing;
            var _local_10:Array<ASAny> = [];
            var _local_9:HeaderPreset = null;
            var _local_14:FooterPreset = null;
            var _local_7= _arg_1;
            if ((this._scrollParams != null) && this._scrollParams.stickyHeader && (_local_7.length > 0) && Std.is(_local_7[0] , HeaderPreset))
            {
                _local_9 = ASCompat.dynamicAs(_arg_1[0] , HeaderPreset);
                _local_7 = _arg_1.slice(1, _local_7.length);
            }
            if ((this._scrollParams != null) && this._scrollParams.stickyFooter && (_local_7.length > 0) && Std.is(_local_7[_local_7.length - 1] , FooterPreset))
            {
                _local_14 = ASCompat.dynamicAs(_local_7[_local_7.length - 1] , FooterPreset);
                _local_7 = _local_7.slice(0, (_local_7.length - 1));
            }
            _local_8 = 0;
            while (_local_8 < _local_7.length)
            {
                _local_17 = _local_7[_local_8];
                if (Std.is(_local_17 , HeaderPreset))
                {
                    this._headerPreset = Std.downcast(_local_17 , HeaderPreset);
                }
                _local_10.push(_local_17);
                if (_local_8 < (_local_7.length - 1))
                {
                    _local_16 = _presetManager.createSpacer(_local_12);
                    _local_17.blendSpacer = _local_16;
                    _local_10.push(_local_16);
                }
                _local_8++;
            }
            if (this._scrollParams != null)
            {
                if ((_local_9 != null) || (_local_14 != null))
                {
                    _local_2 = 0;
                    if (_local_9 != null)
                    {
                        _local_2 += (_local_9.window.height + _local_12);
                        _local_13 = _presetManager.createSpacer(_local_12);
                        _local_10.unshift(_local_13);
                    }
                    if (_local_14 != null)
                    {
                        _local_2 += (_local_14.window.height + _local_12);
                        _local_4 = _presetManager.createSpacer(_local_12);
                        _local_10.push(_local_4);
                    }
                    _local_11 = Std.int(Math.max(0, (this._scrollParams.minHeight - _local_2)));
                    _local_3 = Std.int(Math.max(_local_11, (this._scrollParams.maxHeight - _local_2)));
                    _local_5 = new ListScrollParams(this._scrollParams.alwaysShowScrollbar, _local_11, _local_3, false, false);
                    _local_15 = _presetManager.createScrollList(_local_10, _local_5);
                    _local_15.spacing = 0;
                    _local_6 = [];
                    if (_local_9 != null)
                    {
                        _local_6.push(_local_9);
                    }
                    _local_6.push(_local_15);
                    if (_local_14 != null)
                    {
                        _local_6.push(_local_14);
                    }
                    this._listPreset = _presetManager.createSimpleListView(true, _local_6);
                    this._listPreset.spacing = 0;
                    return;
                }
                this._listPreset = _presetManager.createScrollList(_local_10, this._scrollParams);
            }
            else
            {
                this._listPreset = _presetManager.createSimpleListView(true, _local_10);
            }
            this._listPreset.spacing = 0;
        }

        public var title(never,set):String;
public function  set_title(_arg_1:String):String        {
            return this._frame.caption = _arg_1;
        }

        public function refreshForNewTriggerable()
        {
            if (this._menu != null)
            {
                this._menu.setSelected(MENU_COPY_INTO, false);
                this.updateButtonDisabledStates();
            }
        }

        public function updateButtonDisabledStates()
        {
            if (this._menu == null) { return; }
            var ctrl:ASAny = this._roomEvents.wiredCtrl;
            this._menu.setDisabled(MENU_COPY, false);
            this._menu.setDisabled(MENU_PASTE, !ctrl.hasCurrentElementInClipboard());
            this._menu.setDisabled(MENU_COPY_INTO, false);
            this._menu.setDisabled(MENU_CLEAR_PICKS, ctrl.getStuffIds().length + ctrl.getStuffIds2().length == 0);
            this._menu.setDisabled(MENU_RESET, false);
            this._menu.setDisabled(MENU_SAVE, false);
            this._menu.setDisabled(MENU_CLOSE, false);
        }

        function onMenuButtonClick(_arg_1:WindowMouseEvent)
        {
            if (this._menu != null)
            {
                this.updateButtonDisabledStates();
                this._menu.requestOpen();
            }
        }

        function createMenuPreset()
        {
            this._menu = this._presetManager.createMenuPreset([
                new MenuItem("${wiredfurni.params.menu.copy}", this.onCopyConfigMenuClick, "${wiredfurni.params.menu.copy_paste.tooltip}"),
                new MenuItem("${wiredfurni.params.menu.paste}", this.onPasteConfigMenuClick, "${wiredfurni.params.menu.copy_paste.tooltip}"),
                new MenuItem("${wiredfurni.params.menu.paste_into}", null, "${wiredfurni.params.menu.paste_into.tooltip}", true),
                MenuPreset.SPACER,
                new MenuItem("${wiredfurni.params.menu.clear_picks}", this.onClearPicksMenuClick),
                new MenuItem("${wiredfurni.params.menu.reset}", this.onResetMenuClick),
                MenuPreset.SPACER,
                new MenuItem("${wiredfurni.params.menu.open_wired_menu}", this.onOpenWiredMenuClick),
                new MenuItem("${wiredfurni.params.menu.save}", this.onSaveMenuClick, "${wiredfurni.params.menu.save.tooltip}"),
                new MenuItem("${wiredfurni.params.menu.close}", this.onCloseMenuClick)
            ], this._menuButton);
        }

        function onFrameResized(_arg_1:WindowEvent)
        {
            if (!this._ignoreEvents)
            {
                this.resizeToWidth(this._frame.width);
            }
        }

        function onContentsResized(_arg_1:WindowEvent)
        {
            if (!this._ignoreEvents)
            {
                this.fixHeight();
            }
        }

        function onCloseClicked(_arg_1:WindowMouseEvent)
        {
            if (this._onClose != null)
            {
                this._onClose();
            }
        }

        public var isCopyingIntoMode(get,never):Bool;
public function  get_isCopyingIntoMode():Bool
        {
            return this._menu != null && this._menu.getSelected(MENU_COPY_INTO);
        }

        override public function  get_window():IWindow
        {
            return this._frame;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._ignoreEvents = true;
            this._frame.width = _arg_1;
            this._listPreset.resizeToWidth(_arg_1 - this._leftRightMargin);
            this._ignoreEvents = false;
            this.fixHeight();
        }

        var headerFrameBackground(get,never):IWindow;
function  get_headerFrameBackground():IWindow
        {
            return this._frame.findChildByTag("wired_header_bg");
        }

        function fixHeight()
        {
            this._ignoreEvents = true;
            var _local_2= (this._listPreset.window.height + this._topBottomMargin);
            this._frame.limits.minHeight = _local_2;
            this._frame.limits.maxHeight = _local_2;
            this._frame.height = _local_2;
            this._ignoreEvents = false;
            var _local_1= this.headerFrameBackground;
            if ((_local_1 != null) && (this._headerPreset != null))
            {
                _local_1.height = ((this._headerPreset.window.height + this._frame.margins.top) + _style.sectionSpacing);
            }
        }

        override function  get_childPresets():Array<ASAny>
        {
            return this._menu == null ? [this._listPreset] : [this._listPreset, this._menu];
        }

        override public function dispose()
        {
            this._listPreset.window.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onContentsResized);
            this._frame.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onFrameResized);
            if (this._menuButton != null)
            {
                this._menuButton.removeEventListener(WindowMouseEvent.CLICK, this.onMenuButtonClick);
            }
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._frame.dispose();
            this._frame = null;
            this._listPreset = null;
            this._onClose = null;
            this._menu = null;
            this._menuButton = null;
        }

        public function onCopyConfigMenuClick() { this._roomEvents.wiredCtrl.createClipboardCopy(); }
        public function onPasteConfigMenuClick() { this._roomEvents.wiredCtrl.pasteFromClipboard(); }
        public function onClearPicksMenuClick() { this._roomEvents.wiredCtrl.clearStuffPicks(); }
        public function onResetMenuClick() { this._roomEvents.wiredCtrl.resetToDefault(); }
        public function onOpenWiredMenuClick() { this._roomEvents.openWiredMenu(); }
        public function onSaveMenuClick() { this._roomEvents.wiredCtrl.saveBuilderFromMenu(); }
        public function onCloseMenuClick() { this._roomEvents.wiredCtrl.close(); }
    }

