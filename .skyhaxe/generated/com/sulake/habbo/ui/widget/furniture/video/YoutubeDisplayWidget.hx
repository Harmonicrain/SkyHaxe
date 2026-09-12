package com.sulake.habbo.ui.widget.furniture.video
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FurnitureYoutubeDisplayWidgetHandler;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window._enum.WindowParam;
    import flash.system.Security;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.display.LoaderInfo;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.YoutubeDisplayPlaylist;

     class YoutubeDisplayWidget extends RoomWidgetBase
    {
        static inline final _Str_13698:UInt = 0xFFCCCCFF;
        static inline final _Str_16441:UInt = 0xFFFFFFFF;

        var _habboTracking:IHabboTracking;
        var _player:ASObject;
        var _window:IWindowContainer;
        var _roomObject:IRoomObject;
        var _selectedItem:IWindowContainer;
        var _itemTemplate:IWindow;
        var _queuedVideoParams:ASObject;
        var _currentVideoId:String;
        var _canControlPlayback:Bool = false;
        var _currentVideoPlaybackState:Int = -1;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboTracking)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._habboTracking = _arg_5;
            this.ownHandler.widget = this;
        }

        var ownHandler(get,never):FurnitureYoutubeDisplayWidgetHandler;
function  get_ownHandler():FurnitureYoutubeDisplayWidgetHandler
        {
            return Std.downcast(_handler , FurnitureYoutubeDisplayWidgetHandler);
        }

        override public function  get_mainWindow():IWindow
        {
            return this._window;
        }

        public function show(k:IRoomObject, _arg_2:Bool)
        {
            this._roomObject = k;
            this._canControlPlayback = _arg_2;
            this.createWindow(_arg_2);
            this._window.visible = true;
        }

        function createWindow(k:Bool)
        {
            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("video_viewer_xml").content)) , IWindowContainer);
            if (k)
            {
                this._itemTemplate = cast(this._window.findChildByName("playlists"), IItemListWindow).removeListItemAt(0);
            }
            else
            {
                this._window.findChildByName("right_pane").dispose();
                this._window.findChildByName("video_background").width = (this._window.width - 20);
                this._window.findChildByName("video_background").setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH);
                this._window.width = (this._window.width - 250);
            }
            this._window.procedure = this.windowProcedure;
            this._window.center();
            this._Str_25201();
        }

        function _Str_25201()
        {
            Security.allowDomain(["www.youtube.com"]);
            Security.allowDomain(["ytimg.com"]);
            Security.allowDomain(["s.ytimg.com"]);
            var k= new Loader();
            k.contentLoaderInfo.addEventListener(Event.INIT, (this._Str_23038 : ASAny));
            k.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
        }

        function _Str_23038(k:Event)
        {
            var _local_3:Loader = null;
            if (this._window == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(k.target , LoaderInfo);
            if (_local_2 != null)
            {
                _local_3 = _local_2.loader;
                cast(this._window.findChildByName("video_wrapper"), IDisplayObjectWrapper).setDisplayObject(_local_3);
                _local_3.content.addEventListener("onReady", (this._Str_16623 : ASAny));
                _local_3.content.addEventListener("onStateChange", (this._Str_24061 : ASAny));
                _local_3.content.addEventListener(MouseEvent.MOUSE_UP, (this._Str_11921 : ASAny));
                _local_3.content.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_11921 : ASAny));
            }
        }

        function _Str_11921(k:MouseEvent)
        {
            if (((!(this._window == null)) && this._canControlPlayback))
            {
                cast(k.target, DisplayObject).stage.dispatchEvent(new MouseEvent(k.type));
                if (((ASCompat.toBool(this._player) && (k.type == MouseEvent.MOUSE_UP)) && (!(this._currentVideoId == ""))))
                {
                    if (this._player.getPlayerState() == YoutubeVideoPlaybackStateEnum._Str_5825)
                    {
                        this.ownHandler.pauseVideo(this._roomObject.getId());
                    }
                    else
                    {
                        if (this._player.getPlayerState() == YoutubeVideoPlaybackStateEnum._Str_6168)
                        {
                            this.ownHandler.continueVideo(this._roomObject.getId());
                        }
                    }
                }
            }
        }

        function _Str_16623(k:Event)
        {
            var _local_2:IWindow = null;
            this._player = k.target;
            if (this._window != null)
            {
                _local_2 = this._window.findChildByName("video_wrapper");
                this._player.setSize(_local_2.width, _local_2.height);
                if (this._queuedVideoParams != null)
                {
                    this.loadVideo(this._queuedVideoParams);
                    this._queuedVideoParams = null;
                }
            }
            else
            {
                this._player.destroy();
            }
        }

        function _Str_24061(k:Event)
        {
            this._player = k.target;
            if (this._window != null)
            {
                switch (this._player.getPlayerState())
                {
                    case -1
                       | 1:
                        if (this._currentVideoPlaybackState == 2)
                        {
                            this._player.pauseVideo();
                        }
                        return;
                }
            }
        }

        public function hide(k:IRoomObject)
        {
            if (this._roomObject != k)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._itemTemplate != null)
            {
                this._itemTemplate.dispose();
                this._itemTemplate = null;
            }
            if (this._player != null)
            {
                this._player.destroy();
                this._player = null;
            }
            if (this._currentVideoId != null)
            {
                this._habboTracking.trackEventLog("YouTubeTVs", this._currentVideoId, "video.closed");
            }
            this._queuedVideoParams = null;
            this._selectedItem = null;
            this._roomObject = null;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this.hide(this._roomObject);
            this._habboTracking = null;
            super.dispose();
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:IWindow = null;
            var _local_8 = 0;
            var _local_9:IWindowContainer = null;
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    switch (_arg_2.name)
                    {
                        case "header_button_close":
                            this.hide(this._roomObject);
                            
                        case "playlist_prev":
                            this.ownHandler.switchToPreviousVideo(this._roomObject.getId());
                            
                        case "playlist_next":
                            this.ownHandler.switchToNextVideo(this._roomObject.getId());
                            
                        default:
                            if (Std.is(_arg_2 , IRegionWindow))
                            {
                                if (this._selectedItem != null)
                                {
                                    this._selectedItem.findChildByName("item_background").color = _Str_16441;
                                }
                                if ((this._selectedItem : ASAny) == (_arg_2 : ASAny))
                                {
                                    this._selectedItem = null;
                                    this.ownHandler.selectPlaylist(this._roomObject.getId(), "");
                                }
                                else
                                {
                                    this._selectedItem = Std.downcast(_arg_2 , IWindowContainer);
                                    this._selectedItem.findChildByName("item_background").color = _Str_13698;
                                    this.ownHandler.selectPlaylist(this._roomObject.getId(), this._selectedItem.name);
                                }
                                this._Str_2771();
                            }
                    }
                    return;
                case WindowEvent.WINDOW_EVENT_RESIZE:
                    switch (_arg_2.name)
                    {
                        case "video_viewer":
                            if (this._window != null)
                            {
                                _local_4 = this._window.findChildByName("right_pane");
                                if (_local_4 != null)
                                {
                                    _local_5 = (this._window.width - 29);
                                    _local_6 = Std.int(_local_5 * 0.66);
                                    _local_7 = this._window.findChildByName("video_background");
                                    _local_7.width = _local_6;
                                    _local_4.x = (_local_7.right + 9);
                                    _local_4.width = (_local_5 - _local_6);
                                }
                            }
                            
                        case "playlists":
                            _local_3 = Std.downcast(_arg_2 , IItemListWindow);
                            if (_local_3 != null)
                            {
                                _local_8 = 0;
                                while (_local_8 < _local_3.numListItems)
                                {
                                    _local_9 = Std.downcast(_local_3.getListItemAt(_local_8) , IWindowContainer);
                                    _local_9.findChildByName("item_background").width = _local_3.width;
                                    _local_9.findChildByName("item_contents").width = _local_3.width;
                                    _local_9.findChildByName("item_description").width = (_local_3.width - 22);
                                    _local_8++;
                                }
                            }
                            
                        case "video_wrapper":
                            if (this._player != null)
                            {
                                this._player.setSize(_arg_2.width, _arg_2.height);
                            }
                            
                    }
            }
        }

        public function showVideo(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            if (((this._roomObject == null) || (!(this._roomObject.getId() == k))))
            {
                return;
            }
            var _local_6:ASObject = (((_arg_3 > 0) || (_arg_4 > 0)) ? ({
"videoId":_arg_2,
"startSeconds":_arg_3,
"endSeconds":_arg_4,
"suggestedQuality":"large"
}) : ({
"videoId":_arg_2,
"suggestedQuality":"large"
}));
            if (this._player != null)
            {
                this.loadVideo(_local_6);
                this._queuedVideoParams = null;
            }
            else
            {
                this._queuedVideoParams = _local_6;
            }
            this._currentVideoPlaybackState = _arg_5;
        }

        public function _Str_22371(k:Int, _arg_2:Int)
        {
            if (((this._roomObject == null) || (!(this._roomObject.getId() == k))))
            {
                return;
            }
            if (this._window != null)
            {
                if (this._player)
                {
                    switch (_arg_2)
                    {
                        case 1:
                            this._currentVideoPlaybackState = YoutubeVideoPlaybackStateEnum._Str_5825;
                            this._player.playVideo();
                            return;
                        case 2:
                            this._currentVideoPlaybackState = YoutubeVideoPlaybackStateEnum._Str_6168;
                            this._player.pauseVideo();
                            return;
                    }
                }
            }
        }

        function loadVideo(k:ASObject)
        {
            this._currentVideoId = k.videoId;
            var _local_2:ASAny = (!(this._currentVideoId == ""));
            if (_local_2)
            {
                this._player.loadVideoById(k);
                this._habboTracking.trackEventLog("YouTubeTVs", this._currentVideoId, "video.started");
            }
            else
            {
                this._player.stopVideo();
            }
            if (this._window != null)
            {
                this._window.findChildByName("no_videos_label").visible = (!_local_2);
                this._window.findChildByName("video_wrapper").visible = _local_2;
            }
        }

        public function _Str_24455(k:Int, _arg_2:Vector<YoutubeDisplayPlaylist>, _arg_3:String)
        {
            var _local_5:YoutubeDisplayPlaylist = null;
            var _local_6:IWindowContainer = null;
            if (((((this._roomObject == null) || (!(this._roomObject.getId() == k))) || (this._window == null)) || (this._itemTemplate == null)))
            {
                return;
            }
            var _local_4= Std.downcast(this._window.findChildByName("playlists") , IItemListWindow);
            if (_local_4 == null)
            {
                return;
            }
            _local_4.destroyListItems();
            this._selectedItem = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_5  = _tmp_;
                _local_6 = Std.downcast(this._itemTemplate.clone() , IWindowContainer);
                _local_6.name = _local_5.video;
                _local_6.findChildByName("item_background").width = _local_4.width;
                if (_local_5.video == _arg_3)
                {
                    _local_6.findChildByName("item_background").color = _Str_13698;
                    this._selectedItem = _local_6;
                }
                _local_6.findChildByName("item_contents").width = _local_4.width;
                _local_6.findChildByName("item_title").caption = _local_5.title;
                _local_6.findChildByName("item_description").caption = new compat.RegExp("\\r", "g").replace(_local_5.description, "");
                _local_6.findChildByName("item_description").width = (_local_4.width - 22);
                _local_4.addListItem(_local_6);
            }
            this._Str_2771();
        }

        function _Str_2771()
        {
            if (this._window == null)
            {
                return;
            }
            if (this._selectedItem != null)
            {
                this._window.findChildByName("playlist_prev").enable();
                this._window.findChildByName("playlist_next").enable();
            }
            else
            {
                this._window.findChildByName("playlist_prev").disable();
                this._window.findChildByName("playlist_next").disable();
            }
        }
    }

