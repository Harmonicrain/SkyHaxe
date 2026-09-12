package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class SectionPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _contentList:IItemListWindow;
        var _headerContainer:IWindowContainer;
        var _headerOptionsRightList:IItemListWindow;
        var _headerLeft:IItemListWindow;
        var _expectedWidth:Int = 0;
        var _splitter:SplitterPreset;
        var _titlePreset:TextPreset;
        var _headerOptionsRight:Vector<WiredUIPreset>;
        var _subPreset:WiredUIPreset;
        var _headerOptionLeft:WiredUIPreset;
        var _sourceTypeSelector:SourceTypeSelectorPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:WiredUIPreset, _arg_6:SectionParam = null)
        {
var _local_10:WiredUIPreset  = null;            var _local_9:CollapseExpandSectionButtonPreset = null;
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_6 == null)
            {
                _arg_6 = SectionParam.DEFAULT;
            }
            this._container = Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow);
            this._contentList = Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow);
            this._container.spacing = _arg_3.sectionSpacing;
            this._contentList.spacing = _arg_3.sectionSpacing;
            this._contentList.x = _arg_3.sectionLeftRightMargin;
            this._headerOptionsRight = new Vector<WiredUIPreset>();
            this._headerContainer = Std.downcast(_arg_2.createLayout("container_view") , IWindowContainer);
            this._headerLeft = Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
            this._headerLeft.spacing = _arg_3.genericHorizontalSpacing;
            this._headerOptionsRightList = Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
            this._headerOptionsRightList.spacing = _arg_3.genericHorizontalSpacing;
            this._splitter = _arg_2.createSplitter();
            this._subPreset = _arg_5;
            this._headerOptionLeft = _arg_6.headerOptionLeft;
            var _local_7= new TextParam((this._headerOptionLeft == null) ? 1 : 0, true);
            this._titlePreset = _arg_2.createText(_arg_4, _local_7);
            if (_arg_6.titleYOffset > 0)
            {
                this._titlePreset.window.y = _arg_6.titleYOffset;
            }
            this._headerLeft.addListItem(this._titlePreset.window);
            if (this._headerOptionLeft != null)
            {
                this._headerLeft.addListItem(this._headerOptionLeft.window);
            }
            this._headerContainer.addChild(this._headerLeft);
            this._headerContainer.addChild(this._headerOptionsRightList);
            this._container.addListItem(this._splitter.window);
            this._contentList.addListItem(this._headerContainer);
            if (_arg_6.expandMode != SectionParam.EXPAND_MODE_COLLAPSED)
            {
                this._contentList.addListItem(this._subPreset.window);
            }
            this._container.addListItem(this._contentList);
            final _iter_ = _arg_6.miscHeaderOptions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_10 = _tmp_;
                this.addHeaderOption(_local_10);
            }
            if (_arg_6.sourceTypeSelectorParam != null)
            {
                this._sourceTypeSelector = _arg_2.createSourceTypeSelector(_arg_6.sourceTypeSelectorParam);
                this.addHeaderOption(this._sourceTypeSelector);
            }
            if (_arg_6.expandMode != SectionParam.EXPAND_MODE_EXPANDED)
            {
                _local_9 = _arg_2.createCollapseExpandSectionButton(this.onExpandCollapseClicked, (_arg_6.expandMode == SectionParam.EXPAND_MODE_EXPANDED_WITH_TOGGLE));
                this.addHeaderOption(_local_9);
            }
        }

        public function getSourceTypeSelector():SourceTypeSelectorPreset
        {
            return this._sourceTypeSelector;
        }

        public function addHeaderOption(_arg_1:WiredUIPreset)
        {
            this._headerOptionsRightList.addListItem(_arg_1.window);
            this._headerOptionsRight.push(_arg_1);
        }

        public function onExpandCollapseClicked(_arg_1:Bool)
        {
            if (_arg_1)
            {
                this._contentList.addListItem(this._subPreset.window);
            }
            else
            {
                this._contentList.removeListItem(this._subPreset.window);
            }
        }

        public function refreshAlignments()
        {
            this.resizeToWidth(this._expectedWidth);
        }

        override public function resizeToWidth(_arg_1:Int)
        {
var _local_5:WiredUIPreset  = null;            if (disposed || (this._container == null))
            {
                return;
            }
            super.resizeToWidth(_arg_1);
            this._expectedWidth = _arg_1;
            var _local_4= (_arg_1 - (2 * _style.sectionLeftRightMargin));
            this._splitter.resizeToWidth(_arg_1);
            this._subPreset.resizeToWidth(_local_4);
            var _local_3= 0;
            final _iter_ = this._headerOptionsRight; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5 = _tmp_;
                _local_5.resizeToWidth(_local_5.staticWidth);
                if (_local_5.window.bottom > _local_3)
                {
                    _local_3 = _local_5.window.bottom;
                }
            }
            this._headerOptionsRightList.x = (_local_4 - this._headerOptionsRightList.width);
            this._headerOptionsRightList.height = _local_3;
            var _local_2= this._titlePreset.window.height;
            if (this._headerOptionLeft != null)
            {
                this._headerOptionLeft.resizeToWidth(this._headerOptionLeft.staticWidth);
                this._titlePreset.resizeToWidth(this._titlePreset.staticWidth);
                if (this._headerOptionLeft.window.height > _local_2)
                {
                    _local_2 = this._headerOptionLeft.window.height;
                }
            }
            else
            {
                this._titlePreset.resizeToWidth((_local_4 - this._headerOptionsRightList.width) - _style.genericHorizontalSpacing);
                _local_2 = this._titlePreset.window.height;
            }
            this._headerLeft.height = _local_2;
            this._headerContainer.width = _local_4;
            this._headerContainer.height = Std.int(Math.max(_local_3, _local_2));
            this._container.width = _arg_1;
        }

        public var titleText(never,set):String;
public function  set_titleText(_arg_1:String):String        {
            return this._titlePreset.text = _arg_1;
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
            var _local_1:Array<ASAny> = [this._splitter, this._titlePreset, this._subPreset];
            if (this._headerOptionLeft != null)
            {
                _local_1.push(this._headerOptionLeft);
            }
            if (this._headerOptionsRight != null)
            {
                return _local_1.concat(WiredUIPreset.toArray(this._headerOptionsRight));
            }
            return _local_1;
        }

        public var splitterVisible(never,set):Bool;
public function  set_splitterVisible(_arg_1:Bool):Bool        {
            return this._splitter.visible = _arg_1;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._contentList = null;
            this._headerContainer = null;
            this._headerOptionsRightList = null;
            this._splitter = null;
            this._titlePreset = null;
            this._subPreset = null;
            this._headerLeft = null;
            this._headerOptionLeft = null;
        }
    }

