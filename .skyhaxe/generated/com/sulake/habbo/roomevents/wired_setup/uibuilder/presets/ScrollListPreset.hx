package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ScrollListPreset extends WiredUIPreset implements IListPreset
    {
        var SCROLLBAR_WIDTH:Int = 9;
        var SCROLLBAR_MARGIN:Int = 3;

        var _container:IScrollableListWindow;
        var _presets:Vector<WiredUIPreset>;
        var _centerItems:Bool = false;
        var _scrollParams:ListScrollParams;
        var _cachedWidth:Int = 0;
        var _ignoreListeners:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>, _arg_5:ListScrollParams, _arg_6:Bool = false)
        {
var _local_7:WiredUIPreset  = null;            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("vertical_scroll_list_view") , IScrollableListWindow);
            this._centerItems = _arg_6;
            this._scrollParams = _arg_5;
            this._container.spacing = _arg_3.genericVerticalSpacing;
            this._presets = new Vector<WiredUIPreset>();
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_7 = _tmp_;
                this._presets.push(_local_7);
                this._container.addListItem(_local_7.window);
            }
            this._container.limits.minHeight = _arg_5.minHeight;
            this._container.limits.maxHeight = _arg_5.maxHeight;
            if (_arg_5.alwaysShowScrollbar)
            {
                this._container.autoHideScrollBar = true;
            }
            this._container.scrollableWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onScrollableWindowResized);
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        
        public var spacing(get,set):Int;
public function  set_spacing(_arg_1:Int):Int        {
            return this._container.spacing = _arg_1;
        }
public function  get_spacing():Int
        {
            return this._container.spacing;
        }

        public function resizeChildrenToWidth(_arg_1:Int)
        {
            var _local_3:WiredUIPreset = null;
            var _local_2 = 0;
            _local_2 += (this._container.spacing * (this._presets.length - 1));
            final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_3.resizeToWidth(_arg_1);
                _local_2 += _local_3.window.height;
            }
            if (this._centerItems)
            {
                final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3.window.x = Std.int((_arg_1 / 2) - (_local_3.window.width / 2));
                }
            }
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            this._ignoreListeners = true;
            this._cachedWidth = _arg_1;
            super.resizeToWidth(_arg_1);
            var _local_2= _arg_1;
            var _local_3= _arg_1;
            if (!this._scrollParams.alwaysShowScrollbar)
            {
                this.resizeChildrenToWidth(_local_2);
                this.fixHeight();
            }
            if (this._container.isScrollBarVisible)
            {
                _local_2 = (_arg_1 - SCROLLBAR_WIDTH - SCROLLBAR_MARGIN);
                this.resizeChildrenToWidth(_local_2);
                _local_3 = (_arg_1 - SCROLLBAR_MARGIN);
            }
            this._container.width = _local_3;
            this.fixHeight();
            this._ignoreListeners = false;
        }

        function fixHeight()
        {
            this._container.height = Std.int(Math.min(this._scrollParams.maxHeight, Math.max(this._scrollParams.minHeight, this._container.scrollableRegion.height)));
        }

        function onScrollableWindowResized(_arg_1:WindowEvent)
        {
            if (this._ignoreListeners || disposing)
            {
                return;
            }
            this.resizeToWidth(this._cachedWidth);
        }

        public var backgroundColor(never,set):UInt;
public function  set_backgroundColor(_arg_1:UInt):UInt        {
            this._container.background = true;
            this._container.color = (ASCompat.toInt(0xFF000000 )| ASCompat.toInt(_arg_1));
return _arg_1;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return WiredUIPreset.toArray(this._presets);
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
            this._presets = null;
        }
    }

