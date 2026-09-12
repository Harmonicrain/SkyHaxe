package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class MusicInventoryStatusView 
    {
        public static inline final MISV_BUY_MORE= "MISV_BUY_MORE";
        public static inline final MISV_PREVIEW_PLAYING= "MISV_PREVIEW_PLAYING";

        var _container:IWindowContainer;
        var _windows:Map;
        var _widget:PlaylistEditorWidget;
        var _currentView:String;
        var _songNameElement:ITextWindow;
        var _songAuthorElement:ITextWindow;

        public function new(k:PlaylistEditorWidget, _arg_2:IWindowContainer)
        {
            this._windows = new Map();
            this._container = _arg_2;
            this._widget = k;
            this._Str_18317();
            this.hide();
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

        public function show()
        {
            this._container.visible = true;
        }

        public function hide()
        {
            this._container.visible = false;
        }

        public function _Str_3734(k:String)
        {
            this._container.removeChildAt(0);
            this._container.addChildAt(ASCompat.dynamicAs(this._windows.getValue(k), IWindowContainer), 0);
            this._currentView = k;
        }

        public var songName(never,set):String;
public function  set_songName(k:String):String        {
            if (this._songNameElement == null)
            {
                return k;
            }
            return this._songNameElement.text = k;
        }

        public var _Str_6415(never,set):String;
public function  set__Str_6415(k:String):String        {
            if (this._songAuthorElement == null)
            {
                return k;
            }
            return this._songAuthorElement.text = k;
        }

        public function _Str_20507(k:BitmapData, _arg_2:Bool=true)
        {
            this._Str_19789(MISV_PREVIEW_PLAYING, "preview_play_background_image", k);
            if ((_arg_2 && (!(k == null))))
            {
                k.dispose();
            }
        }

        public function _Str_21729(k:BitmapData, _arg_2:Bool=true)
        {
            this._Str_19789(MISV_BUY_MORE, "get_more_music_background_image", k);
            if ((_arg_2 && (!(k == null))))
            {
                k.dispose();
            }
        }

        function _Str_18317()
        {
            var k:IWindowContainer = null;
            var _local_2:XmlAsset = null;
            var _local_3:IButtonWindow = null;
            var _local_4:IButtonWindow = null;
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("playlisteditor_inventory_subwindow_play_preview") , XmlAsset);
            k = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (k != null)
            {
                this._windows.add(MISV_PREVIEW_PLAYING, k);
                this._songNameElement = Std.downcast(k.getChildByName("preview_play_track_name") , ITextWindow);
                this._songAuthorElement = Std.downcast(k.getChildByName("preview_play_author_name") , ITextWindow);
                _local_3 = Std.downcast(k.getChildByName("stop_preview_button") , IButtonWindow);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_24304);
                this._Str_20507(this._widget._Str_8169(PlayListEditorWidgetAssetsEnum.BACKGROUND_PREVIEW_PLAYING));
                this._Str_7584("jb_icon_disc", Std.downcast(k.getChildByName("song_name_icon_bitmap") , IBitmapWrapperWindow));
                this._Str_7584("jb_icon_composer", Std.downcast(k.getChildByName("author_name_icon_bitmap") , IBitmapWrapperWindow));
            }
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("playlisteditor_inventory_subwindow_get_more_music") , XmlAsset);
            k = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (k != null)
            {
                this._windows.add(MISV_BUY_MORE, k);
                _local_4 = Std.downcast(k.getChildByName("open_catalog_button") , IButtonWindow);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_25633);
                this._Str_21729(this._widget._Str_8169(PlayListEditorWidgetAssetsEnum.BACKGROUND_GET_MORE_MUSIC));
            }
        }

        function _Str_19789(k:String, _arg_2:String, _arg_3:BitmapData)
        {
            var _local_6:BitmapData = null;
            var _local_4= ASCompat.dynamicAs(this._windows.getValue(k), IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.getChildByName(_arg_2) , IBitmapWrapperWindow);
            if (_local_5 == null)
            {
                return;
            }
            if (_arg_3 != null)
            {
                _local_6 = new BitmapData(_local_5.width, _local_5.height, false, 0xFFFFFFFF);
                _local_6.copyPixels(_arg_3, _arg_3.rect, new Point(0, 0));
                _local_5.bitmap = _local_6;
            }
        }

        function _Str_7584(k:String, _arg_2:IBitmapWrapperWindow)
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

        function _Str_25633(k:WindowMouseEvent)
        {
            this._widget._Str_25595();
        }

        function _Str_24304(k:WindowMouseEvent)
        {
            this._widget._Str_16919();
        }
    }

