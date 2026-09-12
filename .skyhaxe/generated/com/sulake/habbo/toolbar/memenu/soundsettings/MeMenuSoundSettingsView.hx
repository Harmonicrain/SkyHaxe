package com.sulake.habbo.toolbar.memenu.soundsettings
;
    import com.sulake.habbo.toolbar.memenu.MeMenuSettingsMenuView;
    import com.sulake.core.window.IWindowContainer;
	import com.sulake.habbo.toolbar.memenu.soundsettings.MeMenuSoundSettingsItem;
    import flash.display.BitmapData;
    import com.sulake.habbo.toolbar.ToolbarView;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.toolbar.memenu.MeMenuController;

     class MeMenuSoundSettingsView 
    {
        var _widget:MeMenuSettingsMenuView;
        var _window:IWindowContainer;
        var _uiSoundsSettings:MeMenuSoundSettingsItem;
        var _furniSoundsSettings:MeMenuSoundSettingsItem;
        var _traxSoundsSettings:MeMenuSoundSettingsItem;
        var _soundsOffIconColor:BitmapData;
        var _soundsOffIconWhite:BitmapData;
        var _soundsOnIconColor:BitmapData;
        var _soundsOnIconWhite:BitmapData;
        var _genericVolume:Float = 1;
        var _furniVolume:Float = 1;
        var _traxVolume:Float = 1;
        var _toolbarView:ToolbarView;


        public function init(k:MeMenuSettingsMenuView, _arg_2:ToolbarView)
        {
            this._toolbarView = _arg_2;
            this._widget = k;
            this.createWindow();
        }

        public function dispose()
        {
            this.saveVolume(this._genericVolume, this._furniVolume, this._traxVolume);
            this._widget = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            if (this._uiSoundsSettings != null)
            {
                this._uiSoundsSettings.dispose();
            }
            this._uiSoundsSettings = null;
            if (this._furniSoundsSettings != null)
            {
                this._furniSoundsSettings.dispose();
            }
            this._furniSoundsSettings = null;
            if (this._traxSoundsSettings != null)
            {
                this._traxSoundsSettings.dispose();
            }
            this._traxSoundsSettings = null;
            if (this._soundsOffIconColor != null)
            {
                this._soundsOffIconColor.dispose();
                this._soundsOffIconColor = null;
            }
            if (this._soundsOffIconWhite != null)
            {
                this._soundsOffIconWhite.dispose();
                this._soundsOffIconWhite = null;
            }
            if (this._soundsOnIconColor != null)
            {
                this._soundsOnIconColor.dispose();
                this._soundsOnIconColor = null;
            }
            if (this._soundsOnIconWhite != null)
            {
                this._soundsOnIconWhite.dispose();
                this._soundsOnIconWhite = null;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function _Str_7269()
        {
            this._genericVolume = this._widget.widget.toolbar.soundManager.genericVolume;
            this._furniVolume = this._widget.widget.toolbar.soundManager.furniVolume;
            this._traxVolume = this._widget.widget.toolbar.soundManager.traxVolume;
            if (this._uiSoundsSettings != null)
            {
                this._uiSoundsSettings.setValue(this._genericVolume);
            }
            if (this._furniSoundsSettings != null)
            {
                this._furniSoundsSettings.setValue(this._furniVolume);
            }
            if (this._traxSoundsSettings != null)
            {
                this._traxSoundsSettings.setValue(this._traxVolume);
            }
        }

        function createWindow()
        {
            var _local_2:IWindow = null;
            var k= Std.downcast(this._widget.widget.toolbar.assets.getAssetByName("me_menu_sound_settings_xml") , XmlAsset);
            this._window = Std.downcast(this._widget.widget.toolbar.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.x = (this._toolbarView.window.width + 10);
            this._window.y = (this._toolbarView.window.bottom - this._window.height);
            var _local_3 = 0;
            while (_local_3 < this._window.numChildren)
            {
                _local_2 = this._window.getChildAt(_local_3);
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_3++;
            }
            this._uiSoundsSettings = new MeMenuSoundSettingsItem(this, MeMenuSoundSettingsItem._Str_4200, this._Str_10739);
            this._furniSoundsSettings = new MeMenuSoundSettingsItem(this, MeMenuSoundSettingsItem._Str_4322, this._Str_12386);
            this._traxSoundsSettings = new MeMenuSoundSettingsItem(this, MeMenuSoundSettingsItem._Str_4191, this._Str_12408);
            this._Str_7269();
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            Logger.log([_local_3]);
            switch (_local_3)
            {
                case "back_btn":
                    this._widget.window.visible = true;
                    this.dispose();
                    return;
                default:
                    Logger.log([("Me Menu Settings View: unknown button: " + _local_3)]);
            }
        }

        public function saveVolume(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Bool=true)
        {
            var _local_5= ((_arg_2 != -1) ? _arg_2 : this._furniVolume);
            var _local_6= ((k != -1) ? k : this._genericVolume);
            var _local_7= ((_arg_3 != -1) ? _arg_3 : this._traxVolume);
            if (_arg_4)
            {
                if (this._widget == null)
                {
                    return;
                }
                this._widget.widget.toolbar.soundManager.furniVolume = _local_5;
                this._widget.widget.toolbar.soundManager.genericVolume = _local_6;
                this._widget.widget.toolbar.soundManager.traxVolume = _local_7;
            }
            else
            {
                this._widget.widget.toolbar.soundManager.previewVolume(_local_6, _local_5, _local_7);
            }
        }

        public function _Str_6111(k:String, _arg_2:Int)
        {
        }

        public var _Str_10739(get,never):IWindowContainer;
public function  get__Str_10739():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("ui_volume_container") , IWindowContainer);
        }

        public var _Str_12386(get,never):IWindowContainer;
public function  get__Str_12386():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("furni_volume_container") , IWindowContainer);
        }

        public var _Str_12408(get,never):IWindowContainer;
public function  get__Str_12408():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("trax_volume_container") , IWindowContainer);
        }

        public var widget(get,never):MeMenuController;
public function  get_widget():MeMenuController
        {
            return this._widget.widget;
        }

        public var _Str_14098(get,never):BitmapData;
public function  get__Str_14098():BitmapData
        {
            return this._soundsOffIconColor;
        }

        public var _Str_14044(get,never):BitmapData;
public function  get__Str_14044():BitmapData
        {
            return this._soundsOffIconWhite;
        }

        public var _Str_13595(get,never):BitmapData;
public function  get__Str_13595():BitmapData
        {
            return this._soundsOnIconColor;
        }

        public var _Str_15177(get,never):BitmapData;
public function  get__Str_15177():BitmapData
        {
            return this._soundsOnIconWhite;
        }
public function new(){}
    }


