package com.sulake.habbo.toolbar.extensions.settings
;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class SoundSettingsView 
    {
        var _window:IWindowContainer;
        var _uiSoundsSettings:SoundSettingsItem;
        var _furniSoundsSettings:SoundSettingsItem;
        var _traxSoundsSettings:SoundSettingsItem;
        var _soundsOffIconColor:BitmapData;
        var _soundsOffIconWhite:BitmapData;
        var _soundsOnIconColor:BitmapData;
        var _soundsOnIconWhite:BitmapData;
        var _genericVolume:Float = 1;
        var _furniVolume:Float = 1;
        var _traxVolume:Float = 1;
        var _toolbar:HabboToolbar;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
            this.createWindow();
        }

        public function dispose()
        {
            this.saveVolume(this._genericVolume, this._furniVolume, this._traxVolume);
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
            this._genericVolume = this._toolbar.soundManager.genericVolume;
            this._furniVolume = this._toolbar.soundManager.furniVolume;
            this._traxVolume = this._toolbar.soundManager.traxVolume;
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
            var k= Std.downcast(this._toolbar.assets.getAssetByName("me_menu_sound_settings_xml") , XmlAsset);
            this._window = Std.downcast(this._toolbar.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            var _local_3 = 0;
            while (_local_3 < this._window.numChildren)
            {
                _local_2 = this._window.getChildAt(_local_3);
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_3++;
            }
            this._uiSoundsSettings = new SoundSettingsItem(this, SoundSettingsItem._Str_4200, this.uiVolumeContainer);
            this._furniSoundsSettings = new SoundSettingsItem(this, SoundSettingsItem._Str_4322, this.furniVolumeContainer);
            this._traxSoundsSettings = new SoundSettingsItem(this, SoundSettingsItem._Str_4191, this.traxVolumeContainer);
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
                if (this._toolbar == null)
                {
                    return;
                }
                this._toolbar.soundManager.furniVolume = _local_5;
                this._toolbar.soundManager.genericVolume = _local_6;
                this._toolbar.soundManager.traxVolume = _local_7;
            }
            else
            {
                this._toolbar.soundManager.previewVolume(_local_6, _local_5, _local_7);
            }
        }

        public function updateUnseenItemCount(k:String, _arg_2:Int)
        {
        }

        public var uiVolumeContainer(get,never):IWindowContainer;
public function  get_uiVolumeContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("ui_volume_container") , IWindowContainer);
        }

        public var furniVolumeContainer(get,never):IWindowContainer;
public function  get_furniVolumeContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("furni_volume_container") , IWindowContainer);
        }

        public var traxVolumeContainer(get,never):IWindowContainer;
public function  get_traxVolumeContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("trax_volume_container") , IWindowContainer);
        }

        public var soundsOffIconColor(get,never):BitmapData;
public function  get_soundsOffIconColor():BitmapData
        {
            return this._soundsOffIconColor;
        }

        public var soundsOffIconWhite(get,never):BitmapData;
public function  get_soundsOffIconWhite():BitmapData
        {
            return this._soundsOffIconWhite;
        }

        public var soundsOnIconColor(get,never):BitmapData;
public function  get_soundsOnIconColor():BitmapData
        {
            return this._soundsOnIconColor;
        }

        public var soundsOnIconWhite(get,never):BitmapData;
public function  get_soundsOnIconWhite():BitmapData
        {
            return this._soundsOnIconWhite;
        }

        public var toolbar(get,never):HabboToolbar;
public function  get_toolbar():HabboToolbar
        {
            return this._toolbar;
        }
    }


