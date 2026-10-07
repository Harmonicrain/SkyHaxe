package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.events._Str_2693;
    import com.sulake.habbo.ui.widget.events._Str_3301;
    import flash.events.IEventDispatcher;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPlayListModificationMessage;
    import com.sulake.habbo.sound.IPlayListController;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPlayListPlayStateMessage;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.sound.HabboMusicPrioritiesEnum;
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPlayListUserActionMessage;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;

     class PlaylistEditorWidget extends RoomWidgetBase
    {
        static inline final _Str_17485= 130;
        static inline final _Str_16479= 100;
        static inline final _Str_18630= 130;
        static inline final _Str_15986= 100;
        static inline final _Str_18472= 130;
        static inline final _Str_16988= 100;

        var _catalog:IHabboCatalog;
        var _configurationManager:IHabboConfigurationManager;
        var _soundManager:IHabboSoundManager;
        var _Str_2314:MainWindowHandler;
        var _furniId:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IHabboSoundManager, _arg_4:IAssetLibrary, _arg_5:IHabboLocalizationManager, _arg_6:IHabboConfigurationManager, _arg_7:IHabboCatalog)
        {
            super(k, _arg_2, _arg_4, _arg_5);
            this._soundManager = _arg_3;
            this._configurationManager = _arg_6;
            this._catalog = _arg_7;
            this._Str_2314 = null;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._Str_2314 != null)
                {
                    this._Str_2314.destroy();
                    this._Str_2314 = null;
                }
                this._soundManager = null;
                super.dispose();
            }
        }

        override public function  get_mainWindow():IWindow
        {
            if (this._Str_2314 == null)
            {
                return null;
            }
            return this._Str_2314.window;
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            k.addEventListener(_Str_2693.RWPLEE_SHOW_PLAYLIST_EDITOR, this._Str_19678);
            k.addEventListener(_Str_2693.RWPLEE_HIDE_PLAYLIST_EDITOR, this._Str_19485);
            k.addEventListener(_Str_2693.RWPLEE_INVENTORY_UPDATED, this._Str_20116);
            k.addEventListener(_Str_2693.RWPLEE_SONG_DISK_INVENTORY_UPDATED, this._Str_22187);
            k.addEventListener(_Str_2693.RWPLEE_PLAY_LIST_UPDATED, this._Str_19711);
            k.addEventListener(_Str_2693.RWPLEE_PLAY_LIST_FULL, this._Str_21874);
            k.addEventListener(_Str_3301.RWPLENPE_SONG_CHANGED, this._Str_9132);
            k.addEventListener(_Str_3301.RWPLENPE_USER_PLAY_SONG, this._Str_9132);
            k.addEventListener(_Str_3301.RWPLENPW_USER_STOP_SONG, this._Str_9132);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            k.removeEventListener(_Str_2693.RWPLEE_SHOW_PLAYLIST_EDITOR, this._Str_19678);
            k.removeEventListener(_Str_2693.RWPLEE_HIDE_PLAYLIST_EDITOR, this._Str_19485);
            k.removeEventListener(_Str_2693.RWPLEE_INVENTORY_UPDATED, this._Str_20116);
            k.removeEventListener(_Str_2693.RWPLEE_SONG_DISK_INVENTORY_UPDATED, this._Str_22187);
            k.removeEventListener(_Str_2693.RWPLEE_PLAY_LIST_UPDATED, this._Str_19711);
            k.removeEventListener(_Str_2693.RWPLEE_PLAY_LIST_FULL, this._Str_21874);
            k.removeEventListener(_Str_3301.RWPLENPE_SONG_CHANGED, this._Str_9132);
            k.removeEventListener(_Str_3301.RWPLENPE_USER_PLAY_SONG, this._Str_9132);
            k.removeEventListener(_Str_3301.RWPLENPW_USER_STOP_SONG, this._Str_9132);
        }

        public var _Str_15010(get,never):MainWindowHandler;
public function  get__Str_15010():MainWindowHandler
        {
            return this._Str_2314;
        }

        public function _Str_18331(k:String):ColorTransform
        {
            var _local_2:UInt = 0;
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var _local_5 = 0;
            while (_local_5 < k.length)
            {
                switch ((_local_5 % 3))
                {
                    case 0:
                        _local_2 = (_local_2 + ASCompat.asInt((k.charCodeAt(_local_5) * 37) ));
                        
                    case 1:
                        _local_3 = (_local_3 + ASCompat.asInt((k.charCodeAt(_local_5) * 37) ));
                        
                    case 2:
                        _local_4 = (_local_4 + ASCompat.asInt((k.charCodeAt(_local_5) * 37) ));
                        
                }
                _local_5++;
            }
            _local_2 = ((_local_2 % _Str_16479) + _Str_17485);
            _local_3 = ((_local_3 % _Str_15986) + _Str_18630);
            _local_4 = ((_local_4 % _Str_16988) + _Str_18472);
            return new ColorTransform((_local_2 / 0xFF), (_local_3 / 0xFF), (_local_4 / 0xFF));
        }

        public function _Str_23659(k:Int)
        {
            var _local_3 = 0;
            var _local_4:RoomWidgetPlayListModificationMessage = null;
            var _local_2= this._soundManager.musicController.getRoomItemPlaylist();
            if (_local_2 != null)
            {
                _local_3 = _local_2.length;
                _local_4 = new RoomWidgetPlayListModificationMessage(RoomWidgetPlayListModificationMessage.RWPLAM_ADD_TO_PLAYLIST, _local_3, k);
                if (messageListener != null)
                {
                    messageListener.processWidgetMessage(_local_4);
                }
            }
        }

        public function _Str_20304(k:Int)
        {
            var _local_2= new RoomWidgetPlayListModificationMessage(RoomWidgetPlayListModificationMessage.RWPLAM_REMOVE_FROM_PLAYLIST, k);
            if (messageListener != null)
            {
                messageListener.processWidgetMessage(_local_2);
            }
        }

        public function _Str_23449()
        {
            var k = 0;
            if (((!(this._Str_2314 == null)) && (!(this._Str_2314._Str_15855 == null))))
            {
                k = ((this._Str_2314._Str_15855._Str_4405 != -1) ? this._Str_2314._Str_15855._Str_4405 : 0);
            }
            var _local_2= new RoomWidgetPlayListPlayStateMessage(RoomWidgetPlayListPlayStateMessage.RWPLPS_TOGGLE_PLAY_PAUSE, this._furniId, k);
            if (messageListener != null)
            {
                messageListener.processWidgetMessage(_local_2);
            }
        }

        public function _Str_25259(k:Int)
        {
            var _local_3:ISongInfo = null;
            var _local_2= this._soundManager.musicController.getSongIdPlayingAtPriority(HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST);
            if (_local_2 != -1)
            {
                _local_3 = this._soundManager.musicController.getSongInfo(_local_2);
                if (_local_3.soundObject != null)
                {
                    _local_3.soundObject.fadeOutSeconds = 0;
                }
            }
            this._soundManager.musicController.playSong(k, HabboMusicPrioritiesEnum.PRIORITY_SONG_PLAY, 0, 0, 0, 0);
        }

        public function _Str_16919()
        {
            this._soundManager.musicController.stop(HabboMusicPrioritiesEnum.PRIORITY_SONG_PLAY);
        }

        public function _Str_8169(k:String):BitmapData
        {
            var _local_3:BitmapData = null;
            var _local_2= Std.downcast(this.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 == null)
            {
                return null;
            }
            _local_3 = ASCompat.dynamicAs(_local_2.content , BitmapData);
            return _local_3.clone();
        }

        public function _Str_24749(k:String)
        {
            var _local_2= this._configurationManager.getProperty("image.library.playlist.url");
            var _local_3:ASAny = ((_local_2 + k) + ".gif");
            Logger.log([("[PlayListEditorWidget]  : " + _local_3)]);
            var _local_4= new URLRequest(_local_3);
            var _local_5= this.assets.loadAssetFromFile(k, _local_4, "image/gif");
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_24982);
        }

        public function _Str_25595()
        {
            var k= new RoomWidgetPlayListUserActionMessage(RoomWidgetPlayListUserActionMessage.RWPLUA_OPEN_CATALOGUE_BUTTON_PRESSED);
            if (messageListener != null)
            {
                messageListener.processWidgetMessage(k);
            }
            this._catalog.openCatalogPage(CatalogPageName.TRAX_SONGS);
        }

        public function _Str_25543()
        {
            this.windowManager.alert(("$" + "{playlist.editor.alert.playlist.full.title}"), ("$" + "{playlist.editor.alert.playlist.full}"), 0, this.alertHandler);
        }

        function alertHandler(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function _Str_19678(k:_Str_2693)
        {
            var _local_2:IPlayListController = null;
            this._furniId = k.furniId;
            if (this._Str_2314 == null)
            {
                this._Str_2314 = new MainWindowHandler(this, this._soundManager.musicController);
                this._Str_2314.window.visible = false;
            }
            if (!this._Str_2314.window.visible)
            {
                this._Str_2314.show();
                this._soundManager.musicController.requestUserSongDisks();
                _local_2 = this._soundManager.musicController.getRoomItemPlaylist();
                if (_local_2 != null)
                {
                    _local_2.requestPlayList();
                }
            }
        }

        function _Str_19485(k:_Str_2693)
        {
            if (this._Str_2314 != null)
            {
                if (this._Str_2314.window.visible)
                {
                    this._Str_2314.hide();
                }
            }
        }

        function _Str_20116(k:_Str_2693)
        {
            if (this._Str_2314 == null)
            {
                return;
            }
            if (this._Str_2314.window.visible)
            {
                this._soundManager.musicController.requestUserSongDisks();
            }
        }

        function _Str_24982(k:AssetLoaderEvent)
        {
            var _local_2:AssetLoaderStruct = null;
            if (k.type == AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
                if (_local_2 != null)
                {
                    if (this._Str_2314 != null)
                    {
                        this._Str_2314._Str_19051(_local_2.assetName);
                    }
                }
            }
        }

        function _Str_22187(k:_Str_2693)
        {
            if (this._Str_2314 != null)
            {
                this._Str_2314._Str_25286();
            }
        }

        function _Str_19711(k:_Str_2693)
        {
            if (this._Str_2314 != null)
            {
                this._Str_2314._Str_25748();
            }
        }

        function _Str_21874(k:_Str_2693)
        {
            this._Str_25543();
        }

        function _Str_9132(k:_Str_3301)
        {
            if (this._Str_2314 != null)
            {
                this._Str_2314.onNowPlayingChanged(k);
            }
        }
    }

