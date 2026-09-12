package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class SimpleListViewPreset extends WiredUIPreset implements IListPreset
    {
        var _container:IItemListWindow;
        var _presets:Vector<WiredUIPreset>;
        var _vertical:Bool = false;
        var _centerItems:Bool = false;
        var _allChildrenStaticWidth:Bool = false;
        var _staticWidth:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Bool, _arg_5:Array<ASAny>, _arg_6:Bool)
        {
var _local_7:WiredUIPreset  = null;            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_4 ? Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow) : Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
            this._vertical = _arg_4;
            this._centerItems = _arg_6;
            this._container.spacing = _arg_4 ? _arg_3.genericHorizontalSpacing : _arg_3.genericVerticalSpacing;
            this._presets = new Vector<WiredUIPreset>();
            if (checkNullIteratee(_arg_5)) for (_tmp_ in _arg_5)
            {
_local_7 = _tmp_;
                this._presets.push(_local_7);
                this._container.addListItem(_local_7.window);
                _local_7.invisibilityListener = this;
            }
            if (!_arg_4)
            {
                this._allChildrenStaticWidth = true;
                this._staticWidth = 0;
                final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    if (!_local_7.hasStaticWidth())
                    {
                        this._allChildrenStaticWidth = false;
                        break;
                    }
                    this._staticWidth += _local_7.staticWidth;
                }
                if (this._allChildrenStaticWidth && (this._presets.length > 1))
                {
                    this._staticWidth += (this._container.spacing * (this._presets.length - 1));
                }
                if (this._allChildrenStaticWidth)
                {
                    this._container.width = this._staticWidth;
                }
            }
        }

        override function onInvisibilityChanged(_arg_1:WiredUIPreset, _arg_2:Bool)
        {
            this._container.arrangeListItems();
            resize();
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

        public var minHeight(never,set):Int;
public function  set_minHeight(_arg_1:Int):Int        {
            return this._container.limits.minHeight = _arg_1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            var _local_7:WiredUIPreset = null;
            var _local_8 = 0;
            var _local_5 = 0;
            var _local_3 = 0;
            var _local_9 = 0;
            var _local_2 = 0;
            var _local_4 = 0;
            super.resizeToWidth(_arg_1);
            var _local_6= 0;
            final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_7  = _tmp_;
                if (_local_7.visible)
                {
                    _local_6++;
                }
            }
            if (this._vertical)
            {
                this._container.width = _arg_1;
                final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    _local_7.resizeToWidth(_arg_1);
                }
                if (this._centerItems)
                {
                    throw new Exception("Centering vertical lists not implemented yet");
                }
            }
            else
            {
                _local_8 = this._allChildrenStaticWidth ? this._staticWidth : _arg_1;
                _local_5 = (_local_8 - ((_local_6 - 1) * this._container.spacing));
                _local_3 = 0;
                final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    if (_local_7.visible)
                    {
                        if (_local_7.hasStaticWidth())
                        {
                            _local_5 -= _local_7.staticWidth;
                        }
                        else
                        {
                            _local_3++;
                        }
                    }
                }
                _local_9 = Std.int(Math.max(0, Std.int(_local_5 / _local_3)));
                _local_2 = this._container.limits.minHeight;
                final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    if (_local_7.visible)
                    {
                        if (_local_7.hasStaticWidth())
                        {
                            _local_7.resizeToWidth(_local_7.staticWidth);
                        }
                        else
                        {
                            _local_7.resizeToWidth(_local_9);
                        }
                        _local_4 = _local_7.window.height;
                        if (_local_4 > _local_2)
                        {
                            _local_2 = _local_4;
                        }
                    }
                }
                if (this._centerItems)
                {
                    final _iter_ = this._presets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_7  = _tmp_;
                        _local_7.window.y = Std.int((_local_2 / 2) - (_local_7.window.height / 2));
                    }
                }
                this._container.width = _local_8;
                this._container.height = _local_2;
            }
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

        override public function hasStaticWidth():Bool
        {
            return this._allChildrenStaticWidth;
        }

        override public function  get_staticWidth():Int
        {
            if (!this._allChildrenStaticWidth)
            {
                return -1;
            }
            return this._staticWidth;
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

