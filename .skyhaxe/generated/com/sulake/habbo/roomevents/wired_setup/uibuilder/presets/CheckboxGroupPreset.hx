package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class CheckboxGroupPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _checkboxes:Map;
        var _onChange:ASFunction;
        var _rows:Vector<IItemListWindow>;
        var _columns:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>, _arg_5:ASFunction, _arg_6:Int = 1)
        {
var _local_11:CheckboxOptionParam  = null;            var _local_9 = false;
            var _local_8:CheckboxOptionPreset = null;
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow);
            this._columns = _arg_6;
            this._onChange = _arg_5;
            var _local_10= 0;
            var _local_7:IItemListWindow = null;
            if (this._columns > 0)
            {
                this._rows = new Vector<IItemListWindow>();
            }
            this._checkboxes = new Map();
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_11 = _tmp_;
                if (_local_11.id == -1)
                {
                    _local_11.id = _local_10;
                }
                _local_9 = (_arg_4[_arg_4.length - 1] == _local_11);
                _local_8 = _arg_2.createCheckboxOption(_local_11, _local_9);
                this._checkboxes.add(_local_11.id, _local_8);
                if (_arg_6 > 1)
                {
                    if ((_local_10 % _arg_6) == 0)
                    {
                        _local_7 = Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
                        _local_7.spacing = _arg_3.genericHorizontalSpacing;
                        this._rows.push(_local_7);
                        this._container.addListItem(_local_7);
                    }
                    _local_7.addListItem(_local_8.window);
                }
                else
                {
                    this._container.addListItem(_local_8.window);
                }
                if (_arg_5 != null)
                {
                    _local_8.checkbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectionChange);
                    _local_8.checkbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSelectionChange);
                }
                _local_10++;
            }
        }

        function onSelectionChange(_arg_1:WindowEvent)
        {
            var _local_2 = 0;
            if (this._onChange != null)
            {
                _local_2 = _arg_1.window.id;
                this._onChange(_local_2, this.get(_local_2).selected);
            }
        }

        public function get(_arg_1:Int):CheckboxOptionPreset
        {
            return this._checkboxes.getValue(_arg_1);
        }

        public var numCheckboxes(get,never):Int;
public function  get_numCheckboxes():Int
        {
            return ASCompat.toInt(this._checkboxes.length);
        }

        
        public var mask(get,set):Int;
public function  get_mask():Int
        {
var _local_2:CheckboxOptionPreset  = null;            var _local_1 = 0;
            final _iter_ = this._checkboxes.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2 = _tmp_;
                if (_local_2.selected)
                {
                    _local_1 = (_local_1 | (1 << _local_2.checkbox.id));
                }
            }
            return _local_1;
        }
public function  set_mask(_arg_1:Int):Int        {
var _local_3:CheckboxOptionPreset  = null;            var _local_2 = false;
            final _iter_ = this._checkboxes.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3 = _tmp_;
                _local_2 = ((_arg_1 & (1 << _local_3.checkbox.id)) != 0);
                Util.select(_local_3.checkbox, _local_2);
            }
return _arg_1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
var _local_4:CheckboxOptionPreset  = null;            var _local_5:IItemListWindow = null;
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            var _local_2= Std.int((_arg_1 - ((this._columns - 1) * _style.genericHorizontalSpacing)) / this._columns);
            var _local_3= 0;
            final _iter_ = this._checkboxes.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4 = _tmp_;
                _local_4.resizeToWidth(_local_2);
                if (this._columns > 1)
                {
                    _local_5 = this._rows[Std.int(_local_3 / this._columns)];
                    if (_local_4.window.height > _local_5.height)
                    {
                        _local_5.height = _local_4.window.height;
                    }
                }
                _local_3++;
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return this._checkboxes.getValues();
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
            this._checkboxes = null;
            this._onChange = null;
            this._rows = null;
        }
    }

