package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.ItemListController;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class RadioGroupPreset extends WiredUIPreset
    {
        var _container:ISelectorWindow;
        var _radioButtons:Vector<RadioButtonPreset>;
        var _onChange:ASFunction;
        var _rows:Vector<IItemListWindow>;
        var _columns:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>, _arg_5:ASFunction, _arg_6:Int = 1)
        {
var _local_13:RadioButtonParam  = null;            var _local_7 = false;
            var _local_9:RadioButtonPreset = null;
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("radio_group_view") , ISelectorWindow);
            this._columns = _arg_6;
            var _local_10:IItemListWindow = null;
            if (this._columns > 0)
            {
                this._rows = new Vector<IItemListWindow>();
            }
            this._radioButtons = new Vector<RadioButtonPreset>();
            var _local_11= -1;
            var _local_12= 0;
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_13 = _tmp_;
                _local_7 = (_arg_4[_arg_4.length - 1] == _local_13);
                _local_9 = _arg_2.createRadioButton(_local_13, _local_7);
                this._radioButtons.push(_local_9);
                if (_arg_6 > 1)
                {
                    if (_local_12 == 0)
                    {
                        _local_10 = Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
                        _local_10.spacing = _arg_3.genericHorizontalSpacing;
                        this._rows.push(_local_10);
                        this.itemList.addListItem(_local_10);
                        _local_11++;
                    }
                    _local_10.addListItem(_local_9.window);
                    _local_9.layoutRowIndex = _local_11;
                    _local_9.layoutColumnIndex = _local_12;
                    _local_9.spanRemainingWidth = _local_13.newLine;
                    if (_local_13.newLine || (_local_12 == (_arg_6 - 1)))
                    {
                        _local_12 = 0;
                    }
                    else
                    {
                        _local_12++;
                    }
                }
                else
                {
                    this.itemList.addListItem(_local_9.window);
                }
                if (_arg_5 != null)
                {
                    _local_9.radioButton.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectionChange);
                }
            }
            this.selected = 0;
            this._onChange = _arg_5;
        }

        function onSelectionChange(_arg_1:WindowEvent)
        {
            if (this._onChange != null)
            {
                this._onChange(this.selected);
            }
        }

        
        public var selected(get,set):Int;
public function  get_selected():Int
        {
            return this._container.getSelected().id;
        }
public function  set_selected(_arg_1:Int):Int        {
            var _local_2= Std.downcast(ASCompat.reinterpretAs(this._container , WindowController).findChildByName(RadioButtonPreset.OPTION_PREFIX + Std.string(_arg_1)) , IRadioButtonWindow);
            this._container.setSelected(_local_2);
return _arg_1;
        }

        public function setOptionDisabled(_arg_1:Int, _arg_2:Bool)
        {
            this._radioButtons[_arg_1].disabled = _arg_2;
        }

        public function get(_arg_1:Int):RadioButtonPreset
        {
            return this._radioButtons[_arg_1];
        }

        override public function resizeToWidth(_arg_1:Int)
        {
var _local_7:IItemListWindow  = null, _local_6:RadioButtonPreset  = null;            var _local_2 = 0;
            var _local_5 = 0;
            var _local_8:IItemListWindow = null;
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this.itemList.width = _arg_1;
            var _local_3= Std.int((_arg_1 - ((this._columns - 1) * _style.genericHorizontalSpacing)) / this._columns);
            if (this._columns > 1)
            {
                final _iter_ = this._rows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7 = _tmp_;
                    _local_7.height = 0;
                    _local_7.width = _arg_1;
                }
            }
            var _local_4= 0;
            final _iter_ = this._radioButtons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6 = _tmp_;
                _local_2 = _local_3;
                if ((this._columns > 1) && _local_6.spanRemainingWidth)
                {
                    _local_5 = ((_local_6.layoutColumnIndex * _local_3) + (_local_6.layoutColumnIndex * _style.genericHorizontalSpacing));
                    _local_2 = Std.int(Math.max(_local_3, (_arg_1 - _local_5)));
                }
                _local_6.resizeToWidth(_local_2);
                if (this._columns > 1)
                {
                    _local_8 = this._rows[_local_6.layoutRowIndex];
                    if (_local_6.window.height > _local_8.height)
                    {
                        _local_8.height = _local_6.window.height;
                    }
                }
                _local_4++;
            }
        }

        var itemList(get,never):ItemListController;
function  get_itemList():ItemListController
        {
            return Std.downcast(ASCompat.reinterpretAs(this._container , WindowController).findChildByName("radio_button_list") , ItemListController);
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return WiredUIPreset.toArray(this._radioButtons);
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
            this._radioButtons = null;
            this._onChange = null;
            this._rows = null;
        }
    }

