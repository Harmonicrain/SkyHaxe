package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class RewardListPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _rowsContainer:IItemListWindow;
        var _header:SimpleListViewPreset;
        var _probabilityHeader:TextPreset;
        var _rows:Vector<RewardRowPreset>;
        var _displayedRewards:Int = 0;
        var _maxRewards:Int = 0;
        var _probabilityEnabled:Bool = true;
        var _expectedWidth:Int = 0;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                         presetManager:PresetManager,
                                         style:WiredStyle,
                                         maxRewards:Int,
                                         displayedRewards:Int)
        {
            super(roomEvents, presetManager, style);
            this._maxRewards = maxRewards;
            this._container = Std.downcast(presetManager.createLayout("vertical_list_view") , IItemListWindow);
            this._container.spacing = style.genericVerticalSpacing;
            var badgeHeader= presetManager.createText(
                "Badge?", new TextParam(TextParam.MODE_STRETCH, false));
            var codeHeader= presetManager.createText(
                "Product/Badge code", new TextParam(TextParam.MODE_OVERFLOW, false));
            this._probabilityHeader = presetManager.createText(
                "Probability", new TextParam(TextParam.MODE_STRETCH, false));
            this._header = presetManager.createSimpleListView(
                false, [badgeHeader, codeHeader, this._probabilityHeader]);
            this._rowsContainer = Std.downcast(presetManager.createLayout(
                "vertical_list_view") , IItemListWindow);
            this._rowsContainer.spacing = style.genericVerticalSpacing;
            this._rows = new Vector<RewardRowPreset>();
            var index = 0;
            while (index < this._maxRewards)
            {
                this._rows.push(presetManager.createRewardRow());
                index++;
            }
            this._container.addListItem(this._header.window);
            this._container.addListItem(this._rowsContainer);
            this.setDisplayedRewards(displayedRewards);
        }

        public function setDisplayedRewards(value:Int)
        {
            var target= Std.int(Math.max(0, Math.min(this._maxRewards, value)));
            if (target == this._displayedRewards)
            {
                return;
            }
            var index = 0;
            if (target > this._displayedRewards)
            {
                index = this._displayedRewards;
                while (index < target)
                {
                    this._rowsContainer.addListItem(this._rows[index].window);
                    if (this._expectedWidth > 0)
                    {
                        this._rows[index].resizeToWidth(this._expectedWidth);
                    }
                    index++;
                }
            }
            else
            {
                index = this._displayedRewards - 1;
                while (index >= target)
                {
                    this._rowsContainer.removeListItem(this._rows[index].window);
                    index--;
                }
            }
            this._displayedRewards = target;
        }

        public var displayedRewards(get,never):Int;
public function  get_displayedRewards():Int
        {
            return this._displayedRewards;
        }

        public function getRow(index:Int):RewardRowPreset
        {
            return this._rows[index];
        }

        public function setProbabilityEnabled(value:Bool)
        {
var row:RewardRowPreset  = null;            if (this._probabilityEnabled == value)
            {
                return;
            }
            this._probabilityEnabled = value;
            this._probabilityHeader.disabled = !value;
            final _iter_ = this._rows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
row = _tmp_;
                row.setProbabilityEnabled(value);
            }
        }

        override public function resizeToWidth(width:Int)
        {
            super.resizeToWidth(width);
            this._expectedWidth = width;
            this._container.width = width;
            this._header.resizeToWidth(width);
            this._rowsContainer.width = width;
            var index = 0;
            while (index < this._displayedRewards)
            {
                this._rows[index].resizeToWidth(width);
                index++;
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
var row:RewardRowPreset  = null;            var children:Array<ASAny> = [this._header];
            final _iter_ = this._rows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
row = _tmp_;
                children.push(row);
            }
            return children;
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
            this._rowsContainer = null;
            this._header = null;
            this._probabilityHeader = null;
            this._rows = null;
        }
    }

