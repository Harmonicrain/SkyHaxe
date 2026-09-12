package com.sulake.habbo.ui.widget.playlisteditor
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.ITextWindow;

     class MusicInventoryGridItem 
    {
        public static inline final _Str_8425= 0;
        public static inline final _Str_13281= 1;
        public static inline final _Str_13230= 2;
        static inline final _Str_7833:UInt = 14612159;
        static inline final _Str_8065:UInt = 0xF1F1F1;

        var _widget:PlaylistEditorWidget;
        var _window:IWindowContainer = null;
        var _diskId:Int = 0;
        var _songId:Int = 0;
        var _toPlayListButton:IContainerButtonWindow = null;
        var _buttonState:Int = 0;

        public function new(k:PlaylistEditorWidget, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:ColorTransform)
        {
            this._widget = k;
            this._diskId = _arg_2;
            this._songId = _arg_3;
            this.createWindow();
            this.deselect();
            if (((!(_arg_4 == null)) && (!(_arg_5 == null))))
            {
                this._Str_8410 = _arg_4;
                this._Str_10802 = _arg_5;
            }
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window ;
        }

        public var diskId(get,never):Int;
public function  get_diskId():Int
        {
            return this._diskId;
        }

        public var songId(get,never):Int;
public function  get_songId():Int
        {
            return this._songId;
        }

        public var _Str_23170(get,never):IContainerButtonWindow;
public function  get__Str_23170():IContainerButtonWindow
        {
            return this._toPlayListButton;
        }

        
        public var _Str_8343(get,set):Int;
public function  get__Str_8343():Int
        {
            return this._buttonState;
        }

        public function update(k:Int, _arg_2:String, _arg_3:ColorTransform)
        {
            if (k == this._songId)
            {
                this._Str_8410 = _arg_2;
                this._Str_10802 = _arg_3;
            }
        }

        public function destroy()
        {
            if (this._window != null)
            {
                this._window.destroy();
            }
        }

        function createWindow()
        {
            var _local_3:BitmapDataAsset = null;
            if (this._widget == null)
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("playlisteditor_music_inventory_item") , XmlAsset);
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            var _local_2= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_2 != null)
            {
                this._toPlayListButton = Std.downcast(_local_2.getChildByName("button_to_playlist") , IContainerButtonWindow);
            }
            this._Str_7584("title_fader", Std.downcast(this._window.getChildByName("title_fader_bitmap") , IBitmapWrapperWindow));
            _local_3 = Std.downcast(this._widget.assets.getAssetByName("icon_arrow") , BitmapDataAsset);
            if (_local_3 != null)
            {
                if (_local_3.content != null)
                {
                    this._Str_24361 = ASCompat.dynamicAs(_local_3.content , BitmapData);
                }
            }
            this._Str_8343 = _Str_8425;
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

        public var _Str_10802(never,set):ColorTransform;
public function  set__Str_10802(k:ColorTransform):ColorTransform        {
            var _local_3:BitmapData = null;
            var _local_4:BitmapData = null;
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("icon_cd_big") , BitmapDataAsset);
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
public function  set__Str_8343(k:Int):Int        {
            var _local_2:BitmapDataAsset = null;
            if (k == _Str_8425)
            {
                _local_2 = Std.downcast(this._widget.assets.getAssetByName("icon_play") , BitmapDataAsset);
            }
            else
            {
                if (k == _Str_13281)
                {
                    _local_2 = Std.downcast(this._widget.assets.getAssetByName("icon_pause") , BitmapDataAsset);
                }
                else
                {
                    if (k == _Str_13230)
                    {
                        _local_2 = Std.downcast(this._widget.assets.getAssetByName("icon_download") , BitmapDataAsset);
                    }
                }
            }
            if (_local_2 != null)
            {
                if (_local_2.content != null)
                {
                    this._Str_23896 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                }
            }
            return this._buttonState = k;
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

        var _Str_14890(never,set):BitmapData;
function  set__Str_14890(k:BitmapData):BitmapData        {
            var _local_2= Std.downcast(this._window.getChildByName("disk_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.bitmap = k;
            }
return k;
        }

        var _Str_24361(never,set):BitmapData;
function  set__Str_24361(k:BitmapData):BitmapData        {
            this._Str_20607("button_to_playlist", "image_button_to_playlist", k);
return k;
        }

        var _Str_23896(never,set):BitmapData;
function  set__Str_23896(k:BitmapData):BitmapData        {
            this._Str_20607("button_play_pause", "image_button_play_pause", k);
return k;
        }

        function _Str_20607(k:String, _arg_2:String, _arg_3:BitmapData)
        {
            if (_arg_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._window.getChildByName("action_buttons") , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            _local_4 = Std.downcast(_local_4.getChildByName(k) , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.getChildByName(_arg_2) , IBitmapWrapperWindow);
            if (_local_5 != null)
            {
                _local_5.bitmap = _arg_3.clone();
                _local_5.width = _arg_3.width;
                _local_5.height = _arg_3.height;
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
    }

