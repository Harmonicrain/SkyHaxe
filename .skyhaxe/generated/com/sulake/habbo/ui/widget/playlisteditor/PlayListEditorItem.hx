package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.XmlAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.ITextWindow;

     class PlayListEditorItem 
    {
        public static inline final PLEI_ICON_STATE_NORMAL= "PLEI_ICON_STATE_NORMAL";
        public static inline final PLEI_ICON_STATE_PLAYING= "PLEI_ICON_STATE_PLAYING";
        static inline final _Str_7833:UInt = 14283002;
        static inline final _Str_8065:UInt = 0xF1F1F1;

        var _widget:PlaylistEditorWidget;
        var _window:IWindowContainer;
        var _removeButton:IContainerButtonWindow = null;
        var _colorTransform:ColorTransform;

        public function new(k:PlaylistEditorWidget, _arg_2:String, _arg_3:String, _arg_4:ColorTransform)
        {
            this._widget = k;
            this._colorTransform = _arg_4;
            this.createWindow();
            this._Str_15168(PLEI_ICON_STATE_NORMAL);
            this.deselect();
            this._Str_8410 = _arg_2;
            this._Str_24145 = _arg_3;
            this._Str_10802 = _arg_4;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window ;
        }

        public var _Str_25542(get,never):IContainerButtonWindow;
public function  get__Str_25542():IContainerButtonWindow
        {
            return this._removeButton;
        }

        function createWindow()
        {
            var _local_2:BitmapDataAsset = null;
            if (this._widget == null)
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("playlisteditor_playlist_item") , XmlAsset);
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            _local_2 = Std.downcast(this._widget.assets.getAssetByName("icon_arrow_left") , BitmapDataAsset);
            if (_local_2 != null)
            {
                if (_local_2.content != null)
                {
                    this._Str_24045 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                }
            }
            this._Str_7584("jb_icon_disc", Std.downcast(this._window.getChildByName("song_name_icon_bitmap") , IBitmapWrapperWindow));
            this._Str_7584("jb_icon_composer", Std.downcast(this._window.getChildByName("author_name_icon_bitmap") , IBitmapWrapperWindow));
            var _local_3= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3 = Std.downcast(_local_3.getChildByName("button_border") , IWindowContainer);
                if (_local_3 != null)
                {
                    this._removeButton = Std.downcast(_local_3.getChildByName("button_remove_from_playlist") , IContainerButtonWindow);
                }
            }
        }

        public function select()
        {
            var k= Std.downcast(this._window.getChildByName("background") , IBorderWindow);
            if (k != null)
            {
                k.color = _Str_7833;
            }
            var _local_2= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_2 != null)
            {
                _local_2.visible = true;
            }
            var _local_3= Std.downcast(this._window.getChildByName("selected") , IBorderWindow);
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
        }

        public function deselect()
        {
            var k= Std.downcast(this._window.getChildByName("background") , IBorderWindow);
            if (k != null)
            {
                k.color = _Str_8065;
            }
            var _local_2= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_2 != null)
            {
                _local_2.visible = false;
            }
            var _local_3= Std.downcast(this._window.getChildByName("selected") , IBorderWindow);
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
        }

        public function _Str_15168(k:String)
        {
            var _local_2:BitmapDataAsset = null;
            var _local_3:BitmapData = null;
            switch (k)
            {
                case PLEI_ICON_STATE_NORMAL:
                    this._Str_10802 = this._colorTransform;
                    return;
                case PLEI_ICON_STATE_PLAYING:
                    _local_2 = Std.downcast(this._widget.assets.getAssetByName("icon_notes_small") , BitmapDataAsset);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    if (_local_2.content != null)
                    {
                        _local_3 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                        this._Str_14890 = _local_3.clone();
                    }
                    return;
            }
        }

        public var _Str_10802(never,set):ColorTransform;
public function  set__Str_10802(k:ColorTransform):ColorTransform        {
            var _local_3:BitmapData = null;
            var _local_4:BitmapData = null;
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("icon_cd_small") , BitmapDataAsset);
            if (_local_2 == null)
            {
                return k;
            }
            if (_local_2.content != null)
            {
                _local_3 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                _local_4 = _local_3.clone();
                if (_local_4 != null)
                {
                    _local_4.colorTransform(_local_3.rect, k);
                    this._Str_14890 = _local_4;
                }
            }
return k;
        }

        public var _Str_8410(never,set):String;
public function  set__Str_8410(k:String):String        {
            var _local_2= Std.downcast(this._window.getChildByName("song_title_text") , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.text = k;
            }
return k;
        }

        public var _Str_24145(never,set):String;
public function  set__Str_24145(k:String):String        {
            var _local_2= Std.downcast(this._window.getChildByName("song_author_text") , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.text = k;
            }
return k;
        }

        var _Str_14890(never,set):BitmapData;
function  set__Str_14890(k:BitmapData):BitmapData        {
            var _local_2= Std.downcast(this._window.getChildByName("disk_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.bitmap = k;
            }
return k;
        }

        var _Str_24045(never,set):BitmapData;
function  set__Str_24045(k:BitmapData):BitmapData        {
            if (k == null)
            {
                return k;
            }
            var _local_2= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2 = Std.downcast(_local_2.getChildByName("button_border") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2 = Std.downcast(_local_2.getChildByName("button_remove_from_playlist") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            var _local_3= Std.downcast(_local_2.getChildByName("button_remove_from_playlist_image") , IBitmapWrapperWindow);
            if (_local_3 != null)
            {
                _local_3.bitmap = k.clone();
                _local_3.width = k.width;
                _local_3.height = k.height;
            }
return k;
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
    }

