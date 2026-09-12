package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.BitmapDataAsset;

     class PlayListStatusView 
    {
        public static inline final PLSV_ADD_SONGS= "PLSV_ADD_SONGS";
        public static inline final PLSV_START_PLAYBACK= "PLSV_START_PLAYBACK";
        public static inline final PLSV_NOW_PLAYING= "PLSV_NOW_PLAYING";

        var _container:IWindowContainer;
        var _windows:Map;
        var _widget:PlaylistEditorWidget;
        var _currentView:String;

        public function new(k:PlaylistEditorWidget, _arg_2:IWindowContainer)
        {
            this._windows = new Map();
            this._container = _arg_2;
            this._widget = k;
            this._Str_18317();
        }

        public function destroy()
        {
            var k:IWindowContainer = null;
            final _iter_ = this._windows.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.destroy();
            }
            this._windows = null;
        }

        public function _Str_3734(k:String)
        {
            this._container.removeChildAt(0);
            this._container.addChildAt(ASCompat.dynamicAs(this._windows.getValue(k), IWindowContainer), 0);
            this._currentView = k;
        }

        public var _Str_11249(never,set):String;
public function  set__Str_11249(k:String):String        {
            if (this._currentView != PLSV_NOW_PLAYING)
            {
                return k;
            }
            var _local_2:IWindowContainer = this._windows.getValue(this._currentView);
            var _local_3= Std.downcast(_local_2.getChildByName("now_playing_track_name") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = k;
            }
return k;
        }

        public var _Str_9732(never,set):String;
public function  set__Str_9732(k:String):String        {
            if (this._currentView != PLSV_NOW_PLAYING)
            {
                return k;
            }
            var _local_2:IWindowContainer = this._windows.getValue(this._currentView);
            var _local_3= Std.downcast(_local_2.getChildByName("now_playing_author_name") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = k;
            }
return k;
        }

        public var _Str_24999(never,set):BitmapData;
public function  set__Str_24999(k:BitmapData):BitmapData        {
            if (k == null)
            {
                return k;
            }
            var _local_2:IWindowContainer = this._windows.getValue(PLSV_ADD_SONGS);
            if (_local_2 == null)
            {
                return k;
            }
            var _local_3= Std.downcast(_local_2.getChildByName("background_image") , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return k;
            }
            _local_3.bitmap = k.clone();
            _local_3.width = k.width;
            _local_3.height = k.height;
return k;
        }

        function _Str_18317()
        {
            var k:IWindowContainer = null;
            var _local_2:XmlAsset = null;
            var _local_3:IButtonWindow = null;
            var _local_4:IContainerButtonWindow = null;
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("playlisteditor_playlist_subwindow_add_songs") , XmlAsset);
            k = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (k != null)
            {
                this._windows.add(PLSV_ADD_SONGS, k);
            }
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("playlisteditor_playlist_subwindow_play_now") , XmlAsset);
            k = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (k != null)
            {
                this._windows.add(PLSV_START_PLAYBACK, k);
                _local_3 = Std.downcast(k.getChildByName("play_now_button") , IButtonWindow);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_20826);
            }
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("playlisteditor_playlist_subwindow_nowplaying") , XmlAsset);
            k = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (k != null)
            {
                this._windows.add(PLSV_NOW_PLAYING, k);
                _local_4 = Std.downcast(k.getChildByName("button_pause") , IContainerButtonWindow);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_20826);
                this._Str_16778("icon_pause_large", Std.downcast(_local_4.getChildByName("pause_image") , IBitmapWrapperWindow));
                this._Str_16778("jb_icon_disc", Std.downcast(k.getChildByName("song_name_icon_bitmap") , IBitmapWrapperWindow));
                this._Str_16778("jb_icon_composer", Std.downcast(k.getChildByName("author_name_icon_bitmap") , IBitmapWrapperWindow));
            }
        }

        function _Str_16778(k:String, _arg_2:IBitmapWrapperWindow)
        {
            var _local_4:BitmapData = null;
            var _local_3= Std.downcast(this._widget.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_3 != null)
            {
                if (((!(_arg_2 == null)) && (!(_local_3.content == null))))
                {
                    _local_4 = ASCompat.dynamicAs(_local_3.content , BitmapData);
                    _arg_2.bitmap = _local_4.clone();
                }
            }
        }

        function _Str_20826(k:WindowMouseEvent)
        {
            this._widget._Str_23449();
        }
    }

