package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.habbo.sound.IHabboMusicController;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IScrollbarWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.sound.HabboMusicPrioritiesEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.ui.widget.events._Str_3301;

     class MainWindowHandler 
    {
        static inline final _Str_16427= 6;
        static inline final _Str_17484= 9;
        static inline final _Str_15951= 5;

        var _widget:PlaylistEditorWidget;
        var _musicController:IHabboMusicController;
        var _mainWindow:IWindowContainer;
        var _myMusicContainer:IBorderWindow;
        var _playListContainer:IBorderWindow;
        var _musicInventoryView:MusicInventoryGridView;
        var _playListEditorView:PlayListEditorItemListView;
        var _musicStatusView:MusicInventoryStatusView;
        var _playListStatusView:PlayListStatusView;
        var _myMusicScrollBar:IScrollbarWindow;
        var _playlistScrollBar:IScrollbarWindow;

        public function new(k:PlaylistEditorWidget, _arg_2:IHabboMusicController)
        {
            var _local_4:String = null;
            var _local_5:BitmapData = null;
            this._widget = k;
            this._musicController = _arg_2;
            var _local_3:Array<ASAny> = [PlayListEditorWidgetAssetsEnum.TITLE_MYMUSIC, PlayListEditorWidgetAssetsEnum.TITLE_PLAYLIST, PlayListEditorWidgetAssetsEnum.BACKGROUND_PREVIEW_PLAYING, PlayListEditorWidgetAssetsEnum.BACKGROUND_GET_MORE_MUSIC, PlayListEditorWidgetAssetsEnum.BACKGROUND_ADD_SONGS];
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                _local_5 = this._widget._Str_8169(_local_4);
                if (_local_5 != null)
                {
                    _local_5.dispose();
                }
                else
                {
                    this._widget._Str_24749(_local_4);
                }
            }
            this.createWindow();
            this._musicInventoryView = new MusicInventoryGridView(k, this._Str_24707(), _arg_2);
            this._playListEditorView = new PlayListEditorItemListView(k, this._Str_23926());
            this._musicStatusView = new MusicInventoryStatusView(k, this._Str_24828());
            this._playListStatusView = new PlayListStatusView(k, this._Str_24111());
            this._Str_19051();
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._mainWindow;
        }

        public var _Str_23639(get,never):MusicInventoryGridView;
public function  get__Str_23639():MusicInventoryGridView
        {
            return this._musicInventoryView;
        }

        public var _Str_15855(get,never):PlayListEditorItemListView;
public function  get__Str_15855():PlayListEditorItemListView
        {
            return this._playListEditorView;
        }

        public function destroy()
        {
            if (this._musicController != null)
            {
                this._musicController.stop(HabboMusicPrioritiesEnum.PRIORITY_SONG_PLAY);
                this._musicController = null;
            }
            if (this._musicInventoryView != null)
            {
                this._musicInventoryView.destroy();
                this._musicInventoryView = null;
            }
            if (this._playListEditorView != null)
            {
                this._playListEditorView.destroy();
                this._playListEditorView = null;
            }
            if (this._playListStatusView != null)
            {
                this._playListStatusView.destroy();
                this._playListStatusView = null;
            }
            if (this._musicStatusView != null)
            {
                this._musicStatusView.destroy();
                this._musicStatusView = null;
            }
            this._mainWindow.destroy();
            this._mainWindow = null;
        }

        public function hide()
        {
            this._mainWindow.visible = false;
            if (this._widget != null)
            {
                this._widget._Str_16919();
            }
        }

        public function show()
        {
            this._musicController.requestUserSongDisks();
            var k= this._musicController.getRoomItemPlaylist();
            if (k != null)
            {
                k.requestPlayList();
                this._Str_16190();
            }
            this._mainWindow.visible = true;
        }

        public function _Str_19051(k:String="")
        {
            if (((k == "") || (k == PlayListEditorWidgetAssetsEnum.TITLE_MYMUSIC)))
            {
                this._Str_20561(this._myMusicContainer, "music_inventory_splash_image", PlayListEditorWidgetAssetsEnum.TITLE_MYMUSIC);
            }
            if (((k == "") || (k == PlayListEditorWidgetAssetsEnum.TITLE_PLAYLIST)))
            {
                this._Str_20561(this._playListContainer, "playlist_editor_splash_image", PlayListEditorWidgetAssetsEnum.TITLE_PLAYLIST);
            }
            if (((k == "") || (k == PlayListEditorWidgetAssetsEnum.BACKGROUND_PREVIEW_PLAYING)))
            {
                this._musicStatusView._Str_20507(this._widget._Str_8169(PlayListEditorWidgetAssetsEnum.BACKGROUND_PREVIEW_PLAYING));
            }
            if (((k == "") || (k == PlayListEditorWidgetAssetsEnum.BACKGROUND_GET_MORE_MUSIC)))
            {
                this._musicStatusView._Str_21729(this._widget._Str_8169(PlayListEditorWidgetAssetsEnum.BACKGROUND_GET_MORE_MUSIC));
            }
            if (((k == "") || (k == PlayListEditorWidgetAssetsEnum.BACKGROUND_ADD_SONGS)))
            {
                this._playListStatusView._Str_24999 = this._widget._Str_8169(PlayListEditorWidgetAssetsEnum.BACKGROUND_ADD_SONGS);
            }
        }

        function _Str_20561(k:IWindowContainer, _arg_2:String, _arg_3:String)
        {
            var _local_5:BitmapData = null;
            var _local_4= Std.downcast(k.getChildByName(_arg_2) , IBitmapWrapperWindow);
            if (_local_4 != null)
            {
                _local_5 = this._widget._Str_8169(_arg_3);
                if (_local_5 != null)
                {
                    _local_4.bitmap = _local_5;
                    _local_4.width = _local_5.width;
                    _local_4.height = _local_5.height;
                }
            }
        }

        function createWindow()
        {
            if (this._widget == null)
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("playlisteditor_main_window") , XmlAsset);
            this._mainWindow = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._mainWindow == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._mainWindow.position = new Point(80, 0);
            var _local_2= Std.downcast(this._mainWindow.getChildByName("content_area") , IWindowContainer);
            if (_local_2 == null)
            {
                throw new ASError("Window is missing 'content_area' element");
            }
            this._myMusicContainer = Std.downcast(_local_2.getChildByName("my_music_border") , IBorderWindow);
            this._playListContainer = Std.downcast(_local_2.getChildByName("playlist_border") , IBorderWindow);
            if (this._myMusicContainer == null)
            {
                throw new ASError("Window content area is missing 'my_music_border' window element");
            }
            if (this._playListContainer == null)
            {
                throw new ASError("Window content area is missing 'playlist_border' window element");
            }
            this._myMusicScrollBar = Std.downcast(this._myMusicContainer.getChildByName("music_inventory_scrollbar") , IScrollbarWindow);
            this._playlistScrollBar = Std.downcast(this._playListContainer.getChildByName("playlist_scrollbar") , IScrollbarWindow);
            if (this._myMusicScrollBar == null)
            {
                throw new ASError("Window content area is missing 'music_inventory_scrollbar' window element");
            }
            if (this._playlistScrollBar == null)
            {
                throw new ASError("Window content area is missing 'playlist_scrollbar' window element");
            }
            var _local_3= this._mainWindow.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
        }

        function _Str_24707():IItemGridWindow
        {
            return Std.downcast(this._myMusicContainer.getChildByName("music_inventory_itemgrid") , IItemGridWindow);
        }

        function _Str_23926():IItemListWindow
        {
            return Std.downcast(this._playListContainer.getChildByName("playlist_editor_itemlist") , IItemListWindow);
        }

        function _Str_24828():IWindowContainer
        {
            return Std.downcast(this._myMusicContainer.getChildByName("preview_play_container") , IWindowContainer);
        }

        function _Str_24111():IWindowContainer
        {
            return Std.downcast(this._playListContainer.getChildByName("now_playing_container") , IWindowContainer);
        }

        function _Str_16190()
        {
            var k= this._musicController.getRoomItemPlaylist();
            if (k == null)
            {
                return;
            }
            if (k.isPlaying)
            {
                this._playListStatusView._Str_3734(PlayListStatusView.PLSV_NOW_PLAYING);
            }
            else
            {
                if (k.length > 0)
                {
                    this._playListStatusView._Str_3734(PlayListStatusView.PLSV_START_PLAYBACK);
                }
                else
                {
                    this._playListStatusView._Str_3734(PlayListStatusView.PLSV_ADD_SONGS);
                }
            }
        }

        function _Str_18647()
        {
            if (this._Str_23997())
            {
                this._musicStatusView.show();
                this._musicStatusView._Str_3734(MusicInventoryStatusView.MISV_PREVIEW_PLAYING);
            }
            else
            {
                if (this._musicController.getSongDiskInventorySize() <= _Str_16427)
                {
                    this._musicStatusView.show();
                    this._musicStatusView._Str_3734(MusicInventoryStatusView.MISV_BUY_MORE);
                }
                else
                {
                    this._musicStatusView.hide();
                }
            }
        }

        function _Str_24609()
        {
            var _local_4 = 0;
            var _local_5:ISongInfo = null;
            var k= this._musicController.getRoomItemPlaylist();
            var _local_2:Array<ASAny> = [];
            var _local_3= -1;
            if (k != null)
            {
                _local_4 = 0;
                while (_local_4 < k.length)
                {
                    _local_5 = k.getEntry(_local_4);
                    if (_local_5 != null)
                    {
                        _local_2.push(_local_5);
                    }
                    _local_4++;
                }
                _local_3 = k.playPosition;
            }
            this._playListEditorView.refresh(_local_2, _local_3);
        }

        public function _Str_25748()
        {
            var _local_3:ISongInfo = null;
            this._Str_24609();
            this._Str_16190();
            var k= this._musicController.getRoomItemPlaylist();
            if (k == null)
            {
                return;
            }
            var _local_2= k.nowPlayingSongId;
            if (_local_2 != -1)
            {
                _local_3 = this._musicController.getSongInfo(_local_2);
                this._playListStatusView._Str_11249 = _local_3.name;
                this._playListStatusView._Str_9732 = _local_3.creator;
            }
            this._playlistScrollBar.visible = (k.length > _Str_15951);
        }

        public function _Str_25286()
        {
            this._musicInventoryView.refresh();
            this._Str_18647();
            this._myMusicScrollBar.visible = (this._musicInventoryView.itemCount > _Str_17484);
        }

        public function onNowPlayingChanged(k:_Str_3301)
        {
            var _local_2:ISongInfo = null;
            var _local_3:ISongInfo = null;
            switch (k.type)
            {
                case _Str_3301.RWPLENPE_SONG_CHANGED:
                    this._Str_16190();
                    this._playListEditorView._Str_21115(k.position);
                    if (k.id != -1)
                    {
                        _local_3 = this._musicController.getSongInfo(k.id);
                        this._playListStatusView._Str_11249 = ((_local_3 != null) ? _local_3.name : "");
                        this._playListStatusView._Str_9732 = ((_local_3 != null) ? _local_3.creator : "");
                    }
                    return;
                case _Str_3301.RWPLENPE_USER_PLAY_SONG:
                    this._musicInventoryView._Str_24959();
                    _local_2 = this._musicController.getSongInfo(k.id);
                    this._musicStatusView.songName = ((_local_2 != null) ? _local_2.name : "");
                    this._musicStatusView.songName = ((_local_2 != null) ? _local_2.name : "");
                    this._musicStatusView._Str_6415 = ((_local_2 != null) ? _local_2.creator : "");
                    this._Str_18647();
                    return;
                case _Str_3301.RWPLENPW_USER_STOP_SONG:
                    this._musicInventoryView._Str_22162();
                    this._Str_18647();
                    return;
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.hide();
        }

        function _Str_23997():Bool
        {
            return !(this._musicController.getSongIdPlayingAtPriority(HabboMusicPrioritiesEnum.PRIORITY_SONG_PLAY) == -1);
        }
    }

