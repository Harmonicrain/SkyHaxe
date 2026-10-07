package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.sound.ISongInfo;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class PlayListEditorItemListView 
    {
        var _itemListWindow:IItemListWindow;
        var _items:Array<ASAny>;
        var _widget:PlaylistEditorWidget;
        var _selectedItem:PlayListEditorItem;
        var _selectedItemIndex:Int = -1;
        var _previousItemPlaying:Int = -1;

        public function new(k:PlaylistEditorWidget, _arg_2:IItemListWindow)
        {
            this._itemListWindow = _arg_2;
            this._widget = k;
            this._selectedItem = null;
        }

        public var _Str_4405(get,never):Int;
public function  get__Str_4405():Int
        {
            return this._selectedItemIndex;
        }

        public function destroy()
        {
            if (this._itemListWindow == null)
            {
                return;
            }
            this._itemListWindow.destroyListItems();
        }

        public function refresh(k:Array<ASAny>, _arg_2:Int)
        {
            var _local_3:ISongInfo = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:ColorTransform = null;
            var _local_7:PlayListEditorItem = null;
            if (this._itemListWindow == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            this._previousItemPlaying = -1;
            this._items = new Array<ASAny>();
            this._itemListWindow.destroyListItems();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_4 = _local_3.name;
                _local_5 = _local_3.creator;
                _local_6 = this._widget._Str_18331(_local_3.songData);
                _local_7 = new PlayListEditorItem(this._widget, _local_4, _local_5, _local_6);
                _local_7.window.procedure = this._Str_13002;
                _local_7._Str_25542.procedure = this._Str_13002;
                this._itemListWindow.addListItem(_local_7.window);
                this._items.push(_local_7);
            }
            this._Str_21115(_arg_2);
        }

        public function _Str_21115(k:Int)
        {
            var _local_2:PlayListEditorItem = null;
            var _local_3:PlayListEditorItem = null;
            if (this._items == null)
            {
                return;
            }
            if (k < 0)
            {
                final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3._Str_15168(PlayListEditorItem.PLEI_ICON_STATE_NORMAL);
                }
                return;
            }
            if (k >= this._items.length)
            {
                return;
            }
            if (((this._previousItemPlaying >= 0) && (this._previousItemPlaying < this._items.length)))
            {
                _local_2 = ASCompat.dynamicAs(this._items[this._previousItemPlaying] , PlayListEditorItem);
                _local_2._Str_15168(PlayListEditorItem.PLEI_ICON_STATE_NORMAL);
            }
            _local_2 = ASCompat.dynamicAs(this._items[k] , PlayListEditorItem);
            _local_2._Str_15168(PlayListEditorItem.PLEI_ICON_STATE_PLAYING);
            this._previousItemPlaying = k;
        }

        public function _Str_16851()
        {
            if (this._selectedItem != null)
            {
                this._selectedItem.deselect();
                this._selectedItem = null;
                this._selectedItemIndex = -1;
            }
        }

        function _Str_13002(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4 = 0;
            var _local_3:ASAny = (k.type == WindowMouseEvent.DOUBLE_CLICK);
            if (((k.type == WindowMouseEvent.CLICK) || ASCompat.toBool(_local_3)))
            {
                if (((_arg_2.name == "button_remove_from_playlist") || ASCompat.toBool(_local_3)))
                {
                    if (this._selectedItem != null)
                    {
                        this._selectedItem.deselect();
                    }
                    if (this._selectedItemIndex > -1)
                    {
                        this._widget._Str_20304(this._selectedItemIndex);
                    }
                    this._selectedItem = null;
                    this._selectedItemIndex = -1;
                }
                else
                {
                    if (this._selectedItem != null)
                    {
                        this._selectedItem.deselect();
                    }
                    _local_4 = this._itemListWindow.getListItemIndex(k.window);
                    if (_local_4 != -1)
                    {
                        this._selectedItemIndex = _local_4;
                        this._selectedItem = this._items[_local_4];
                        this._selectedItem.select();
                        if (_arg_2.name == "button_remove_from_playlist")
                        {
                            this._widget._Str_20304(_local_4);
                        }
                        if (this._widget._Str_15010 != null)
                        {
                            this._widget._Str_15010._Str_23639._Str_16851();
                        }
                    }
                }
            }
        }
    }

