package com.sulake.habbo.ui.widget.memenu.soundsettings
;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class MeMenuSoundSettingsSlider 
    {
        var _settingsItem:MeMenuSoundSettingsItem;
        var _sliderContainer:IWindowContainer;
        var _sliderBase:BitmapData;
        var _sliderButton:BitmapData;
        var _referenceWidth:Int = 0;
        var _minValue:Float = 0;
        var _maxValue:Float = 1;

        public function new(k:MeMenuSoundSettingsItem, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, _arg_4:Float=0, _arg_5:Float=1)
        {
            this._settingsItem = k;
            this._sliderContainer = _arg_2;
            this._minValue = _arg_4;
            this._maxValue = _arg_5;
            this._Str_6048(_arg_3);
            this._Str_4995();
        }

        public function dispose()
        {
            this._settingsItem = null;
            this._sliderContainer = null;
            this._sliderBase = null;
            this._sliderButton = null;
        }

        public function setValue(k:Float)
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var _local_2= this._sliderContainer.findChildByName("slider_button");
            if (_local_2 != null)
            {
                _local_2.x = this._Str_5687(k);
            }
        }

        function _Str_5687(k:Float):Int
        {
            return Std.int((this._referenceWidth * ((k - this._minValue) / (this._maxValue - this._minValue))));
        }

        function getValue(k:Float):Float
        {
            return ((k / this._referenceWidth) * (this._maxValue - this._minValue)) + this._minValue;
        }

        function _Str_5862(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowEvent.WINDOW_EVENT_RELOCATED)
            {
                return;
            }
            this._settingsItem.saveVolume(this.getValue(_arg_2.x), false);
        }

        function _Str_4995()
        {
            var k:IWindowContainer = null;
            var _local_2:IWindowContainer = null;
            var _local_3:IBitmapWrapperWindow = null;
            if (this._sliderContainer == null)
            {
                return;
            }
            _local_3 = Std.downcast(this._sliderContainer.findChildByName("slider_base") , IBitmapWrapperWindow);
            if (((!(_local_3 == null)) && (!(this._sliderBase == null))))
            {
                _local_3.bitmap = new BitmapData(this._sliderBase.width, this._sliderBase.height, true, 0xFFFFFF);
                _local_3.bitmap.copyPixels(this._sliderBase, this._sliderBase.rect, new Point(0, 0), null, null, true);
            }
            k = Std.downcast(this._sliderContainer.findChildByName("slider_movement_area") , IWindowContainer);
            if (k != null)
            {
                _local_2 = Std.downcast(k.findChildByName("slider_button") , IWindowContainer);
                if (_local_2 != null)
                {
                    _local_3 = Std.downcast(_local_2.findChildByName("slider_bitmap") , IBitmapWrapperWindow);
                    if (((!(_local_3 == null)) && (!(this._sliderButton == null))))
                    {
                        _local_3.bitmap = new BitmapData(this._sliderButton.width, this._sliderButton.height, true, 0xFFFFFF);
                        _local_3.bitmap.copyPixels(this._sliderButton, this._sliderButton.rect, new Point(0, 0), null, null, true);
                        _local_2.procedure = this._Str_5862;
                        this._referenceWidth = (k.width - _local_3.width);
                    }
                }
            }
        }

        function _Str_6048(k:IAssetLibrary)
        {
            var _local_2:BitmapDataAsset = null;
            if (k == null)
            {
                return;
            }
            _local_2 = cast(k.getAssetByName("memenu_settings_slider_base"), BitmapDataAsset);
            this._sliderBase = cast(_local_2.content, BitmapData);
            _local_2 = cast(k.getAssetByName("memenu_settings_slider_button"), BitmapDataAsset);
            this._sliderButton = cast(_local_2.content, BitmapData);
        }
    }


