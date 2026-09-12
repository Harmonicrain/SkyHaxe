package com.sulake.habbo.toolbar.extensions.settings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.memenu.soundsettings.MeMenuSoundSettingsSlider;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class SoundSettingsItem implements IDisposable 
    {
        public static inline final _Str_4200= 0;
        public static inline final _Str_4322= 1;
        public static inline final _Str_4191= 2;

        var _type:Int = 0;
        var _volume:Float = Math.NaN;
        var _window:IWindowContainer;
        var _slider:MeMenuSoundSettingsSlider;
        var _meMenuSoundSettingsView:SoundSettingsView;

        public function new(k:SoundSettingsView, _arg_2:Int, _arg_3:IWindowContainer)        {
            var _local_4:IWindow = null;
            this._type = _arg_2;
            this._meMenuSoundSettingsView = k;
            this._window = _arg_3;
            this._slider = new MeMenuSoundSettingsSlider(this, Std.downcast(this._window.findChildByName("volume_container") , IWindowContainer), k.toolbar.assets, 0, 1);
            _local_4 = this._window.findChildByName("sounds_off");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            _local_4 = this._window.findChildByName("sounds_on");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            this.updateSoundIcons();
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._slider != null)
                {
                    this._slider.dispose();
                    this._slider = null;
                }
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._meMenuSoundSettingsView == null;
        }

        public function saveVolume(k:Float, _arg_2:Bool)
        {
            this._volume = k;
            switch (this._type)
            {
                case _Str_4200:
                    this._meMenuSoundSettingsView.saveVolume(k, -1, -1, _arg_2);
                    
                case _Str_4322:
                    this._meMenuSoundSettingsView.saveVolume(-1, k, -1, _arg_2);
                    
                case _Str_4191:
                    this._meMenuSoundSettingsView.saveVolume(-1, -1, k, _arg_2);
                    
            }
            this.updateSoundIcons();
            this._meMenuSoundSettingsView._Str_7269();
        }

        function updateSoundIcons()
        {
            if (this._volume == 0)
            {
                this.setBitmap("sounds_on_icon", "sounds_on_white");
                this.setBitmap("sounds_off_icon", "sounds_off_color");
            }
            else
            {
                this.setBitmap("sounds_on_icon", "sounds_on_color");
                this.setBitmap("sounds_off_icon", "sounds_off_white");
            }
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "sounds_off":
                    this.saveVolume(0, false);
                    return;
                case "sounds_on":
                    this.saveVolume(1, false);
                    return;
                default:
                    Logger.log([("Me Menu Settings, Sound settings item: unknown button: " + _local_3)]);
            }
        }

        function setBitmap(k:String, _arg_2:String)
        {
            cast(this._window.findChildByName(k), IStaticBitmapWrapperWindow).assetUri = ("toolbar_memenu_settings_" + _arg_2);
        }

        public function setValue(k:Float)
        {
            this._slider.setValue(k);
            this.updateSoundIcons();
        }
    }

