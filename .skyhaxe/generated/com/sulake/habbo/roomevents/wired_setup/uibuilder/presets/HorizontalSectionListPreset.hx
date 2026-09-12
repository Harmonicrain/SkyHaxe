package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class HorizontalSectionListPreset extends WiredUIPreset
    {
        var _list:IItemListWindow;
        var _splitters:Vector<IWindow>;
        var _presets:Array<ASAny>;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, presets:Array<ASAny>)
        {
var             i = 0, preset:WiredUIPreset  = null, splitter:IWindow  = null;            super(roomEvents, presetManager, style);
            this._list = Std.downcast(presetManager.createLayout("horizontal_list_view") , IItemListWindow);
            this._list.spacing = 0;
            this._splitters = new Vector<IWindow>();
            this._presets = presets;
            i= 0;while (i < presets.length)
            {
preset= ASCompat.dynamicAs(presets[i] , WiredUIPreset);
                if (i > 0)
                {
splitter= style.createSplitterVerticalView();
                    splitter.setParamFlag(16, false);
                    this._splitters.push(splitter);
                    this._list.addListItem(splitter);
                }
                this._list.addListItem(preset.window);
i++;
            }
        }

        override public function  get_window():IWindow { return this._list; }

        override public function resizeToWidth(width:Int)
        {
var splitter:IWindow  = null;            super.resizeToWidth(width);
            var splitterWidth= this._splitters.length > 0 ? this._splitters[0].width : 0;
            var remaining= width - this._splitters.length * splitterWidth;
            var flexible= 0;
            var preset:WiredUIPreset = null;
            final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
preset  = _tmp_;
                if (preset.hasStaticWidth()) remaining -= preset.staticWidth;
                else flexible++;
            }
            var share= Std.int(flexible > 0 ? Std.int(Math.max(0, Std.int(remaining / flexible)) ): 0);
            var lastFlexible:WiredUIPreset = null;
            var maximumHeight= 0;
            final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
preset  = _tmp_;
                if (preset.hasStaticWidth()) preset.resizeToWidth(preset.staticWidth);
                else
                {
                    lastFlexible = preset;
                    preset.resizeToWidth(share);
                    remaining -= share;
                }
                maximumHeight = Std.int(Math.max(maximumHeight, preset.window.height));
            }
            if (remaining > 0 && lastFlexible != null)
            {
                lastFlexible.resizeToWidth(share + remaining);
                maximumHeight = Std.int(Math.max(maximumHeight, lastFlexible.window.height));
            }
            final _iter_ = this._splitters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
splitter = _tmp_;
                splitter.height = maximumHeight + this._style.sectionSpacing;
            }
            this._list.height = maximumHeight;
            this._list.width = width;
            this._list.arrangeListItems();
        }

        override function  get_childPresets():Array<ASAny> { return this._presets; }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._list.dispose();
            this._list = null;
            this._presets = null;
            this._splitters = null;
        }
    }

