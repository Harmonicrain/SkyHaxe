package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.habbo.sound.IHabboMusicController;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import com.sulake.habbo.sound.ISongInfo;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class MusicInventoryGridView 
    {
        var _musicController:IHabboMusicController;
        var _itemGridWindow:IItemGridWindow;
        var _items:Map;
        var _widget:PlaylistEditorWidget;
        var _selectedItem:MusicInventoryGridItem;

        public function new(k:PlaylistEditorWidget, _arg_2:IItemGridWindow, _arg_3:IHabboMusicController)
        {
            this._items = new Map();
            this._musicController = _arg_3;
            this._itemGridWindow = _arg_2;
            this._widget = k;
            this._selectedItem = null;
            this._musicController.events.addEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
        }

        public var itemCount(get,never):Int;
public function  get_itemCount():Int
        {
            return ASCompat.toInt(this._items.length);
        }

        public function destroy()
        {
            if (this._itemGridWindow != null)
            {
                this._itemGridWindow.destroyGridItems();
                this._itemGridWindow = null;
            }
            if (this._musicController != null)
            {
                if (this._musicController.events != null)
                {
                    this._musicController.events.removeEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
                }
                this._musicController = null;
            }
            if (this._items != null)
            {
                this._items.reset();
                this._items = null;
            }
            this._selectedItem = null;
            this._widget = null;
        }

        public function refresh()
        {
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:ISongInfo = null;
            var _local_10:String = null;
            var _local_11:ColorTransform = null;
            var _local_12:MusicInventoryGridItem = null;
            var _local_13:MusicInventoryGridItem = null;
            if (this._itemGridWindow == null)
            {
                return;
            }
            this._itemGridWindow.removeGridItems();
            var k= this._items;
            var _local_2= new Map();
            var _local_3= k.getKeys();
            this._items = new Map();
            var _local_4= this._musicController.getSongDiskInventorySize();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_7 = this._musicController.getSongDiskInventoryDiskId(_local_5);
                _local_8 = this._musicController.getSongDiskInventorySongId(_local_5);
                _local_9 = this._musicController.getSongInfo(_local_8);
                _local_10 = null;
                _local_11 = null;
                if (_local_9 != null)
                {
                    _local_10 = _local_9.name;
                    _local_11 = this._widget._Str_18331(_local_9.songData);
                }
                if (_local_3.indexOf(_local_7) == -1)
                {
                    _local_12 = new MusicInventoryGridItem(this._widget, _local_7, _local_8, _local_10, _local_11);
                }
                else
                {
                    _local_12 = k.getValue(_local_7);
                    _local_3.splice(_local_3.indexOf(_local_7), 1);
                }
                _local_12.window.procedure = this._Str_20197;
                _local_12._Str_23170.procedure = this._Str_20197;
                this._itemGridWindow.addGridItem(_local_12.window);
                this._items.add(_local_7, _local_12);
                _local_5++;
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_6  = ASCompat.toInt(_tmp_);
                _local_13 = k.getValue(_local_6);
                _local_13.destroy();
                k.remove(_local_6);
            }
        }

        public function _Str_24959()
        {
            if (this._selectedItem != null)
            {
                this._selectedItem._Str_8343 = MusicInventoryGridItem._Str_13281;
            }
        }

        public function _Str_22162()
        {
            if (this._selectedItem != null)
            {
                this._selectedItem._Str_8343 = MusicInventoryGridItem._Str_8425;
            }
        }

        public function _Str_16851()
        {
            if (this._selectedItem != null)
            {
                this._selectedItem.deselect();
                this._selectedItem = null;
            }
        }

        function _Str_20197(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4 = 0;
            var _local_5:MusicInventoryGridItem = null;
            var _local_3:ASAny = (k.type == WindowMouseEvent.DOUBLE_CLICK);
            if (((k.type == WindowMouseEvent.CLICK) || ASCompat.toBool(_local_3)))
            {
                if (((_arg_2.name == "button_to_playlist") || ASCompat.toBool(_local_3)))
                {
                    if (this._selectedItem != null)
                    {
                        this._selectedItem.deselect();
                        this._Str_16797();
                        this._widget._Str_23659(this._selectedItem.diskId);
                        this._selectedItem = null;
                    }
                }
                else
                {
                    if (_arg_2.name == "button_play_pause")
                    {
                        if (this._selectedItem._Str_8343 == MusicInventoryGridItem._Str_8425)
                        {
                            this._selectedItem._Str_8343 = MusicInventoryGridItem._Str_13230;
                            this._widget._Str_25259(this._selectedItem.songId);
                        }
                        else
                        {
                            this._Str_16797();
                        }
                    }
                    else
                    {
                        _local_4 = this._itemGridWindow.getGridItemIndex(k.window);
                        if (_local_4 != -1)
                        {
                            _local_5 = this._items.getWithIndex(_local_4);
                            if (_local_5 != this._selectedItem)
                            {
                                if (this._selectedItem != null)
                                {
                                    this._selectedItem.deselect();
                                }
                                this._selectedItem = _local_5;
                                this._selectedItem.select();
                                this._Str_16797();
                            }
                            if (this._widget._Str_15010 != null)
                            {
                                this._widget._Str_15010._Str_15855._Str_16851();
                            }
                        }
                    }
                }
            }
        }

        function _Str_16797()
        {
            this._widget._Str_16919();
            this._Str_22162();
        }

        function onSongInfoReceivedEvent(k:SongInfoReceivedEvent)
        {
            var _local_2:ISongInfo = null;
            var _local_3:String = null;
            var _local_4:ColorTransform = null;
            var _local_5:MusicInventoryGridItem = null;
            if (this._musicController != null)
            {
                _local_2 = this._musicController.getSongInfo(k.id);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.name;
                    _local_4 = this._widget._Str_18331(_local_2.songData);
                    _local_5 = this._items.getValue(k.id);
                    if (_local_5 != null)
                    {
                        _local_5.update(k.id, _local_3, _local_4);
                    }
                }
            }
        }
    }

