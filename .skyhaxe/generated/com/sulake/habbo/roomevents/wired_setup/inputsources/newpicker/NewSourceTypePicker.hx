package com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypePicker;

     class NewSourceTypePicker implements ISourceTypePicker
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _container:IItemListWindow;
        var _listener:ISourceTypeListener;
        var _options:Map = new Map();
        var _splitters:Vector<IWindowContainer> = new Vector();
        var _selected:NewSourceTypeOption;
        var _leftTemplate:IContainerButtonWindow;
        var _middleTemplate:IContainerButtonWindow;
        var _rightTemplate:IContainerButtonWindow;
        var _splitterTemplate:IWindowContainer;
        var _splitterBaseColor:UInt = 0;
        var _initializing:Bool = false;
        var _disposed:Bool = false;

        public function new(k:HabboUserDefinedRoomEvents, _arg_2:IItemListWindow, _arg_3:ISourceTypeListener)
        {
            this._roomEvents = k;
            this._container = _arg_2;
            this._listener = _arg_3;
            this._leftTemplate = Std.downcast(_arg_2.getListItemAt(0) , IContainerButtonWindow);
            this._splitterTemplate = Std.downcast(_arg_2.getListItemAt(1) , IWindowContainer);
            this._splitterBaseColor = ASCompat.toInt(this._splitterTemplate.getChildAt(0).color )& 0xFFFFFF;
            this._middleTemplate = Std.downcast(_arg_2.getListItemAt(2) , IContainerButtonWindow);
            this._rightTemplate = Std.downcast(_arg_2.getListItemAt(4) , IContainerButtonWindow);
            _arg_2.removeListItems();
        }

        public function initialize(k:Array<ASAny>, _arg_2:Int)
        {
var             index = 0, option:NewSourceTypeOption  = null;            var index = 0;
            var optionId = 0;
            var button:IContainerButtonWindow = null;
            var splitter:IWindowContainer = null;
            this._initializing = true;
            if (this._selected != null)
            {
                this._selected.deactivate();
                this._selected = null;
            }
            this.clear();
            this._options = new Map();
            this._splitters = new Vector<IWindowContainer>();
            index= 0;while (index < k.length)
            {
                optionId = ASCompat.toInt(k[index]);
                if (index == 0)
                {
                    button = Std.downcast(this._leftTemplate.clone() , IContainerButtonWindow);
                }
                else if (index == k.length - 1)
                {
                    button = Std.downcast(this._rightTemplate.clone() , IContainerButtonWindow);
                }
                else
                {
                    button = Std.downcast(this._middleTemplate.clone() , IContainerButtonWindow);
                }
option= new NewSourceTypeOption(this, button, optionId);
                this._options.add(optionId, option);
                this._container.addListItem(option.container);
                if (optionId == _arg_2)
                {
                    this._selected = option;
                }
                if (index != k.length - 1)
                {
                    splitter = Std.downcast(this._splitterTemplate.clone() , IWindowContainer);
                    this._container.addListItem(splitter);
                    this._splitters.push(splitter);
                }
index++;
            }
            if (this._selected != null)
            {
                this._selected.activate();
            }
            else if (k.length > 0)
            {
                this.onClick(this._options.getValue(k[0]));
            }
            this._initializing = false;
            this.updateColorings();
        }

        public function select(k:Int)
        {
var option:NewSourceTypeOption  = null;            final _iter_ = this._options.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
option = _tmp_;
                if (k == option.option)
                {
                    this.onClick(option);
                    return;
                }
            }
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker) function onClick(k:NewSourceTypeOption)
        {
            if (k == this._selected)
            {
                return;
            }
            if (this._selected != null)
            {
                this._selected.deactivate();
            }
            this._selected = k;
            if (this._selected != null)
            {
                this._selected.activate();
                if (this._listener != null)
                {
                    this._listener.sourceType = this._selected.option;
                }
            }
        }

        @:allow(com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker) function updateColorings()
        {
var             index = 0, left:NewSourceTypeOption  = null, right:NewSourceTypeOption  = null, color:UInt  = 0, splitter:IWindowContainer  = null;            if (this._initializing)
            {
                return;
            }
            index= 0;while (index < this._splitters.length)
            {
left= ASCompat.dynamicAs(this._options.getWithIndex(index) , NewSourceTypeOption);
right= ASCompat.dynamicAs(this._options.getWithIndex(index + 1) , NewSourceTypeOption);
color= 0xFFFFFF;
                if (left.active || (!right.active && left.hovered))
                {
                    color = left.color;
                }
                else if (right.active || right.hovered)
                {
                    color = right.color;
                }
splitter= this._splitters[index];
                splitter.getChildAt(0).color = (ASCompat.toInt(splitter.getChildAt(0).color )& ASCompat.toInt(0xFF000000)) | ASCompat.toInt(multiplyColors(this._splitterBaseColor, color));
index++;
            }
        }

        static function multiplyColors(k:UInt, _arg_2:UInt):UInt
        {
            var r:UInt = Std.int(((ASCompat.toInt(k )>> 16) & 0xFF) * ((ASCompat.toInt(_arg_2 )>> 16) & 0xFF) / 255);
            var g:UInt = Std.int(((ASCompat.toInt(k )>> 8) & 0xFF) * ((ASCompat.toInt(_arg_2 )>> 8) & 0xFF) / 255);
            var b:UInt = Std.int((ASCompat.toInt(k )& 0xFF) * (ASCompat.toInt(_arg_2 )& 0xFF) / 255);
            return (ASCompat.toInt(r )<< 16) | (ASCompat.toInt(g )<< 8) | ASCompat.toInt(b);
        }

        function clear()
        {
var option:NewSourceTypeOption  = null, splitter:IWindowContainer  = null;            this._container.removeListItems();
            final _iter_ = this._options.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
option = _tmp_;
                option.dispose();
            }
            final _iter_ = this._splitters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
splitter = _tmp_;
                splitter.dispose();
            }
        }

        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.clear();
            this._container.dispose();
            this._container = null;
            this._leftTemplate.dispose();
            this._leftTemplate = null;
            this._middleTemplate.dispose();
            this._middleTemplate = null;
            this._rightTemplate.dispose();
            this._rightTemplate = null;
            this._splitterTemplate.dispose();
            this._splitterTemplate = null;
            this._options.dispose();
            this._options = null;
            this._splitters = null;
            this._selected = null;
            this._listener = null;
            this._roomEvents = null;
            this._disposed = true;
        }
    }

